local map = {1,1,1,1,1,1,1,1,1,1,1,1,18,18,18,18,18,8,0,0,0,0,1,18,18,18,18,18,1,1,1,1,1,1,18,18,18,18,18,1,0,0,0,2,1,18,18,18,18,18,16,0,0,0,0,1,18,18,13,18,5,1,0,1,1,0,1,1,1,1,1,1,1,0,0,0,0,1,7,13,0,0,0,1,16,0,0,0,16,0,0,0,0,0,0,0,0,0,0,1,12,13,0,0,0,1,6,0,0,0,1,1,1,1,1,1,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["11_8_106"] = {
CanAttack=true},
["7_7_116"] = {
DestPoint='11,7'},
["6_6_109"] = {
InTrap=false},
["2_4_110"] = {
Count=10},
["8_4_116"] = {
DestPoint='11,4'},
["1_3_116"] = {
DestPoint='11,3'},
["2_2_113"] = {
ChestType=0,
Count=10},
["8_2_108"] = {
InTrap=false}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}