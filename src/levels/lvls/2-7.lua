local map = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,5,1,6,0,0,0,0,1,1,0,1,0,0,0,1,1,1,1,3,0,1,1,13,1,1,1,1,1,11,0,1,1,0,1,1,0,0,0,0,0,1,0,0,1,2,0,1,1,1,1,2,1,0,13,1,0,0,0,0,1,1,0,1,0,1,0,8,0,1,1,1,0,1,1,7,1,0,1,0,0,2,0,7,1,0,1,1,0,1,0,1,1,1,0,1,1,1,16,1,1,0,0,2,0,0,1,0,0,3,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["6_11_109"] = {
InTrap=false},
["8_11_108"] = {
InTrap=false},
["11_10_107"] = {
CanSearch=false},
["8_9_111"] = {
Count=45},
["11_8_106"] = {
CanAttack=false,
dog_id='11_10_107'},
["4_7_106"] = {
CanAttack=false,
dog_id='10_3_107'},
["2_5_110"] = {
Count=10},
["8_5_106"] = {
CanAttack=false},
["10_5_110"] = {
Count=10},
["12_4_116"] = {
DestPoint='12,11'},
["4_3_106"] = {
CanAttack=false},
["10_3_107"] = {
CanSearch=false}}
return{ m = map,w=13,h=12,levelParams=level,CustomProperties=CustomProperties}