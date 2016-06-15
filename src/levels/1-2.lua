local map = {1,1,1,1,1,1,1,1,1,1,1,0,0,8,0,0,1,1,1,1,1,0,1,0,0,0,1,1,7,1,0,1,1,1,0,1,1,0,1,0,1,7,1,0,1,1,0,0,5,1,6,0,0,1,1,1,1,1,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_4_110"] = {
Count=10},
["6_3_110"] = {
Count=10},
["4_2_109"] = {
InTrap=false},
["6_2_108"] = {
InTrap=false}}
return{ m = map,w=9,h=7,levelParams=level,CustomProperties=CustomProperties}