local map = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,13,0,1,5,1,6,1,0,0,0,1,1,0,1,0,1,0,1,0,0,0,1,0,1,1,0,1,0,1,0,1,1,1,1,1,0,1,1,0,1,0,1,3,0,3,1,1,16,0,1,1,0,1,0,1,1,13,1,1,0,0,2,1,1,0,1,0,0,0,0,2,1,7,0,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,7,0,0,0,0,8,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["6_10_109"] = {
InTrap=false},
["8_10_108"] = {
InTrap=false},
["6_7_107"] = {
CanSearch=false},
["8_7_107"] = {
CanSearch=false},
["11_7_116"] = {
DestPoint='11,3'},
["12_6_106"] = {
CanAttack=false,
dog_id='8_7_107'},
["8_5_106"] = {
CanAttack=false,
dog_id='6_7_107'},
["10_5_110"] = {
Count=10},
["2_3_110"] = {
Count=10}}
return{ m = map,w=13,h=11,levelParams=level,CustomProperties=CustomProperties}