using Gee;

[GtkTemplate (ui = "/krokoziabla/coach/root_window.glade")]
class RootWindow : Gtk.ApplicationWindow
{
    public RootWindow(Gtk.Application app)
    {
        Object(application: app);

        Timeout.add(1000, this.refresh_current_time);

        if ( Sqlite.Database.open("main.db", out db) != Sqlite.OK )
        {
            print("Cannot open db\n");
        }
        tasks_dao = new TasksDao(db);

        tasks.@foreach(row => create_task_for((row as Gtk.ListBoxRow).get_child()));
    }

    [GtkChild]
    private Gtk.ListBox tasks;

    [GtkChild]
    private Gtk.Label current_time;

    private Task? current;
    private Timer timer = new Timer();
    private Sqlite.Database db;
    private TasksDao tasks_dao;

    [GtkCallback]
    private void on_task_added(Gtk.Entry entry)
    {
        if ( entry.text == "" )
        {
            return;
        }

        var label = new Gtk.Label(entry.text);
        label.visible = true;
        tasks.prepend(label);

        create_task_for(label);

        entry.text = "";
    }

    [GtkCallback]
    private void on_task_selected(Gtk.ListBox tasks, Gtk.ListBoxRow? row)
    {
        timer.stop();
        if ( current != null )
        {
            current.time += timer.elapsed();
            tasks_dao.update(current);
            current = null;
        }

        if ( row == null )
        {
            return;
        }

        unowned var id = (uint8[]) row.get_child().get_data<uint *>("id");
        id.length = row.get_child().get_data("id_size");
        print("%d\n", id.length);
        current = tasks_dao.read(id);
        timer.start();

        refresh_current_time();
    }

    private bool refresh_current_time()
    {
        if ( current != null )
        {
            current_time.label = format_time(current.time + timer.elapsed());
        }
        return true;
    }

    private void create_task_for(Gtk.Widget widget)
    {
        var task = new Task.with(Uuid.string_random(), (widget as Gtk.Label).label, 0);
        tasks_dao.update(task);
        widget.set_data("uuid", task.uuid);
        widget.set_data("id", task.id);
        widget.set_data("id_size", task.id.length);
    }

    private static string format_time(double time)
    {
        return new DateTime.from_unix_utc((int64) time).format("%T");
    }
}
