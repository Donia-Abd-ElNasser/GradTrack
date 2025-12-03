import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/screens/all_chats/group_creation/group_creation_cubit.dart';

import 'package:gradtrack/screens/group/all_student_cubit/all_student_cubit.dart';

class GroupView extends StatelessWidget {
  GroupView({super.key});
  final TextEditingController groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),
            ),
           Padding(
              padding: const EdgeInsets.only(bottom: 14,left: 14,right: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: groupNameController,
                  style: const TextStyle(
                    
                    color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Group Name",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                    ),
                   // prefixIcon: const Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),
            ),
           // const SizedBox(height: 14),
    
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
    
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                onPressed: () {
                  final groupName = groupNameController.text.trim();
                  final selectedStudents =
                      context.read<AllStudentCubit>().getSelectedStudents();
    
                  if (groupName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter group name")),
                    );
                    return;
                  }
    
                  if (selectedStudents.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Select students first")),
                    );
                    return;
                  }
    
                  final selectedIds =
                      selectedStudents.map((s) => s.id).toList();
    
                  BlocProvider.of<GroupCreationCubit>(context).createGroup(
                    groupName: groupName,
                    memberIds: selectedIds,
                  );
                  print('------------->${groupName}----------->');
                  print("Selected Students:");
  for (var student in selectedStudents) {
    print(" - Name: ${student.name}, Email: ${student.email}, ID: ${student.id}");
  }
                },
                child: const Text(
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
