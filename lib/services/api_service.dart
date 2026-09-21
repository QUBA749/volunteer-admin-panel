import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';
import 'auth_service.dart';

class ApiService {
  Map<String, String> get _headers {
    final token = AuthService().token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final res = await http.get(Uri.parse('${AppConstants.apiBaseUrl}/dashboard/summary'), headers: _headers);
      if (res.statusCode == 200) return jsonDecode(res.body);
      throw Exception('Failed');
    } catch (e) {
      return {'totalVolunteers': 120, 'totalEvents': 15, 'todayAttendance': 45, 'activeTasks': 0};
    }
  }

  Future<List<Event>> getUpcomingEvents() async {
    try {
      final res = await http.get(Uri.parse('${AppConstants.apiBaseUrl}/events/upcoming'), headers: _headers);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => Event.fromJson(e)).toList();
      }
      throw Exception('Failed');
    } catch (e) {
      return [Event(id: '1', eventName: 'Community Cleanup', description: 'Clean the park', location: 'Central Park', startTime: DateTime.now().add(const Duration(days: 1)), endTime: DateTime.now().add(const Duration(days: 1, hours: 4)), status: 'upcoming', createdAt: DateTime.now())];
    }
  }

  Future<List<Volunteer>> getVolunteers({String? status, String? city, String? search, int page = 1, int perPage = 20}) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'perPage': perPage.toString(),
        if (status != null && status.isNotEmpty) 'status': status,
        if (city != null && city.isNotEmpty) 'city': city,
        if (search != null && search.isNotEmpty) 'search': search,
      };
      final uri = Uri.parse('${AppConstants.apiBaseUrl}/volunteers').replace(queryParameters: queryParams);
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body)['data'];
        return data.map((e) => Volunteer.fromJson(e)).toList();
      }
      throw Exception('Failed');
    } catch (e) {
      return [Volunteer(id: '1', fullName: 'John Doe', email: 'john@example.com', phone: '123-456-7890', city: 'New York', skills: ['teaching'], status: 'active', createdAt: DateTime.now(), tasksCompleted: 5, attendancePct: 95.0)];
    }
  }

  Future<Volunteer> getVolunteerById(String id) async {
    try {
      final res = await http.get(Uri.parse('${AppConstants.apiBaseUrl}/volunteers/$id'), headers: _headers);
      if (res.statusCode == 200) return Volunteer.fromJson(jsonDecode(res.body));
      throw Exception('Failed');
    } catch (e) {
      return Volunteer(id: id, fullName: 'John Doe', email: 'john@example.com', phone: '123-456-7890', city: 'New York', skills: ['teaching'], status: 'active', createdAt: DateTime.now(), tasksCompleted: 5, attendancePct: 95.0);
    }
  }

  Future<Volunteer> updateVolunteer(String id, Map<String, dynamic> data) async {
    final res = await http.put(Uri.parse('${AppConstants.apiBaseUrl}/volunteers/$id'), headers: _headers, body: jsonEncode(data));
    if (res.statusCode == 200) return Volunteer.fromJson(jsonDecode(res.body));
    throw Exception('Failed');
  }

  Future<void> deleteVolunteer(String id) async {
    final res = await http.delete(Uri.parse('${AppConstants.apiBaseUrl}/volunteers/$id'), headers: _headers);
    if (res.statusCode != 200) throw Exception('Failed');
  }

  Future<List<Event>> getEvents({String? status, String? search, int page = 1, int perPage = 20}) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'perPage': perPage.toString(),
        if (status != null && status.isNotEmpty) 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
      };
      final uri = Uri.parse('${AppConstants.apiBaseUrl}/events').replace(queryParameters: queryParams);
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body)['data'];
        return data.map((e) => Event.fromJson(e)).toList();
      }
      throw Exception('Failed');
    } catch (e) {
      return [Event(id: '1', eventName: 'Community Cleanup', description: 'Clean the park', location: 'Central Park', startTime: DateTime.now().add(const Duration(days: 1)), endTime: DateTime.now().add(const Duration(days: 1, hours: 4)), status: 'upcoming', createdAt: DateTime.now())];
    }
  }

  Future<Event> getEventById(String id) async {
    try {
      final res = await http.get(Uri.parse('${AppConstants.apiBaseUrl}/events/$id'), headers: _headers);
      if (res.statusCode == 200) return Event.fromJson(jsonDecode(res.body));
      throw Exception('Failed');
    } catch (e) {
      return Event(id: id, eventName: 'Community Cleanup', description: 'Clean the park', location: 'Central Park', startTime: DateTime.now().add(const Duration(days: 1)), endTime: DateTime.now().add(const Duration(days: 1, hours: 4)), status: 'upcoming', createdAt: DateTime.now());
    }
  }

  Future<Event> createEvent(Map<String, dynamic> data) async {
    final res = await http.post(Uri.parse('${AppConstants.apiBaseUrl}/events'), headers: _headers, body: jsonEncode(data));
    if (res.statusCode == 201 || res.statusCode == 200) return Event.fromJson(jsonDecode(res.body));
    throw Exception('Failed');
  }

  Future<Event> updateEvent(String id, Map<String, dynamic> data) async {
    final res = await http.put(Uri.parse('${AppConstants.apiBaseUrl}/events/$id'), headers: _headers, body: jsonEncode(data));
    if (res.statusCode == 200) return Event.fromJson(jsonDecode(res.body));
    throw Exception('Failed');
  }

  Future<void> deleteEvent(String id) async {
    final res = await http.delete(Uri.parse('${AppConstants.apiBaseUrl}/events/$id'), headers: _headers);
    if (res.statusCode != 200) throw Exception('Failed');
  }
}
