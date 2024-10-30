class Todo {
  String id;
  String description;
  bool isCompleted;
  DateTime createdDate;
  DateTime? updatedDate;

  Todo({
    required this.id,
    required this.description,
    this.isCompleted = false,
    required this.createdDate,
    DateTime? updatedDate,
  }) : updatedDate = updatedDate ?? createdDate;

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'isCompleted': isCompleted,
        'createdDate': createdDate.toIso8601String(),
        'updatedDate': updatedDate?.toIso8601String(),
      };

  static Todo fromMap(Map<String, dynamic> map) => Todo(
        id: map['id'],
        description: map['description'],
        isCompleted: map['isCompleted'],
        createdDate: DateTime.parse(map['createdDate']),
        updatedDate: map['updatedDate'] != null
            ? DateTime.parse(map['updatedDate'])
            : null,
      );

  // Method to toggle the completion status and update the updatedDate
  void toggleStatus() {
    isCompleted = !isCompleted;
    updatedDate = DateTime.now();
  }
}
