
import express from "express";
import { getEmergencyContacts, addEmergencyContact, updateEmergencyContact, deleteEmergencyContact } from "../controllers/emergency.controller.js";
const router = express.Router();

router.get("/get-emergency-contacts/:userId", getEmergencyContacts);
router.post("/add-emergency-contact", addEmergencyContact);
router.put("/update/:userId/:contactId", updateEmergencyContact);
router.delete("/delete/:userId/:contactId", deleteEmergencyContact);

export default router;