import express from "express";
import { updateProfile, getUser,addEmergencyContact } from "../controllers/user.controller.js";

const router = express.Router();

router.put("/:userId", updateProfile);
router.get("/:userId", getUser);
router.post("/add-emergency-contact", addEmergencyContact);
export default router;
