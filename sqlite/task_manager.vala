using Gee;

class SqliteTaskManager : Object, TaskManager
{
    private Database db;

    public SqliteTaskManager(string[] labels)
    {
        db = new Database("coach.db");

        var rows = db.prepare("""
            SELECT *
            FROM sqlite_master
            WHERE type = 'table' AND name = 'task_type'
        """).execute();

        db.prepare("""
            CREATE TABLE IF NOT EXISTS task_type
            (
                uuid CHARACTER(36),
                name TEXT,
                PRIMARY KEY (uuid)
            )
        """).execute();

        db.prepare("""
            CREATE TABLE IF NOT EXISTS task
            (
                date CHARACTER(22),
                uuid CHARACTER(36) REFERENCES task_type (uuid),
                time DOUBLE,
                PRIMARY KEY (date, uuid)
            )
        """).execute();

        if ( rows.finished )
        {
            foreach (var label in labels)
            {
                create_task(label);
            }
        }
    }

    public Task[] list_tasks()
    {
        var query = db.prepare("""
            SELECT uuid
            FROM task
        """);

        var tasks = new Task[0];
        for (var row = query.execute(); !row.finished; row.next())
        {
            tasks += new SqliteTask(row.get_string("uuid"), db);
        }
        return tasks;
    }

    public string create_task(string label)
    {
        var id = Uuid.string_random();
        db.prepare("""
            INSERT INTO task_type (uuid, name)
            VALUES (:uuid, :name)
        """)
        .execute(
            ":uuid", typeof(string), id,
            ":name", typeof(string), label
        );
        db.prepare("""
            INSERT INTO task (date, uuid, time)
            VALUES (date('now'), :uuid, :time)
        """)
        .execute(
            ":uuid", typeof(string), id,
            ":time", typeof(double), 0.0
        );
        return id;
    }

    public Task get_task(string id) { return new SqliteTask(id, db); }
}
