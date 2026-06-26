import sys
import json
import urllib.request
import urllib.parse
import os
import base64

# Load local .env file if present in the same directory as this script
env_path = os.path.join(os.path.dirname(__file__), ".env")
if os.path.exists(env_path):
    with open(env_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, val = line.split("=", 1)
                os.environ[key.strip()] = val.strip()

# Configuration (can be overridden via environment variables or .env file)
CPANEL_HOST = os.environ.get("CPANEL_HOST", "https://node3-eu.o2switch.net:2083") # Example o2switch host
CPANEL_USER = os.environ.get("CPANEL_USER", "stanworl")
CPANEL_TOKEN = os.environ.get("CPANEL_TOKEN", "")
CPANEL_PASSWORD = os.environ.get("CPANEL_PASSWORD", "")

def log(msg):
    sys.stderr.write(f"[cPanel MCP] {msg}\n")
    sys.stderr.flush()

def call_cpanel_api(module, function, params=None):
    if not CPANEL_TOKEN and not CPANEL_PASSWORD:
        return {"errors": ["Neither CPANEL_TOKEN nor CPANEL_PASSWORD is configured."]}
        
    url = f"{CPANEL_HOST.rstrip('/')}/execute/{module}/{function}"
    if params:
        query_string = urllib.parse.urlencode(params)
        url = f"{url}?{query_string}"
        
    log(f"Calling UAPI: {url}")
    req = urllib.request.Request(url)
    
    if CPANEL_TOKEN:
        req.add_header("Authorization", f"cpanel {CPANEL_USER}:{CPANEL_TOKEN}")
    else:
        # Use HTTP Basic Auth with regular cPanel password
        auth_str = f"{CPANEL_USER}:{CPANEL_PASSWORD}"
        auth_bytes = auth_str.encode("utf-8")
        auth_b64 = base64.b64encode(auth_bytes).decode("utf-8")
        req.add_header("Authorization", f"Basic {auth_b64}")
    
    try:
        with urllib.request.urlopen(req) as response:
            res_data = json.loads(response.read().decode("utf-8"))
            return res_data
    except Exception as e:
        log(f"HTTP Request failed: {e}")
        return {"errors": [str(e)]}

def handle_list_tools():
    return {
        "tools": [
            {
                "name": "cpanel_list_subdomains",
                "description": "List all subdomains configured in cPanel.",
                "inputSchema": {
                  "type": "object",
                  "properties": {}
                }
            },
            {
                "name": "cpanel_create_subdomain",
                "description": "Create a new subdomain in cPanel.",
                "inputSchema": {
                  "type": "object",
                  "properties": {
                    "subdomain": {"type": "string", "description": "Subdomain prefix, e.g. 'staging'"},
                    "domain": {"type": "string", "description": "Base domain, e.g. 'stanworld.org'"},
                    "dir": {"type": "string", "description": "Document root path relative to home, e.g. 'public_html/staging'"}
                  },
                  "required": ["subdomain", "domain", "dir"]
                }
            },
            {
                "name": "cpanel_list_databases",
                "description": "List all MySQL databases in cPanel.",
                "inputSchema": {
                  "type": "object",
                  "properties": {}
                }
            },
            {
                "name": "cpanel_get_disk_usage",
                "description": "Get server disk space usage statistics.",
                "inputSchema": {
                  "type": "object",
                  "properties": {}
                }
            }
        ]
    }

def handle_call_tool(name, arguments):
    if name == "cpanel_list_subdomains":
        res = call_cpanel_api("SubDomain", "listsubdomains")
        if res.get("errors"):
            return f"Error: {res.get('errors')}"
        data = res.get("data", [])
        subdomains = [f"{item['subdomain']}.{item['domain']} -> {item['dir']}" for item in data]
        return "\n".join(subdomains) if subdomains else "No subdomains found."
        
    elif name == "cpanel_create_subdomain":
        sub = arguments.get("subdomain")
        domain = arguments.get("domain")
        directory = arguments.get("dir")
        params = {
            "subdomain": sub,
            "domain": domain,
            "dir": directory
        }
        res = call_cpanel_api("SubDomain", "addsubdomain", params)
        if res.get("errors"):
            return f"Failed to create subdomain: {res.get('errors')}"
        return f"Subdomain {sub}.{domain} successfully created pointing to {directory}!"
        
    elif name == "cpanel_list_databases":
        res = call_cpanel_api("Mysql", "list_dbs")
        if res.get("errors"):
            return f"Error: {res.get('errors')}"
        data = res.get("data", [])
        dbs = [f"- {db['database']} ({db['size_formatted']})" for db in data]
        return "\n".join(dbs) if dbs else "No databases found."
        
    elif name == "cpanel_get_disk_usage":
        res = call_cpanel_api("DiskUsage", "fetch_disk_usage")
        if res.get("errors"):
            return f"Error: {res.get('errors')}"
        data = res.get("data", {})
        return f"Disk usage: {json.dumps(data)}"
        
    else:
        return f"Unknown tool: {name}"

def main():
    log("cPanel MCP Server started.")
    # Process JSON-RPC messages from stdin
    for line in sys.stdin:
        if not line.strip():
            continue
        try:
            request = json.loads(line)
            method = request.get("method")
            req_id = request.get("id")
            
            if method == "tools/list":
                response = {
                    "jsonrpc": "2.0",
                    "result": handle_list_tools(),
                    "id": req_id
                }
            elif method == "tools/call":
                params = request.get("params", {})
                name = params.get("name")
                args = params.get("arguments", {})
                tool_output = handle_call_tool(name, args)
                response = {
                    "jsonrpc": "2.0",
                    "result": {
                        "content": [
                            {"type": "text", "text": tool_output}
                        ]
                    },
                    "id": req_id
                }
            else:
                response = {
                    "jsonrpc": "2.0",
                    "error": {"code": -32601, "message": "Method not found"},
                    "id": req_id
                }
            
            sys.stdout.write(json.dumps(response) + "\n")
            sys.stdout.flush()
        except Exception as e:
            log(f"Error parsing request: {e}")

if __name__ == "__main__":
    main()
