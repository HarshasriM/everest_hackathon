import express from "express";
import { sendSosAlert } from "../controllers/sos.controller.js";
const router = express.Router();

router.post("/send-sos-alert", sendSosAlert);

export default router;