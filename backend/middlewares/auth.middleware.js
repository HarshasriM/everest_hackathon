// middlewares/auth.middleware.js
export const isAuthenticated = (req, res, next) => {
  if (!req.session || !req.session.user) {
    return res.status(401).json({ message: "Unauthorized, please log in first" });
  }

  req.user = req.session.user; // store logged-in user info
  next();
};
