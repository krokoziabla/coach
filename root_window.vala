using Gee;

[GtkTemplate (ui = "/krokoziabla/coach/root_window.glade")]
class RootWindow : Gtk.ApplicationWindow
{
    private Map<string, Task> id2task = new HashMap<string, Task>();

    public RootWindow(Gtk.Application app)
    {
        Object(application: app);

        Timeout.add(1000, this.refresh_current_time);
    }

    [GtkChild]
    private Gtk.ListBox tasks;

    [GtkChild]
    private Gtk.Label current_time;

    [GtkChild]
    private Gtk.Label current_label;

    private Task? current;

    [GtkCallback]
    private void on_task_added(Gtk.Entry entry)
    {
        if (entry.text == "")
        {
            return;
        }

        var task = new Task(Uuid.string_random(), entry.text);
        id2task.@set(task.uuid, task);

        var label = new Gtk.Label(task.name);
        label.visible = true;
        label.set_data("uuid", task.uuid);
        tasks.prepend(label);

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
        current_label.label = current.name;

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
}
