local map = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,17,0,17,0,0,17,17,17,17,17,17,0,0,17,0,17,1,1,1,1,0,1,1,1,7,1,17,0,17,1,1,17,17,17,17,17,17,1,1,17,0,17,0,1,1,1,0,1,1,1,0,0,17,1,17,0,8,0,17,17,17,17,17,0,0,17,0,17,1,1,1,0,0,0,0,0,0,0,17,0,17,0,1,17,17,17,17,17,17,1,0,17,0,17,0,1,0,0,0,1,1,1,0,0,17,0,17,1,1,17,17,17,17,17,17,1,1,17,0,17,0,1,1,1,1,0,0,0,0,0,17,1,17,0,1,17,17,17,17,17,17,1,0,17,0,17,5,1,6,0,0,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["1_10_110"] = {
Count=10},
["6_1_109"] = {
InTrap=false},
["8_1_108"] = {
InTrap=false}}
return{ m = map,w=13,h=15,levelParams=level,CustomProperties=CustomProperties}