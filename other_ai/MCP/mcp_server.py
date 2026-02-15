from mcp.server.fastmcp import FastMCP
from ollama import Client

client = Client(host="http://0.0.0.0:11434") # Set Ollama host

mcp = FastMCP("ollama-mcp") # Create MCP server

@mcp.tool()
def ask_model(prompt: str) -> str:
    """
    Input a prompt and return the response.
    """
    response = client.chat(
        model="llama3.1:8b",
        messages=[
            {"role": "user", "content": prompt}
        ],
        stream=False
    )
    return response["message"]["content"]

if __name__ == "__main__":
    print(ask_model("Explain what a port scan is.")) # Test (not a MCP client)
    mcp.run()

