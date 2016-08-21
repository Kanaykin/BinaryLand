local map = {1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,1,0,0,0,0,1,0,8,0,1,17,0,0,0,1,0,1,0,0,17,0,1,0,0,1,1,1,1,17,1,0,17,0,0,13,7,0,17,0,1,17,1,0,1,0,0,17,0,1,17,1,0,1,1,1,17,1,1,7,1,5,1,6,0,0,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["6_4_110"] = {
Count=10},
["2_1_110"] = {
Count=10},
["4_1_109"] = {
InTrap=false},
["6_1_108"] = {
InTrap=false}}
return{ m = map,w=9,h=9,levelParams=level,CustomProperties=CustomProperties}