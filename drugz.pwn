//
//  drugz.pwn
//

#define MAX_DRUGS	10

enum
{
	ZAZA,
	TOBACCO,
	PAPER,
	JOINT,
	LIGHTER,
	COCAINE,
	HEROIN,
	METH,
	FENT,
	PCP
}

enum Drug
{
	DrugName[64],
	DrugIniName[64],
	DrugAmount,
	DrugPrice
}

new gDrugz[MAX_DRUGS][Drug];

stock InitDrugValues()
{
	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT name, name_alt, price FROM drug_prices ORDER BY id ASC");
	if (!result) {
		print("Database error: cannot fetch drug prices!");
		return;
	}

	new 
		i = 0,
		name[64], 
		name_alt[64], 
		price;

	while (DB_SelectNextRow(result))
	{
		DB_GetFieldStringByName(result, "name", name, sizeof(name));
		DB_GetFieldStringByName(result, "name_alt", name_alt, sizeof(name_alt));
		price = DB_GetFieldIntByName(result, "price");

		gDrugz[i][DrugName] = name_alt;
		gDrugz[i][DrugIniName] = name;
		gDrugz[i][DrugAmount] = 0;
		gDrugz[i][DrugPrice] = price;
		i++;
	}

	print("Drug prices initialized!");
	DB_FreeResultSet(result);
}

