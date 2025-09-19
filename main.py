import streamlit as st
import os
from dotenv import load_dotenv

# --- Core LangChain Imports ---
from langchain_community.utilities import SQLDatabase
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.memory import ConversationBufferWindowMemory
from langchain_core.messages import HumanMessage, AIMessage

# --- NEW: Imports for Building a Custom Agent ---
from langchain.agents import AgentExecutor, create_tool_calling_agent
from langchain_community.agent_toolkits.sql.toolkit import SQLDatabaseToolkit
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder

# --- 1. PRE-FLIGHT CHECKS & SETUP ---

load_dotenv()

# Check for API Key
api_key = os.getenv("GOOGLE_API_KEY")
if not api_key:
    st.error("🔴 Google API Key not found. Please set it in the .env file.")
    st.stop()

# Check for Database File
DB_PATH = "sales.db"
if not os.path.exists(DB_PATH):
    st.error(f"🔴 Database file '{DB_PATH}' not found. Please ensure it is in the correct directory.")
    st.stop()

# --- 2. INITIALIZE CORE COMPONENTS (LLM, DB, MEMORY) ---

# Initialize the LLM
llm = ChatGoogleGenerativeAI(
    model="gemini-2.5-flash",
    google_api_key=api_key,
    temperature=0,
    convert_system_message_to_human=True
)

# Initialize the Database connection
db = SQLDatabase.from_uri(f"sqlite:///{DB_PATH}")

# Initialize Memory in Streamlit's session state
if "memory" not in st.session_state:
    st.session_state.memory = ConversationBufferWindowMemory(
        k=20, # Remember the last 20 messages
        memory_key="chat_history", # The key for the placeholder in the prompt
        return_messages=True,
    )
memory = st.session_state.memory

# --- 3. CREATE THE AGENT ---

# Define the System Prompt
SYSTEM_MESSAGE = """
You are a professional, friendly, and highly knowledgeable SQL Data Analyst named 'DB-Bot'.
Your primary goal is to help users get insights from the 'sales.db' database.

Here are your rules:
- You MUST use the tools provided to interact with the database.
- Do not make up answers. If you don't know the answer, say so.
- Your SQL queries MUST be read-only (`SELECT`). Do not execute any `DELETE`, `UPDATE`, `INSERT`, etc.
- Use the conversation history to understand and answer follow-up questions.
"""

# Create the prompt template with a placeholder for memory
prompt = ChatPromptTemplate.from_messages([
    ("system", SYSTEM_MESSAGE),
    MessagesPlaceholder(variable_name="chat_history"),
    ("human", "{input}"),
    MessagesPlaceholder(variable_name="agent_scratchpad"),
])

# Get the tools from the SQLDatabaseToolkit
# The toolkit automatically creates tools for listing tables, checking schemas, and querying the DB
toolkit = SQLDatabaseToolkit(db=db, llm=llm)
tools = toolkit.get_tools()

# Create the agent by combining the LLM, the prompt, and the tools
agent = create_tool_calling_agent(llm, tools, prompt)

# Create the AgentExecutor, which is the runtime for the agent
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    memory=memory, # This is the crucial step to link the memory
    verbose=True,
    handle_parsing_errors=True # Handles cases where the LLM output is not perfect
)

# --- 4. CREATE THE STREAMLIT APP UI ---

st.set_page_config(page_title="Conversational DB Agent", page_icon="🤖")
st.title("🤖 Conversational Database Agent")

# Display chat messages from history
chat_history = memory.chat_memory.messages
for message in chat_history:
    role = "user" if isinstance(message, HumanMessage) else "assistant"
    with st.chat_message(role):
        st.markdown(message.content)

# Accept user input
if user_question := st.chat_input("Ask about your data..."):
    with st.chat_message("user"):
        st.markdown(user_question)

    with st.chat_message("assistant"):
        message_placeholder = st.empty()
        with st.spinner("The AI agent is thinking..."):
            try:
                # The agent_executor now automatically handles history from the linked memory
                response = agent_executor.invoke({"input": user_question})
                final_answer = response["output"]
                message_placeholder.markdown(final_answer)

            except Exception as e:
                final_answer = f"An error occurred: {e}"
                message_placeholder.error(final_answer)