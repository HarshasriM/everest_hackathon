import mongoose from "mongoose";
import emergencyContactSchema from "./emergencyContact.model.js";

const userSchema = new mongoose.Schema(
  {
    phoneNumber: { type: String, required: true, unique: true },
    name: { type: String },
    email: { type: String },
    profileImageUrl: { type: String },
    address: { type: String },

    emergencyContacts: {
      type: [emergencyContactSchema],
      default: [],
    },


    isProfileComplete: { type: Boolean, default: false },
    isVerified: { type: Boolean, default: false },

    lastLoginAt: { type: Date },
  },
  { timestamps: { createdAt: true, updatedAt: false } }
);

const User = mongoose.model("User", userSchema);

export default User;
