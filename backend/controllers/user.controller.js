import User from "../models/user.model.js";
import mongoose from "mongoose";
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

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    // Create new subdocument (this auto-generates _id)
    const newContact = {
      _id: new mongoose.Types.ObjectId(),
      name,
      phoneNumber,
      relation,
      user: userId,
    };

    user.emergencyContacts.push(newContact);
    await user.save();
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
      data: {
        contact_id: newContact._id,
        name: newContact.name,
        phoneNumber: newContact.phoneNumber,
        relation: newContact.relation,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};



export const updateEmergencyContact = async (req, res) => {
  try {
    const { userId, contactId } = req.params;
    const { name, phoneNumber, relationship } = req.body;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    const contact = user.emergencyContacts.id(contactId);
    if (!contact) {
      return res.status(404).json({ success: false, message: "Contact not found" });
    }

    // Update fields
    if (name) contact.name = name;
    if (phoneNumber) contact.phoneNumber = phoneNumber;
    if (relationship) contact.relationship = relationship;

    await user.save();

    res.status(200).json({
      success: true,
      message: "Emergency contact updated successfully",
      data: {
        contact_id: contact._id,
        name: contact.name,
        phoneNumber: contact.phoneNumber,
        relation: contact.relation,
      },
    });
  } catch (error) {
    console.error("Error updating contact:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};


export const deleteEmergencyContact = async (req, res) => {
  try {
    const { userId, contactId } = req.params;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    const contact = user.emergencyContacts.id(contactId);
    if (!contact) {
      return res.status(404).json({ success: false, message: "Contact not found" });
    }

    contact.deleteOne();
    await user.save();

    res.status(200).json({
      success: true,
      message: "Emergency contact deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting contact:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

export const getEmergencyContacts = async (req, res) => {
  try {
    const { userId } = req.params; 
    const user = await User.findById(userId).select("emergencyContacts");
    if (!user) {
      return res.status(404).json({ success: false, message: "User not found" });
    } 
    res.status(200).json({
      success: true,
      data: user.emergencyContacts,
    });
  } catch (error) {
    console.error("Error fetching contacts:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

