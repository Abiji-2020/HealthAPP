from fastapi import FastAPI
from llama_cpp import Llama
from pydantic import BaseModel
from typing import List, Dict 

llm = Llama.from_pretrained(
	repo_id="Codeprocastinator/Llama-3.2-3b-it-mental-health",
	filename="unsloth.Q4_K_M.gguf",
)

app = FastAPI()

class Message(BaseModel):
    role: str
    content: str

class ChatResponse(BaseModel):
    response:str 

@app.post("/chat",response_model=ChatResponse)
async def chat(messages: List[Message]):
    formatted_message = [{"role": msg.role, "content": msg.content} for msg in messages]

    try:
        response = llm.create_chat_completion(
            messages=formatted_message,
            max_tokens=1024,
            stop=["<|eot_id|>"]
        )
        assistant_response = response["choices"][0]["message"]["content"]
        return ChatResponse(response=assistant_response)
    except Exception as e:
        return ChatResponse(response=f"Error : {str(e)}")
