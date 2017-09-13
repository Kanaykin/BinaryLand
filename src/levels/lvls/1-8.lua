local map = {0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,1,0,8,7,1,1,12,0,0,1,0,1,0,1,1,1,1,1,1,0,1,0,1,0,0,0,0,0,13,1,13,1,0,1,0,1,1,1,1,0,1,0,1,0,1,2,0,0,7,1,0,0,0,1,0,1,13,1,1,1,1,1,13,0,1,0,1,13,1,7,0,1,1,0,1,1,0,1,5,1,6,0,0,0,0,7,1,0,1,1,1,1,1,1,1,1,1,1,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["4_9_110"] = {
Count=10},
["7_9_113"] = {
ChestType=0,
Count=10},
["2_5_106"] = {
CanAttack=true},
["5_5_110"] = {
Count=10},
["4_3_110"] = {
Count=10},
["2_2_109"] = {
InTrap=false},
["4_2_108"] = {
InTrap=false},
["9_2_110"] = {
Count=10}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}