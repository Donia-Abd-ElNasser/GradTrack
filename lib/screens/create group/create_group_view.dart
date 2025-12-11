import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/screens/all_groups/group_creation/group_creation_cubit.dart';
import 'package:gradtrack/screens/create%20group/all_student_cubit/all_student_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({super.key});

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  final TextEditingController groupNameController = TextEditingController();
  // State variable to hold the logged-in user's ID
  String? _currentUserId;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    // Fetch user ID when the widget is initialized, not on every build.
    _fetchCurrentUser();
  }

  // Asynchronous function to fetch the user ID from SharedPreferences
  Future<void> _fetchCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString("userId");
    final savedName = prefs.getString("userName");

    if (savedUserId == null) {
      print("===== No Saved User ID, user not logged in =====");
    } else {
      print("Loaded User → ID: $savedUserId | Name: $savedName");
    }

   
    setState(() {
      _currentUserId = savedUserId;
      _isLoadingUser = false;
    });
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search students...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),
            ),

            // Group Name Text Field
            Padding(
              padding: const EdgeInsets.only(bottom: 14, left: 14, right: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: groupNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Group Name",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),
            ),


            Expanded(
              child: BlocBuilder<AllStudentCubit, AllStudentsState>(
                builder: (context, state) {
                  if (state is StudentsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is StudentsFailure) {
                    return Center(child: Text("Error: ${state.error}"));
                  }

                  if (state is StudentsSuccess) {
                    final students = state.students;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];

                        // Existing student list item logic...
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              // Using kGradient which is defined in constants.dart
                              colors: kGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student.email,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                value: student.selected,
                                activeColor: Colors.black,
                                onChanged: (val) {
                                  BlocProvider.of<AllStudentCubit>(
                                    context,
                                  ).toggleSelect(index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return Container();
                },
              ),
            ),

            // 🎯 Create Group Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed:
                    _isLoadingUser
                        ? null 
                        : () {
                          final groupName = groupNameController.text.trim();
                          final selectedStudents =
                              context
                                  .read<AllStudentCubit>()
                                  .getSelectedStudents();

                          if (_currentUserId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "User not logged in. Cannot create group.",
                                ),
                              ),
                            );
                            return;
                          }

                          if (groupName.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Enter group name")),
                            );
                            return;
                          }

                          if (selectedStudents.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Select students first"),
                              ),
                            );
                            return;
                          }

                          // Collect selected student IDs
                          final selectedIds =
                              selectedStudents.map((s) => s.id).toList();

                          if (!selectedIds.contains(_currentUserId)) {
                            print(
                              '-----------Adding Current User ID: $_currentUserId to members list =============',
                            );
                            selectedIds.add(_currentUserId!);
                          }

                          BlocProvider.of<GroupCreationCubit>(
                            context,
                          ).createGroup(
                            groupName: groupName,
                            memberIds: selectedIds,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Group Created Successfully"),
                            ),
                          );
                          print(
                            '------------->Group Name: $groupName----------->',
                          );
                          print(
                            "Selected Member IDs (including current user): $selectedIds",
                          );
                        },
                child:
                    _isLoadingUser
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          "Create Group",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
