interface Task : Object
{
    public abstract string uuid { get; }
    public abstract string name { get; }
    public abstract double elapsed_time { get; set; } // seconds
}
