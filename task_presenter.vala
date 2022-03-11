class TaskPresenter
{
    private Timer timer = new Timer();
    private Task? current;
    private TaskManager manager = new SqliteTaskManager({
        "Туалет",
        "Обед",
        "Почта",
        "Переписка",
        "Перерыв",
        "Простой",
        "Выбор",
        "Ревью",
    });
    private weak TaskView view;

    public TaskPresenter(TaskView view)
    {
        Timeout.add(1000, this.refresh_current_time);
        this.view = view;

        var tasks = manager.list_tasks();
        foreach (var task in tasks)
        {
            view.create_widget(task.name, task.uuid);
        }
    }


    public void on_task_proposed(string text)
    {
        view.create_widget(text, manager.create_task(text));
    }

    public void on_task_selected(string? id)
    {
        timer.stop();
        if ( current != null )
        {
            current.elapsed_time += timer.elapsed();
            current = null;
        }

        if ( id == null ) return;

        current = manager.get_task(id);
        timer.start();

        refresh_current_time();
    }

    private bool refresh_current_time()
    {
        if ( current != null ) view.refresh_current_time(format_time(current.elapsed_time + timer.elapsed()));
        return true;
    }

    private static string format_time(double time) { return new DateTime.from_unix_utc((int64) time).format("%T"); }
}
