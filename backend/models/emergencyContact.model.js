import mongoose from "mongoose";

const emergencyContactSchema = new mongoose.Schema({
  name: { type: String, required: true },
  phoneNumber: { type: String, required: true },
  relationship: { type: String, required: true },
  isPrimary: { type: Boolean, default: false },
  canReceiveSosAlerts: { type: Boolean, default: true },
  canTrackLocation: { type: Boolean, default: false },
  email: { type: String },
});

export default emergencyContactSchema;
