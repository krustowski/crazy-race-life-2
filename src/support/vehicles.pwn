#if defined _CRL2_VEHICLES
	#endinput
#endif
#define _CRL2_VEHICLES

new 
	const VEHICLE_PLATE[] = "--CRL2--";

forward InitVehicles();

public InitVehicles()
{
	// Taxi SF 
	AddStaticVehicle(420, -1986.96, 120.03, 27.38, 0.0, -1, -1);
	AddStaticVehicle(420, -1987.37, 128.51, 27.39, 0.0, -1, -1);
	AddStaticVehicle(420, -1987.45, 136.94, 27.39, 0.0, -1, -1);
	
	AddStaticVehicle(420, -1423.44, -296.03, 13.85, 49.02, -1, -1);
	AddStaticVehicle(420, -1430.25, -290.73, 13.85, 53.78, -1, -1);

	// Taxi LV
	AddStaticVehicle(420, 1429.19, 2609.62, 10.52, 111.12, -1, -1);
	AddStaticVehicle(420, 1439.24, 2609.41, 10.52, 111.12, -1, -1);

	AddStaticVehicle(420, 2833.63, 1258.51, 10.77, 0.0, -1, -1);
	AddStaticVehicle(420, 2833.47, 1265.94, 10.78, 0.0, -1, -1);

	AddStaticVehicle(420, 1716.28, 1472.79, 10.52, 358.99, -1, -1);
	AddStaticVehicle(420, 1719.37, 1482.69, 10.52, 358.99, -1, -1);

	// Taxi LS
	AddStaticVehicle(420, 1670.27, -2248.74, 13.24, 172.99, -1, -1);
	AddStaticVehicle(420, 1661.39, -2249.57, 13.21, 172.99, -1, -1);

	AddStaticVehicle(420, 1774.76, -1914.67, 13.24, 225.46, -1, -1);
	AddStaticVehicle(420, 1774.78, -1909.17, 13.24, 225.46, -1, -1);

	AddStaticVehicle(420, 823.28, -1332.25, 13.24, 225.46, -1, -1);
	AddStaticVehicle(420, 832.52, -1332.17, 13.26, 225.46, -1, -1);

	// Tram SF 
	AddStaticVehicle(449, -2006.57, 150.48, 27.10, 334.54, -1, -1);

	// Tow truck SF docks and Wang Cars
	AddStaticVehicle(525, -1638.71, 63.78, 3.43, 131.83, -1, -1);
	AddStaticVehicle(525, -1912.96, 304.25, 40.92, 179.81, -1, -1);

	// Bayside boat race 
	AddStaticVehicle(452, -2227.32, 2402.30, 0.00, 42.27, -1, -1);
	AddStaticVehicle(452, -2251.92, 2427.81, 0.00, 225.45, -1, -1);

	// El Quebrados desert cart race
	AddStaticVehicle(568, -1498.64, 1972.45, 48.42, 273.59, -1, -1);
	AddStaticVehicle(568, -1498.40, 1975.67, 48.42, 271.60, -1, -1);
	AddStaticVehicle(568, -1498.07, 1980.42, 48.37, 271.60, -1, -1);

	// MTA by kompry
	AddStaticVehicle(522, 199.328, -1790.488, 3.655, 0.0, -1, -1); // spawnpoint (1)
	AddStaticVehicle(522, 1888.236, -2399.764, 13.199, 182.0, -1, -1); // spawnpoint (2)
	AddStaticVehicle(522, 1891.617, -2399.939, 13.199, 173.0, -1, -1); // spawnpoint (2)
	AddStaticVehicle(522, 1889.321, -2399.803, 13.074, 175.0, -1, -1); // spawnpoint (3)
	AddStaticVehicle(522, 1890.475, -2399.837, 13.074, 176.0, -1, -1); // spawnpoint (4)

	AddStaticVehicle(522, 2040.105, 1341.658, 10.332, 259.0, -1, -1);
	AddStaticVehicle(522, 2040.151, 1344.618, 10.332, 259.0, -1, -1);
	AddStaticVehicle(522, 2040.051, 1346.566, 10.332, 259.0, -1, -1);
	AddStaticVehicle(409, 2379.6838, 1031.7986, 10.6203, 179.8633, 1, 1); //
	AddStaticVehicle(605, 1844.4413, 1248.1547, 10.6394, 91.5823, 2, 2); //
	AddStaticVehicle(581, 2409.8162, 1020.6308, 10.4183, 356.9659, 87, 1); //
	AddStaticVehicle(581, 2407.7952, 1020.7648, 10.4181, 358.7930, 36, 1); //
	AddStaticVehicle(581, 2405.8110, 1021.1887, 10.4178, 358.7873, 66, 1); //

	//-------------------------------------------------------------------------------
	//Boss

	AddStaticVehicle(411, 1707.4657, 1434.3721, 10.3533, 356.7238, 116, 1); // letiste venturas
	AddStaticVehicle(411, 1708.1104, 1443.7477, 10.4670, 349.7090, 106, 1); // letiste venturas
	AddStaticVehicle(481, 1688.7257, 1445.7723, 10.2836, 279.5629, 46, 46); // kolo venturas letiste
	AddStaticVehicle(481, 1688.4663, 1447.5942, 10.2810, 282.0507, 14, 1); // kolo venturas letiste
	AddStaticVehicle(481, 1688.3223, 1449.2086, 10.2833, 271.8508, 26, 1); // kolo venturas letiste
	AddStaticVehicle(481, 1688.4011, 1450.5739, 10.2743, 274.7141, 3, 3); // kolo venturas letiste
	AddStaticVehicle(481, 1688.3363, 1451.7584, 10.2739, 278.0057, 46, 46); // kolo venturas letiste
	AddStaticVehicle(522, 1696.9905, 1477.3119, 10.3284, 294.7530, 7, 79); // MOTO venturas letiste
	AddStaticVehicle(522, 1696.9918, 1480.0471, 10.3340, 313.0961, 36, 105); // MOTO venturas letiste
	AddStaticVehicle(522, 1696.9917, 1480.0471, 10.3303, 313.0990, 36, 105); // MOTO venturas letiste
	AddStaticVehicle(431, 1727.3485, 1481.0919, 10.7686, 342.4481, 71, 87); // BUs venturas letiste
	AddStaticVehicle(405, 2039.0491, 995.6431, 10.5468, 179.4234, 40, 1); // four dragons
	AddStaticVehicle(409, 2038.7787, 1004.5322, 10.4719, 180.3101, 1, 1); // four dragons
	AddStaticVehicle(405, 2038.8015, 1014.7733, 10.5469, 180.1547, 91, 1); // four dragons
	AddStaticVehicle(519, 1333.9961, 1617.8342, 11.7390, 268.5894, 1, 1); // Letiste venturas vnitrek
	AddStaticVehicle(519, 1332.0784, 1588.6335, 11.7416, 266.8001, 1, 1); // Letiste venturas vnitrek
	AddStaticVehicle(519, 1633.0486, 1547.3411, 11.7233, 46.0568, 1, 1); // Letiste venturas vnitrek
	AddStaticVehicle(519, 1572.8802, 1448.6053, 11.7471, 88.3226, 1, 1); // Letiste venturas vnitrek
	AddStaticVehicle(577, 1582.9418, 1269.7876, 10.7286, 52.0746, 8, 16); // Letiste venturas vnitrek
	AddStaticVehicle(417, 1304.7650, 1410.2708, 10.9384, 273.2145, 0, 0); // Letiste venturas vnitrek
	AddStaticVehicle(417, 1300.7816, 1441.8033, 10.8904, 274.0446, 0, 0); // Letiste venturas vnitrek
	AddStaticVehicle(593, 1285.8500, 1360.9598, 11.2844, 272.0649, 13, 8); // Letiste venturas vnitrek
	AddStaticVehicle(511, 1284.3549, 1324.3623, 12.1943, 269.8205, 34, 51); // Letiste venturas vnitrek
	AddStaticVehicle(475, 1322.5449, 1278.6807, 10.6270, 180.7509, 56, 29); // Letiste venturas vnitrek
	AddStaticVehicle(463, 1312.7643, 1279.2102, 10.3607, 189.8089, 36, 36); // Letiste venturas vnitrek
	AddStaticVehicle(404, 1282.2305, 1294.1544, 10.5546, 89.7916, 119, 50); // Letiste venturas vnitrek
	AddStaticVehicle(513, 1573.4563, 1632.8821, 11.3643, 142.1108, 51, 6); // Letiste venturas vnitrek
	AddStaticVehicle(513, 1558.9230, 1645.2474, 11.3695, 136.1284, 21, 36); // Letiste venturas vnitrek
	AddStaticVehicle(513, 1551.3788, 1657.7781, 11.3638, 103.9002, 30, 34); // Letiste venturas vnitrek
	AddStaticVehicle(513, 1586.0459, 1626.0530, 11.3645, 164.8137, 55, 20); // Letiste venturas vnitrek
	AddStaticVehicle(513, 1571.3127, 1644.6924, 11.3660, 136.8022, 51, 6); // Letiste venturas vnitrek
	AddStaticVehicle(480, 1703.7491, 1619.5308, 10.1593, 155.0648, 53, 53); // Letiste venturas vnitrek
	AddStaticVehicle(479, 1698.7765, 1622.2445, 10.5292, 151.8812, 27, 36); // Letiste venturas vnitrek
	AddStaticVehicle(474, 1694.0846, 1625.0941, 10.5830, 144.6756, 105, 1); // Letiste venturas vnitrek
	AddStaticVehicle(497, 2295.3979, 2443.8813, 47.1600, 178.3152, 0, 1); // POLICIE VRTULASI
	AddStaticVehicle(497, 2284.0427, 2441.3237, 47.1573, 0.9358, 0, 1); // POLICIE VRTULASI
	AddStaticVehicle(497, 2273.2456, 2444.4827, 47.1478, 185.3554, 0, 1); // POLICIE VRTULASI

	AddStaticVehicle(579, 2588.1018, -944.3834, 81.3247, 191.4354, 62, 62); // off road
	AddStaticVehicle(579, 2591.4219, -943.5134, 81.3322, 194.7983, 10, 10); // off road
	AddStaticVehicle(579, 2594.3972, -942.7399, 81.2430, 192.6938, 15, 15); // off road
	AddStaticVehicle(579, 2588.2163, -968.2394, 81.3225, 277.1459, 42, 42); // off road
	AddStaticVehicle(579, 2590.2410, -951.2093, 81.3075, 192.8260, 62, 62); // off road
	AddStaticVehicle(579, 2594.4514, -950.1075, 81.3275, 193.0102, 10, 10); // off road
	AddStaticVehicle(500, 2577.2266, -971.1443, 81.4824, 5.9593, 25, 119); // off road
	AddStaticVehicle(500, 2573.6101, -972.0602, 81.6890, 9.6057, 13, 119); // off road
	AddStaticVehicle(500, 2570.4070, -972.2739, 81.9880, 9.5686, 75, 84); // off road
	AddStaticVehicle(468, 2579.7830, -970.9474, 81.0274, 8.1648, 6, 6); // off road
	AddStaticVehicle(468, 2593.8870, -968.8467, 81.0205, 8.0766, 53, 53); // off road
	AddStaticVehicle(468, 2597.9978, -968.3833, 80.8931, 5.0265, 6, 6); // off road
	AddStaticVehicle(468, 2595.6707, -968.3954, 80.9645, 12.2957, 53, 53); // off road
	AddStaticVehicle(468, 2600.0435, -967.9568, 80.7797, 17.2735, 53, 53); // off road

	AddStaticVehicle(411, 2351.7466, 1405.1989, 10.5505, 269.5594, 106, 1); // garaz
	AddStaticVehicle(411, 2351.6194, 1408.6191, 10.5505, 270.5017, 64, 1); // garaz
	AddStaticVehicle(411, 2351.9487, 1411.8346, 10.5505, 269.2871, 106, 1); // garaz
	AddStaticVehicle(411, 2351.4678, 1415.7719, 10.5505, 271.7662, 64, 1); // garaz
	AddStaticVehicle(451, 2351.9185, 1419.2119, 10.5307, 270.6961, 61, 61); // garaz

	//-------------------------------------------------------------------------------------------
	//HAJATI
	AddStaticVehicle(406, 1372.0599, -1888.5458, 15.0201, 359.8915, 1, 1); //
	AddStaticVehicle(601, 2282.3809, 2476.7578, 10.5791, 180.6260, 1, 1); //
	AddStaticVehicle(599, 2277.5945, 2476.6782, 11.0094, 179.9791, 0, 1); //
	AddStaticVehicle(599, 2277.2668, 2443.8179, 11.0103, 358.9673, 0, 1); //
	AddStaticVehicle(598, 2278.3423, 2416.9207, 10.4326, 90.6088, 0, 1); //
	AddStaticVehicle(598, 2289.3726, 2416.9402, 10.4750, 90.7897, 0, 1); //
	AddStaticVehicle(597, 2255.8340, 2458.6948, 10.5896, 2.2111, 0, 1); //


	AddStaticVehicle(427, 2251.6208, 2475.5220, 10.9521, 178.5989, 0, 1); //
	AddStaticVehicle(427, 2291.0657, 2443.8220, 10.9549, 2.5235, 0, 1); //
	AddStaticVehicle(585, 2142.0415, 1006.5154, 10.4056, 89.5371, 62, 62); //
	AddStaticVehicle(581, 2142.3408, 1019.1952, 10.4126, 90.0508, 66, 1); //
	AddStaticVehicle(580, 2172.1748, 1025.8055, 10.6162, 270.2493, 67, 67); //
	AddStaticVehicle(566, 2172.1506, 1019.2934, 10.6000, 88.8206, 95, 1); //
	AddStaticVehicle(565, 2162.8140, 1016.2005, 10.4465, 272.5718, 62, 62); //
	AddStaticVehicle(561, 2142.6189, 1025.8116, 10.6337, 88.6019, 43, 21); //

	AddStaticVehicle(588, 1937.7334, 1395.4403, 9.1546, 320.6901, 1, 1); // nwmmm
	AddStaticVehicle(545, 1943.2976, 1366.3328, 8.9202, 181.1409, 40, 96); // nwmm
	AddStaticVehicle(603, 2169.1453, 1114.3914, 12.3971, 332.9957, 75, 77); // nwm
	AddStaticVehicle(586, 2456.0103, 1286.6018, 10.3339, 3.0928, 25, 1); // moto u baráku

	AddStaticVehicle(608, 1530.6556, 1190.6989, 11.3453, 0.0001, 1, 1); // www
	AddStaticVehicle(601, 1559.2065, 1161.7305, 10.5634, 359.4489, 1, 1); // ww
	AddStaticVehicle(601, 1567.6467, 1161.3405, 10.5638, 360.0000, 1, 1); // w
	AddStaticVehicle(601, 1563.3978, 1161.1917, 10.5773, 359.9292, 1, 1); // vvv
	AddStaticVehicle(407, 1571.9799, 1161.8931, 11.0418, 2.1316, 3, 1); // vv
	AddStaticVehicle(407, 1576.1803, 1162.1091, 11.0389, 2.0883, 3, 1); // v

	AddStaticVehicle(605, 2087.3149, 1460.4913, 10.6245, 345.2599, 67, 8); // 1
	AddStaticVehicle(602, 2423.6025, 1146.2777, 10.4779, 180.3826, 75, 77); // 2
	AddStaticVehicle(589, 2351.1174, 1501.6195, 10.4784, 270.6555, 7, 7); // 3
	AddStaticVehicle(587, 2351.7122, 1487.3732, 10.5455, 271.1997, 53, 1); // 4
	AddStaticVehicle(585, 2351.5193, 1490.7429, 10.4041, 269.3290, 53, 53); // 5
	AddStaticVehicle(580, 2351.9956, 1476.3799, 10.6165, 270.4769, 67, 67); // 6
	AddStaticVehicle(579, 2350.9351, 1472.7313, 10.7543, 91.8873, 62, 62); // 7
	AddStaticVehicle(576, 2351.0713, 1458.4519, 10.4290, 89.2360, 74, 8); // 8
	AddStaticVehicle(576, 2351.4885, 1440.6265, 10.4334, 269.5279, 74, 8); // 9
	AddStaticVehicle(575, 2352.0901, 1447.8015, 10.4256, 272.1600, 25, 96); // 10
	AddStaticVehicle(571, 2272.1382, 1385.5864, 42.1042, 2.7126, 40, 35); // 11
	AddStaticVehicle(571, 2273.9817, 1385.6183, 42.1039, 359.3380, 36, 2); // 12
	AddStaticVehicle(571, 2275.8926, 1385.6545, 42.1040, 0.5967, 91, 2); // 13
	AddStaticVehicle(571, 2269.5225, 1392.0181, 42.1044, 1.3084, 2, 35); // 14
	AddStaticVehicle(571, 2271.9255, 1392.4990, 42.1042, 358.1568, 51, 53); // 15
	AddStaticVehicle(571, 2273.6775, 1392.4683, 42.1040, 0.9704, 91, 2); // 16
	AddStaticVehicle(571, 2275.7869, 1392.4569, 42.1046, 356.1782, 40, 35); // 17

	//AddStaticVehicle(560, -2795.7339, -121.0982, 6.8574, 90.6723, 2, 1); // 1
	AddStaticVehicle(560, -2266.5076, 121.3087, 34.8284, 268.9907, 3, 1); // 3
	AddStaticVehicle(579, -2184.4077, 293.1379, 35.0848, 358.2932, 3, 3); // 4
	AddStaticVehicle(402, -1956.7057, 305.2405, 40.8751, 177.0687, 0, 3); // 6
	AddStaticVehicle(415, -1952.4701, 258.6288, 40.8238, 88.9323, 25, 1); // 7
	AddStaticVehicle(562, -1952.4683, 263.0709, 40.7076, 90.3869, 35, 1); // 8
	AddStaticVehicle(565, -1952.5840, 268.5277, 40.6896, 90.9275, 53, 53); // 9
	AddStaticVehicle(496, 652.8029, 1698.4017, 6.6533, 310.5625, 250, 101); // 10
	AddStaticVehicle(581, 435.9633, 2537.2192, 15.8692, 94.1647, 186, 75); // 11
	AddStaticVehicle(477, 425.9083, 2544.6746, 16.0417, 88.7763, 185, 39); // 12
	AddStaticVehicle(475, 414.6477, 2532.1875, 16.3424, 267.1475, 32, 165); // 13

	//------------------------------------------------------------------------------------------
	//Chack
	AddStaticVehicle(534, 2093.5459, 2157.6160, 10.5441, 358.5436, 53, 53); //
	AddStaticVehicle(534, 2080.6294, 2158.0891, 10.5433, 359.9919, 62, 62); //
	AddStaticVehicle(579, 1248.6991, -806.0133, 84.0723, 180.4498, 62, 62); //
	AddStaticVehicle(603, 1423.5546, -881.6712, 50.2973, 0.5547, 18, 1); //
	//AddStaticVehicle(603, 1423.5548, -881.6707, 50.2981, 0.5660, 18, 1); //
	AddStaticVehicle(405, 2510.0908, -1671.7053, 13.2852, 346.1132, 75, 1); //
	//AddStaticVehicle(405, 2510.0908, -1671.7053, 13.2852, 346.1132, 75, 1); //
	AddStaticVehicle(405, 1464.8967, -901.7821, 54.7142, 359.5529, 75, 1); //
	AddStaticVehicle(402, 1528.5540, -813.5322, 71.6205, 271.3222, 39, 39); //
	//AddStaticVehicle(427, 1497.1135, -696.7408, 94.8819, 91.5784, 0, 1); //
	//AddStaticVehicle(445, 1460.5386, -632.6729, 95.6466, 179.0355, 37, 37); //
	AddStaticVehicle(451, 1337.2939, -1125.8040, 23.4687, 176.5716, 36, 36); //
	AddStaticVehicle(426, 1314.7368, -1411.4272, 13.1268, 89.8783, 53, 53); //
	AddStaticVehicle(405, 1078.8638, -943.4752, 42.6225, 97.3053, 75, 1); //
	AddStaticVehicle(587, 1889.9089, -1757.9772, 13.1890, 269.7582, 43, 1); //
	AddStaticVehicle(415, 1876.3981, 1179.6964, 10.6021, 0.4130, 36, 1); //
	AddStaticVehicle(445, 1886.0162, 1180.0969, 10.7031, 180.0130, 37, 37); //
	AddStaticVehicle(434, 1913.0947, 697.9313, 10.7820, 358.3806, 6, 6); //
	AddStaticVehicle(451, 1929.2423, 698.1835, 10.5297, 180.1301, 36, 36); //
	AddStaticVehicle(429, 1938.8356, 698.1643, 10.5050, 359.7591, 2, 1); //
	AddStaticVehicle(426, 1925.9933, 708.4312, 10.5897, 0.2086, 7, 7); //
	AddStaticVehicle(421, 1913.1555, 708.7736, 10.7117, 359.8270, 36, 1); //
	AddStaticVehicle(579, 1882.0939, 957.2076, 10.7549, 269.0636, 15, 15); //
	AddStaticVehicle(560, 1880.9763, 982.1381, 10.5257, 269.7756, 37, 0); //
	AddStaticVehicle(560, 1881.0511, 1013.2974, 10.5255, 269.8147, 56, 29); //
	AddStaticVehicle(579, 1882.0300, 963.7077, 10.7483, 270.5491, 62, 62); //
	AddStaticVehicle(579, 1882.0275, 954.0338, 10.7529, 269.6631, 15, 15); //
	AddStaticVehicle(522, 2215.20, 1263.36, 10.82, 0, 0, 0); //moto
	AddStaticVehicle(522, 2215.04, 1261.42, 10.82, 0, 0, 0); //moto2
	AddStaticVehicle(522, 2215.66, 1259.38, 10.82, 0, 0, 0); //moto3
	AddStaticVehicle(522, 2215.68, 1256.53, 10.82, 0, 0, 0); //moto4
	AddStaticVehicle(603, 2249.19, 1261.59, 10.82, 0, 0, 0); //fínix
	AddStaticVehicle(603, 2249.14, 1256.81, 10.81, 0, 0, 0); //fínix 2
	AddStaticVehicle(603, 2660.19, 1173.02, 10.66, 0, 0, 0); //phoenix
	AddStaticVehicle(448, 2096.0518, -1812.6667, 12.9671, 90.8525, 3, 6); //
	AddStaticVehicle(448, 2096.0674, -1814.0520, 12.9767, 90.9450, 3, 6); //
	AddStaticVehicle(448, 2096.0898, -1815.1420, 12.9694, 84.8328, 3, 6); //
	AddStaticVehicle(448, 2096.0994, -1816.2047, 12.9754, 86.4761, 3, 6); //
	AddStaticVehicle(466, 2115.8135, -1782.2570, 13.1303, 178.8026, 2, 76); //
	AddStaticVehicle(480, 2110.0852, -1783.2638, 13.1620, 179.0197, 6, 6); //
	AddStaticVehicle(408, 2861.3445, -2049.9368, 11.4825, 358.4635, 26, 26); //
	AddStaticVehicle(408, 2861.5190, -2038.8027, 11.4801, 0.1247, 26, 26); //
	AddStaticVehicle(408, 2861.3423, -2027.7723, 11.4880, 0.3243, 26, 26); //
	AddStaticVehicle(604, 2862.6074, -1996.9855, 10.7223, 329.7362, 16, 76); //
	AddStaticVehicle(495, 2373.8804, -1928.1426, 13.5149, 0.1294, 118, 117); //
	AddStaticVehicle(427, 1601.5320, -1605.8014, 13.6134, 89.6029, 0, 1); //
	AddStaticVehicle(601, 1602.0303, -1692.1196, 5.6494, 272.3871, 1, 1); //
	AddStaticVehicle(601, 1602.0303, -1692.1196, 5.6494, 272.3870, 1, 1); //
	AddStaticVehicle(601, 1602.1957, -1696.0555, 5.6494, 271.2098, 1, 1); //

	AddStaticVehicle(596, 1595.5342, -1711.0197, 5.6145, 178.9316, 0, 1); //
	AddStaticVehicle(596, 1587.5128, -1711.0092, 5.6127, 357.8445, 0, 1); //
	AddStaticVehicle(596, 1590.9025, -1711.3728, 5.5903, 176.9570, 0, 1); //
	AddStaticVehicle(528, 1578.7892, -1710.7571, 5.9352, 177.5343, 0, 0); //

	//-------------------------------------------------------------------------------------------

	// LS Ganton / Grove Street
	AddStaticVehicle(492, 2444.9200, -1653.6200, 13.1058, 90.0000, -1, -1); // Greenwood //
	AddStaticVehicle(412, 2304.3000, -1635.8100, 14.3558, 205.0000, -1, -1); // Voodoo //
	AddStaticVehicle(575, 2502.8000, -1754.3300, 13.0015, 270.0000, -1, -1); // Broadway //
	AddStaticVehicle(535, 2289.0400, -1754.5400, 13.5415, 271.0000, -1, -1); // Slamvan //
	AddStaticVehicle(559, 2446.1300, -1763.1900, 13.5815, 180.0000, -1, -1); // Jester //

	// LS Idlewood / Ganton
	AddStaticVehicle(566, 2161.5800, -1793.9400, 13.3653, 90.0000, -1, -1); // Tahoma //
	AddStaticVehicle(536, 2088.9700, -1566.0700, 13.1747, 180.0000, -1, -1); // Blade //
	AddStaticVehicle(426, 2265.1600, -1691.8700, 13.6962, 92.0000, -1, -1); // Premier //

	// LS Little Mexico / Idlewood
	AddStaticVehicle(421, 1806.2300, -1632.0700, 13.5369, 270.0000, -1, -1); // Washington //
	AddStaticVehicle(496, 1800.9000, -1713.5800, 13.5228, 182.9000, -1, -1); // Blista Compact //

	// LS Glen Park
	AddStaticVehicle(533, 1963.4000, -1157.1400, 26.0442, 180.0000, -1, -1); // Feltzer //
	AddStaticVehicle(480, 2027.8700, -1273.0400, 21.0046, 270.0000, -1, -1); // Comet //
	AddStaticVehicle(506, 2077.9800, -1179.3600, 23.9042, 0.0000, -1, -1); // Super GT //
	AddStaticVehicle(492, 1923.7700, -1085.4900, 24.6022, 88.0000, -1, -1); // Greenwood //
	AddStaticVehicle(438, 1986.0600, -1081.5900, 25.0039, 0.0000, -1, -1); // Cabbie //
	AddStaticVehicle(405, 1848.0700, -1173.9600, 24.9091, 90.0000, -1, -1); // Sentinel //

	// Willowfield industrial
	//AddStaticVehicle(443, 2658.0000, -1305.0000, 57.1769, 0.0000, -1, -1); // Packer
	//AddStaticVehicle(455, 2660.0000, -1295.0000, 57.1769, 90.0000, -1, -1); // Flatbed
	//AddStaticVehicle(514, 2645.0000, -1290.0000, 45.3772, 180.0000, -1, -1); // Tanker

	// Downtown LS / Pershing Sq
	AddStaticVehicle(405, 1432.5900, -1331.3800, 13.6072, 270.0000, -1, -1); // Sentinel //
	AddStaticVehicle(421, 1461.1300, -1359.4000, 13.7028, 0.0000, -1, -1); // Washington //
	AddStaticVehicle(585, 1503.8000, -1317.3500, 14.3072, 0.0000, -1, -1); // Emperor //
	AddStaticVehicle(555, 1729.4100, -1329.3500, 13.6063, 52.0000, -1, -1); // Windsor //
	AddStaticVehicle(541, 1628.2600, -1514.7300, 13.6093, 176.0000, -1, -1); // Bullet //
	AddStaticVehicle(517, 1812.9300, -1280.5600, 13.6463, 1.0000, -1, -1); // Majestic //
	AddStaticVehicle(416, 2037.5600, -1428.5500, 17.0012, 90.0000, -1, -1); // Ambulance //

	// LS Vinewood

	// LS Mulholland

	// LS Rodeo / Richman
	AddStaticVehicle(496, 211.8800, -1419.2000, 12.9900, 0.0000, -1, -1); // Blista Compact //
	AddStaticVehicle(426, 301.7700, -1491.4000, 24.6061, 56.0000, -1, -1); // Premier //
	AddStaticVehicle(543, 401.9300, -1506.8600, 31.9043, 306.0000, -1, -1); // Sadler //

	// LS Market
	AddStaticVehicle(516, 1014.6400, -1368.0000, 13.3663, 88.6000, -1, -1); // Nebula //
	AddStaticVehicle(507, 1274.9500, -1359.0100, 13.5038, 0.0000, -1, -1); // Elegant //
	AddStaticVehicle(524, 1242.9900, -1266.0600, 13.4038, 270.0000, -1, -1); // Cement Truck //
	AddStaticVehicle(486, 1253.9400, -1258.6300, 13.2038, 90.0000, -1, -1); // Dozer //
	AddStaticVehicle(416, 1180.1600, -1308.5000, 13.8012, 271.0000, -1, -1); // Ambulance //
	AddStaticVehicle(491, 1086.2500, -1369.0400, 13.8012, 185.0000, -1, -1); // Virgo //
	AddStaticVehicle(459, 972.7200, -1262.8000, 16.0412, 180.0000, -1, -1); // RC Van //
	AddStaticVehicle(439, 903.7500, -1236.8000, 16.4012, 2.0000, -1, -1); // Stallion //
	AddStaticVehicle(428, 846.0700, -1193.6300, 16.9712, 184.4400, -1, -1); // Securicar //
	AddStaticVehicle(414, 851.2000, -1293.0300, 13.6012, 275.3500, -1, -1); // Mule //

	// LS Commerce underpass garages
	AddStaticVehicle(562, 1599.5500, -1815.1900, 13.4227, 270.0000, -1, -1); // Elegy //
	AddStaticVehicle(576, 1655.4700, -1806.5500, 13.5482, 90.0000, -1, -1); // Tornado //
	AddStaticVehicle(504, 1604.5600, -1825.3700, 13.4726, 270.0000, -1, -1); // Bloodring Banger //

	// LS Santa Maria Beach
	AddStaticVehicle(496, 892.8100, -1668.5200, 13.2625, 0.0000, -1, -1); // Blista Compact //
	AddStaticVehicle(502, 874.6100, -1658.7400, 13.1120, 180.0000, -1, -1); // Hotring Racer //

	// LS Docks / Easter Basin
	AddStaticVehicle(408, 2784.5900, -2439.6900, 13.6384, 88.6100, -1, -1); // Trashmaster //
	AddStaticVehicle(530, 2770.5900, -2447.3000, 13.6462, 102.8800, -1, -1); // Forklift //
	AddStaticVehicle(524, 2744.9900, -2447.9000, 13.6484, 273.5600, -1, -1); // Cement Truck //

	// LS El Corona / Willowfield
	AddStaticVehicle(426, 2059.1600, -1904.7000, 13.5469, 0.0000, -1, -1); // Premier //
	AddStaticVehicle(551, 1944.3700, -1979.5100, 13.5469, 270.0000, -1, -1); // Merit //
	AddStaticVehicle(604, 1837.7400, -1869.1800, 13.3869, 181.8700, -1, -1); // Grendale damaged //
	AddStaticVehicle(526, 2498.4700, -1951.7000, 13.4400, 181.0000, -1, -1); // Fortune //
	AddStaticVehicle(561, 2523.2600, -1967.1000, 13.5400, 0.0000, -1, -1); // Stratum //

	// LS Playa del Seville
	AddStaticVehicle(454, 2932.7400, -2057.2400, 0.0000, 270.0000, -1, -1); // Tropic //
	AddStaticVehicle(484, 2937.4800, -2044.1700, 0.0000, 270.0000, -1, -1); // Marquis //

	// LS Las Colinas
	AddStaticVehicle(506, 2261.1700, -1101.7000, 37.9700, 158.1500, -1, -1); // Super GT //
	AddStaticVehicle(478, 2271.4400, -1033.2300, 51.7400, 142.4200, -1, -1); // Walton //
	AddStaticVehicle(474, 2157.9100, -1023.7600, 62.6100, 186.7100, -1, -1); // Hermes //
	AddStaticVehicle(466, 2029.3800, -958.5900, 40.7000, 100.6900, -1, -1); // Glendale //

	// LS Jefferson (East Los Santos)
	AddStaticVehicle(426, 2487.0400, -1557.2900, 24.0525, 90.4400, -1, -1); // Premier //
	AddStaticVehicle(507, 2489.2900, -1519.5300, 23.9900, 95.2100, -1, -1); // Elegant //
	AddStaticVehicle(552, 2512.2300, -1469.1200, 24.0100, 87.3600, -1, -1); // Utility Van //
	AddStaticVehicle(542, 2546.2800, -1437.0900, 24.0000, 265.7000, -1, -1); // Clover //
	AddStaticVehicle(602, 2242.7700, -1446.6200, 24.0000, 90.0000, -1, -1); // Alpha //

	// LS East Lost Santos
	AddStaticVehicle(463, 2409.1800, -1389.6600, 24.2800, 93.0400, -1, -1); // Freeway //
	AddStaticVehicle(429, 2460.3100, -1413.3700, 23.7800, 91.0100, -1, -1); // Banshee //
	AddStaticVehicle(545, 2425.5700, -1227.2400, 23.1000, 0.0000, -1, -1); // Hustler //
	AddStaticVehicle(546, 2406.4900, -1231.3900, 23.8300, 189.0000, -1, -1); // Intruder //
	AddStaticVehicle(549, 2392.6600, -1490.8300, 23.8200, 90.2300, -1, -1); // Tampa //

	// LS Prickle Pine East Beach
	AddStaticVehicle(496, 2910.4100, -959.6100, 11.0469, 88.0000, -1, -1); // Blista Compact //
	AddStaticVehicle(456, 2846.0000, -1550.6400, 11.0978, 187.0000, -1, -1); // Yankee //
	AddStaticVehicle(543, 2797.9100, -1575.8600, 10.9259, 90.0000, -1, -1); // Sadler //
	AddStaticVehicle(492, 2797.7800, -1257.5500, 46.9589, 50.6000, -1, -1); // Greenwood //
	AddStaticVehicle(536, 2797.5200, -1389.0200, 21.4240, 244.4200, -1, -1); // Blade //

	// Los Santos Forum
	AddStaticVehicle(502, 2681.0900, -1674.1500, 9.4559, 0.0000, -1, -1); // Hotring A //
	AddStaticVehicle(510, 2672.6800, -1670.3700, 9.3759, 88.0000, -1, -1); // Mountain Bike //
	AddStaticVehicle(541, 2659.0200, -1706.6900, 9.3259, 93.0000, -1, -1); // Bullet //
	AddStaticVehicle(545, 2658.0100, -1697.1300, 9.3159, 85.0000, -1, -1); // Hustler //

	// SF Downtown / Financial
	AddStaticVehicle(409, -1735.2000, 751.5800, 24.8906, 270.0000, -1, -1); // Stretch //
	AddStaticVehicle(419, -1734.8800, 1053.0400, 17.5802, 90.0000, -1, -1); // Esperanto //
	AddStaticVehicle(533, -1704.5200, 999.5900, 17.5844, 270.0000, -1, -1); // Feltzer //
	AddStaticVehicle(582, -1699.1500, 1035.4500, 45.2100, 91.2800, -1, -1); // Newsvan //
	AddStaticVehicle(582, -1873.4700, 830.6900, 35.1600, 270.0000, -1, -1); // Newsvan //

	// SF Downtown Police Station
	AddStaticVehicle(497, -1679.9500, 706.0100, 30.6000, 90.0000, -1, -1); // Police Maverick //
	AddStaticVehicle(601, -1612.5900, 732.5500, -5.2400, 0.0000, -1, -1); // SWAT //
	AddStaticVehicle(490, -1590.4900, 707.8800, -5.2400, 270.0000, -1, -1); // FBI Rancher //
	AddStaticVehicle(597, -1604.6300, 749.7100, -5.2400, 180.0000, -1, -1); // SFPD car //
	AddStaticVehicle(597, -1572.4300, 718.3700, -5.2400, 90.0000, -1, -1); // SFPD car //

	// SF Chinatown
	AddStaticVehicle(438, -2217.0300, 725.7200, 49.4156, 270.0000, -1, -1); // Cabbie //
	AddStaticVehicle(401, -2247.8000, 649.8100, 49.4404, 0.0000, -1, -1); // Bravura //
	AddStaticVehicle(499, -2176.9400, 653.7100, 49.4304, 180.0000, -1, -1); // Benson //

	// SF Doherty garage district
	AddStaticVehicle(422, -2111.9600, -84.6800, 35.3241, 90.0000, -1, -1); // Bobcat //
	AddStaticVehicle(525, -2089.7700, -84.9200, 35.1622, 0.0000, -1, -1); // Tow Truck //
	AddStaticVehicle(434, -2049.7400, 10.7500, 35.3219, 0.0000, -1, -1); // Hotknife //

	// SF Juniper Hill (SupaSave market)
	AddStaticVehicle(404, -2425.2600, 740.5300, 35.0191, 0.0000, -1, -1); // Pereniel //
	AddStaticVehicle(418, -2412.2500, 740.7700, 35.0126, 0.0000, -1, -1); // Moonbeam //
	AddStaticVehicle(456, -2487.5100, 793.7800, 35.1726, 270.0000, -1, -1); // Yankee //

	// SF Queens (Police Station)
	AddStaticVehicle(427, -2440.8400, 524.0400, 29.9000, 182.2400, -1, -1); // Enforcer //
	AddStaticVehicle(597, -2414.6000, 536.1600, 29.9200, 258.4400, -1, -1); // SFPD car //
	AddStaticVehicle(597, -2422.7400, 521.8700, 29.9200, 226.2900, -1, -1); // SFPD car //

	// SF King's
	AddStaticVehicle(555, -1926.2300, 585.2100, 35.1294, 180.0000, -1, -1); // Windsor //
	AddStaticVehicle(506, -2087.4000, 557.7300, 35.1794, 270.0000, -1, -1); // Super GT //

	// SF docks industrial
	AddStaticVehicle(443, -1659.6400, 42.6600, 3.5597, 314.5800, -1, -1); // Packer //
	AddStaticVehicle(403, -1693.6600, -35.8600, 3.5564, 42.1500, -1, -1); // Linerunner //
	AddStaticVehicle(578, -1723.5000, 58.8300, 3.5597, 215.5800, -1, -1); // DFT-30 //

	// SF Garcia
	AddStaticVehicle(401, -2122.3100, 137.9500, 35.9575, 82.8600, -1, -1); // Bravura //
	AddStaticVehicle(436, -2267.3000, 196.7200, 35.1638, 270.0000, -1, -1); // Previon //
	AddStaticVehicle(518, -2337.3800, -125.7800, 35.3138, 180.0000, -1, -1); // Buccaneer //

	// SF Missionary Hill
	AddStaticVehicle(547, -2402.0600, -587.6300, 132.6400, 303.2500, -1, -1); // Primo //
	AddStaticVehicle(552, -2494.6200, -602.5400, 132.5600, 180.0000, -1, -1); // Utility Van //

	// SF Paradiso
	AddStaticVehicle(551, -2635.2900, 932.5300, 71.9284, 187.1000, -1, -1); // Merit //
	AddStaticVehicle(529, -2781.7500, 765.8800, 50.5951, 90.0000, -1, -1); // Willard //

	// SF Santa Flora (Medical Center)
	AddStaticVehicle(416, -2707.5500, 634.1700, 14.4512, 180.0000, -1, -1); // Ambulance //
	AddStaticVehicle(416, -2698.3700, 630.1200, 14.4512, 180.0000, -1, -1); // Ambulance //

	// SF Queens
	AddStaticVehicle(421, -2486.5300, 421.0000, 27.7878, 143.6000, -1, -1); // Washington //
	AddStaticVehicle(419, -2513.9200, 359.6400, 35.1144, 249.1300, -1, -1); // Esperanto //

	// SF Calton Heights
	AddStaticVehicle(506, -2016.3200, 853.9800, 45.4424, 270.0000, -1, -1); // Super GT //
	AddStaticVehicle(533, -2023.5200, 917.2000, 46.1253, 239.3500, -1, -1); // Feltzer //
	AddStaticVehicle(496, -2133.5700, 990.1400, 80.0016, 0.0000, -1, -1); // Blista Compact //
	AddStaticVehicle(419, -2181.7300, 1032.2400, 80.0086, 180.0000, -1, -1); // Esperanto //

	// SF Juniper Hill/Hollow
	AddStaticVehicle(496, -2519.4600, 926.1700, 65.0346, 0.0000, -1, -1); // Blista Compact //
	AddStaticVehicle(419, -2511.9400, 1130.8800, 55.7702, 87.5200, -1, -1); // Esperanto //
	AddStaticVehicle(541, -2457.8300, 1069.6000, 55.7802, 1.0300, -1, -1); // Bullet //
	AddStaticVehicle(543, -2437.3200, 1033.2100, 50.3902, 6.0300, -1, -1); // Sadler //

	// SF Palisades
	AddStaticVehicle(458, -2858.9000, 688.4700, 23.2268, 291.0500, -1, -1); // Solair //
	AddStaticVehicle(483, -2836.4300, 863.6500, 44.0516, 267.4500, -1, -1); // Camper //
	AddStaticVehicle(567, -2865.8900, 1044.2500, 33.8916, 6.8200, -1, -1); // Savanna //
	AddStaticVehicle(588, -2740.2500, 1263.7400, 11.7616, 91.7400, -1, -1); // Hotdog //
	AddStaticVehicle(458, -2927.1800, 505.7100, 4.9160, 180.0000, -1, -1); // Solair //
	AddStaticVehicle(472, -2954.1300, 499.8800, 0.0016, 0.0000, -1, -1); // Coastguard //
	AddStaticVehicle(595, -2981.5600, 502.1900, 0.0016, 0.0000, -1, -1); // Launch //
	AddStaticVehicle(454, -2968.1500, 499.5000, 0.0000, 0.0000, -1, -1); // Tropic //

	// SF Gant Bridge underpass
	AddStaticVehicle(589, -2644.9400, 1337.6100, 7.1616, 0.0000, -1, -1); // Club //

	// SF Downtown
	AddStaticVehicle(479, -1638.69, 1296.0300, 7.0300, 312.4300, -1, -1); // Regina //

	// SF Hashbury
	AddStaticVehicle(482, -2480.1700, -196.6400, 25.6200, 90.0000, -1, -1); // Burrito //
	AddStaticVehicle(543, -2517.2700, -3.2400, 25.6100, 270.0000, -1, -1); // Sadler //

	// SF Avispa Country Club
	AddStaticVehicle(587, -2783.9600, -282.9700, 7.0300, 0.0000, -1, -1); // Euros //
	AddStaticVehicle(410, -2749.9800, -294.1500, 7.0300, 180.0000, -1, -1); // Manana //
	AddStaticVehicle(457, -2656.0700, -278.4300, 7.4900, 136.0000, -1, -1); // Caddy //
	AddStaticVehicle(457, -2652.5200, -282.3200, 7.4900, 136.0000, -1, -1); // Caddy //

	// SF Otto's Cars
	AddStaticVehicle(589, -1664.1300, 1221.8200, 13.6700, 224.4400, -1, -1); // Club //
	AddStaticVehicle(507, -1677.9600, 1209.6000, 13.6700, 228.0500, -1, -1); // Elegant //
	AddStaticVehicle(477, -1678.5600, 1209.7700, 21.1500, 231.2600, -1, -1); // ZR-350 //
	AddStaticVehicle(506, -1663.8400, 1222.7700, 21.1500, 216.5600, -1, -1); // Super GT //

	// SF Michelle's Auto Repair
	AddStaticVehicle(525, -1769.7600, 1204.8500, 25.1200, 180.0000, -1, -1); // Tow Truck //
	AddStaticVehicle(501, -1784.9600, 1227.1600, 32.6500, 175.5600, -1, -1); // RC Goblin //
	AddStaticVehicle(465, -1790.1700, 1224.0000, 32.6500, 175.5600, -1, -1); // RC Raider //
	AddStaticVehicle(464, -1794.0900, 1226.0900, 32.6500, 175.5600, -1, -1); // RC Baron //

	// LV Strip (Caligula's)
	AddStaticVehicle(409, 2177.3600, 1708.9400, 11.0906, 178.0000, -1, -1); // Stretch //
	AddStaticVehicle(415, 2075.8900, 1605.3100, 10.6706, 0.0000, -1, -1); // Cheetah //
	AddStaticVehicle(429, 2094.0400, 1738.7400, 10.6706, 333.0000, -1, -1); // Banshee //

	// Old Venturas Strip
	AddStaticVehicle(412, 2264.8800, 2131.0000, 10.8284, 270.0000, -1, -1); // Voodoo //
	AddStaticVehicle(576, 2480.5600, 2156.0500, 10.8244, 90.0000, -1, -1); // Tornado //

	// LV Roca Escalante
	AddStaticVehicle(602, 2370.8200, 2576.7200, 10.8200, 0.0000, -1, -1); // Alpha //
	AddStaticVehicle(526, 2331.8200, 2575.7900, 10.8100, 6.3400, -1, -1); // Fortune //

	// LV Golf Club
	AddStaticVehicle(451, 1486.8600, 2877.5900, 10.8200, 0.0000, -1, -1); // Turismo //
	AddStaticVehicle(429, 1527.4500, 2795.4800, 10.8262, 270.7100, -1, -1); // Banshee //
	AddStaticVehicle(457, 1460.8800, 2733.8200, 10.8200, 0.0000, -1, -1); // Caddy //
	AddStaticVehicle(457, 1469.5300, 2733.8800, 10.8200, 0.0000, -1, -1); // Caddy //

	// LV Pilgrim
	AddStaticVehicle(529, 2563.9300, 1890.4400, 10.8234, 90.0000, -1, -1); // Willard //
	AddStaticVehicle(426, 2630.8000, 1839.0400, 10.8234, 270.6900, -1, -1); // Premier //
	AddStaticVehicle(551, 2598.9600, 1697.2400, 10.8203, 270.0500, -1, -1); // Merit //

	// LV Julius Thruway rest stop
	AddStaticVehicle(514, 2358.2100, 824.4600, 6.8503, 266.5500, -1, -1); // Tanker //
	AddStaticVehicle(515, 2698.5100, 1448.3400, 6.8687, 180.0000, -1, -1); // Roadtrain //

	// LV North quarry road
	AddStaticVehicle(495, 1020.9300, 2211.4000, 10.8219, 0.0000, -1, -1); // Sandking //
	AddStaticVehicle(489, 1027.3600, 2111.8500, 10.8219, 0.0000, -1, -1); // Rancher //

	// LV Airport parking
	AddStaticVehicle(409, 1644.1800, 1290.3800, 10.8200, 180.0000, -1, -1); // Stretch //
	AddStaticVehicle(551, 1679.3300, 1315.6600, 10.8240, 0.0000, -1, -1); // Merit //

	// LV Camel's Toe area (Pyramid Casino and Hotel)
	AddStaticVehicle(415, 2148.9500, 1410.1300, 10.8219, 177.4300, -1, -1); // Cheetah //
	AddStaticVehicle(429, 2116.5100, 1397.5300, 10.8262, 0.0000, -1, -1); // Banshee //

	// LV Hospital (Redsands at LVA)
	AddStaticVehicle(416, 1590.6300, 1821.2000, 10.8212, 0.0000, -1, -1); // Ambulance //

	// The Big Spread Ranch
	AddStaticVehicle(451, 716.7800, 1944.6000, 5.5300, 0.0000, -1, -1); // Turismo //
	AddStaticVehicle(475, 711.2900, 1945.1800, 5.5300, 0.0000, -1, -1); // Sabre //

	// Dillimore farms
	AddStaticVehicle(531, 1056.4100, -287.3800, 73.9923, 180.0000, -1, -1); // Tractor //
	AddStaticVehicle(531, 1061.5900, -287.9300, 73.9923, 180.0000, -1, -1); // Tractor //

	// Dillimore
	AddStaticVehicle(426, 865.8600, -580.2400, 18.2360, 90.0000, -1, -1); // Premier //
	AddStaticVehicle(402, 696.0700, -470.1000, 16.3360, 90.0000, -1, -1); // Buffalo //
	AddStaticVehicle(428, 709.5400, -449.1600, 16.3360, 86.0000, -1, -1); // Securicar //
	AddStaticVehicle(443, 662.4900, -444.5100, 16.3360, 92.0000, -1, -1); // Packer //
	AddStaticVehicle(456, 797.6900, -610.7300, 16.3452, 0.0000, -1, -1); // Yankee //
	AddStaticVehicle(530, 813.5000, -610.9800, 16.3352, 0.0000, -1, -1); // Forklift //
	AddStaticVehicle(468, 815.3000, -563.9500, 16.3352, 270.0000, -1, -1); // Sanchez //
	AddStaticVehicle(480, 687.6600, -635.5400, 16.3352, 0.0000, -1, -1); // Comet //
	AddStaticVehicle(523, 613.4600, -597.0900, 17.2352, 270.0000, -1, -1); // HPV1000 //
	AddStaticVehicle(427, 625.2800, -610.3100, 17.0052, 270.0000, -1, -1); // Enforcer //
	AddStaticVehicle(601, 613.0100, -601.5900, 17.2352, 270.0000, -1, -1); // SWAT //
	AddStaticVehicle(490, 614.0100, -590.8800, 17.2352, 270.0000, -1, -1); // FBI Rancher //
	AddStaticVehicle(504, 663.4200, -619.9300, 16.3352, 270.0000, -1, -1); // Bloodring Banger //
	AddStaticVehicle(508, 646.6900, -503.1400, 16.3352, 0.0000, -1, -1); // Journey //

	// Palomino Creek
	AddStaticVehicle(473, 2119.9500, -101.6700, 0.0900, 130.2200, -1, -1); // Dinghy //
	AddStaticVehicle(422, 2195.0000, -105.0000, 25.9733, 90.0000, -1, -1); // Bobcat //
	AddStaticVehicle(456, 2249.2600, -82.7300, 26.5102, 180.0000, -1, -1); // Yankee //
	AddStaticVehicle(442, 2267.7600, -34.9300, 26.4812, 270.0000, -1, -1); // Romero //

	// Montgomery
	AddStaticVehicle(568, 1371.0700, 196.5600, 19.5530, 334.1200, -1, -1); // Bandito //
	AddStaticVehicle(543, 1390.4300, 265.9300, 19.5652, 158.7500, -1, -1); // Sadler //
	AddStaticVehicle(456, 1334.4500, 326.4000, 19.5552, 337.7600, -1, -1); // Yankee //
	AddStaticVehicle(578, 1335.1900, 285.1900, 19.5652, 244.8700, -1, -1); // DFT-30 //
	AddStaticVehicle(530, 1333.6000, 292.3700, 19.5652, 161.6900, -1, -1); // Forklift //
	AddStaticVehicle(414, 1208.4500, 189.3100, 20.4752, 336.7500, -1, -1); // Mule //
	AddStaticVehicle(445, 1228.0900, 299.6700, 19.5552, 337.3400, -1, -1); // Admiral //

	// Red County Farm (Montgomery)
	AddStaticVehicle(482, 1519.2800, 2.3200, 23.8652, 287.0000, -1, -1); // Burrito //

	// Blueberry
	AddStaticVehicle(524, 94.9700, -153.7600, 2.5710, 270.0000, -1, -1); // Cement Truck //
	AddStaticVehicle(525, 164.2400, -182.8500, 1.5810, 270.0000, -1, -1); // Tow Truck //
	AddStaticVehicle(533, 249.3600, -159.0000, 1.5710, 95.0000, -1, -1); // Feltzer //
	AddStaticVehicle(609, 169.1500, -55.4500, 1.5710, 273.0000, -1, -1); // Boxville //
	AddStaticVehicle(552, 310.3400, -228.3600, 1.5310, 0.0000, -1, -1); // Utility Van //

	// Blueberry farmland
	AddStaticVehicle(531, 121.1200, -69.9100, 1.5711, 90.0000, -1, -1); // Tractor //
	AddStaticVehicle(532, -121.3300, 43.0800, 3.1110, 340.0000, -1, -1); // Combine //
	AddStaticVehicle(532, 1.8500, 40.5300, 3.1110, 335.1000, -1, -1); // Combine //
	AddStaticVehicle(610, -22.6600, 41.3000, 3.1146, 340.0000, -1, -1); // Farm Trailer //
	AddStaticVehicle(512, -11.2400, -0.3200, 3.1140, 230.0000, -1, -1); // Cropdust //

	// Fort Carson
	AddStaticVehicle(489, -166.0000, 1011.8200, 19.7435, 90.0000, -1, -1); // Rancher //
	AddStaticVehicle(568, -80.6100, 1076.8700, 19.7431, 0.0000, -1, -1); // Bandito //
	AddStaticVehicle(600, -160.1500, 1228.3800, 19.7412, 180.0000, -1, -1); // Picador //
	AddStaticVehicle(416, -334.5400, 1065.1200, 19.7312, 270.0000, -1, -1); // Ambulance //
	AddStaticVehicle(427, -228.6200, 986.3300, 19.6212, 0.0000, -1, -1); // Enforcer //
	AddStaticVehicle(428, -81.8800, 1339.8000, 10.9212, 8.8500, -1, -1); // Securicar //
	AddStaticVehicle(442, -220.9700, 1104.3200, 19.7412, 90.0000, -1, -1); // Romero //
	AddStaticVehicle(482, -306.2000, 800.2900, 15.0512, 316.3900, -1, -1); // Burrito //
	AddStaticVehicle(508, 44.2200, 1174.0100, 18.6600, 1.2000, -1, -1); // Journey //
	AddStaticVehicle(412, -79.5200, 1222.1200, 19.7464, 4.9600, -1, -1); // Voodoo //
	AddStaticVehicle(475, -177.2000, 1222.6100, 19.7300, 91.7200, -1, -1); // Sabre //
	AddStaticVehicle(480, 158.7400, 1191.2900, 15.1152, 99.7400, -1, -1); // Comet //
	AddStaticVehicle(588, 145.1500, 1095.3200, 13.7600, 120.5000, -1, -1); // Hotdog //
	AddStaticVehicle(561, -44.8400, 1167.3800, 19.5588, 181.9000, -1, -1); // Stratum //
	AddStaticVehicle(582, -87.1500, 1077.6000, 19.7400, 180.9500, -1, -1); // Newsvan //
	AddStaticVehicle(589, -197.0400, 1222.7400, 19.7416, 358.5800, -1, -1); // Club //
	AddStaticVehicle(551, -157.7600, 1184.0700, 19.7403, 1.2000, -1, -1); // Merit //

	// Las Payasadas
	AddStaticVehicle(600, -326.2700, 2655.6700, 63.4384, 8.4800, -1, -1); // Picador //
	AddStaticVehicle(412, -213.8000, 2596.1300, 62.7064, 180.0000, -1, -1); // Voodoo //
	AddStaticVehicle(489, -222.1800, 2728.9100, 62.6878, 275.0000, -1, -1); // Rancher //
	AddStaticVehicle(470, -231.3400, 2607.8900, 62.7023, 1.5300, -1, -1); // Patriot //

	// Las Barrancas
	AddStaticVehicle(419, -856.5600, 1555.6900, 23.9300, 180.0000, -1, -1); // Esperanto //
	AddStaticVehicle(422, -827.8500, 1425.7400, 13.9100, 9.6200, -1, -1); // Bobcat //
	AddStaticVehicle(508, -746.7800, 1640.7900, 27.2300, 12.4700, -1, -1); // Journey //
	AddStaticVehicle(442, -780.9800, 1544.8000, 27.0412, 91.8500, -1, -1); // Romero //
	AddStaticVehicle(566, -754.8700, 1583.9700, 26.9612, 53.0800, -1, -1); // Tahoma //

	// El Quebrados
	AddStaticVehicle(413, -1412.6400, 2584.7000, 55.8300, 356.2300, -1, -1); // Pony //
	AddStaticVehicle(523, -1400.3600, 2640.9400, 55.6800, 266.6100, -1, -1); // HPV1000 //
	AddStaticVehicle(599, -1401.6900, 2646.9700, 55.6800, 272.9500, -1, -1); // Ranger //
	AddStaticVehicle(424, -1358.5100, 2048.8500, 52.5100, 273.5200, -1, -1); // BF Injection //
	AddStaticVehicle(416, -1509.6400, 2524.5700, 55.6812, 0.0000, -1, -1); // Ambulance //
	AddStaticVehicle(493, -1378.0300, 2120.0100, 40.0700, 232.2500, -1, -1); // Jetmax //
	AddStaticVehicle(428, -1519.9400, 2629.0600, 55.8300, 89.7400, -1, -1); // Securicar //
	AddStaticVehicle(552, -1472.6900, 2640.7600, 55.8390, 3.0400, -1, -1); // Utility van //
	AddStaticVehicle(518, -1528.3400, 2525.7300, 55.7790, 180.7200, -1, -1); // Buccaneer //

	// Tierra Robada ("Reservoir Lonehouse")
	AddStaticVehicle(460, -921.0200, 2654.7200, 40.0700, 139.8400, -1, -1); // Skimmer //

	// Tierra Robada (Interstate Dinner)
	AddStaticVehicle(508, -1939.9100, 2393.1500, 49.4900, 110.6100, -1, -1); // Journey //

	// Tierra Robada desert
	AddStaticVehicle(568, -34.8200, 2648.9500, 63.5868, 91.0000, -1, -1); // Bandito //
	
	// Area 69
	//AddStaticVehicle(495, 505.0000, 2105.0000, 43.9905, 0.0000, -1, -1); // Sandking
	//AddStaticVehicle(470, 495.0000, 2095.0000, 44.9623, 90.0000, -1, -1); // Patriot
	//AddStaticVehicle(471, 510.0000, 2110.0000, 44.2297, 180.0000, -1, -1); // Quad

	// Hunter Quarry
	AddStaticVehicle(406, 681.9900, 888.9300, -39.7544, 90.0000, -1, -1); // Dumper //
	AddStaticVehicle(486, 677.8400, 903.7000, -40.3644, 98.2500, -1, -1); // Dozer //
	AddStaticVehicle(495, 832.8000, 867.2500, 12.6944, 200.0000, -1, -1); // Sandking //

	// Angel Pine logging town
	AddStaticVehicle(568, -2049.0300, -2465.7200, 30.6288, 141.0000, -1, -1); // Bandito //
	AddStaticVehicle(478, -2164.8300, -2461.0000, 30.6203, 51.5500, -1, -1); // Walton //
	AddStaticVehicle(543, -2114.0100, -2312.3300, 30.6288, 229.1900, -1, -1); // Sadler //
	AddStaticVehicle(561, -2205.5000, -2252.2400, 30.6888, 229.6000, -1, -1); // Stratum //
	AddStaticVehicle(495, -2151.3700, -2440.2600, 30.6288, 143.0700, -1, -1); // Sandking //
	AddStaticVehicle(416, -2205.4300, -2297.8700, 30.6288, 321.2400, -1, -1); // Ambulance //
	AddStaticVehicle(578, -2000.7600, -2422.2700, 30.6288, 125.8500, -1, -1); // DFT-30 //
	AddStaticVehicle(530, -2015.4000, -2406.6800, 30.6288, 319.2400, -1, -1); // Forklift //
	AddStaticVehicle(515, -1961.8700, -2443.2400, 30.6210, 109.4000, -1, -1); // Roadtrain //
	
	// Whetstone Highway Petrol Station stop
	AddStaticVehicle(579, -1577.4600, -2730.5000, 48.5400, 326.9600, -1, -1); // Huntley //
	AddStaticVehicle(581, -1567.2600, -2735.7200, 48.5400, 327.3600, -1, -1); // BF-400 //
	AddStaticVehicle(588, -1609.4300, -2695.8400, 48.5300, 234.4800, -1, -1); // Hotdog //

	// Back o Beyond / Shady Creeks / Whetstone forest road
	AddStaticVehicle(489, -524.3800, -2158.1600, 51.1803, 86.5900, -1, -1); // Rancher //
	AddStaticVehicle(568, -816.6300, -2484.7200, 82.1303, 148.7200, -1, -1); // Bandito //
	AddStaticVehicle(568, -1076.4700, -2118.5300, 41.9863, 325.4600, -1, -1); // Bandito //
	AddStaticVehicle(543, -1635.7300, -2225.1400, 30.4998, 90.0000, -1, -1); // Sadler //

	// Los Santos Inlet (Interstate way)
	AddStaticVehicle(543, -274.0300, -2178.6700, 28.8239, 108.5900, -1, -1); // Sadler //
	AddStaticVehicle(508, -14.7200, -2518.2800, 36.6539, 212.8300, -1, -1); // Journey //
	AddStaticVehicle(554, 34.0100, -2633.2500, 40.4039, 92.3800, -1, -1); // Yosemite //
	
	// Sherman Dam
	AddStaticVehicle(470, -904.2100, 1983.7000, 60.9171, 311.0000, -1, -1); // Patriot //
	AddStaticVehicle(489, -909.7400, 2019.8500, 60.9191, 133.1500, -1, -1); // Rancher //

	// Mount Chiliad base
	AddStaticVehicle(471, -2397.3300, -2213.4800, 33.2896, 297.6600, -1, -1); // Quad //
	AddStaticVehicle(468, -2399.5300, -2206.7000, 33.2807, 295.2800, -1, -1); // Sanchez //
	AddStaticVehicle(468, -2400.6800, -2202.2300, 33.2807, 295.2800, -1, -1); // Sanchez //

	// Area 69 perimeter road
	AddStaticVehicle(470, 305.0000, 1755.0000, 17.4906, 0.0000, -1, -1); // Patriot //
	AddStaticVehicle(489, 295.0000, 1745.0000, 17.4906, 90.0000, -1, -1); // Rancher //

	// Flint County oil fields
	AddStaticVehicle(514, 285.3200, 1375.7100, 10.5859, 0.0000, -1, -1); // Tanker //
	AddStaticVehicle(422, 615.1800, 1351.2500, 11.8190, 0.0000, -1, -1); // Bobcat //
	AddStaticVehicle(552, 637.4100, 1227.5300, 11.7190, 293.4700, -1, -1); // Utility van //

	// Corvin Stadium area

	// Highway rest stop north LS
	AddStaticVehicle(551, 1697.9800, -560.9600, 36.1967, 182.9600, -1, -1); // Merit //
	AddStaticVehicle(514, 1676.9000, -88.7800, 35.5601, 8.1100, -1, -1); // Tanker //

	// Highway rest stop south SF
	AddStaticVehicle(426, -1605.0000, -1295.0000, 57.1656, 0.0000, -1, -1); // Premier
	AddStaticVehicle(543, -1595.0000, -1305.0000, 55.9940, 90.0000, -1, -1); // Sadler

	// Tierra Robada / Interstate highway (between SF and LV neer Las Barrancas)
	AddStaticVehicle(495, -1234.6100, 1920.4700, 43.0600, 318.4500, -1, -1); // Sandking //
	AddStaticVehicle(482, -1449.1000, 1877.2200, 32.6300, 185.9600, -1, -1); // Burrito //
	AddStaticVehicle(508, -1197.6100, 1821.1700, 41.8000, 226.6600, -1, -1); // Journey //
	AddStaticVehicle(422, -1201.9900, 1816.1100, 41.8000, 226.9900, -1, -1); // Bobcat //
	AddStaticVehicle(552, -1818.2400, 2050.2100, 9.3300, 269.9600, -1, -1); // Utility Van //

	// Panopticon area
	AddStaticVehicle(489, -762.1500, -136.2600, 65.6636, 21.7100, -1, -1); // Rancher //
	AddStaticVehicle(568, -535.2800, -176.9100, 78.4088, 180.0000, -1, -1); // Bandito //

	//-------------------------------------------------------------------------------------------
	// Additional map-filler vehicles: car parks, parking lots and roadside spots.

	// LS East Beach multi-storey car park
	AddStaticVehicle(401, 2796.2899, -1428.5924, 20.0349, 1.1940, -1, -1); // Bravura //
	AddStaticVehicle(426, 2799.6544, -1428.7884, 19.9742, 1.0655, -1, -1); // Premier //
	AddStaticVehicle(474, 2809.6126, -1428.6956, 20.0294, 180.1395, -1, -1); // Hermes //
	AddStaticVehicle(496, 2796.5029, -1428.7634, 23.8986, 0.7926, -1, -1); // Blista Compact //
	AddStaticVehicle(581, 2809.6657, -1427.5696, 23.8348, 359.3583, -1, -1); // BF-400 //
	AddStaticVehicle(540, 2816.8198, -1435.6099, 24.1069, 270.1723, -1, -1); // Vincent //
	AddStaticVehicle(550, 2802.9220, -1428.7820, 28.0575, 359.9112, -1, -1); // Sunrise //
	AddStaticVehicle(474, 2816.8353, -1455.3908, 27.9659, 270.7324, -1, -1); // Hermes //
	AddStaticVehicle(516, 2799.8094, -1428.6190, 32.0242, 359.2245, -1, -1); // Nebula //
	AddStaticVehicle(561, 2816.9367, -1435.4705, 31.9884, 268.9677, -1, -1); // Stratum //
	AddStaticVehicle(474, 2816.7131, -1445.3356, 35.9034, 270.4318, -1, -1); // Hermes //
	AddStaticVehicle(585, 2816.7346, -1438.7707, 35.7274, 269.7694, -1, -1); // Emperor //
	AddStaticVehicle(477, 2816.7706, -1445.3927, 39.8062, 269.2929, -1, -1); // ZR-350 //
	AddStaticVehicle(461, 2817.9395, -1448.6735, 39.6825, 269.2659, -1, -1); // PCJ-600 //

	// LS Conference Center parking
	AddStaticVehicle(422, 1062.0699, -1746.1801, 13.4547, 269.9998, -1, -1); // Bobcat //
	AddStaticVehicle(400, 1099.0000, -1766.6600, 13.4407, 269.9998, -1, -1); // Landstalker //

	// LS East Beach parking
	AddStaticVehicle(547, 2656.5422, -1701.8273, 9.1067, 269.6266, -1, -1); // Primo //
	AddStaticVehicle(554, 2657.3649, -1807.7244, 9.3918, 94.9158, -1, -1); // Yosemite //
	AddStaticVehicle(445, 2676.5130, -1821.2541, 9.3056, 309.7163, -1, -1); // Admiral //
	AddStaticVehicle(576, 2696.5255, -1671.3138, 9.1402, 0.2570, -1, -1); // Tornado //
	AddStaticVehicle(600, 2771.3014, -1841.0341, 9.5429, 19.0967, -1, -1); // Picador //
	AddStaticVehicle(474, 2798.1399, -1562.6300, 10.7352, 90.0002, -1, -1); // Hermes //
	AddStaticVehicle(467, 2802.9371, -1539.9295, 10.7200, 179.7696, -1, -1); // Oceanic //
	AddStaticVehicle(500, 2811.4720, -1827.0814, 10.0985, 268.7693, -1, -1); // Mesa //
	AddStaticVehicle(554, 2812.7300, -1673.4000, 10.0270, 0.0000, -1, -1); // Yosemite //
	AddStaticVehicle(566, 2822.0967, -1562.1660, 10.7200, 268.7059, -1, -1); // Tahoma //

	// LS East Los Santos parking
	AddStaticVehicle(475, 2390.7600, -1510.2200, 23.6970, 90.0002, -1, -1); // Sabre //

	// LS El Corona parking
	AddStaticVehicle(475, 1946.9253, -2136.5282, 13.3900, 90.2605, -1, -1); // Sabre //

	// LS Jefferson parking
	AddStaticVehicle(445, 2147.9500, -1175.6500, 23.7525, 90.0002, -1, -1); // Admiral //
	AddStaticVehicle(436, 2161.4800, -1192.3700, 23.6157, 90.0002, -1, -1); // Previon //
	AddStaticVehicle(400, 2205.6083, -1164.9358, 25.8283, 91.0797, -1, -1); // Landstalker //
	AddStaticVehicle(517, 2216.9031, -1166.0314, 25.6114, 269.5744, -1, -1); // Majestic //

	// LS Los Santos International parking
	AddStaticVehicle(533, 1364.9380, -2354.8451, 13.3450, 271.2261, -1, -1); // Feltzer //
	AddStaticVehicle(554, 1365.3127, -2228.4104, 13.6434, 269.6859, -1, -1); // Yosemite //
	AddStaticVehicle(561, 1388.1790, -2225.1951, 13.4103, 180.0228, -1, -1); // Stratum //
	AddStaticVehicle(421, 1388.2026, -2207.8497, 13.4883, 181.2604, -1, -1); // Washington //
	AddStaticVehicle(413, 1390.6056, -2261.9802, 13.6485, 179.7061, -1, -1); // Pony //
	AddStaticVehicle(458, 1391.3721, -2347.8433, 13.4464, 181.2381, -1, -1); // Solair //
	AddStaticVehicle(550, 1394.9427, -2242.0899, 13.4490, 181.8359, -1, -1); // Sunrise //
	AddStaticVehicle(459, 1404.5955, -2207.5720, 13.6384, 180.5521, -1, -1); // Berkley's RC Van //
	AddStaticVehicle(550, 1407.9385, -2207.6489, 13.4490, 178.8071, -1, -1); // Sunrise //
	AddStaticVehicle(436, 1407.9827, -2364.8594, 13.3430, 178.8122, -1, -1); // Previon //
	AddStaticVehicle(527, 1408.0100, -2349.7600, 13.3482, 179.9999, -1, -1); // Cadrona //
	AddStaticVehicle(526, 1408.0100, -2332.6101, 13.3956, 179.9999, -1, -1); // Fortune //
	AddStaticVehicle(458, 1411.0458, -2313.7108, 13.4464, 180.3623, -1, -1); // Solair //
	AddStaticVehicle(477, 1515.3399, -2361.1448, 13.2936, 181.5448, -1, -1); // ZR-350 //
	AddStaticVehicle(554, 1515.3799, -2211.4042, 13.6434, 179.0871, -1, -1); // Yosemite //
	AddStaticVehicle(440, 1560.3273, -2240.9590, 13.7510, 271.3972, -1, -1); // Rumpo //
	AddStaticVehicle(558, 1560.3590, -2315.3935, 13.2459, 271.0913, -1, -1); // Uranus //

	// LS Marina parking
	AddStaticVehicle(401, 782.2610, -1633.6823, 13.1989, 90.2990, -1, -1); // Bravura //

	// LS Mulholland Intersection parking
	AddStaticVehicle(477, 1571.7281, -1011.5907, 23.6529, 181.6807, -1, -1); // ZR-350 //
	AddStaticVehicle(527, 1583.9100, -1047.5200, 23.7075, 307.4892, -1, -1); // Cadrona //
	AddStaticVehicle(551, 1594.7505, -1009.7779, 23.8055, 187.6737, -1, -1); // Merit //
	AddStaticVehicle(422, 1616.7900, -1123.6500, 23.9066, 90.0002, -1, -1); // Bobcat //
	AddStaticVehicle(566, 1617.6789, -1008.6890, 23.7012, 357.1762, -1, -1); // Tahoma //
	AddStaticVehicle(401, 1619.8449, -1098.3613, 23.7223, 268.0860, -1, -1); // Bravura //
	AddStaticVehicle(550, 1678.4888, -1011.6283, 23.8005, 197.3553, -1, -1); // Sunrise //
	AddStaticVehicle(551, 1696.8413, -1085.1787, 23.8055, 179.1735, -1, -1); // Merit //
	AddStaticVehicle(565, 1704.9700, -1069.0300, 23.5906, 360.0000, -1, -1); // Flash //
	AddStaticVehicle(517, 1707.6300, -1035.7800, 23.7910, 360.0000, -1, -1); // Majestic //
	AddStaticVehicle(533, 1744.2633, -1012.0481, 23.7590, 346.8654, -1, -1); // Feltzer //
	AddStaticVehicle(527, 1744.4900, -1085.7600, 23.7622, 360.0000, -1, -1); // Cadrona //
	AddStaticVehicle(405, 1758.0262, -1085.0660, 23.8859, 178.5051, -1, -1); // Sentinel //
	AddStaticVehicle(517, 1771.3900, -1061.6400, 23.8457, 360.0000, -1, -1); // Majestic //
	AddStaticVehicle(566, 1779.4197, -1023.7501, 23.7590, 333.4279, -1, -1); // Tahoma //

	// LS Playa del Seville parking
	AddStaticVehicle(466, 2767.8130, -1876.3750, 9.5365, 179.0655, -1, -1); // Glendale //

	// LS Rodeo parking
	AddStaticVehicle(411, 200.8150, -1439.3400, 12.8746, 320.0000, -1, -1); // Infernus //
	AddStaticVehicle(521, 339.2860, -1342.9200, 14.1278, 299.9999, -1, -1); // FCR-900 //

	// LS Verona Beach parking
	AddStaticVehicle(540, 878.8840, -1658.8000, 13.4664, 0.0000, -1, -1); // Vincent //

	// LS Willowfield parking
	AddStaticVehicle(439, 1987.3892, -1995.8910, 13.4462, 180.3623, -1, -1); // Stallion //
	AddStaticVehicle(404, 2065.4600, -1919.4000, 13.3312, 179.9999, -1, -1); // Pereniel //
	AddStaticVehicle(546, 2065.6599, -1902.6300, 13.3368, 0.0000, -1, -1); // Intruder //
	AddStaticVehicle(482, 2380.0266, -1928.2498, 13.5172, 0.7357, -1, -1); // Burrito //

	// LS Downtown Los Santos roadside
	AddStaticVehicle(477, 1524.8196, -1307.0123, 14.9334, 269.5490, -1, -1); // ZR-350 //
	AddStaticVehicle(507, 1599.5518, -1359.6049, 15.5739, 177.8485, -1, -1); // Elegant //
	AddStaticVehicle(579, 1685.5585, -1307.0122, 13.6646, 269.9136, -1, -1); // Huntley //

	// LS East Beach roadside
	AddStaticVehicle(467, 2674.2251, -1483.0225, 30.2494, 192.2676, -1, -1); // Oceanic //
	AddStaticVehicle(507, 2841.8392, -1133.1708, 12.6980, 97.0516, -1, -1); // Elegant //
	AddStaticVehicle(576, 2878.6826, -1457.8145, 10.4655, 357.2313, -1, -1); // Tornado //

	// LS East Los Santos roadside
	AddStaticVehicle(404, 2393.9057, -1149.9005, 28.5965, 90.0721, -1, -1); // Pereniel //
	AddStaticVehicle(534, 2490.5273, -1146.6132, 37.8601, 91.1627, -1, -1); // Remington //

	// LS Glen Park roadside
	AddStaticVehicle(536, 1843.2376, -1423.3421, 13.1887, 180.4865, -1, -1); // Blade //
	AddStaticVehicle(479, 1843.3000, -1291.7500, 13.2443, 179.1437, -1, -1); // Regina //

	// LS Idlewood roadside
	AddStaticVehicle(536, 1881.3125, -1457.3000, 13.1809, 90.9086, -1, -1); // Blade //
	AddStaticVehicle(483, 1914.9375, -1758.7000, 13.5237, 269.9730, -1, -1); // Camper //
	AddStaticVehicle(439, 1933.9875, -1457.3000, 13.2821, 90.5842, -1, -1); // Stallion //
	AddStaticVehicle(536, 2087.8658, -1457.3629, 23.5483, 91.0380, -1, -1); // Blade //

	// LS Market roadside
	AddStaticVehicle(547, 894.8125, -1316.6750, 13.2164, 90.4998, -1, -1); // Primo //
	AddStaticVehicle(533, 983.6880, -1137.6700, 23.5640, 90.0002, -1, -1); // Feltzer //
	AddStaticVehicle(555, 1050.5800, -1275.6200, 13.2640, 179.9999, -1, -1); // Windsor //
	AddStaticVehicle(415, 1050.5800, -1192.4800, 19.9409, 179.9999, -1, -1); // Cheetah //
	AddStaticVehicle(477, 1065.7500, -1336.5500, 13.1295, 0.0000, -1, -1); // ZR-350 //
	AddStaticVehicle(585, 1191.6750, -1351.6250, 13.0392, 180.4910, -1, -1); // Emperor //
	AddStaticVehicle(402, 1264.6373, -1328.4862, 13.1826, 359.4302, -1, -1); // Buffalo //
	AddStaticVehicle(561, 1302.5625, -1152.9500, 23.5196, 270.5872, -1, -1); // Stratum //

	// LS Pershing Square roadside
	AddStaticVehicle(401, 1536.2000, -1672.1875, 13.1989, 359.7997, -1, -1); // Bravura //

	// LS Richman roadside
	AddStaticVehicle(422, 213.3684, -1367.6415, 50.2034, 311.1976, -1, -1); // Bobcat //
	AddStaticVehicle(533, 297.5884, -1293.5051, 53.8676, 121.5895, -1, -1); // Feltzer //
	AddStaticVehicle(535, 351.8389, -1264.1366, 53.4615, 115.6112, -1, -1); // Slamvan //

	// LS Rodeo roadside
	AddStaticVehicle(421, 276.9462, -1639.8841, 33.0876, 260.2972, -1, -1); // Washington //
	AddStaticVehicle(463, 298.2850, -1536.3199, 24.1842, 55.0001, -1, -1); // Freeway //
	AddStaticVehicle(415, 401.6363, -1578.6836, 27.6677, 87.1913, -1, -1); // Cheetah //
	AddStaticVehicle(429, 409.7237, -1428.1122, 32.5441, 36.0549, -1, -1); // Banshee //
	AddStaticVehicle(521, 438.3346, -1509.1963, 30.4746, 187.5170, -1, -1); // FCR-900 //
	AddStaticVehicle(562, 455.3238, -1619.6375, 25.6215, 359.2819, -1, -1); // Elegy //
	AddStaticVehicle(587, 489.0313, -1356.1783, 17.0028, 296.5188, -1, -1); // Euros //
	AddStaticVehicle(506, 543.6987, -1474.3500, 14.3684, 1.8132, -1, -1); // Super GT //
	AddStaticVehicle(480, 543.8250, -1613.8750, 16.1238, 0.6138, -1, -1); // Comet //
	AddStaticVehicle(411, 604.4375, -1578.6750, 15.7699, 89.7361, -1, -1); // Infernus //

	// LS Verdant Bluffs roadside
	AddStaticVehicle(492, 1268.2000, -2047.8750, 59.0117, 0.0650, -1, -1); // Greenwood //

	// LS Vinewood roadside
	AddStaticVehicle(562, 882.5000, -1137.1750, 23.4013, 90.2647, -1, -1); // Elegy //

	// LS Willowfield roadside
	AddStaticVehicle(413, 2393.3101, -1927.6899, 13.4844, 179.9999, -1, -1); // Pony //

	// LS East Beach
	AddStaticVehicle(522, 2815.6899, -1430.6801, 39.6770, 269.9998, -1, -1); // NRG-500 //

	// LS Jefferson
	AddStaticVehicle(404, 2135.2600, -1132.4100, 25.4682, 45.0000, -1, -1); // Pereniel //

	// LS Mulholland Intersection
	AddStaticVehicle(507, 1657.4600, -1111.5000, 23.8055, 90.0002, -1, -1); // Elegant //
	AddStaticVehicle(507, 1752.6500, -1045.9301, 23.8602, 360.0000, -1, -1); // Elegant //

	// LS Ocean Docks
	AddStaticVehicle(530, 2164.6799, -2306.1299, 13.2873, 0.0000, -1, -1); // Forklift //
	AddStaticVehicle(530, 2456.1599, -2521.6899, 13.3924, 269.9998, -1, -1); // Forklift //
	AddStaticVehicle(530, 2496.1399, -2375.5400, 13.3654, 225.0003, -1, -1); // Forklift //

	// LS Playa del Seville
	AddStaticVehicle(574, 2860.1201, -1920.4000, 10.7273, 360.0000, -1, -1); // Sweeper //

	// LS Richman
	AddStaticVehicle(572, 298.5010, -1196.3600, 80.6414, 84.4998, -1, -1); // Mower //

	// LS Verona Beach
	AddStaticVehicle(481, 850.7870, -2053.7200, 12.4256, 0.0000, -1, -1); // BMX //

	// SF Downtown underground car park
	AddStaticVehicle(426, -1687.9399, 1007.8300, 17.3414, 269.9998, -1, -1); // Premier //

	// SF Easter Bay Airport car park
	AddStaticVehicle(558, -1424.7425, -212.1020, 5.7008, 269.8644, -1, -1); // Uranus //
	AddStaticVehicle(585, -1425.4045, -232.5797, 5.6345, 269.5692, -1, -1); // Emperor //
	AddStaticVehicle(445, -1436.1149, -247.7959, 5.9322, 178.9963, -1, -1); // Admiral //
	AddStaticVehicle(458, -1440.3199, -143.2400, 5.8995, 359.4015, -1, -1); // Solair //
	AddStaticVehicle(540, -1386.7646, -212.0974, 5.9195, 89.6251, -1, -1); // Vincent //
	AddStaticVehicle(421, -1384.3411, -247.1171, 5.9414, 181.3998, -1, -1); // Washington //
	AddStaticVehicle(482, -1476.3134, -17.1096, 6.1016, 89.9098, -1, -1); // Burrito //
	AddStaticVehicle(561, -1476.1985, -29.6351, 5.8634, 89.4270, -1, -1); // Stratum //
	AddStaticVehicle(558, -1427.9167, -0.7500, 5.7008, 269.6169, -1, -1); // Uranus //
	AddStaticVehicle(551, -1426.1000, 11.5858, 5.8993, 269.4016, -1, -1); // Merit //
	AddStaticVehicle(516, -1425.2216, 32.1773, 5.8993, 270.1078, -1, -1); // Nebula //
	AddStaticVehicle(440, -1452.4913, -40.4850, 6.2058, 179.6627, -1, -1); // Rumpo //
	AddStaticVehicle(516, -1460.7430, -60.5489, 5.8993, 0.0353, -1, -1); // Nebula //
	AddStaticVehicle(581, -1476.8307, -63.2232, 5.6478, 89.1703, -1, -1); // BF-400 //
	AddStaticVehicle(516, -1475.8170, -83.7894, 5.8993, 89.2293, -1, -1); // Nebula //
	AddStaticVehicle(554, -1428.0589, -91.9927, 6.0965, 269.0159, -1, -1); // Yosemite //
	AddStaticVehicle(458, -1425.2208, -79.7922, 5.8995, 270.2695, -1, -1); // Solair //
	AddStaticVehicle(551, -1458.4295, -83.7307, 5.8993, 269.2441, -1, -1); // Merit //
	AddStaticVehicle(426, -1440.2194, 43.4480, 5.7555, 179.1084, -1, -1); // Premier //
	AddStaticVehicle(516, -1387.1645, -21.2017, 5.8993, 90.8310, -1, -1); // Nebula //
	AddStaticVehicle(496, -1385.7100, -25.2674, 5.7111, 89.4015, -1, -1); // Blista Compact //
	AddStaticVehicle(585, -1336.3407, -25.5673, 5.6345, 269.1741, -1, -1); // Emperor //
	AddStaticVehicle(496, -1335.5900, 23.9433, 5.7111, 268.6362, -1, -1); // Blista Compact //
	AddStaticVehicle(558, -1355.6548, -40.9582, 5.7008, 0.4403, -1, -1); // Uranus //
	AddStaticVehicle(421, -1376.1606, -60.5515, 5.9414, 359.1259, -1, -1); // Washington //
	AddStaticVehicle(436, -1337.9800, -83.7477, 5.7961, 269.4016, -1, -1); // Previon //
	AddStaticVehicle(558, -1335.9444, -96.1611, 5.7008, 269.6707, -1, -1); // Uranus //
	AddStaticVehicle(413, -1387.3416, -71.4521, 6.1016, 90.8739, -1, -1); // Pony //
	AddStaticVehicle(581, -1476.6526, -232.7436, 5.6478, 90.8459, -1, -1); // BF-400 //
	AddStaticVehicle(527, -1476.2865, -224.4519, 5.8013, 90.1376, -1, -1); // Cadrona //
	AddStaticVehicle(561, -1372.2106, 43.2960, 5.8634, 359.5741, -1, -1); // Stratum //

	// SF Queens hotel car park
	AddStaticVehicle(603, -2482.7534, 396.9315, 27.6628, 144.5662, -1, -1); // Phoenix //
	AddStaticVehicle(602, -2516.5738, 309.9721, 34.9732, 247.0985, -1, -1); // Alpha //
	AddStaticVehicle(575, -2497.6799, 370.2890, 27.4625, 60.4998, -1, -1); // Broadway //
	AddStaticVehicle(402, -2493.0601, 378.8060, 27.6427, 60.4998, -1, -1); // Buffalo //
	AddStaticVehicle(579, -2479.9500, 416.2120, 27.7658, 135.4999, -1, -1); // Huntley //

	// SF Santa Flora Medical Center car park
	AddStaticVehicle(421, -2589.5144, 627.5709, 14.3945, 90.6843, -1, -1); // Washington //
	AddStaticVehicle(526, -2546.2700, 631.8320, 14.3018, 270.3871, -1, -1); // Fortune //

	// SF Doherty parking
	AddStaticVehicle(421, -2068.6668, -83.9233, 35.1055, 359.9586, -1, -1); // Washington //

	// SF Esplanade North parking
	AddStaticVehicle(554, -1649.2200, 1307.2800, 7.1330, 315.0000, -1, -1); // Yosemite //

	// SF Foster Valley parking
	AddStaticVehicle(461, -2149.1846, -760.4520, 31.6434, 270.7898, -1, -1); // PCJ-600 //
	AddStaticVehicle(496, -2149.0752, -859.9667, 31.7345, 268.7902, -1, -1); // Blista Compact //
	AddStaticVehicle(533, -2148.9960, -913.9416, 31.8215, 269.1268, -1, -1); // Feltzer //
	AddStaticVehicle(507, -2148.9593, -817.9581, 31.9227, 270.5012, -1, -1); // Elegant //
	AddStaticVehicle(507, -2134.2300, -885.5350, 31.9227, 269.9998, -1, -1); // Elegant //
	AddStaticVehicle(533, -2134.0687, -775.4720, 31.8215, 271.1731, -1, -1); // Feltzer //
	AddStaticVehicle(533, -2125.4199, -814.8890, 31.8215, 90.4998, -1, -1); // Feltzer //
	AddStaticVehicle(533, -2125.2000, -760.5340, 31.8215, 88.9998, -1, -1); // Feltzer //
	AddStaticVehicle(526, -2125.1141, -953.1111, 31.8721, 268.7475, -1, -1); // Fortune //
	AddStaticVehicle(576, -1897.4100, -852.9840, 31.6843, 91.0000, -1, -1); // Tornado //
	AddStaticVehicle(507, -1897.3700, -900.0290, 31.9227, 269.0000, -1, -1); // Elegant //
	AddStaticVehicle(526, -1888.4689, -924.5212, 31.8612, 269.5830, -1, -1); // Fortune //
	AddStaticVehicle(401, -1888.4407, -963.6649, 31.8286, 268.7829, -1, -1); // Bravura //
	AddStaticVehicle(401, -1888.4308, -846.6172, 31.8286, 271.8711, -1, -1); // Bravura //
	AddStaticVehicle(579, -1888.2085, -900.1077, 31.9971, 272.0176, -1, -1); // Huntley //
	AddStaticVehicle(526, -1887.3300, -753.9730, 31.8721, 91.0000, -1, -1); // Fortune //
	AddStaticVehicle(422, -1886.7401, -786.9874, 32.0238, 270.8978, -1, -1); // Bobcat //
	AddStaticVehicle(551, -1886.5244, -960.4353, 31.9227, 268.7079, -1, -1); // Merit //
	AddStaticVehicle(461, -1872.2800, -930.6400, 31.6434, 269.0000, -1, -1); // PCJ-600 //
	AddStaticVehicle(400, -1872.1000, -823.8960, 32.1211, 269.0000, -1, -1); // Landstalker //
	AddStaticVehicle(533, -1872.0986, -864.5016, 31.8215, 270.4525, -1, -1); // Feltzer //

	// SF Garcia parking
	AddStaticVehicle(543, -2265.2500, 204.8340, 35.0634, 90.4998, -1, -1); // Sadler //
	AddStaticVehicle(404, -2265.1799, 133.0720, 34.9484, 90.4998, -1, -1); // Pereniel //

	// SF Hashbury parking
	AddStaticVehicle(418, -2461.1805, -5.4913, 28.0724, 89.7883, -1, -1); // Moonbeam //

	// SF Juniper Hill parking
	AddStaticVehicle(445, -2499.8279, 741.5195, 34.9478, 181.1383, -1, -1); // Admiral //
	AddStaticVehicle(551, -2438.5400, 741.7180, 34.9149, 180.3869, -1, -1); // Merit //

	// SF Juniper Hollow parking
	AddStaticVehicle(526, -2526.7100, 1229.5200, 37.2706, 27.6016, -1, -1); // Fortune //
	AddStaticVehicle(547, -2491.6299, 1214.3800, 37.2200, 321.7356, -1, -1); // Primo //

	// SF King's parking
	AddStaticVehicle(526, -2222.7800, 306.5180, 34.9659, 0.0000, -1, -1); // Fortune //
	AddStaticVehicle(603, -2175.8385, 306.3275, 34.9964, 358.9661, -1, -1); // Phoenix //
	AddStaticVehicle(527, -2167.3501, 293.3720, 34.9185, 0.0000, -1, -1); // Cadrona //

	// SF Missionary Hill parking
	AddStaticVehicle(582, -2531.9500, -601.3450, 132.6988, 0.0000, -1, -1); // Newsvan //

	// SF Ocean Flats parking
	AddStaticVehicle(550, -2686.5601, -55.0934, 4.2380, 0.5000, -1, -1); // Sunrise //
	AddStaticVehicle(547, -2658.5978, 268.1178, 4.1340, 181.1022, -1, -1); // Primo //
	AddStaticVehicle(576, -2627.1001, -55.2050, 3.9968, 0.5000, -1, -1); // Tornado //

	// SF Battery Point roadside
	AddStaticVehicle(579, -2573.3742, 1364.3077, 7.0276, 128.4238, -1, -1); // Huntley //

	// SF Calton Heights roadside
	AddStaticVehicle(587, -2251.1351, 1257.0969, 41.8434, 304.3456, -1, -1); // Euros //
	AddStaticVehicle(422, -2150.8701, 1220.1500, 47.2738, 269.9998, -1, -1); // Bobcat //
	AddStaticVehicle(551, -2135.8000, 950.9375, 79.7509, 359.6572, -1, -1); // Merit //
	AddStaticVehicle(422, -2135.8000, 1052.0625, 79.8520, 359.2805, -1, -1); // Bobcat //
	AddStaticVehicle(436, -2135.5500, 771.2500, 69.2102, 0.0805, -1, -1); // Previon //
	AddStaticVehicle(436, -2046.3700, 1112.7800, 53.0852, 330.0000, -1, -1); // Previon //
	AddStaticVehicle(436, -2010.3250, 899.2000, 45.0930, 179.2621, -1, -1); // Previon //

	// SF Doherty roadside
	AddStaticVehicle(541, -1818.9301, -182.7010, 9.1206, 88.9998, -1, -1); // Bullet //

	// SF Downtown roadside
	AddStaticVehicle(526, -1926.6250, 1184.2000, 45.1456, 90.9175, -1, -1); // Fortune //
	AddStaticVehicle(540, -1875.3906, 539.0295, 34.1811, 235.5215, -1, -1); // Vincent //
	AddStaticVehicle(507, -1565.2624, 636.2724, 6.9384, 179.7659, -1, -1); // Elegant //

	// SF Easter Basin roadside
	AddStaticVehicle(410, -1720.4270, 341.1535, 6.7281, 133.7763, -1, -1); // Manana //

	// SF Easter Bay Airport roadside
	AddStaticVehicle(405, -1459.5900, -5.0622, 5.9250, 89.4015, -1, -1); // Sentinel //

	// SF Financial roadside
	AddStaticVehicle(533, -1736.3800, 1032.5699, 17.3840, 94.9998, -1, -1); // Feltzer //
	AddStaticVehicle(421, -1720.3250, 757.1125, 24.6758, 179.2209, -1, -1); // Washington //

	// SF Juniper Hollow roadside
	AddStaticVehicle(458, -2520.1637, 1248.2812, 34.9359, 74.6467, -1, -1); // Solair //

	// SF King's roadside
	AddStaticVehicle(579, -1998.1750, 428.3125, 35.0002, 0.9454, -1, -1); // Huntley //

	// SF Santa Flora roadside
	AddStaticVehicle(576, -2628.7500, 559.8000, 14.1218, 270.8999, -1, -1); // Tornado //

	// SF Easter Bay Airport
	AddStaticVehicle(583, -1315.6200, -273.0850, 13.8371, 34.3959, -1, -1); // Tug //
	AddStaticVehicle(522, -1302.4900, -676.7710, 13.7629, 360.0000, -1, -1); // NRG-500 //
	AddStaticVehicle(506, -1245.5100, 48.3457, 13.9288, 315.0000, -1, -1); // Super GT //
	AddStaticVehicle(485, -1238.5000, -107.4220, 13.8453, 75.0002, -1, -1); // Baggage //

	// SF Missionary Hill
	AddStaticVehicle(437, -2399.3101, -603.8310, 132.7500, 275.0000, -1, -1); // Coach //

	// SF Ocean Flats
	AddStaticVehicle(510, -2796.5300, 140.5910, 6.8075, 90.4998, -1, -1); // Mountain Bike //

	// LV Pilson Intersection stadium car park
	AddStaticVehicle(566, 1125.9601, 2296.7666, 10.6184, 88.8944, -1, -1); // Tahoma //
	AddStaticVehicle(496, 1148.2690, 2300.1737, 10.5314, 89.2861, -1, -1); // Blista Compact //
	AddStaticVehicle(445, 1135.9968, 2267.9860, 10.7525, 269.0377, -1, -1); // Admiral //
	AddStaticVehicle(401, 1106.3635, 2251.2533, 10.6364, 0.2196, -1, -1); // Bravura //

	// LV Roca Escalante underground car park
	AddStaticVehicle(579, 2528.7528, 2399.0707, 4.1955, 359.3534, -1, -1); // Huntley //

	// LV Royal Casino multi-storey car park
	AddStaticVehicle(540, 2292.8296, 1455.1722, 39.6679, 89.3220, -1, -1); // Vincent //
	AddStaticVehicle(451, 2292.9857, 1480.2374, 41.1098, 271.1274, -1, -1); // Turismo //
	AddStaticVehicle(411, 2353.1292, 1483.6546, 42.6005, 270.3574, -1, -1); // Infernus //
	AddStaticVehicle(589, 2353.5532, 1444.5293, 42.5284, 270.6847, -1, -1); // Club //
	AddStaticVehicle(585, 2353.0484, 1430.1942, 10.4548, 270.6173, -1, -1); // Emperor //
	AddStaticVehicle(526, 2353.2702, 1465.7855, 19.4669, 271.1810, -1, -1); // Fortune //
	AddStaticVehicle(477, 2352.9476, 1455.2820, 20.0379, 90.6346, -1, -1); // ZR-350 //
	AddStaticVehicle(507, 2352.9442, 1433.6779, 34.3716, 270.5939, -1, -1); // Elegant //
	AddStaticVehicle(559, 2353.2154, 1408.6402, 35.7776, 269.1296, -1, -1); // Jester //
	AddStaticVehicle(480, 2295.6836, 1519.5059, 36.2574, 180.4732, -1, -1); // Comet //
	AddStaticVehicle(426, 2319.0118, 1519.2163, 23.3805, 359.8663, -1, -1); // Premier //
	AddStaticVehicle(405, 2312.4884, 1519.2552, 29.9484, 1.2101, -1, -1); // Sentinel //
	AddStaticVehicle(540, 2325.6108, 1519.3063, 17.1383, 359.1160, -1, -1); // Vincent //

	// LV Royal Casino covered parking
	AddStaticVehicle(463, 2103.8388, 1408.2215, 10.4107, 181.1530, -1, -1); // Freeway //
	AddStaticVehicle(561, 2142.2317, 1408.6047, 10.7462, 179.2619, -1, -1); // Stratum //

	// LV Starfish Casino multi-storey car park
	AddStaticVehicle(587, 2221.6272, 1944.4043, 9.6007, 268.6325, -1, -1); // Euros //
	AddStaticVehicle(579, 2223.6536, 1940.4317, 9.8517, 270.3921, -1, -1); // Huntley //
	AddStaticVehicle(541, 2221.2959, 1940.4153, 15.0686, 89.0167, -1, -1); // Bullet //
	AddStaticVehicle(535, 2223.6169, 1944.2793, 15.1449, 269.9494, -1, -1); // Slamvan //
	AddStaticVehicle(545, 2223.6169, 1956.5025, 26.1601, 268.7820, -1, -1); // Hustler //
	AddStaticVehicle(541, 2223.6229, 1952.3693, 26.0215, 271.3111, -1, -1); // Bullet //
	AddStaticVehicle(575, 2221.7577, 1936.2699, 20.5190, 88.7365, -1, -1); // Broadway //
	AddStaticVehicle(535, 2223.6835, 1948.3790, 20.6206, 269.3079, -1, -1); // Slamvan //
	AddStaticVehicle(585, 2222.0643, 1936.2582, 31.4143, 89.8707, -1, -1); // Emperor //
	AddStaticVehicle(579, 2223.6928, 1956.3638, 31.7643, 268.5115, -1, -1); // Huntley //
	AddStaticVehicle(587, 2232.3999, 1998.9000, 15.0800, 179.9999, -1, -1); // Euros //
	AddStaticVehicle(426, 2268.2399, 1999.3583, 15.1019, 179.9239, -1, -1); // Premier //

	// LV The Emerald Isle multi-storey car park
	AddStaticVehicle(402, 2078.7110, 2416.5076, 23.6425, 270.5351, -1, -1); // Buffalo //
	AddStaticVehicle(429, 2096.0357, 2393.0958, 23.4535, 270.0849, -1, -1); // Banshee //
	AddStaticVehicle(565, 2096.1572, 2396.0906, 23.4032, 270.2602, -1, -1); // Flash //
	AddStaticVehicle(426, 2104.1601, 2404.8309, 23.5237, 270.6322, -1, -1); // Premier //
	AddStaticVehicle(415, 2078.5361, 2401.9516, 40.7837, 271.1701, -1, -1); // Cheetah //
	AddStaticVehicle(458, 2078.5511, 2393.2119, 40.8708, 269.8946, -1, -1); // Solair //
	AddStaticVehicle(550, 2078.6119, 2416.5562, 40.8734, 90.2020, -1, -1); // Sunrise //
	AddStaticVehicle(535, 2078.6009, 2416.5644, 36.4651, 269.5782, -1, -1); // Slamvan //
	AddStaticVehicle(526, 2086.3814, 2398.9787, 36.5153, 90.6676, -1, -1); // Fortune //
	AddStaticVehicle(555, 2086.4201, 2422.4659, 36.4449, 269.8450, -1, -1); // Windsor //
	AddStaticVehicle(405, 2086.5109, 2410.8811, 19.3963, 90.5412, -1, -1); // Sentinel //
	AddStaticVehicle(575, 2096.0626, 2393.0385, 19.1683, 271.0509, -1, -1); // Broadway //
	AddStaticVehicle(436, 2104.1499, 2416.6512, 19.2674, 90.0684, -1, -1); // Previon //
	AddStaticVehicle(589, 2078.4489, 2422.5546, 14.8253, 269.4020, -1, -1); // Club //
	AddStaticVehicle(422, 2095.9554, 2404.8246, 15.1176, 270.4254, -1, -1); // Bobcat //
	AddStaticVehicle(602, 2096.1534, 2410.7621, 15.0226, 270.9311, -1, -1); // Alpha //
	AddStaticVehicle(581, 2085.9263, 2393.0059, 31.9681, 90.1494, -1, -1); // BF-400 //
	AddStaticVehicle(555, 2086.4710, 2416.6204, 32.1480, 90.8037, -1, -1); // Windsor //
	AddStaticVehicle(506, 2095.9503, 2404.8014, 32.1104, 269.8510, -1, -1); // Super GT //
	AddStaticVehicle(575, 2096.2174, 2393.0474, 49.2698, 271.0294, -1, -1); // Broadway //
	AddStaticVehicle(426, 2104.1116, 2393.1881, 49.3283, 89.5035, -1, -1); // Premier //
	AddStaticVehicle(562, 2104.3127, 2422.5337, 49.2339, 89.2714, -1, -1); // Elegy //
	AddStaticVehicle(533, 2086.5569, 2393.1446, 10.6678, 89.9479, -1, -1); // Feltzer //
	AddStaticVehicle(527, 2086.4004, 2419.5818, 45.0695, 90.7302, -1, -1); // Cadrona //
	AddStaticVehicle(521, 2096.6207, 2395.9727, 44.8388, 270.9838, -1, -1); // FCR-900 //
	AddStaticVehicle(545, 2104.2054, 2401.9694, 45.0796, 88.8712, -1, -1); // Hustler //
	AddStaticVehicle(555, 2086.4291, 2413.7488, 27.8511, 90.4758, -1, -1); // Windsor //
	AddStaticVehicle(415, 2096.1590, 2401.9746, 27.9017, 269.9733, -1, -1); // Cheetah //
	AddStaticVehicle(429, 2104.2286, 2393.0170, 27.7581, 90.4976, -1, -1); // Banshee //

	// LV The Visage car park
	AddStaticVehicle(422, 1946.0310, 1784.1522, 18.9050, 181.6606, -1, -1); // Bobcat //
	AddStaticVehicle(603, 1942.4547, 1761.1122, 18.7838, 178.5624, -1, -1); // Phoenix //
	AddStaticVehicle(540, 1980.4889, 1751.3723, 18.8534, 359.9248, -1, -1); // Vincent //
	AddStaticVehicle(541, 1924.4543, 1760.7534, 12.4366, 359.1755, -1, -1); // Bullet //
	AddStaticVehicle(527, 2009.0461, 1728.2440, 12.5450, 178.9632, -1, -1); // Cadrona //
	AddStaticVehicle(426, 1901.8239, 1933.6278, 7.3501, 178.8678, -1, -1); // Premier //
	AddStaticVehicle(402, 1920.3865, 1816.7698, 12.6180, 0.0989, -1, -1); // Buffalo //
	AddStaticVehicle(565, 1891.1176, 1784.6983, 12.4281, 0.1887, -1, -1); // Flash //
	AddStaticVehicle(401, 2001.3608, 1751.2606, 12.5598, 358.7807, -1, -1); // Bravura //
	AddStaticVehicle(426, 1893.6157, 1989.3456, 13.5403, 179.9139, -1, -1); // Premier //
	AddStaticVehicle(507, 1893.5359, 1966.4629, 13.6841, 358.7055, -1, -1); // Elegant //

	// LV Whitewood Estates stadium car park
	AddStaticVehicle(526, 1135.7368, 2231.6502, 16.5675, 270.9737, -1, -1); // Fortune //
	AddStaticVehicle(547, 1067.9912, 2185.1800, 16.5169, 90.1250, -1, -1); // Primo //
	AddStaticVehicle(477, 1092.8857, 2228.9591, 10.5670, 359.6069, -1, -1); // ZR-350 //
	AddStaticVehicle(576, 1068.0292, 2203.4828, 10.4812, 270.2127, -1, -1); // Tornado //
	AddStaticVehicle(527, 1096.1991, 2217.0981, 10.6216, 359.0215, -1, -1); // Cadrona //
	AddStaticVehicle(507, 1116.5314, 2194.4608, 10.7196, 179.1098, -1, -1); // Elegant //
	AddStaticVehicle(400, 1113.1899, 2171.6744, 10.9180, 178.5303, -1, -1); // Landstalker //

	// LV Blackfield Chapel parking
	AddStaticVehicle(600, 1412.8000, 708.1320, 10.6102, 0.0000, -1, -1); // Picador //
	AddStaticVehicle(496, 1412.8000, 746.4200, 10.5314, 0.0000, -1, -1); // Blista Compact //
	AddStaticVehicle(401, 1522.3300, 787.6960, 10.6770, 0.0000, -1, -1); // Bravura //

	// LV Caligula's Palace parking
	AddStaticVehicle(603, 2365.1001, 1658.9900, 10.6995, 90.0002, -1, -1); // Phoenix //

	// LV Come-A-Lot parking
	AddStaticVehicle(402, 2131.1299, 1025.7600, 10.6946, 269.9998, -1, -1); // Buffalo //
	AddStaticVehicle(405, 2154.3732, 987.6007, 10.8057, 179.3453, -1, -1); // Sentinel //
	AddStaticVehicle(589, 2160.8701, 1028.9100, 10.5284, 269.9998, -1, -1); // Club //

	// LV Creek parking
	AddStaticVehicle(445, 2815.2322, 2349.7470, 10.7525, 89.1828, -1, -1); // Admiral //
	AddStaticVehicle(547, 2827.1738, 2353.4622, 10.6184, 91.4047, -1, -1); // Primo //
	AddStaticVehicle(550, 2830.9870, 2027.1297, 10.7224, 180.3021, -1, -1); // Sunrise //
	AddStaticVehicle(579, 2841.1299, 2338.4700, 10.8049, 269.9998, -1, -1); // Huntley //
	AddStaticVehicle(551, 2853.0500, 2372.0200, 10.7196, 90.0002, -1, -1); // Merit //
	AddStaticVehicle(401, 2856.8090, 2309.4312, 10.6364, 1.2079, -1, -1); // Bravura //
	AddStaticVehicle(533, 2866.6332, 2330.8610, 10.6184, 271.1262, -1, -1); // Feltzer //
	AddStaticVehicle(561, 2878.7136, 2368.5534, 10.6837, 90.6192, -1, -1); // Stratum //
	AddStaticVehicle(600, 2890.9268, 2342.2485, 10.6102, 269.5242, -1, -1); // Picador //

	// LV Julius Thruway East parking
	AddStaticVehicle(436, 2661.9556, 2246.4920, 10.5247, 89.0980, -1, -1); // Previon //

	// LV Julius Thruway North parking
	AddStaticVehicle(551, 2366.1127, 2579.5961, 10.7184, 1.8502, -1, -1); // Merit //
	AddStaticVehicle(547, 2423.3621, 2570.0240, 10.6184, 346.4835, -1, -1); // Primo //
	AddStaticVehicle(421, 2447.5056, 2562.6846, 21.8164, 346.0430, -1, -1); // Washington //

	// LV Las Venturas parking
	AddStaticVehicle(587, 2511.0500, 934.9750, 10.5539, 360.0000, -1, -1); // Euros //

	// LV Las Venturas Airport parking
	AddStaticVehicle(586, 1685.8400, 1297.9399, 10.3839, 0.0000, -1, -1); // Wayfarer //

	// LV Old Venturas Strip parking
	AddStaticVehicle(589, 2588.2500, 2053.1201, 10.5284, 273.4524, -1, -1); // Club //
	AddStaticVehicle(560, 2605.3899, 2086.1299, 10.5771, 179.9999, -1, -1); // Sultan //

	// LV Pilgrim parking
	AddStaticVehicle(579, 2511.6932, 1671.4131, 10.8455, 270.8693, -1, -1); // Huntley //

	// LV Pilson Intersection parking
	AddStaticVehicle(445, 1329.4220, 2249.6668, 10.7525, 268.9616, -1, -1); // Admiral //
	AddStaticVehicle(445, 1357.7412, 2286.8494, 10.7525, 269.8155, -1, -1); // Admiral //

	// LV Redsands West parking
	AddStaticVehicle(413, 1385.8700, 2246.1699, 10.9219, 90.0002, -1, -1); // Pony //
	AddStaticVehicle(405, 1492.1100, 2291.3000, 10.7453, 0.0000, -1, -1); // Sentinel //
	AddStaticVehicle(482, 1499.1400, 2268.5500, 10.9219, 0.0000, -1, -1); // Burrito //
	AddStaticVehicle(554, 1537.7800, 2214.4199, 10.9168, 0.0000, -1, -1); // Yosemite //

	// LV Roca Escalante parking
	AddStaticVehicle(405, 2512.9586, 2355.2143, 10.7859, 270.9230, -1, -1); // Sentinel //
	AddStaticVehicle(428, 2530.4199, 2491.3799, 11.0228, 269.9998, -1, -1); // Securicar //
	AddStaticVehicle(477, 2530.4199, 2520.9800, 21.6217, 269.9998, -1, -1); // ZR-350 //
	AddStaticVehicle(400, 2564.7300, 2271.1201, 10.9180, 90.0002, -1, -1); // Landstalker //

	// LV The Clown's Pocket parking
	AddStaticVehicle(575, 2183.7202, 1879.2754, 10.5172, 0.2543, -1, -1); // Broadway //
	AddStaticVehicle(541, 2186.0230, 1786.9522, 10.5425, 182.4537, -1, -1); // Bullet //

	// LV The Emerald Isle parking
	AddStaticVehicle(565, 2015.6053, 2239.4922, 23.5984, 271.2441, -1, -1); // Flash //
	AddStaticVehicle(507, 2076.4500, 2468.6899, 10.7196, 180.0001, -1, -1); // Elegant //
	AddStaticVehicle(560, 2153.5500, 2490.7200, 10.5755, 269.9998, -1, -1); // Sultan //

	// LV The Pink Swan parking
	AddStaticVehicle(579, 1844.8600, 1161.5000, 10.8187, 90.0002, -1, -1); // Huntley //

	// LV Yellow Bell Golf Course parking
	AddStaticVehicle(457, 1421.7000, 2830.2300, 10.5166, 269.9998, -1, -1); // Caddy //

	// LV Rockshore West roadside
	AddStaticVehicle(461, 2266.1899, 649.3470, 10.9206, 0.0000, -1, -1); // PCJ-600 //
	AddStaticVehicle(496, 2441.9099, 654.8950, 10.8958, 269.9998, -1, -1); // Blista Compact //

	// LV Spinybed roadside
	AddStaticVehicle(499, 2146.5901, 2756.5901, 10.8713, 269.9998, -1, -1); // Benson //

	// LV The Strip roadside
	AddStaticVehicle(401, 2040.1500, 1351.4800, 10.4880, 180.0001, -1, -1); // Bravura //
	AddStaticVehicle(507, 2074.6499, 1135.5500, 10.5712, 0.0000, -1, -1); // Elegant //
	AddStaticVehicle(535, 2074.6499, 1660.0500, 10.4704, 0.0000, -1, -1); // Slamvan //
	AddStaticVehicle(545, 2119.9800, 1988.4600, 10.5327, 180.0001, -1, -1); // Hustler //
	AddStaticVehicle(506, 2119.9800, 2163.6799, 10.4620, 180.0001, -1, -1); // Super GT //

	// LV Blackfield Chapel
	AddStaticVehicle(442, 1491.0300, 727.1910, 10.7194, 90.0002, -1, -1); // Romero //

	// LV Creek
	AddStaticVehicle(510, 2822.3999, 2160.0100, 13.4922, 269.9998, -1, -1); // Mountain Bike //

	// LV LVA Freight Depot
	AddStaticVehicle(477, 1487.4800, 1017.8200, 10.5670, 0.0000, -1, -1); // ZR-350 //

	// LV Rockshore East
	AddStaticVehicle(486, 2711.8301, 822.5040, 10.9897, 0.0000, -1, -1); // Dozer //

	// LV Spinybed
	AddStaticVehicle(574, 2261.4299, 2770.6201, 10.6123, 90.0002, -1, -1); // Sweeper //
	AddStaticVehicle(443, 2399.9800, 2799.8899, 11.4281, 269.9998, -1, -1); // Packer //

	// Bone County parking
	AddStaticVehicle(478, 521.2230, 2372.1499, 30.3149, 143.9998, -1, -1); // Walton //

	// Easter Bay Chemicals parking
	AddStaticVehicle(440, -1030.1500, -643.4020, 32.2136, 89.7091, -1, -1); // Rumpo //
	AddStaticVehicle(498, -1003.9000, -641.6150, 32.0689, 89.7091, -1, -1); // Boxville //
	AddStaticVehicle(413, -982.7960, -663.7680, 32.1094, 270.4914, -1, -1); // Pony //

	// Fallen Tree parking
	AddStaticVehicle(482, -560.1540, -488.4590, 25.6250, 180.8160, -1, -1); // Burrito //
	AddStaticVehicle(459, -560.0550, -473.0050, 25.6149, 0.0000, -1, -1); // Berkley's RC Van //
	AddStaticVehicle(440, -519.4780, -472.1770, 25.7292, 180.5439, -1, -1); // Rumpo //
	AddStaticVehicle(456, -485.2610, -488.1870, 25.6250, 0.0000, -1, -1); // Yankee //

	// Flint County parking
	AddStaticVehicle(463, -572.3670, -1050.6300, 23.3847, 55.3339, -1, -1); // Freeway //
	AddStaticVehicle(463, -567.5980, -1045.0300, 23.5287, 237.5612, -1, -1); // Freeway //
	AddStaticVehicle(468, -36.6128, -2496.9900, 36.3728, 214.8772, -1, -1); // Sanchez //
	AddStaticVehicle(491, -17.8053, -2500.5000, 36.4971, 120.3767, -1, -1); // Virgo //

	// Montgomery parking
	AddStaticVehicle(478, 1396.7116, 395.4903, 19.7582, 67.4137, -1, -1); // Walton //

	// Regular Tom parking
	AddStaticVehicle(489, -301.0640, 1750.8000, 42.9047, 89.5000, -1, -1); // Rancher //

	// Angel Pine roadside
	AddStaticVehicle(463, -2217.2500, -2405.1201, 30.9531, 229.9999, -1, -1); // Freeway //
	AddStaticVehicle(419, -2099.0200, -2241.9500, 30.4737, 139.9999, -1, -1); // Esperanto //

	// Las Payasadas roadside
	AddStaticVehicle(482, -290.5010, 2721.3201, 62.4319, 180.0001, -1, -1); // Burrito //

	// Whetstone roadside
	AddStaticVehicle(478, -1220.2100, -2632.0500, 9.9911, 85.5002, -1, -1); // Walton //

	// 'The Big Ear'
	AddStaticVehicle(495, -346.6070, 1609.0601, 76.0030, 93.0002, -1, -1); // Sandking //

	// Angel Pine
	AddStaticVehicle(478, -1994.6200, -2382.6599, 30.6254, 341.0000, -1, -1); // Walton //

	// Back o Beyond
	AddStaticVehicle(510, -891.0140, -2634.8201, 96.8824, 308.9499, -1, -1); // Mountain Bike //
	AddStaticVehicle(478, -623.4540, -2409.9299, 29.7165, 0.0000, -1, -1); // Walton //

	// Beacon Hill
	AddStaticVehicle(605, -360.9830, -1046.1500, 59.2270, 0.0000, -1, -1); // Sadler //

	// Bone County
	AddStaticVehicle(588, 680.8410, 1831.3199, 5.1723, 9.5000, -1, -1); // Hotdog //

	// El Castillo del Diablo
	AddStaticVehicle(424, -17.4257, 2355.7400, 23.9795, 143.9998, -1, -1); // BF Injection //

	// Fallen Tree
	AddStaticVehicle(514, -605.4790, -492.1890, 26.1305, 0.0000, -1, -1); // Tanker //

	// Flint County
	AddStaticVehicle(531, -1144.3199, -1466.3300, 125.7017, 100.0000, -1, -1); // Tractor //
	AddStaticVehicle(604, -141.1320, -2516.5701, 30.7977, 120.3767, -1, -1); // Glendale //

	// Flint Intersection
	AddStaticVehicle(422, -73.2554, -1587.4800, 2.6176, 145.0001, -1, -1); // Bobcat //

	// Flint Range
	AddStaticVehicle(543, -371.9530, -1436.9100, 25.6259, 83.3568, -1, -1); // Sadler //

	// Fort Carson
	AddStaticVehicle(442, -304.2210, 1023.7800, 19.4929, 269.9998, -1, -1); // Romero //
	AddStaticVehicle(510, -263.3210, 1170.7900, 19.6492, 5.0000, -1, -1); // Mountain Bike //
	AddStaticVehicle(543, 70.7797, 1000.1900, 14.0363, 180.0001, -1, -1); // Sadler //

	// Las Payasadas
	AddStaticVehicle(586, -201.5940, 2595.9700, 62.2667, 51.0000, -1, -1); // Wayfarer //
	AddStaticVehicle(471, -158.2160, 2701.6001, 61.8244, 340.0000, -1, -1); // Quad //

	// Lil' Probe Inn
	AddStaticVehicle(604, -20.7622, 1341.1400, 9.0064, 299.9999, -1, -1); // Glendale //

	// Los Santos Inlet
	AddStaticVehicle(531, -287.4430, -2171.6799, 29.0313, 111.9611, -1, -1); // Tractor //

	// Red County
	AddStaticVehicle(468, -923.7040, -532.6830, 25.6853, 273.8088, -1, -1); // Sanchez //
	AddStaticVehicle(543, -414.3970, -443.0050, 17.8122, 206.4777, -1, -1); // Sadler //

	// Shady Creeks
	AddStaticVehicle(471, -1347.8500, -2268.3201, 36.3182, 327.0000, -1, -1); // Quad //
	AddStaticVehicle(605, -1305.1700, -2394.7400, 23.8503, 0.0000, -1, -1); // Sadler //

	// The Farm
	AddStaticVehicle(572, -1076.6000, -1207.1801, 128.9461, 177.4869, -1, -1); // Mower //

	// The Sherman Dam
	AddStaticVehicle(588, -907.4870, 1991.8700, 60.8609, 334.0000, -1, -1); // Hotdog //

	// Tierra Robada
	AddStaticVehicle(510, -1665.5500, 2557.8701, 84.8789, 281.0000, -1, -1); // Mountain Bike //
	AddStaticVehicle(605, -1432.0200, 2182.4900, 50.2047, 0.0000, -1, -1); // Sadler //
	AddStaticVehicle(468, -1055.0699, 1543.5100, 33.2541, 0.0000, -1, -1); // Sanchez //
	AddStaticVehicle(471, -938.2540, 1432.0400, 29.5725, 322.0000, -1, -1); // Quad //
	AddStaticVehicle(421, -680.5810, 948.1980, 12.0742, 37.0000, -1, -1); // Washington //
	AddStaticVehicle(471, -595.7800, 2709.1299, 71.8949, 180.4998, -1, -1); // Quad //

	// Whetstone
	AddStaticVehicle(525, -1915.4900, -1638.5900, 21.6897, 250.0001, -1, -1); // Tow Truck //
	AddStaticVehicle(481, -1862.4000, -1561.8400, 21.3084, 87.0002, -1, -1); // BMX //
	AddStaticVehicle(604, -1826.4399, -1638.6300, 21.5845, 59.4999, -1, -1); // Glendale //

	// Set the unique Vehlicle Plate for all vehicles possible.
	for (new i = 0; i < MAX_VEHICLES; i++)
	{
		SetVehicleNumberPlate(i, VEHICLE_PLATE);
	}
}

