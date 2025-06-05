new DB: gDbConnectionHandle;

public InitDB() 
{
	gDbConnectionHandle = DB_Open("crl2_data.db");

	if (gDbConnectionHandle) 
	{
		print("Connected to database successfully!");
	}
	else 
	{
		print("Failed to connect to database!");
	}
}
