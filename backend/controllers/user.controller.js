import User from "../models/user.model.js";

// Complete or update profile
export const updateProfile = async (req, res) => {
  try {
    const { userId } = req.params;
    const updatedData = req.body;

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
