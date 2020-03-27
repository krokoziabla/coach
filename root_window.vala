using Gee;

[GtkTemplate (ui = "/krokoziabla/coach/root_window.glade")]
class RootWindow : Gtk.ApplicationWindow
{
    private Map<string, Task> id2task = new HashMap<string, Task>();

    public RootWindow(Gtk.Application app)
    {
        Object(application: app);

        Timeout.add(1000, this.refresh_current_time);

        tasks.@foreach(row => create_task_for((row as Gtk.ListBoxRow).get_child()));
    }

    public override void destroy()
    {
        base.destroy();

        var i = id2task.iterator();
        while (i.next())
        {
            var task = i.@get().value;
            print("%s\t%s\n", task.name, task.elapsed());
        }
    }

    [GtkChild]
    private Gtk.ListBox tasks;

    [GtkChild]
    private Gtk.Label current_time;

    private Task? current;

    [GtkCallback]
    private void on_task_added(Gtk.Entry entry)
    {
        if (entry.text == "")
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
        if (current != null)
        {
            current.stop();
            current = null;
        }

        if (row == null)
        {
            return;
        }

        current = id2task.@get(row.get_child().get_data("uuid"));
        current.start();

        refresh_current_time();
    }

    private bool refresh_current_time()
    {
        if (current != null)
        {
            current_time.label = current.elapsed();
        }
        return true;
    }

    private void create_task_for(Gtk.Widget widget)
    {
        var task = new Task(Uuid.string_random(), (widget as Gtk.Label).label);
        id2task.@set(task.uuid, task);
        widget.set_data("uuid", task.uuid);
    }
}
