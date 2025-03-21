import 'package:agape/auth/screens/login_screen.dart';
import 'package:agape/common/controllers/record_controller.dart';
import 'package:agape/common/screens/record_list.dart';
import 'package:agape/common/screens/register_record.dart';
import 'package:agape/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({super.key});

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  @override
  Widget build(BuildContext context) {
    final statAsync = ref.watch(statsProvider);

    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: secondaryColor,
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(height: 20),
                statAsync.when(
                  data: (stats) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 253, 252),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: iconsColor,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${stats['disability']?['total_records'] ?? 0}",
                                            style: const TextStyle(
                                              fontSize: 40.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                      const Text(
                                        'Total records',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 156, 151, 151),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            // wheelchair data
                            Expanded(
                              child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 253, 252),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.wheelchair_pickup_sharp,
                                            size: 60,
                                            color: iconsColor,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            stats['disability']['equipments']
                                                .values
                                                .reduce((sum, val) => sum + val)
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 40.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                      const Text(
                                        'Total Wheelchairs',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 156, 151, 151),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ]),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                ),
                const SizedBox(
                  height: 20,
                ),
                //the two cards goes here
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterRecord(recordId: null)),
                        );
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 253, 252),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.person_add,
                              size: 90,
                              color: iconsColor,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 156, 151, 151),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    //list card
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserListPage()),
                        );
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.list,
                              size: 90,
                              color: iconsColor,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Recipient List',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 156, 151, 151),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                )
              ]),
            ),
          ),
        ));
  }
}
