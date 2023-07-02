import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/controllers/subscription_controller.dart';

class SubscriptionScreen extends StatelessWidget {
  SubscriptionScreen({super.key});
  final SubscriptionController subscriptionController = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Langganan"),
      ),
      body: Obx(
        () => subscriptionController.status != Status.success
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Column(
                children: [
                  Text(subscriptionController.updater.toString(), style: smallText.copyWith(fontSize: 1, color: Colors.transparent)),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemCount: subscriptionController.subscription.length,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: secondaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(15),
                          width: Get.width,
                          child: Column(
                            children: [
                              Text(subscriptionController.subscription[index].name ?? '-', style: h3),
                              const SizedBox(height: 15),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Rp. ${subscriptionController.subscription[index].amount ?? '-'}",
                                    style: h2.copyWith(color: primaryColor),
                                  ),
                                  Text(
                                    "/${subscriptionController.subscription[index].time ?? '-'} Hari",
                                    style: h5,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.check_circle, color: primaryColor),
                                      SizedBox(width: 10),
                                      Text("Bebas Iklan"),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(subscriptionController.subscription[index].subscriptionType!.contains('2') ? Icons.check_circle : Icons.remove_circle,
                                          color: subscriptionController.subscription[index].subscriptionType!.contains('2') ? primaryColor : secondaryColor),
                                      const SizedBox(width: 10),
                                      const Text("Lihat konten premium"),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(subscriptionController.subscription[index].subscriptionType!.contains('3') ? Icons.check_circle : Icons.remove_circle,
                                          color: subscriptionController.subscription[index].subscriptionType!.contains('3') ? primaryColor : secondaryColor),
                                      const SizedBox(width: 10),
                                      const Text("Download konten premium"),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: defaultButtonStyle,
                                  onPressed: () {
                                    subscriptionController.createPayment(index);
                                  },
                                  child: subscriptionController.buttonLoading[index]
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: secondaryColor))
                                      : const Text("Pilih"),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
