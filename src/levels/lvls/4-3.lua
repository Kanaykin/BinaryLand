local map = {1,1,1,1,1,1,1,1,1,1,1,1,7,0,0,0,8,16,16,16,16,1,1,18,18,18,18,1,0,0,0,0,1,1,18,18,18,18,1,0,0,0,0,1,1,1,1,0,1,1,0,0,0,0,1,1,18,18,18,18,1,0,0,0,0,1,1,18,18,18,18,1,1,0,1,1,1,1,18,18,18,18,1,18,0,18,18,1,1,18,18,18,18,1,18,18,0,18,1,1,0,0,0,5,1,6,0,0,0,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_9_110"] = {
Count=10},
["7_9_116"] = {
DestPoint='7,5'},
["8_9_116"] = {
DestPoint='8,4'},
["9_9_116"] = {
DestPoint='9,5'},
["10_9_116"] = {
DestPoint='10,5'},
["5_1_109"] = {
InTrap=false},
["7_1_108"] = {
InTrap=false}}
return{ m = map,w=11,h=10,levelParams=level,CustomProperties=CustomProperties}