class Task
{
    public string uuid;
    public string name;
    private Timer? timer;

    public Task(string uuid, string name)
    {
        this.uuid = uuid;
        this.name = name;
    }

    public void start()
    {
        if (timer == null)
        {
            timer = new Timer();
        }
        else
        {
            timer.@continue();
        }
    }

    public void stop()
    {
        if (timer != null)
        {
            timer.stop();
        }
    }

    public string elapsed()
    {
        return new DateTime.from_unix_utc((int64) (timer != null ? timer.elapsed() : 0.0f)).format("%T");
    }
}
