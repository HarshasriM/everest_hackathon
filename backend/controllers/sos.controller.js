

import twilio from "twilio";
import dotenv from "dotenv";
dotenv.config();

const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

export const sendSosAlert = async (req, res) => {
  try {
    const { username, phoneNumbers, location } = req.body;

    // phoneNumbers should be an array of strings
    if(!username){
      username = "Your near ones";
    }
    if (!phoneNumbers || !Array.isArray(phoneNumbers) || phoneNumbers.length === 0 || !location) {
      return res.status(400).json({ message: "username, phoneNumbers[], and location are required" });
    }

    const message = `${username} in danger! 📍Location: ${location}`;

    const results = [];

    for (const number of phoneNumbers) {
      try {
        const msg = await client.messages.create({
          body: message,
          from: process.env.TWILIO_PHONE_NUMBER,
          to: number,
        });
        results.push({ number, status: "sent", sid: msg.sid });
      } catch (error) {
        results.push({ number, status: "failed", error: error.message });
      }
    }

    return res.status(200).json({
      success: true,
      message: "SOS alerts processed",
      results,
    });
  } catch (error) {
    console.error("SOS Alert Error:", error);
    res.status(500).json({ message: "Failed to send SOS alerts", error: error.message });
  }
};

