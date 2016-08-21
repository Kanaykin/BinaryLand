local map = {0,1,1,1,1,1,1,1,1,1,1,0,1,7,1,0,0,8,0,0,2,1,0,1,0,1,12,0,1,1,1,3,1,0,1,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,1,0,1,1,1,0,1,0,0,0,0,1,0,0,0,1,0,1,1,16,1,1,1,1,1,13,1,0,1,0,0,0,5,1,6,0,0,1,0,1,1,1,1,1,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["3_8_110"] = {
Count=10},
["10_8_106"] = {
CanAttack=false,
dog_id='10_7_107'},
["5_7_113"] = {
ChestType=0,
Count=10},
["10_7_107"] = {
CanSearch=false},
["4_3_116"] = {
DestPoint='1,1'},
["6_2_109"] = {
InTrap=false},
["8_2_108"] = {
InTrap=false}}
return{ m = map,w=11,h=9,levelParams=level,CustomProperties=CustomProperties}