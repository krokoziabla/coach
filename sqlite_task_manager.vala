using Gee;
using Sqlite;

class SqliteTaskManager : Object, TaskManager
{
    private Map<string, Task> id2task = new HashMap<string, Task>();
    private Database db;

    public SqliteTaskManager()
    {
        if ( Database.open("coach.db", out db) != Sqlite.OK ) print("Cannot open db\n");
    }

    public void print_tasks()
    {
        var i = id2task.iterator();
        while (i.next())
        {
            var task = i.@get().value;
            print("%s\t%s\n", task.name, format_time(task.elapsed_time));
        }
    }

    public string create_task(string label)
    {
        var task = new SqliteTask(Uuid.string_random(), label);
        id2task.@set(task.uuid, task);
        return task.uuid;
    }

    public Task get_task(string id) { return id2task.@get(id); }

    private static string format_time(double time) { return new DateTime.from_unix_utc((int64) time).format("%T"); }
}
