import express from "express";
import { updateProfile, getUser} from "../controllers/user.controller.js";

const router = express.Router();

router.put("/:userId", updateProfile);
router.get("/:userId", getUser);
export default router;
