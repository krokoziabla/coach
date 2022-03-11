class Query
{
    private SQLHeavy.Query query;

    public Query(SQLHeavy.Query query)
    {
        this.query = query;
    }

    public QueryResult execute(string? first_parameter=null, ...)
    {
        try
        {
            return new QueryResult(query.vexecute(first_parameter, va_list()));
        }
        catch (SQLHeavy.Error e)
        {
            assert_not_reached();
        }
    }

    public void set_string(string field, string? value)
    {
        try
        {
            query.set_string(field, value);
        }
        catch (SQLHeavy.Error e)
        {
            assert_not_reached();
        }
    }

    public void set_double(string field, double value)
    {
        try
        {
            query.set_double(field, value);
        }
        catch (SQLHeavy.Error e)
        {
            assert_not_reached();
        }
    }
}
