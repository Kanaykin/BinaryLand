local map = {0,16,13,0,0,0,0,0,0,0,16,0,0,1,0,0,0,0,0,0,13,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,16,1,0,0,0,0,1,0,1,1,0,7,1,0,0,13,0,1,1,1,1,1,1,1,0,0,0,0,1,16,0,0,0,0,0,0,0,0,0,1,0,0,0,8,0,0,13,0,13,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,5,1,6,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_11_116"] = {
DestPoint='2,1'},
["11_11_116"] = {
DestPoint='11,1'},
["8_8_116"] = {
DestPoint='1,1'},
["8_7_110"] = {
Count=10},
["4_5_116"] = {
DestPoint='1,1'},
["8_1_109"] = {
InTrap=false},
["10_1_108"] = {
InTrap=false}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}