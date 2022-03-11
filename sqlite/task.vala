class SqliteTask : Object, Task
{
    private Database db;

    private string _uuid;
    private string _name;
    private double _elapsed_time;

    public string uuid { get { return _uuid; } }
    public string name { get { return _name; } }

    public double elapsed_time {
        get { return _elapsed_time; }
        set {
            var query = db.prepare("""
                UPDATE task
                SET time = :time
                WHERE uuid = :uuid
                RETURNING time
            """);
            query.set_string(":uuid", _uuid);
            query.set_double(":time", value);

            for (var task = query.execute(); !task.finished; task.next())
            {
                _elapsed_time = task.get_double("time");
                break;
            }
        }
    }

    public SqliteTask(string uuid, Database db)
    {
        this.db = db;

        var query = db.prepare("""
            SELECT uuid, name, time
            FROM task
            JOIN task_type
            USING (uuid)
            WHERE uuid = :uuid AND date = date('now')
        """);
        query.set_string(":uuid", uuid);

        for (var task = query.execute(); !task.finished; task.next())
        {
            _uuid = task.get_string("uuid");
            _name = task.get_string("name");
            _elapsed_time = task.get_double("time");
            break;
        }
    }
}

