import express from "express";
import { updateProfile, getUser,addEmergencyContact,updateEmergencyContact,deleteEmergencyContact, getEmergencyContacts } from "../controllers/user.controller.js";

const router = express.Router();

router.put("/:userId", updateProfile);
router.get("/:userId", getUser);
router.get("/get-emergency-contacts/:userId", getEmergencyContacts);
router.post("/add-emergency-contact", addEmergencyContact);
router.put("/update/:userId/:contactId", updateEmergencyContact);
router.delete("/delete/:userId/:contactId", deleteEmergencyContact);
export default router;
