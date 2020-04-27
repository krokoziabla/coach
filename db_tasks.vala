using Sqlite;

class TasksDao
{
    private unowned Sqlite.Database db;

    private Statement insert_statement;
    private Statement select_statement;

    public TasksDao(Sqlite.Database db)
    {
        this.db = db;

        string query = """
            CREATE TABLE IF NOT EXISTS task
            (
                date CHARACTER(22),
                uuid CHARACTER(36),
                id blob,
                name TEXT,
                time DOUBLE,
                PRIMARY KEY (date, uuid)
            )""";

        string message;
        var ret = db.exec(query, null, out message);

        if ( ret != Sqlite.OK )
        {
            print("%s\n", message);
        }

        query = """
            INSERT INTO task (date, uuid, id, name, time)
            VALUES
                (date('now'), '', randomblob(16), 'a', 0),
                (date('now'), '', randomblob(16), 'b', 0)
        """;

        ret = db.exec(query, null, out message);

        if ( ret != Sqlite.OK )
        {
            print("%s\n", message);
        }

        query = """
            INSERT OR REPLACE INTO task (date, uuid, id, name, time)
            VALUES (date('now'), :uuid, :id, :name, :time)
        """;

        ret = db.prepare_v2(query, query.length, out insert_statement);

        if ( ret != OK )
        {
            print("prepare %s\n", db.errmsg());
        }

        query = "SELECT uuid, name, time, id FROM task WHERE id = :uuid AND date = date('now')";

        ret = db.prepare_v2(query, query.length, out select_statement);

        if ( ret != OK )
        {
            print("prepare %s\n", db.errmsg());
        }
    }

    public void update(Task task)
    {
        task.bind_to(insert_statement);

        var ret = insert_statement.step();

        if ( ret != DONE )
        {
            print("step %s\n", db.errmsg());
        }

        ret = insert_statement.reset();

        if ( ret != OK )
        {
            print("reset %s\n", db.errmsg());
        }
    }

    public Task read(uint8[] uuid)
    {
        var ret = select_statement.bind_blob(insert_statement.bind_parameter_index(":uuid"), uuid, uuid.length);

        if ( ret != OK )
        {
            print("bind %s\n", db.errmsg());
        }

        Task? task = null;

        while ( true )
        {
            ret = select_statement.step();

            if ( ret != ROW )
            {
                break;
            }

            if ( task != null )
            {
                print("more than one uuid\n");
            }
            else
            {
                task = Task.from(select_statement);
            }
        }

        if ( ret != DONE )
        {
            print("step %s\n", db.errmsg());
        }

        ret = select_statement.reset();

        if ( ret != OK )
        {
            print("reset %s\n", db.errmsg());
        }

        return task ?? new Task.with("", "", 0.0);
    }
}
