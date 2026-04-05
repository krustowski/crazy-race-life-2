new DB: gDbConnectionHandle;

#if !defined _CRL2_TEST_BUILD
new gDbFile[16] = "crl2_data.db";
#endif

stock InitDB() 
{
#if !defined _CRL2_TEST_BUILD
	gDbConnectionHandle = DB_Open(gDbFile);

	if (gDbConnectionHandle) 
	{
		print("Connected to database successfully!");
	}
	else 
	{
		print("Failed to connect to database!");
	}
#else
	print("[TEST] InitDB stubbed");
#endif
}
