class Overview {
  int total;
  int current;
  int archived;
  int pending;
  int completed;
  int deleted;

  Overview(
      {this.total,
      this.current,
      this.archived,
      this.pending,
      this.completed,
      this.deleted});

  factory Overview.fromJson(Map<String, dynamic> map) {
    return Overview(
        total: map['Total'],
        current: map['Current'],
        archived: map['Archived'],
        pending: map['Pending'],
        completed: map['Completed'],
        deleted: map['Deleted']);
  }
}
