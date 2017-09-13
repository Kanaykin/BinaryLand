local map = {1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,8,0,0,0,2,1,1,1,1,1,13,1,1,1,0,1,1,1,0,0,0,0,1,0,0,0,0,1,1,0,1,13,1,1,13,1,1,0,1,1,0,1,0,12,1,0,1,0,0,1,1,3,0,1,1,1,0,0,0,1,1,1,1,0,0,5,1,6,1,7,1,1,1,1,1,1,1,1,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["10_8_106"] = {
CanAttack=false,
dog_id='2_3_107'},
["5_4_113"] = {
ChestType=0,
Count=10},
["2_3_107"] = {
CanSearch=false},
["5_2_109"] = {
InTrap=false},
["7_2_108"] = {
InTrap=false},
["9_2_110"] = {
Count=10}}
return{ m = map,w=11,h=9,levelParams=level,CustomProperties=CustomProperties}