local map = {1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,8,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,7,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,13,0,0,0,0,0,0,1,1,0,1,1,1,1,1,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,5,1,1,6,0,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["1_7_110"] = {
Count=10},
["4_1_109"] = {
InTrap=false},
["7_1_108"] = {
InTrap=false}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}