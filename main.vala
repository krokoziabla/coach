int main(string[] argv)
{
    var app = new Gtk.Application("krokoziabla.coach", ApplicationFlags.FLAGS_NONE);

    app.activate.connect(() => new RootWindow(app).show());
    return app.run(argv);
}
