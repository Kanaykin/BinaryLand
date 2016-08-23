local map = {1,1,1,1,1,1,1,1,1,1,1,1,7,1,0,0,8,0,0,0,1,1,1,0,1,0,1,1,1,1,0,1,1,1,0,13,0,1,7,0,0,0,0,1,1,0,1,0,0,0,2,0,1,0,1,1,0,1,1,0,13,1,1,1,1,1,1,13,1,2,1,0,0,0,1,12,1,1,3,0,0,0,1,0,0,1,3,1,1,0,1,1,1,1,1,0,1,0,1,1,0,0,0,5,1,6,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_10_110"] = {
Count=10},
["6_8_110"] = {
Count=10},
["7_7_106"] = {
CanAttack=false,
dog_id='10_4_107'},
["4_5_106"] = {
CanAttack=false,
dog_id='2_4_107'},
["10_5_113"] = {
ChestType=0,
Count=10},
["2_4_107"] = {
CanSearch=false},
["10_4_107"] = {
CanSearch=false},
["5_2_109"] = {
InTrap=false},
["7_2_108"] = {
InTrap=false}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}