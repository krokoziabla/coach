class Database
{
    private SQLHeavy.Database db;

    public Database(string file)
    {
        try
        {
            db = new SQLHeavy.Database(file);
        }
        catch (SQLHeavy.Error e)
        {
            assert_not_reached();
        }
    }

    public Query prepare(string sql)
    {
        try
        {
            return new Query(db.prepare(sql));
        }
        catch (SQLHeavy.Error e)
        {
            assert_not_reached();
        }
    }
}
