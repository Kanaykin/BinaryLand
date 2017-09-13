local map = {0,0,1,1,1,1,0,0,1,0,1,1,2,0,1,0,8,0,1,0,0,0,0,0,1,0,17,1,0,0,0,0,1,0,0,1,0,17,1,1,1,1,0,0,0,1,1,3,17,1,13,0,1,0,1,2,0,1,0,17,1,17,0,0,3,0,0,0,1,0,17,1,17,0,1,1,0,0,1,0,1,17,1,17,0,0,1,7,0,2,0,1,5,1,6,1,0,1,2}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_8_106"] = {
CanAttack=false,
dog_id='4_5_107'},
["4_5_107"] = {
CanSearch=false},
["1_4_106"] = {
CanAttack=false,
dog_id='10_4_107'},
["10_4_107"] = {
CanSearch=false},
["11_2_110"] = {
Count=10},
["2_1_106"] = {
CanAttack=false},
["5_1_109"] = {
InTrap=false},
["7_1_108"] = {
InTrap=false},
["11_1_106"] = {
CanAttack=false}}
return{ m = map,w=11,h=9,levelParams=level,CustomProperties=CustomProperties}