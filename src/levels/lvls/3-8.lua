local map = {0,1,0,0,0,0,0,1,0,0,0,0,5,0,1,1,0,1,7,1,1,1,1,0,0,0,0,1,0,0,1,1,1,0,7,1,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,13,0,1,1,1,0,0,1,0,0,0,2,0,1,0,1,0,0,0,1,1,1,1,1,1,0,0,0,1,0,0,0,0,6,8,0,0,1,0,2,0,1,1,1,1,0,13,0,0,0,1,13,0,0,1,0,0,0,0,0,0,0,16,1,1,0,0,1,13,0,0,13,0,13,1,1,1,0,0,0,1,0,0,0,0,16,0,0,0,13,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0,1,1,1,1,1,0,0,0,0,12,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["13_13_109"] = {
InTrap=false},
["6_12_110"] = {
Count=10},
["9_11_110"] = {
Count=10},
["11_9_106"] = {
CanAttack=false},
["7_7_108"] = {
InTrap=false},
["13_7_106"] = {
CanAttack=false},
["10_5_116"] = {
DestPoint='3,5'},
["7_3_116"] = {
DestPoint='3,3'},
["11_1_113"] = {
ChestType=1,
Count=40}}
return{ m = map,w=13,h=13,levelParams=level,CustomProperties=CustomProperties}