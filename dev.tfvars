# -----------------------------
# RESOURCE GROUP
# -----------------------------
resource_group = "rg-devops-demo"
location       = "Central India"


# -----------------------------
# SQL CONFIG
# -----------------------------
# MUST be globally unique, lowercase, 3–63 chars
sql_server_name = "rishabhsqldemo12345"

db_name = "appdb"

admin_user = "sqladmin"


# -----------------------------
# NETWORK (FIREWALL)
# -----------------------------
# Replace with your actual public IP
# Get using: https://whatismyipaddress.com
start_ip = "49.37.120.10"
end_ip   = "49.37.120.10"


# -----------------------------
# AZURE AD PRINCIPAL
# -----------------------------
# This should be your Service Principal OBJECT ID (NOT clientId)
# Get using:
# az ad sp show --id <CLIENT_ID> --query id -o tsv
principal_id = "adc661c8-c0b9-49ae-b5b7-826b31b90522"
