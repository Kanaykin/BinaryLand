local map = {0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,3,1,0,0,0,0,1,2,0,1,0,0,1,0,2,2,0,1,0,0,1,0,0,1,0,0,0,0,1,0,3,1,0,0,1,0,0,0,1,1,1,0,1,1,0,1,0,1,3,0,1,0,0,1,0,0,1,3,0,0,0,1,0,0,1,0,0,1,0,0,0,0,1,0,0,1,0,2,1,0,0,0,0,1,0,0,1,0,0,1,0,0,5,0,1,0,0,8,0,1,1,0,6}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["8_10_107"] = {
CanSearch=false},
["4_9_106"] = {
CanAttack=true,
dog_id='5_7_107'},
["11_9_106"] = {
CanAttack=true,
dog_id='8_10_107'},
["1_8_106"] = {
CanAttack=true,
dog_id='1_5_107'},
["5_7_107"] = {
CanSearch=false},
["1_5_107"] = {
CanSearch=false},
["10_5_107"] = {
CanSearch=false},
["8_3_106"] = {
CanAttack=true,
dog_id='10_5_107'},
["1_1_109"] = {
InTrap=false},
["11_1_108"] = {
InTrap=false}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}