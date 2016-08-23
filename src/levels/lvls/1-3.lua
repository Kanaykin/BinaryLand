local map = {1,1,1,1,1,1,1,1,1,1,0,0,0,8,0,1,7,1,1,7,0,0,13,0,0,0,1,1,0,0,0,1,0,0,0,1,1,1,1,1,0,0,0,0,1,1,0,13,0,0,0,1,7,1,1,0,1,0,0,13,0,1,1,1,5,1,1,1,1,6,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["8_7_110"] = {
Count=10},
["2_6_110"] = {
Count=10},
["8_3_110"] = {
Count=10},
["2_1_109"] = {
InTrap=false},
["7_1_108"] = {
InTrap=false}}
return{ m = map,w=9,h=8,levelParams=level,CustomProperties=CustomProperties}