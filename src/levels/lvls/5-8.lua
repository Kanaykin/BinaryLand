local map = {1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1,18,8,18,1,0,1,16,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,16,1,0,1,0,1,0,1,0,1,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,1,1,1,16,1,0,1,1,1,7,0,1,0,1,0,0,0,0,0,0,0,5,16,6,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["1_9_116"] = {
DestPoint='9,9'},
["9_7_116"] = {
DestPoint='1,7'},
["1_5_116"] = {
DestPoint='9,5'},
["9_4_116"] = {
DestPoint='1,4'},
["4_3_116"] = {
DestPoint='4,3'},
["1_2_110"] = {
Count=10},
["4_1_109"] = {
InTrap=false},
["5_1_116"] = {
DestPoint='5,1'},
["6_1_108"] = {
InTrap=false}}
return{ m = map,w=9,h=12,levelParams=level,CustomProperties=CustomProperties}