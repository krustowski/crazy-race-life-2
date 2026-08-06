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

	// Route 68 gas station
	//AddStaticVehicle(551, 905.0000, 55.0000, 74.2676, 0.0000, -1, -1); // Merit
	//AddStaticVehicle(422, 895.0000, 45.0000, 83.6456, 90.0000, -1, -1); // Bobcat

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
