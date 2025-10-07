import mongoose from "mongoose";

const emergencyContactSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
  name: { type: String, },
  phoneNumber: { type: String, },
  relationship: { type: String, },
});

export default emergencyContactSchema;
