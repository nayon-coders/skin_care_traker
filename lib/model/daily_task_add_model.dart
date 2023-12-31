class DailyTaskAddModel {
  int start;
  String startDate;
  List<TaskList> task;

  DailyTaskAddModel({
    required this.start,
    required this.startDate,
    required this.task,
  });

  Map<String, dynamic> toMap() {
    return {
      'start': {
        'start': start,
        'start_date': startDate,
      },
      'task': task.map((t) => t.toMap()).toList(),
    };
  }
}

class TaskList {
  String date;
  String image;
  String status;
  String isDone;


  TaskList({
    required this.date,
    required this.image,
    required this.status,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'image': image,
      'status': status,
      'isDone' : isDone
    };
  }
}
