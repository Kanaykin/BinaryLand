local map = {11,0,8,0,0,0,0,0,0,12,0,12,0,0,0,0,0,5,6,11}
local level = {
time = 120
}
local CustomProperties = {
["1_5_111"] = {
Count=40},
["2_3_113"] = {
ChestType=1,
Count=50},
["4_3_113"] = {
ChestType=0,
Count=106},
["4_1_111"] = {
Count=99}}
return{ m = map,w=4,h=5,levelParams=level,CustomProperties=CustomProperties}