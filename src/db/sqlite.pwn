#if defined _CRL2_SQLITE
	#endinput
#endif
#define _CRL2_SQLITE

new 
	DB: gDbConnectionHandle;

#if defined _CRL2_TEST_BUILD
// Built fresh from sql/migrations by `make tests`, so the tests run on the real
// schema and never touch live data.
new 
	gDbFile[] = "crl2_test.db";
#else
new 
	gDbFile[] = "crl2_data.db";
#endif

new 
	bool: gDbInTransaction = false;

stock InitDB()
{
	gDbConnectionHandle = DB_Open(gDbFile);

	if (gDbConnectionHandle)
	{
		print("Connected to database successfully!");
	}
	else
	{
		print("Failed to connect to database!");
	}
}

// Runs a statement that returns no rows (BEGIN, COMMIT, ...) and reports
// whether it succeeded.
stock bool: ExecDBStatement(const statement[])
{
	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, statement);

	if (!result)
	{
		printf("Database error: %s failed!", statement);
		return false;
	}

	DB_FreeResultSet(result);
	return true;
}

// Opens a transaction, so a batch of writes costs one disk sync instead of one
// per statement (every statement outside a transaction commits on its own, on
// the main thread). Returns whether this call opened it: only then should the
// caller CommitDBTransaction(). A batch started inside another one just joins
// it, since SQLite cannot nest BEGIN.
stock bool: BeginDBTransaction()
{
	if (gDbInTransaction || !ExecDBStatement("BEGIN"))
	{
		return false;
	}

	gDbInTransaction = true;
	return true;
}

// Commits the transaction BeginDBTransaction() opened. A failed commit is
// rolled back so the connection is not left stuck inside it, and false tells
// the caller that none of the batch's writes reached the disk.
stock bool: CommitDBTransaction()
{
	gDbInTransaction = false;

	if (ExecDBStatement("COMMIT"))
	{
		return true;
	}

	ExecDBStatement("ROLLBACK");
	return false;
}
