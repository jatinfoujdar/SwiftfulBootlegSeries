# 🚀 IPO WhatsApp Alert

Receive daily updates about open IPOs directly on your WhatsApp!  
This project fetches current IPO data, formats it with user-friendly highlights and emojis, and sends it to your WhatsApp using Green API - all automatically, every morning at 10:00 AM IST.

---

## ✨ Features

- **Automated Scheduling:** Runs daily at 10:00 AM IST via GitHub Actions.
- **WhatsApp Alerts:** Sends IPO updates to your WhatsApp using Green API.
- **Rich Formatting:** Uses bold text and emojis for easy readability.
- **All IPO Types:** Supports both mainboard and SME IPOs.
- **Secure:** Credentials are stored as encrypted GitHub secrets.

---

## 📦 Project Structure

ipo-whatsapp-alert/
├── ipo_whatsapp_alert.py # Main Python script
├── requirements.txt # Python dependencies
└── .github/
└── workflows/
└── schedule.yml # GitHub Actions workflow


---

## ⚙️ How It Works

1. **Fetches IPO data** from [Investorgain](https://www.investorgain.com/).
2. **Filters open IPOs** (where today is between open and close dates).
3. **Formats the message** with company, category, dates, price, GMP, and emojis.
4. **Sends the message** to your WhatsApp number using Green API.
5. **Runs automatically** every day at 10:00 AM IST via GitHub Actions.

---

## 🚦 Example WhatsApp Message

🚀 Open IPOs Today

🏢 Company Name
🏷️ Category: SME
📅 Open Date: 15-May
📅 Close Date: 18-May
📈 Listing Date: 25-May
💰 Price: ₹101
🚦 GMP: ₹15


---

## 🛠️ Setup & Deployment

### 1. **Fork or Clone This Repository**

git clone https://github.com/your-username/ipo-whatsapp-alert.git
cd ipo-whatsapp-alert


### 2. **Set Up Green API**

- Register at [Green API](https://green-api.com/).
- Create an instance and scan the QR code with your WhatsApp.
- Note your **Instance ID** and **API Token**.

### 3. **Add GitHub Secrets**

Go to your repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**.  
Add the following:

| Name         | Value (Example)         |
|--------------|------------------------|
| INSTANCE_ID  | `1234567890`           |
| API_TOKEN    | `abcdef1234567890...`  |
| TO_PHONE     | `919999999999`         |

### 4. **Review or Edit the Script**

- The script is ready to use, but you can customize formatting or data fields in `ipo_whatsapp_alert.py`.

### 5. **GitHub Actions Workflow**

- The workflow file `.github/workflows/schedule.yml` is preconfigured to run daily at 10:00 AM IST.
- You can also trigger it manually from the **Actions** tab.

---

## 🔒 Security

- Your Green API credentials and WhatsApp number are stored securely as **GitHub Actions secrets**.
- Never commit your credentials directly to the repository.

---

## 💡 Customization

- **Change schedule:** Edit the `cron` line in `.github/workflows/schedule.yml` to adjust run time.
- **Add more data fields:** Modify the message formatting in `ipo_whatsapp_alert.py`.
- **Send to multiple numbers:** Extend the script to loop through a list of recipients.

---

## 🧩 Dependencies

- [requests](https://pypi.org/project/requests/) - For making HTTP requests.

Install locally with:
pip install -r requirements.txt


---

## 🙋 FAQ

**Q: Can I use this with my personal WhatsApp?**  
A: Yes! Green API works with regular WhatsApp accounts.

**Q: Is this free?**  
A: Yes, both GitHub Actions and Green API have free tiers suitable for personal use.

**Q: What if I want to run this at a different time?**  
A: Change the `cron` schedule in the workflow file.

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

---

## 🌟 Contributions

Pull requests and suggestions are welcome!  
Feel free to fork this repo and enhance the project.

---

## 📬 Contact

For help or feedback, open an [issue](https://github.com/your-username/ipo-whatsapp-alert/issues) or reach out via GitHub.

---

**Happy Investing! 🚀**
