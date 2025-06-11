import re

# The input array as a string
pawn_array = """
new Float: gRaceCoordsDesertAirCircuit[][E_RACE_COORD] =
{
	{369.64, 2502.15, 17.40},
	{-14.31, 2500.38, 48.37},
	{-416.20, 2460.88, 99.84},
	{-763.97, 2511.05, 148.77},
	{-1165.76, 2715.24, 108.65},
	{-1496.06, 2721.65, 135.44},
	{-1818.74, 2634.10, 130.46},
	{-1932.01, 2278.66, 130.03},
	{-1784.93, 2042.32, 130.40},
	{-1518.67, 1946.81, 136.81},
	// 11
	{-1148.50, 2143.69, 121.28},
	{-861.34, 2313.76, 178.20},
	{-591.26, 2500.01, 120.71},
	{-267.54, 2545.04, 78.56},
	{125.84, 2510.74, 35.65},
	{353.49, 2505.97, 17.40}
};
"""

# Target race_id
race_id = 5

# Updated regex to match negative and positive floats
coord_pattern = re.compile(r"\{\s*(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)\s*\}")

# Extract coordinates
coords = coord_pattern.findall(pawn_array)

# Start building SQL
sql = "INSERT INTO race_coords (race_id, seq_no, x, y, z, rot) VALUES\n"

# Append each row
values = []
for i, (x, y, z) in enumerate(coords):
    values.append(f"({race_id}, {i+1}, {x}, {y}, {z}, 0.0)")

# Join all values and finish the statement
sql += ",\n".join(values) + ";"

print(sql)

