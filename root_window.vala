[GtkTemplate (ui = "/krokoziabla/coach/root_window.glade")]
class RootWindow : Gtk.ApplicationWindow
{
    public RootWindow(Gtk.Application app)
    {
        Object(application: app);
    }

    [GtkChild]
    private Gtk.ListBox tasks;

    [GtkCallback]
    private void onTaskAdded()
    {
        var label = new Gtk.Label("hello");
        label.visible = true;
        tasks.prepend(label);
    }
}
