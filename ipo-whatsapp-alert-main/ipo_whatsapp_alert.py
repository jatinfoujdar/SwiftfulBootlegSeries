import os
import requests
from datetime import datetime

INSTANCE_ID = os.environ['INSTANCE_ID']
API_TOKEN = os.environ['API_TOKEN']
TO_PHONE = os.environ['TO_PHONE']

def send_whatsapp_message(message):
    url = f"https://api.green-api.com/waInstance{INSTANCE_ID}/sendMessage/{API_TOKEN}"
    payload = {
        "chatId": f"{TO_PHONE}@c.us",
        "message": message
    }
    response = requests.post(url, json=payload)
    print("Status:", response.status_code)
    print("Response:", response.text)

ipo_url = "https://webnodejs.investorgain.com/cloud/report/data-read/331/1/5/2025/2025-26/0/all"
response = requests.get(ipo_url)
data = response.json()

today = datetime.now().date()
open_ipos = []

for ipo in data.get("reportTableData", []):
    open_date_str = ipo.get("~Srt_Open")
    close_date_str = ipo.get("~Srt_Close")
    if open_date_str and close_date_str:
        open_date = datetime.strptime(open_date_str, "%Y-%m-%d").date()
        close_date = datetime.strptime(close_date_str, "%Y-%m-%d").date()
        if open_date <= today <= close_date:
            open_ipos.append(ipo)

if not open_ipos:
    message = "❗️ *No open IPOs found for today.*"
else:
    message = "🚀 *Open IPOs Today*\n\n"
    for ipo in open_ipos:
        message += (
            f"*🏢 {ipo.get('IPO')}*\n"
            f"🏷️ *Category:* {ipo.get('~IPO_Category')}\n"
            f"📅 *Open Date:* {ipo.get('Open')}\n"
            f"📅 *Close Date:* {ipo.get('Close')}\n"
            f"📈 *Listing Date:* {ipo.get('Listing')}\n"
            f"💰 *Price:* {ipo.get('Price')}\n"
            f"🚦 *GMP:* {ipo.get('GMP')}\n"
            "-----------------------------\n"
        )

send_whatsapp_message(message)
