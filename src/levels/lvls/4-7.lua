local map = {1,1,1,1,1,1,1,1,1,1,1,0,5,0,1,18,8,0,2,1,6,0,0,0,0,1,18,1,0,0,1,16,0,0,13,0,1,18,1,1,0,13,0,1,16,0,0,0,18,1,0,0,0,0,0,0,0,1,0,0,1,2,0,0,0,1,0,13,1,1,0,1,0,0,0,0,0,0,0,0,13,0,13,0,1,0,0,1,0,0,0,7,1,0,0,1,16,0,12,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_10_109"] = {
InTrap=false},
["8_10_106"] = {
CanAttack=true},
["10_10_108"] = {
InTrap=false},
["10_9_116"] = {
DestPoint='10,3'},
["1_7_116"] = {
DestPoint='4,7'},
["7_6_106"] = {
CanAttack=true},
["4_3_110"] = {
Count=10},
["9_3_116"] = {
DestPoint='9,7'},
["11_3_113"] = {
ChestType=0,
Count=10}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}