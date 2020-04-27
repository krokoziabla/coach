using Sqlite;

class Task
{
    public string uuid;
    public uint8[] id;
    public string name;
    public double time; // seconds

    public Task() {}

    public Task.with(string uuid, string name, double time)
    {
        this.uuid = uuid;
        this.name = name;
        this.time = time;
        this.id = new uint8[16];
    }

    public void bind_to(Statement statement)
    {
        var ret = statement.bind_text(statement.bind_parameter_index(":uuid"), uuid);

        if ( ret != OK )
        {
            //print("bind %s\n", db.errmsg());
        }

        ret = statement.bind_blob(statement.bind_parameter_index(":id"), id, id.length);

        if ( ret != OK )
        {
            //print("bind %s\n", db.errmsg());
        }

        ret = statement.bind_text(statement.bind_parameter_index(":name"), name);

        if ( ret != OK )
        {
            //print("bind %s\n", db.errmsg());
        }

        ret = statement.bind_double(statement.bind_parameter_index(":time"), time);

        if ( ret != OK )
        {
            //print("bind %s\n", db.errmsg());
        }
    }

    public static Task from(Statement statement)
    {
        var task = new Task();
        task.uuid = statement.column_text(0);
        task.name = statement.column_text(1);
        task.time = statement.column_double(2);
        unowned var blob = (uint8[]) statement.column_blob(3);
        blob.length = statement.column_bytes(3);
        task.id = blob.copy();
        return task;
    }
}
