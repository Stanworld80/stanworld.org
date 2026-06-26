# cPanel MCP Server - Integration Guide for Antigravity

This standalone Python script implements the **Model Context Protocol (MCP)**, allowing your AI assistant (Antigravity) to manage your o2switch cPanel directly from the chat.

## Exposed Tools
1. `cpanel_list_subdomains`: Lists all active subdomains and their directories.
2. `cpanel_create_subdomain`: Automatically creates new subdomains pointing to specific directories.
3. `cpanel_list_databases`: Lists all active MySQL databases and sizes.
4. `cpanel_get_disk_usage`: Gets current server storage metrics.

---

## Authentication Methods

Since some hosting providers (like o2switch) restrict the creation of API Tokens on shared packages, this server supports two methods of authentication:

### Method A: Regular cPanel Password (e.g. if API Tokens are disabled)
You can authenticate using your normal cPanel username and password. 
* **Security Recommendation**: Instead of writing the password inside the Antigravity `config.json` file, you can save it in a local **`.env`** file.
  1. Create a file named `.env` in the same directory as the script (`c:/Users/stani/stanworld.org/.env`).
  2. Write your password inside it:
     ```ini
     CPANEL_PASSWORD=votre_mot_de_passe
     ```
  3. Because `.env` is already configured in `.gitignore`, this file will remain local to your computer and will never be pushed to your GitHub repository! The Python script will automatically detect and load it on startup.

### Method B: cPanel API Token (Recommended if enabled)
1. Go to your cPanel Dashboard -> **Manage API Tokens** (Gérer les jetons d'API).
2. Click **Create** and name it `antigravity-mcp`.
3. Select/grant permissions for Domain Management and MySQL.
4. Copy the generated API Token.

---

## Step 2: Register the MCP Server in Antigravity

To register this tool, open the Antigravity configuration file located under:
`C:\Users\stani\.gemini\antigravity-ide\config.json` (or `settings.json`).

### Configuration Example using cPanel Password (Method A):
```json
{
  "mcpServers": {
    "cpanel-mcp": {
      "command": "python",
      "args": ["c:/Users/stani/stanworld.org/cpanel_mcp_server.py"],
      "env": {
        "CPANEL_HOST": "https://node3-eu.o2switch.net:2083",
        "CPANEL_USER": "stanworl",
        "CPANEL_PASSWORD": "YOUR_CPANEL_PASSWORD"
      }
    }
  }
}
```

### Configuration Example using API Token (Method B):
```json
{
  "mcpServers": {
    "cpanel-mcp": {
      "command": "python",
      "args": ["c:/Users/stani/stanworld.org/cpanel_mcp_server.py"],
      "env": {
        "CPANEL_HOST": "https://node3-eu.o2switch.net:2083",
        "CPANEL_USER": "stanworl",
        "CPANEL_TOKEN": "YOUR_GENERATED_API_TOKEN"
      }
    }
  }
}
```

3. Restart the Antigravity IDE/editor to load the new tools!
