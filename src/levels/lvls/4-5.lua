local map = {1,1,1,1,1,1,1,1,1,1,1,18,18,18,13,8,0,18,0,1,1,18,18,18,16,1,1,0,0,1,1,18,18,18,1,16,0,0,0,1,1,18,18,18,16,1,0,0,0,1,1,18,18,18,1,16,0,0,0,1,1,18,18,18,16,1,0,1,0,1,1,18,18,18,1,16,0,0,0,1,1,18,18,18,16,1,0,1,0,1,1,1,1,18,1,6,0,0,0,1,1,13,13,13,5,1,1,1,0,1,1,7,13,13,1,12,0,0,7,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["5_10_116"] = {
DestPoint='2,10'},
["6_9_116"] = {
DestPoint='9,9'},
["5_8_116"] = {
DestPoint='2,8'},
["6_7_116"] = {
DestPoint='9,7'},
["5_6_116"] = {
DestPoint='2,6'},
["6_5_116"] = {
DestPoint='9,5'},
["5_4_116"] = {
DestPoint='2,4'},
["6_3_108"] = {
InTrap=false},
["5_2_109"] = {
InTrap=false},
["2_1_110"] = {
Count=10},
["6_1_113"] = {
ChestType=1,
Count=30},
["9_1_110"] = {
Count=10}}
return{ m = map,w=10,h=12,levelParams=level,CustomProperties=CustomProperties}