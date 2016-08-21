local map = {0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,13,1,0,1,1,0,0,0,0,1,13,0,1,13,0,1,1,0,0,0,1,1,0,0,0,0,0,16,1,0,2,1,0,0,0,0,0,16,0,1,0,0,0,0,0,0,0,16,1,0,1,2,0,1,13,1,13,0,1,7,0,1,0,0,1,0,1,0,0,1,1,1,0,0,3,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,5,1,6,0,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["8_7_116"] = {
DestPoint='3,7'},
["11_7_106"] = {
CanAttack=false,
dog_id='11_3_107'},
["7_6_116"] = {
DestPoint='2,6'},
["6_5_116"] = {
DestPoint='1,5'},
["10_5_106"] = {
CanAttack=false},
["7_4_110"] = {
Count=10},
["11_3_107"] = {
CanSearch=true},
["5_1_109"] = {
InTrap=false},
["7_1_108"] = {
InTrap=false}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}