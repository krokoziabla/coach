class Task
{
    public string uuid;
    public string name;
    public double elapsed_time = 0u; // seconds

    public Task(string uuid, string name)
    {
        this.uuid = uuid;
        this.name = name;
    }
}
