local map = {1,4,4,4,8,4,4,1,11,0,2,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,3,1,0,0,3,1,1,0,1,1,1,2,0,0,1,1,0,1,17,1,0,0,1,1,1,0,1,17,1,17,17,0,1,1,0,1,17,1,17,17,0,14,1,0,16,5,16,0,6,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["9_9_111"] = {
Count=20},
["2_8_106"] = {
CanAttack=true,
dog_id='4_6_107'},
["4_6_107"] = {
CanSearch=false},
["8_6_107"] = {
CanSearch=false},
["6_5_106"] = {
CanAttack=false,
dog_id='8_6_107'},
["9_2_112"] = {
BonusFile=''},
["3_1_116"] = {
DestPoint='2,1'},
["4_1_109"] = {
InTrap=false},
["5_1_116"] = {
DestPoint='1,1'},
["7_1_108"] = {
InTrap=false}}
return{ m = map,w=9,h=9,levelParams=level,CustomProperties=CustomProperties}