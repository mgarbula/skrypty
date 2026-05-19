import ollama

ROUTER_SYSTEM_PROMPT = """
You are an intent classification router engine.
Your job is to analyze user input and classify it to exactly ONE of these intents:
- WELCOME: If the user is saying hello, greeting you, asking "who are you", or starting the conversation.
- MENU: If the user is asking about what options, services, food, items, or products are available.
- ORDER: If the user is trying to buy something, checkout, book a service, select a specific item to purchase, or modify an existing order.

CRITICAL: You must reply with exactly one word from this list: [WELCOME, MENU, ORDER]. Do not include punctuation, markdown, or any other text.
"""

MENU_DATA = """
- Espresso: 6 PLN
- Cappuccino: 10 PLN
- Avocado Toast: 20 PLN
- Chocolate Croissant: 10 PLN
"""

INTENT_PROMPTS = {
    "WELCOME": """
You are a friendly, welcoming chatbot to the digital cafe.
Greet the customer warmly, ask how their day is going, and gently guide them to ask about our menu.
Keep it concise (1-2 sentences). Do not take orders yet.
""",

    "MENU": f"""
You are our digital cafe's menu assistant. Here is our exclusive local menu:
{MENU_DATA}

CRITICAL RULES:
1. Present this menu beautifully using bullet points.
2. Inform the user they can place an order whenever they are ready.
3. NEVER mention, invent, or suggest any items, drinks, or food options that are not explicitly listed in the OFFICIAL CAFE MENU above.
""",
    
    "ORDER": f"""
You are the strict order-taking assistant.
Here is our official menu:
{MENU_DATA}

CRITICAL RULES:
1. If the user asks what is available, what drinks we have, or asks for recommendations, you MUST ONLY reference items from the OFFICIAL CAFE MENU above.
2. NEVER invent or hallucinate items. If it is not on the menu, it does not exist.
3. If they ask for something off-menu, politely state: "I'm sorry, we only serve items from our official menu."
4. If they select a valid item, acknowledge their selection, confirm the item, and ask if they want anything else or if they are ready to finalize. Keep a helpful, transactional tone.
"""
}

MODEL = "llama3.2:3b"

def get_intent(user_input):
    response = ollama.chat(
        model=MODEL,
        messages=[
            {"role": "system", "content": ROUTER_SYSTEM_PROMPT},
            {"role": "user", "content": user_input},
        ],
        options={"temperature": 0.0},
    )

    intent = response["message"]["content"].strip().upper()

    for valid_intent in ["WELCOME", "MENU", "ORDER"]:
        if valid_intent in intent:
            return valid_intent
    return "WELCOME"

def generate_response(intent, user_input, history):
    messages = [{"role": "system", "content": INTENT_PROMPTS[intent]}]

    for interaction in history[-3:]:
        messages.append({"role": "user", "content": interaction["user"]})
        messages.append({"role": "assistant", "content": interaction["bot"]})

    messages.append({"role": "user", "content": user_input})

    response = ollama.chat(model=MODEL, messages=messages)
    return response["message"]["content"]

def main():
    print("Local Chatbot Initialized. Type 'exit' or 'quit' to quit.\n")
    history = []

    while True:
        user_input = input("You: ")
        if user_input.lower() in ["exit", "quit"]:
            print("Bot: Bye!")
            break

        detected_intent = get_intent(user_input)

        print(f"    [DEBUG - detected intent: {detected_intent}]")

        bot_response = generate_response(detected_intent, user_input, history)
        print(f"Bot: {bot_response}\n")

        history.append({'user': user_input, 'bot': bot_response})


if __name__ == "__main__":
    main()
