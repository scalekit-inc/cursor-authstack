# Code Samples

This reference provides implementation examples for integrating Scalekit Agent Auth across different frameworks, languages, and use cases.

## Quick Start Guide

Choose the right sample based on your needs:

| Your Goal | Recommended Sample | Framework | Complexity |
|-----------|-------------------|-----------|------------|
| **I just want to see working code** | [google-adk-agent-example](#google-adk-framework-samples) | Google ADK | ⭐ Simple (1 file) |
| Build a conversational AI agent | [sample-langchain-agent](#langchain-framework-samples) | LangChain | ⭐⭐ Medium |
| Use OpenAI's native tool calling | [python-connect-demos/openai](#openai-integration) | OpenAI | ⭐⭐ Medium |
| Multi-tool, reusable workflows | [python-connect-demos/mcp](#mcp-model-context-protocol) | MCP | ⭐⭐⭐ Advanced |
| Simple one-off tool calls | [python-connect-demos/direct](#direct-sdk-usage) | Direct SDK | ⭐ Simple |
| Agent-based natural language | [python-connect-demos/langchain](#langchain-integration) | LangChain | ⭐⭐ Medium |
| Custom API endpoints | [python-connect-demos/proxy](#proxyraw-api) | Proxy | ⭐⭐ Medium |

---

## LangChain Framework Samples

### Repository: [scalekit-inc/sample-langchain-agent](https://github.com/scalekit-inc/sample-langchain-agent.git)

**Overview:** Conversational AI agent that can access external APIs (Gmail, etc.) via OAuth, hold multi-turn conversations, and autonomously execute tool calls based on user intent.

**Requirements:**
- Python >= 3.11
- `scalekit-sdk-python` >= 2.4.3
- `langchain` >= 0.1.0
- `langchain-openai` >= 0.1.0
- GPT-4o API access

**Environment Variables:**
```bash
OPENAI_API_KEY=your_openai_api_key_here
SCALEKIT_CLIENT_ID=your_scalekit_client_id
SCALEKIT_CLIENT_SECRET=your_scalekit_client_secret
SCALEKIT_ENV_URL=your_scalekit_environment_url
```

**Installation:**
```bash
pip install -r requirements.txt
python main.py
```

**Key Code Examples:**

**1. SDK Initialization**
```python
import os
import scalekit.client
from dotenv import load_dotenv

load_dotenv()

scalekit = scalekit.client.ScalekitClient(
    client_id=os.getenv("SCALEKIT_CLIENT_ID"),
    client_secret=os.getenv("SCALEKIT_CLIENT_SECRET"),
    env_url=os.getenv("SCALEKIT_ENV_URL"),
)
actions = scalekit.actions
```

**2. OAuth Authorization Flow**
```python
user_name = "user-1234"
connection_names = ["gmail"]

# Generate authorization links for each service
for conn_name in connection_names:
    link = actions.get_authorization_link(
        identifier=user_name,
        connection_name=conn_name
    )
    print(f"🔗 Authorize {conn_name}: {link.link}")
    input("✅ Press Enter after authorization...")
```

**3. Tool Discovery & Agent Creation**
```python
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI

# Discover tools from Scalekit
scalekit_tools = actions.langchain.get_tools(
    identifier=user_name,
    connection_names=connection_names,
    page_size=100
)

# Create agent
llm = ChatOpenAI(model="gpt-4o", temperature=0.1)
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful conversational assistant with access to tools."),
    ("placeholder", "{chat_history}"),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_tool_calling_agent(llm, scalekit_tools, prompt)
agent_executor = AgentExecutor(
    agent=agent,
    tools=scalekit_tools,
    verbose=False,
    handle_parsing_errors=True
)
```

**4. Execute with Chat History**
```python
response = agent_executor.invoke({
    "input": "fetch my first unread email",
    "chat_history": chat_history
})
```

**Use Cases:**
- Email management (fetch, read, search)
- Multi-turn conversations with context
- OAuth flow for multiple services
- Tool discovery from Scalekit

---

## Google ADK Framework Samples

### Repository: [scalekit-inc/google-adk-agent-example](https://github.com/scalekit-inc/google-adk-agent-example.git)

**Overview:** Minimal Gmail-powered agent demonstrating Agent Auth integration with Google's Agent Development Kit. Entire integration fits in one file.

**Requirements:**
- Python >= 3.11
- `google-adk` >= 1.15.1
- `scalekit-sdk-python` >= 2.4.6
- Google API key

**Environment Variables:**
```bash
GOOGLE_GENAI_USE_VERTEXAI=FALSE
GOOGLE_API_KEY=your_google_api_key_here
SCALEKIT_CLIENT_ID=your_scalekit_client_id
SCALEKIT_CLIENT_SECRET=your_scalekit_client_secret
SCALEKIT_ENV_URL=your_scalekit_environment_url
```

**Installation:**
```bash
pip install -r requirements.txt
adk run scalekit_tool_agent
```

**Key Code Examples:**

**1. Complete Agent Implementation**
```python
from google.adk.agents import Agent
import scalekit.client
import os

identifier = "user-1234"
connection_name = "gmail"

# Initialize Scalekit client
client = scalekit.client.ScalekitClient(
    client_id=os.getenv("SCALEKIT_CLIENT_ID"),
    client_secret=os.getenv("SCALEKIT_CLIENT_SECRET"),
    env_url=os.getenv("SCALEKIT_ENV_URL")
)

# Generate OAuth authorization link
auth = client.actions.get_authorization_link(
    identifier=identifier,
    connection_name=connection_name
)

print("📧 Gmail Authorization Required")
print(f"🔗 Visit this URL to authorize the gmail connection:\n\n   {auth.link}\n")
input("✅ Press Enter after authorization...")

# Generate Gmail tools with authenticated access
gmail_tools = client.actions.google.get_tools(
    providers=["GMAIL"],
    identifier=identifier,
    page_size=100
)

# Create ADK agent
root_agent = Agent(
    name="scalekit_tool_agent",
    model="gemini-2.5-flash",
    description="Tool agent for Gmail and general questions",
    instruction=(
        "You are a helpful assistant that can use gmail tools to answer "
        "user questions based on their emails and general questions."
    ),
    tools=gmail_tools,
)
```

**Use Cases:**
- Read and analyze user emails
- Search inbox content
- Natural language email queries
- Quick start pattern for new developers

---

## Python Integration Patterns

### Repository: [scalekit-inc/python-connect-demos](https://github.com/scalekit-inc/python-connect-demos.git)

Comprehensive collection of integration patterns organized by framework and use case.

#### Direct SDK Usage

**Pattern:** Simple one-off tool calls with direct SDK methods.

**Gmail - Fetch Emails**
```python
response = connect.execute_tool(
    tool_name="gmail_fetch_mails",
    identifier="user@example.com",
    tool_input={
        "max_results": 10,
        "query": "is:unread"
    }
)
```

**Slack - Send Message**
```python
response = connect.execute_tool(
    tool_name="slack_send_message",
    identifier="user_id",
    tool_input={
        "channel": "#connect",
        "text": "Hello from demo!"
    }
)
```

**Salesforce - SOQL Query**
```python
response = connect.execute_tool(
    tool_name="salesforce_soql_execute",
    identifier="user_id",
    tool_input={
        "soql_query": "SELECT Id, Name FROM Account"
    }
)
```

**Pre/Post Modifiers** (reduce token usage)
```python
from scalekit.connect.types import ToolInput, ToolOutput

@connect.pre_modifier(tool_names=["gmail_fetch_mails"])
def gmail_pre_modifier(tool_input: ToolInput):
    tool_input['query'] = 'is:unread'
    return tool_input

@connect.post_modifier(tool_names=["gmail_fetch_mails"])
def gmail_post_modifier(output: ToolOutput):
    return {"response": output['messages'][0]['snippet']}
```

#### LangChain Integration

**Pattern:** Agent-based workflows with natural language interactions.

**Calendar Agent**
```python
from langchain_openai import ChatOpenAI
from langchain.agents import AgentExecutor, create_openai_tools_agent

tools = connect.langchain.get_tools(
    identifier="user_123",
    providers=["GOOGLECALENDAR"],
    tool_names=["googlecalendar_list_events"]
)

llm = ChatOpenAI(model="gpt-4o")
agent = create_openai_tools_agent(llm, tools, prompt)
executor = AgentExecutor(agent=agent, tools=tools, verbose=True)
result = executor.invoke({"input": "List my events for today"})
```

**Salesforce Agent**
```python
tools = connect.langchain.get_tools(
    identifier="user_123",
    providers=["SALESFORCE"],
    tool_names=["salesforce_soql_execute"]
)
result = executor.invoke({"input": "Get all accounts with 'united' in the name"})
```

**Freshdesk Customer Support Workflow**
```python
# Complete workflow: create contact, ticket, assign, reply, update status
tools = connect.langchain.get_tools(
    identifier="user_123",
    providers=["FRESHDESK"]
)
```

#### OpenAI Integration

**Pattern:** Multi-step workflows using OpenAI's native tool calling.

**Gmail → Summary → Slack**
```python
from openai import OpenAI

client = OpenAI()
response = client.responses.create(
    model="gpt-4.1",
    input=[{"role": "user", "content": "Read emails, send summary to Slack"}],
    tools=tool.ALL_TOOLS,
    tool_choice="auto"
)

# Scalekit handles tool execution
tool_response = sk.connect.handle_tool_calls(
    input_messages=input_messages,
    openai_response=response,
    identifier="user@example.com"
)
```

#### MCP (Model Context Protocol)

**Pattern:** Multi-tool, reusable config patterns for complex workflows.

**Email Reminder Automation**
```python
from scalekit.actions.models.mcp_config import McpConfigConnectionToolMapping

# Create MCP config
config_response = my_mcp.create_config(
    name="reminder-manager",
    description="Summarizes emails and creates calendar events",
    connection_tool_mappings=[
        # Gmail works directly — no dashboard setup required
        McpConfigConnectionToolMapping(
            connection_name="gmail",
            tools=[]
        ),
        # Google Calendar must be created in dashboard first
        McpConfigConnectionToolMapping(
            connection_name="MY_CALENDAR",
            tools=["googlecalendar_create_event", "googlecalendar_delete_event"]
        )
    ]
)

# Get MCP instance and URL
instance = my_mcp.ensure_instance(
    config_name="reminder-manager",
    user_identifier="john-doe",
    name="reminder-mcp-john"
)
mcp_url = instance.instance.url
```

#### Proxy/Raw API

**Pattern:** Custom API endpoints not in tool catalog.

**Google Drive Operations**
```python
# Upload file
upload_response = client.actions.request(
    connection_name="GOOGLE_DRIVE",
    identifier="user@example.com",
    path="/upload/drive/v3/files",
    method="POST",
    query_params={"uploadType": "media", "name": "demo.pdf"},
    form_data=file_bytes,
    headers={"Content-Type": "application/pdf"}
)
```

#### Static Auth

**Pattern:** API key or Basic authentication (no OAuth).

**API Key Auth**
```python
response = actions.get_or_create_connected_account(
    connection_name="fathom",
    identifier="your_user",
    authorization_details={
        "static_auth": {
            "api_key": "your-api-key"
        }
    }
)
```

**Basic Auth**
```python
response = actions.get_or_create_connected_account(
    connection_name="gong",
    identifier="your_user",
    authorization_details={
        "static_auth": {
            "domain": "account.gong.io",
            "username": "api-key",
            "password": "api-secret"
        }
    }
)
```

**Freshdesk (Domain + Username + Password)**
```python
response = connect.execute_tool(
    tool_name="freshdesk_create_ticket",
    identifier="user_id",
    tool_input={
        "name": "John Doe",
        "email": "john@example.com",
        "subject": "Website server down",
        "description": "<div>Site has crashed</div>",
        "type": "Problem",
        "tags": ["urgent", "server"]
    }
)
```

---

## Provider Reference

| Provider | Sample Repo | Demo File | Auth Type |
|----------|-------------|-----------|-----------|
| **Attention** | python-connect-demos | `direct/attention.py` | API Key |
| **Chorus** | python-connect-demos | `direct/chorus.py` | Basic |
| **Clari** | python-connect-demos | `direct/clari.py` | Basic |
| **Fathom** | python-connect-demos | `direct/fathom.py` | API Key |
| **Freshdesk** | python-connect-demos | `static/freshdesk.py`, `langchain/freshdesk.py` | Basic |
| **Gmail** | sample-langchain-agent, google-adk-agent-example, python-connect-demos | `main.py`, `agent.py`, `direct/gmail.py` | OAuth |
| **Gong** | python-connect-demos | `direct/gong.py` | Basic |
| **Google Calendar** | python-connect-demos | `langchain/main.py`, `mcp/main.py` | OAuth |
| **Google Drive** | python-connect-demos | `proxy/gdrive.py` | OAuth |
| **HubSpot** | python-connect-demos | `langchain/hubspot.py` | OAuth |
| **Salesforce** | python-connect-demos | `direct/salesforce.py`, `langchain/salesforce.py` | OAuth |
| **Slack** | python-connect-demos, openai integration | `direct/slack.py` | OAuth |
| **Snowflake** | python-connect-demos | `direct/snowflake.py` | OAuth |

---

## Common Patterns

### Token Management

**Extract tokens from connected account:**
```python
account = actions.get_connected_account(connection_name, identifier)
tokens = account.connected_account.authorization_details["oauth_token"]
access_token = tokens["access_token"]
refresh_token = tokens["refresh_token"]
```

**Check connection status:**
```python
response = connect.get_connected_account(connection_name, identifier)
if response.connected_account.status != "ACTIVE":
    # Re-authenticate
```

### Error Handling

**Check connection before executing tools:**
```python
def authenticate_tool(connect, connection_name, identifier):
    response = connect.get_connected_account(connection_name, identifier)
    if response.connected_account.status != "ACTIVE":
        link = connect.get_authorization_link(
            connection_name=connection_name,
            identifier=identifier
        )
        print(f"Authorize: {link.link}")
        input("Press Enter after authorizing...")
    return True
```

### Configuration

**Environment setup:**
```python
import os
from dotenv import load_dotenv

load_dotenv()

scalekit = scalekit.client.ScalekitClient(
    client_id=os.getenv("SCALEKIT_CLIENT_ID"),
    client_secret=os.getenv("SCALEKIT_CLIENT_SECRET"),
    env_url=os.getenv("SCALEKIT_ENV_URL"),
)
```

---

## Getting Help

### Scalekit Documentation
- **Official Docs:** [docs.scalekit.com](https://docs.scalekit.com)
- **Scalekit Dashboard:** [app.scalekit.com](https://app.scalekit.com)
- **API Credentials:** Dashboard → Developers → Settings → API Credentials

### Sample Repositories
- **LangChain Agent:** [github.com/scalekit-inc/sample-langchain-agent](https://github.com/scalekit-inc/sample-langchain-agent)
- **Google ADK Agent:** [github.com/scalekit-inc/google-adk-agent-example](https://github.com/scalekit-inc/google-adk-agent-example)
- **Python Connect Demos:** [github.com/scalekit-inc/python-connect-demos](https://github.com/scalekit-inc/python-connect-demos)

### Framework Documentation
- **LangChain:** [python.langchain.com](https://python.langchain.com)
- **Google ADK:** [google.github.io/adk-docs](https://google.github.io/adk-docs)
- **MCP Protocol:** [spec.modelcontextprotocol.io](https://spec.modelcontextprotocol.io)
- **OpenAI API:** [platform.openai.com/docs](https://platform.openai.com/docs)

### SDK Documentation
- **Python SDK:** [github.com/scalekit-inc/scalekit-sdk-python](https://github.com/scalekit-inc/scalekit-sdk-python)
- **Node SDK:** [github.com/scalekit-inc/scalekit-sdk-node](https://github.com/scalekit-inc/scalekit-sdk-node)

### Troubleshooting
1. **Connection not ACTIVE:** Check OAuth flow completed in browser
2. **Token expired:** Scalekit auto-refreshes tokens; call `get_connected_account` before tool calls
3. **Invalid credentials:** Verify `SCALEKIT_ENV_URL`, `SCALEKIT_CLIENT_ID`, and `SCALEKIT_CLIENT_SECRET`
4. **Tool not found:** Verify connection name matches Scalekit Dashboard exactly
5. **Scope errors:** Check connection configuration has required scopes in Scalekit Dashboard
