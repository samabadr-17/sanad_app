import 'package:flutter/material.dart';

import '../../data/model/order_model.dart';
import '../../data/model/provider_model.dart';
import '../../data/model/service_model.dart';

class ClientHomeProvider extends ChangeNotifier {
  // services in the client home screen
  final List<ServiceModel> _services = [
    ServiceModel(id: '1', title: 'النقاشة', icon: "assets/icons/paint-roller.svg"),
    ServiceModel(id: '2', title: 'صيانة الأجهزة المنزلية', icon: "assets/icons/washing-machine.svg"),
    ServiceModel(id: '3', title: 'السباكة', icon: "assets/icons/vertor.svg"),
    ServiceModel(id: '4', title: 'النجارة', icon: "assets/icons/hammer.svg"),
    ServiceModel(
      id: '5',
      title: 'الكهرباء',
      icon: "assets/icons/plug-zap.svg",
    ),
    ServiceModel(
      id: '6',
      title: 'صيانة المركبات',
      icon: "assets/icons/car-front.svg",
    ),
  ];

  // current order
  final List<OrderModel> _orders = [
    OrderModel(
      id: 'SN-2048',
      title: 'إصلاح غسالة أوتوماتيك',
      status: 'زيارة مجدولة',
      date: 'الأحد، 10 نوفمبر',
      details: 'أحمد محمود • مدينة نصر',
    ),
  ];

  // recommended services providers
  final List<ProviderModel> _providers = [
    ProviderModel(
      id: '1',
      name: 'أحمد سمير',
      initial: 'أ س',
      speciality: 'متخصص صيانة وإصلاح الأجهزة',
      rating: '4.9 (126 تقييم)',
      experience: 'خبرة 8 سنوات',
      availablity: 'متاح اليوم',
      price: 150,
      serviceId: '2',
    ),
    ProviderModel(
      id: '2',
      name: 'محمد علي',
      initial: 'م ع',
      speciality: 'متخصص صيانة وإصلاح الأجهزة',
      rating: '4.1 (119 تقييم)',
      experience: 'خبرة 6 سنوات',
      availablity: 'متاح غدا',
      price: 150,
      serviceId: '2',
    ),
  ];

  // storing id of selected servic
  String? _selectedServiceId;

  // getters to access private data "we can access the lists through provider"
  List<ServiceModel> get services => _services;
  List<OrderModel> get orders => _orders;
  List<ProviderModel> get providers => _providers;

  // function that is called when the client choose service where id of the selected dercive is recieeved
  void selectService(String serviceId) {
    _selectedServiceId = serviceId;
    // notify the ui that the selected service changed
    notifyListeners();
  }

  // getter return list of providers acc to selected service
  List<ProviderModel> get filteredProviders {
    // if no service is selected, display all providers
    if (_selectedServiceId == null) {
      return _providers;
    } else {
      // else return only providers related to the selected service
      return _providers.where((provider) {
        return provider.serviceId == _selectedServiceId;
      }).toList(); // convert it to list
    }
  }
}
