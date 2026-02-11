import os
from pathlib import Path

from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from pydantic import BaseModel

from llama_index.core import VectorStoreIndex, SimpleDirectoryReader, Settings
from llama_index.vector_stores.chroma import ChromaVectorStore
from llama_index.core.storage.storage_context import StorageContext
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.llms.ollama import Ollama

import chromadb

OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")

app = FastAPI()

# ---- Models ----
Settings.embed_model = OllamaEmbedding(
    model_name="nomic-embed-text",
    base_url=OLLAMA_BASE_URL, #"http://localhost:11434",
)

Settings.llm = Ollama(
    model="llama3.1",
    temperature=0.2,
    base_url=OLLAMA_BASE_URL #"http://localhost:11434",
)

# ---- Load + Index documents ----
BASE_DIR = Path(__file__).parent
DATA_DIR = BASE_DIR / "data"
CHROMA_DIR = BASE_DIR / "chroma_db"

chroma_client = chromadb.PersistentClient(path=str(CHROMA_DIR))
chroma_collection = chroma_client.get_or_create_collection("about_me")

vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
storage_context = StorageContext.from_defaults(vector_store=vector_store)

documents = SimpleDirectoryReader(str(DATA_DIR)).load_data()

index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context,
)

query_engine = index.as_query_engine(
    similarity_top_k=4,
    system_prompt=(
        "You are an AI that answers questions only about me using the provided context. "
        "If the answer is not in the context, say you do not know."
    ),
)

# ---- API ----
class ChatRequest(BaseModel):
    message: str

@app.post("/chat")
def chat(req: ChatRequest):
    response = query_engine.query(req.message)
    return {"answer": str(response)}

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # for beta only
    allow_methods=["*"],
    allow_headers=["*"],
)
