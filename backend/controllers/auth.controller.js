import User from "../models/user.model.js";
import twilio from "twilio";
import dotenv from "dotenv";
dotenv.config();

const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
const verifySid = process.env.TWILIO_VERIFY_SERVICE_SID;


// 1️⃣ Send OTP
export const sendOtp = async (req, res) => {
  try {
    const { phoneNumber } = req.body;
    if (!phoneNumber) return res.status(400).json({ message: "Phone number is required" });
     const verification = await client.verify.v2
      .services(verifySid)
      .verifications.create({ to: phoneNumber, channel: "sms" });

    res.json({ message: "OTP sent successfully", sid: verification.sid });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// 2️⃣ Verify OTP
export const verifyOtp = async (req, res) => {
  try {
    const { phoneNumber, otp } = req.body;
    if (!phoneNumber || !otp)
      return res.status(400).json({ message: "Phone number and OTP required" });

     const verificationCheck = await client.verify.v2
        .services(verifySid)
        .verificationChecks.create({
            to: phoneNumber,
            code: otp,
  })

    if (verificationCheck.status !== "approved") {
      return res.status(400).json({ message: "Invalid OTP or Otp expired" });
    }

    // check if user exists, else create
    let user = await User.findOne({ phoneNumber });
    if (!user) {
      user = await User.create({
        phoneNumber,
        isVerified: true,
        isProfileComplete: false,
      });
    } else {
      user.isVerified = true;
      await user.save();
    }


    res.status(200).json({
      message: "OTP verified successfully",
      userId: user._id,
      user:user,
      isProfileComplete: user.isProfileComplete,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
