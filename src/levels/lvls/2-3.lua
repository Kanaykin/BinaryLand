local map = {1,1,1,1,1,1,1,1,1,1,7,0,0,0,5,1,6,1,1,0,1,0,1,7,1,0,1,1,0,0,0,1,1,1,0,1,1,1,1,0,0,0,0,0,1,1,1,16,7,0,0,0,0,1,1,0,0,1,1,0,1,0,1,1,0,0,8,0,0,0,0,1,1,1,1,1,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_8_110"] = {
Count=10},
["6_8_109"] = {
InTrap=false},
["8_8_108"] = {
InTrap=false},
["6_7_110"] = {
Count=10},
["3_4_116"] = {
DestPoint='8,4'},
["4_4_110"] = {
Count=10}}
return{ m = map,w=9,h=9,levelParams=level,CustomProperties=CustomProperties}