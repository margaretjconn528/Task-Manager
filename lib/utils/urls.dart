class Urls{
  static String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static String SignUpURL = '$_baseUrl/registration';
  static String LoginUrl = '$_baseUrl/login';
  static String AddTaskURL = '$_baseUrl/createTask';
  static String TaskCountURL = '$_baseUrl/taskStatusCount';
  static String ProfileUpdateURL = '$_baseUrl/profileUpdate';
  static String TaskByStatusURL(String status) => '$_baseUrl/listTaskByStatus/$status';
  static String DeleteTaskURL(String id) => '$_baseUrl/deleteTask/$id';
  static String ChangeStatusURL(String id, String status) => '$_baseUrl/updateTaskStatus/$id/$status';
}