# cPanel MCP Server - Integration Guide for Antigravity

This standalone Python script implements the **Model Context Protocol (MCP)**, allowing your AI assistant (Antigravity) to manage your o2switch cPanel directly from the chat.

## Exposed Tools
1. `cpanel_list_subdomains`: Lists all active subdomains and their directories.
2. `cpanel_create_subdomain`: Automatically creates new subdomains pointing to specific directories.
3. `cpanel_list_databases`: Lists all active MySQL databases and sizes.
4. `cpanel_get_disk_usage`: Gets current server storage metrics.

---

## Step 1: Create a cPanel API Token
1. Go to your cPanel Dashboard.
2. Under the **Sécurité** (Security) section, click on **Manage API Tokens** (Gérer les jetons d'API).
3. Click **Create** (Créer) and set a name (e.g. `antigravity-mcp`).
4. Select/grant the required permissions:
   - **Subdomains / Domain Management** (Gestion des sous-domaines).
   - **MySQL / Database Management** (optional, for listing databases).
5. Copy the generated **API Token** immediately (it will only be shown once).

---

## Step 2: Configure Environment Variables
You need to pass the configuration to the python script. You can set these environment variables globally on your Windows machine, or run the server with them:
* `CPANEL_HOST`: `https://node3-eu.o2switch.net:2083` (Replace with your actual o2switch cPanel URL address, which you can see in your browser bar when logged into cPanel).
* `CPANEL_USER`: `stanworl`
* `CPANEL_TOKEN`: *[Your generated API Token]*

---

## Step 3: Register the MCP Server in Antigravity
To register this tool in your Antigravity client:
1. Open the Antigravity configuration file. On your computer, it is located under:
   `C:\Users\stani\.gemini\antigravity-ide\config.json` (or `settings.json`).
2. Add the custom command server configuration under your `mcpServers` settings:

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

3. Restart the Antigravity IDE/editor.
4. Antigravity will automatically load the new tools! You can then say:
   - *"Liste mes sous-domaines."*
   - *"Crée le sous-domaine staging.stanworld.org pointant vers public_html/staging."*
