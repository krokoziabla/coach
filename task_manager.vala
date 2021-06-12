interface TaskManager : Object
{
    public abstract string create_task(string label);
    public abstract Task get_task(string id);
    public abstract void print_tasks();
}
