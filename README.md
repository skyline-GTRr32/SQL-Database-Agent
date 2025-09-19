# Conversational SQL Database Agent 🤖

[![Python Version](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)
[![Framework](https://img.shields.io/badge/Framework-Streamlit-red.svg)](https://streamlit.io)
[![Library](https://img.shields.io/badge/Library-LangChain-green.svg)](https://www.langchain.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

An intelligent, conversational AI agent that allows you to chat with your SQL database in natural language. Instead of writing complex SQL queries, you can simply ask questions, and the agent will find the answers for you. It even remembers the context of your conversation for follow-up questions.

---

### Demo

<!-- 
**IMPORTANT**: Create a short screen recording (GIF) of you interacting with the app and place it here. This is the best way to showcase your project.
Tools like LICEcap or ScreenToGif are great for this.
-->
![Agent Demo GIF](https://user-images.githubusercontent.com/12345/your-demo-gif-url-here.gif) 
*(Replace this with a real GIF of your application in action!)*

---

### ✨ Features

*   **Natural Language to SQL:** Ask questions in plain English, and the agent generates, validates, and executes the appropriate SQL query.
*   **Conversational Memory:** The agent remembers the last 20 turns of your conversation, allowing you to ask follow-up questions naturally.
*   **Safety Guardrails:** The agent is configured with a read-only system prompt, preventing it from executing any destructive commands (`DELETE`, `UPDATE`, `DROP`, etc.).
*   **Schema Aware:** The agent automatically inspects the database schema to write accurate and relevant queries.
*   **User-Friendly UI:** A clean and simple chat interface built with Streamlit.

---

### 🛠️ Tech Stack

*   **Backend:** Python
*   **AI Framework:** LangChain
*   **LLM:** Google Gemini Pro
*   **UI:** Streamlit
*   **Database:** SQLite

---

### 🚀 Getting Started

Follow these instructions to set up and run the project on your local machine.

#### **1. Prerequisites**

*   Python 3.10 or higher
*   Access to the Google Gemini API and a valid API Key.

#### **2. Clone the Repository**

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

#### **3. Set Up the Virtual Environment**

It's highly recommended to use a virtual environment to keep dependencies isolated.

```bash
# Create the virtual environment
python -m venv venv

# Activate the virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
.\venv\Scripts\activate
```

#### **4. Install Dependencies**

```bash
pip install -r requirements.txt
```

#### **5. Configure Environment Variables**

Create a file named `.env` in the root of the project directory. This file will hold your secret API key.

```
GOOGLE_API_KEY="your_actual_google_api_key_here"
```

> **Note:** The `.env` file is included in `.gitignore` to prevent you from accidentally committing your secret key to version control.

#### **6. Create and Populate the Database**

The project includes a SQL script to set up the database. Run the following command from your terminal:

```bash
# This command creates 'sales.db' and populates it using 'schema.sql'
sqlite3 sales.db < schema.sql
```

#### **7. Run the Application**

You are now ready to start the agent!

```bash
streamlit run main.py
```

Your web browser should automatically open to the application's local URL.

---

### 💬 Example Conversation

Here's an example of the agent's conversational memory in action:

> **You:**
> List all the products in the 'Apparel' category.

> **🤖 Agent:**
> Here are the products in the 'Apparel' category: 'Zephyr Jacket' and 'Orbit Backpack'.

> **You:**
> Now, which of those is more expensive?

> **🤖 Agent:**
> The 'Zephyr Jacket' is more expensive at 8999 cents, compared to the 'Orbit Backpack' at 7499 cents.

---

### 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
