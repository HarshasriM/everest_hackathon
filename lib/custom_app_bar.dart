import 'package:everest_hackathon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SHEAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? title;
  final double imageSize;

  const SHEAppBar({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
    this.title,
    this.imageSize = 40.0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.85), // Reduced opacity
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Lighter shadow
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle decorative elements
          Positioned(
            top: -15,
            right: -15,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03), // More subtle
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03), // More subtle
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side - Back button and title
                Row(
                  children: [
                    if (showBackButton)
                      GestureDetector(
                        onTap: onBackPressed ?? () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1), // Lighter
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2), // Lighter border
                              width: 1.2,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 16, // Slightly smaller
                          ),
                        ),
                      ),
                    
                    const SizedBox(width: 12),
                    
                    // SHE Logo with subtle design
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08), // Lighter
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2), // Lighter border
                              width: 1.2,
                            ),
                          ),
                          child: const Text(
                            "S",
                            style: TextStyle(
                              fontSize: 16, // Slightly smaller
                              fontWeight: FontWeight.w600, // Less bold
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.2,
                            ),
                          ),
                          child: const Text(
                            "H",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.2,
                            ),
                          ),
                          child: const Text(
                            "E",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    if (title != null) ...[
                      const SizedBox(width: 12),
                      
                      // Subtle divider
                      Container(
                        width: 1,
                        height: 20,
                        color: Colors.white.withOpacity(0.2), // Lighter
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Title
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500, // Less bold
                          color: Colors.white.withOpacity(0.9), // Slightly transparent
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ],
                ),

                // Right side - Profile Image with Tooltip
                _buildProfileImageWithTooltip(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageWithTooltip(BuildContext context) {
    return Tooltip(
      message: "Support", // Tooltip text
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            context.push(AppRoutes.helpSupport);
          },
          child: Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.25), // Lighter border
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // Lighter shadow
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                "assets/images/niya.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15), // Lighter fallback
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: imageSize * 0.5,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Compact version for simpler screens
class SHEAppBarCompact extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? title;

  const SHEAppBarCompact({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.85), // Reduced opacity
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06), // Lighter shadow
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side
            Row(
              children: [
                if (showBackButton)
                  IconButton(
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 18, // Smaller
                    ),
                    splashRadius: 20, // Smaller splash
                  ),
                Text(
                  "SHE",
                  style: TextStyle(
                    fontSize: 20, // Slightly smaller
                    fontWeight: FontWeight.w600, // Less bold
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                if (title != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    "•",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4), // More subtle
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w400, // Less bold
                    ),
                  ),
                ],
              ],
            ),

            // Right side - Profile Image with Tooltip
            Tooltip(
              message: "Support",
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.helpSupport);
                  },
                  child: Container(
                    width: 34, // Slightly smaller
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25), // Lighter border
                        width: 1.2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/niya.jpg",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}