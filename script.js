(async () => {
  try {
    // IP ve konum verisini al
    const res = await fetch("https://ipapi.co/json/");
    const data = await res.json();

    // Tarih ve saat oluştur
    const now = new Date();
    const hour = now.getHours().toString().padStart(2, '0');
    const minute = now.getMinutes().toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const year = now.getFullYear();

    const time = `${hour}:${minute}`;
    const date = `${day}/${month}/${year}`;

    // Embed verisi
    const embedData = {
      embeds: [
        {
          title: "New Visitor from Website",
          color: 0x7289da,
          fields: [
            { name: "Date", value: date, inline: true },
            { name: "Time", value: time, inline: true },
            { name: "IP Address", value: data.ip, inline: false },
            { name: "Country", value: data.country_name, inline: true },
            { name: "Continent", value: data.continent_code, inline: true },
          ],
          timestamp: new Date().toISOString()
        }
      ]
    };

    // Discord webhook URL
    const webhookUrl = "https://discord.com/api/webhooks/1401847218360553592/23yorbGxmhC6fiIOuWfVla91DVzzGZKD2NgeFmvuQwWOg47htnHLMmgikrlTq7yFqG-y";

    // Discord webhook'a gönder
    const response = await fetch(webhookUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(embedData)
    });

    if (response.ok) {
      console.log("Discord webhook message sent successfully.");
    } else {
      console.warn("Failed to send message to Discord webhook.");
    }
  } catch (error) {
    console.error("Error fetching data or sending webhook:", error);
  }
})();
