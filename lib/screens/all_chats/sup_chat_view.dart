import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/core/routes.dart';
import 'package:gradtrack/screens/all_chats/group/groups_cubit.dart';
import 'package:gradtrack/screens/all_chats/group/groups_state.dart';
import 'package:gradtrack/screens/auth/model/group_model.dart';
import 'package:intl/intl.dart';

class SupChatView extends StatelessWidget {
  const SupChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsCubit()..fetchGroups(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Groups",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 18),
                // 🔍 Search
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Search group...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 📌 groups list
                BlocBuilder<GroupsCubit, GroupsState>(
                  builder: (context, state) {
                    if (state is GroupsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GroupsFailure) {
                      return Center(
                          child: Text("Error: ${state.errrmssg}"));
                    } else if (state is GroupsSuccess) {
                      final List<GroupModel> groups = state.groups;
                      if (groups.isEmpty) {
                        return const Center(child: Text("No Groups Yet"));
                      }

                      return ListView.builder(
                        itemCount: groups.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          final time = group.time;
String timeOnly = DateFormat('hh:mm a').format(time.toDate());
                          return GestureDetector(
                            onTap: () {
                               GoRouter.of(context).push(AppRoutes.kGroupChat,extra: group);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: kGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.peopleGroup,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          group.name,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${group.members.length} Members",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Great Work,that\'s an amazing team',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    timeOnly,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
