import os
import uvicorn
from fastapi import FastAPI
from dotenv import load_dotenv
from openai import AsyncOpenAI
import json

# Load environment variables from .env file.
load_dotenv()

# Instantiate the asynchronous client with the API key.
client = AsyncOpenAI(api_key=os.getenv("OPENAI_API_KEY"))

app = FastAPI()

# Store previous response
previous_response = None

@app.get("/")
def read_root():
    return {"info": "HTTP server for Godot controlling movement."}

@app.get("/move")
async def move():
    """
    Endpoint that uses GPT-4-turbo to generate pose numbers and returns
    corresponding animation commands for the Godot client.
    """
    global previous_response
    
    # System message explaining the task
    system_msg = """You are a pose generator that outputs a single number between 1-3.
    1 maps to 'walk', 2 maps to 'wave', and 3 maps to 'static'.
    Respond only with a JSON object containing a single 'pose_number' field."""
    
    # Include previous response in the user message if it exists
    user_msg = f"Generate a new pose number. Previous pose was: {previous_response}" if previous_response else "Generate a pose number."
    
    response = await client.chat.completions.create(
        model="gpt-4-turbo-preview",
        messages=[
            {"role": "system", "content": system_msg},
            {"role": "user", "content": user_msg}
        ],
        temperature=0.7
    )
    
    # Extract pose number from LLM response
    try:
        raw_content = response.choices[0].message.content.strip()
        # Remove markdown code fences if present
        if raw_content.startswith("```"):
            lines = raw_content.splitlines()
            if lines[0].startswith("```"):
                lines = lines[1:]
            if lines and lines[-1].startswith("```"):
                lines = lines[:-1]
            raw_content = "\n".join(lines).strip()

        data = json.loads(raw_content)
        pose_number = int(data.get("pose_number", 0))
        previous_response = pose_number
        
        # Map pose number to animation type
        pose_map = {
            1: "breakdance",
            2: "flair_dance",
            3: "hip_hop_dance"
        }
        animation_type = pose_map.get(pose_number, "walk")
        
        return {"action": "animate", "type": animation_type}
    
    except Exception as e:
        print(f"Error processing LLM response: {e}")
        return {"action": "animate", "type": "walk"}

if __name__ == "__main__":
    uvicorn.run("server:app", host="0.0.0.0", port=8000, log_level="info")