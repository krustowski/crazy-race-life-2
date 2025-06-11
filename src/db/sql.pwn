new DB: gDbConnectionHandle;

new gDbFile[16] = "crl2_data.db";

forward InitDB();

public InitDB() 
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
