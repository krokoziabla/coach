class SqliteTask : Object, Task
{
    private string _uuid;
    private string _name;
    public string uuid { get { return _uuid; } }
    public string name { get { return _name; } }
    public double elapsed_time { get; set; default = 0.0; }

    public SqliteTask(string uuid, string name)
    {
        this._uuid = uuid;
        this._name = name;
    }
}