new gVehicleNames[][] = {
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Pereniel",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Mr Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster Truck",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"News Chopper",
	"Rancher",
	"FBI Rancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista Compact",
	"Police Maverick",
	"Boxville",
	"Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer",
	"Hotring Racer",
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropdust",
	"Stunt",
	"Tanker",
	"RoadTrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster Truck",
	"Monster Truck",
	"Uranus",
	"Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight",
	"Trailer",
	"Kart",
	"Mower",
	"Duneride",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"Newsvan",
	"Tug",
	"Trailer",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Trailer",
	"Trailer",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police Car (LSPD)",
	"Police Car (SFPD)",
	"Police Car (LVPD)",
	"Police Ranger",
	"Picador",
	"S.W.A.T. Van",
	"Alpha",
	"Phoenix",
	"Glendale",
	"Sadler",
	"Luggage Trailer",
	"Luggage Trailer",
	"Stair Trailer",
	"Boxville",
	"Farm Plow",
	"Utility Trailer"
};

new const VEHICLE_MODEL_ID_START = 400;
new const VEHICLE_MODEL_ID_END = 611;

stock GetVehicleNameByID(vehicleid, str[], size = sizeof(str))
{
	if (!IsValidVehicle(vehicleid))
	{
		return 0;
	}

	new
		modelid = GetVehicleModel(vehicleid);

	format(str, size, "%s", gVehicleNames[modelid - VEHICLE_MODEL_ID_START]);

	return 1;
}

stock GetVehicleNameByModel(modelid, str[], size = sizeof(str))
{
	if (modelid < VEHICLE_MODEL_ID_START || modelid > VEHICLE_MODEL_ID_END)
	{
		return 0;
	}

	format(str, size, "%s", gVehicleNames[modelid - VEHICLE_MODEL_ID_START]);

	return 1;
}
