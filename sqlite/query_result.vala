class QueryResult
{
    private SQLHeavy.QueryResult result;

    public QueryResult(SQLHeavy.QueryResult result)
    {
        this.result = result;
    }

    public bool finished { get { return result.finished; } }

    public virtual double get_double(string field)
    {
        try
        {
            return result.get_double(field);
        }
        catch (SQLHeavy.Error e)
        {
            assert_not_reached();
        }
    }

    public string? get_string(string field)
    {
        try
        {
            return result.get_string(field);
        }
        catch (SQLHeavy.Error e)
        {
            assert_not_reached();
        }
    }

    public bool next()
    {
        try
        {
            return result.next();
        }
        catch (SQLHeavy.Error e)
        {
            assert_not_reached();
        }
    }
}
