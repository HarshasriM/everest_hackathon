import User from "../models/user.model.js";
import EmergencyContact from "../models/emergencyContact.model.js";
import twilio from "twilio";
import dotenv from "dotenv";
dotenv.config();
// Complete or update profile
export const updateProfile = async (req, res) => {
  try {
    const { userId } = req.params;
    const updatedData = req.body;
    console.log(updatedData);
    const user = await User.findByIdAndUpdate(
      userId,
      { ...updatedData, isProfileComplete: true },
      { new: true }
    );

    if (!user) return res.status(404).json({ message: "User not found" });
    res.status(200).json({ message: "Profile updated successfully", user });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Get user by ID
export const getUser = async (req, res) => {
  try {
    const { userId } = req.params;
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// add emergency contact and send Twilio message



const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

export const addEmergencyContact = async (req, res) => {
  try {
    const {userId,name, phoneNumber, relation } = req.body;
    // const userId = req.user._id; // assuming auth middleware attaches this
    // const userName = req.user.name;

    const newContact = {name,phoneNumber,relation,user:userId};
    const user = await User.findByIdAndUpdate(
      userId,
      { $push: { emergencyContacts: newContact } },
      { new: true } // returns updated user
    );

    // Send Twilio message
    const message = `Hi ${name},

  ${user.name} has added you as an emergency contact in SHE - a women's safety app.

  You will receive SOS alerts with location information if ${user.name} is in danger.

  Stay safe!
  SHE Team`;

    await client.messages.create({
      body: message,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: phoneNumber,
    });

    res.status(201).json({
      success: true,
      message: "Emergency contact added and notified successfully",
      data: newContact,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

