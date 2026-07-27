#if defined _CRL2_MODELS
	#endinput
#endif
#define _CRL2_MODELS

//
//  Models
//

#define DOWNLOAD_REQUEST_EMPTY        (DOWNLOAD_REQUEST:0)
#define DOWNLOAD_REQUEST_MODEL_FILE   (DOWNLOAD_REQUEST:1)
#define DOWNLOAD_REQUEST_TEXTURE_FILE (DOWNLOAD_REQUEST:2)

new
    gModelsUrl[] = "https://cdn.vxn.dev/samp";
 
stock InitVehicleModels()
{
    //CreateVehicle(-19999, 0.0, 0.0, 6.0, 0.0, -1, -1, -1);
    
    //AddSimpleModel(-1, 562, -20001, "elegy.dff", "elegy.txd");
    //CreateVehicle(-19998, 0.0, 0.0, 5.0, 0.0, -1, -1, -1);

    //AddSimpleModel(-1, 494, -20002, "hotring.dff", "hotring.txd");
    //CreateVehicle(-19997, 0.0, 0.0, 4.0, 0.0, -1, -1, -1);

    return 1;
}