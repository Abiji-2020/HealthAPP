# HealthApp

## Project Overview
A fine-tuned Large Language Model (LLM) designed to identify user emotional states and provide empathetic support.

## Key Features
- **Emotion Detection**: Accurately identifies user emotional states, including happiness, sadness, anger, and fear.
- **Emotional Support**: Provides empathetic and supportive responses to users.
- **Conversational Interface**: Engages in natural-sounding conversations with users.

## Technical Specifications
- **Base Model**: LLaMA 3.2 (3B)
- **Dataset**: [Mental Health Counseling Conversations](https://huggingface.co/datasets/Amod/mental_health_counseling_conversations)
- **Fine-tuning Framework**: Unsloth
- **Fine-tuning Method**: LoRA (Low-Rank Adaptation) for efficient adaptation
- **Parameter Quantization**: 4-bit parameter quantization for reduced computational requirements

## Usage

### Installation

1. Install the required libraries:
   ```bash
   pip install unsloth transformers datasets torch
   ```
2. Log in to Hugging Face to access the model:
   ```python
   from huggingface_hub import login
   from kaggle_secrets import UserSecretsClient

   user_secrets = UserSecretsClient()
   hf_token = user_secrets.get_secret("HUGGINGFACE_TOKEN")
   login(hf_token)
   ```
3. Download the pre-trained model and tokenizer:
   ```python
   from unsloth import FastLanguageModel

   model, tokenizer = FastLanguageModel.from_pretrained(
       model_name="unsloth/Llama-3.2-3B-Instruct",
       max_seq_length=2048,
       dtype=None,
       load_in_4bit=True,
   )
   ```

### Example Usage

```python
from unsloth import FastLanguageModel

def get_response(user_input):
    instruction = """You are an experienced psychologist named Amelia.\nBe polite to the patient and answer all mental health-related queries."""

    messages = [
        {"role": "system", "content": instruction},
        {"role": "user", "content": user_input}
    ]

    prompt = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
    inputs = tokenizer(prompt, return_tensors='pt', padding=True, truncation=True).to("cuda")
    outputs = model.generate(**inputs, max_new_tokens=150, num_return_sequences=1)

    text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return text.split("assistant")[1]

# Test the model
user_input = "I'm feeling really sad today."
response = get_response(user_input)
print(response)
```
## License
Our Emotional Support LLM is licensed under [Insert License].

## Acknowledgments
We thank the creators of LLaMA, Unsloth, and LoRA for their contributions to our project.

## Future Development
- **Multilingual Support**: Expand language support for global accessibility.
- **Emotion Analysis**: Integrate advanced emotion analysis for more accurate support.
- **Human Evaluation**: Conduct human evaluations for model refinement.
