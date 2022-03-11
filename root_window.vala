[GtkTemplate (ui = "/krokoziabla/coach/root_window.glade")]
class RootWindow : Gtk.ApplicationWindow, TaskView
{
    public RootWindow(Gtk.Application app)
    {
        Object(application: app);

        presenter = new TaskPresenter(this);
    }

    public override void destroy()
    {
        presenter.on_task_selected(null);
        base.destroy();
    }


    [GtkChild]
    private unowned Gtk.ListBox tasks;

    [GtkChild]
    private unowned Gtk.Label current_time;

    private TaskPresenter presenter;

    [GtkCallback]
    private void on_task_proposed(Gtk.Entry entry)
    {
        if ( entry.text == "" ) return;

        presenter.on_task_proposed(entry.text);

        entry.text = "";
    }

    [GtkCallback]
    private void on_task_selected(Gtk.ListBox tasks, Gtk.ListBoxRow? row)
    {
        if (row != null)
            presenter.on_task_selected(row.get_child().get_data("uuid"));
        else
            presenter.on_task_selected(null);
    }

    public void create_widget(string text, string uuid)
    {
        var label = new Gtk.Label(text);
        label.visible = true;
        label.set_data("uuid", uuid);
        tasks.prepend(label);
    }

    public void refresh_current_time(string time) { current_time.label = time; }
}
