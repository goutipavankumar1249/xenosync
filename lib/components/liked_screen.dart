// import 'package:flutter/material.dart';
//
// class LikedScreen extends StatelessWidget {
//   final List<String> likedProfiles = ["User1", "User2", "User3"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: likedProfiles.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: _buildProfileCard(context, likedProfiles[index], Colors.blue[100], "{UserName} liked your profile"),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildProfileCard(BuildContext context, String userName, Color? backgroundColor, String message) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       width: MediaQuery.of(context).size.width,  // MediaQuery works here
//       height: 55,
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 45,
//             height: 45,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               shape: BoxShape.circle,
//             ),
//           ),
//           SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 message.replaceAll("{UserName}", userName),
//                 style: TextStyle(
//                   fontFamily: 'Montserrat',
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'interaction.dart';
import 'interaction_service.dart';

class LikedScreen extends StatelessWidget {
  final InteractionService _interactionService = InteractionService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserInteraction>>(
      stream: _interactionService.getLikedByStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final interactions = snapshot.data ?? [];

        return interactions.isEmpty
            ? Center(child: Text('No likes yet'))
            : ListView.builder(
          itemCount: interactions.length,
          itemBuilder: (context, index) {
            final interaction = interactions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildProfileCard(
                context,
                interaction.userName,
                interaction.userImage,
                Colors.blue[100],
                "${interaction.userName} liked your profile",
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, String userName, String userImage,
      Color? backgroundColor, String message) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: 55,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: userImage.isNotEmpty
                    ? NetworkImage(userImage)
                    : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
