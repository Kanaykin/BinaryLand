local map = {1,1,1,1,1,1,1,1,1,1,0,5,1,1,6,0,0,1,1,0,0,0,1,0,0,16,1,1,0,1,1,1,1,1,0,1,1,0,1,0,8,16,0,0,1,1,16,1,0,1,0,1,0,1,1,0,1,0,1,0,0,0,1,1,0,0,0,1,0,0,16,1,1,1,1,1,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["3_8_109"] = {
InTrap=false},
["6_8_108"] = {
InTrap=false},
["8_7_116"] = {
DestPoint='6,7'},
["6_5_116"] = {
DestPoint='6,2'},
["2_4_116"] = {
DestPoint='2,8'},
["8_2_116"] = {
DestPoint='8,8'}}
return{ m = map,w=9,h=9,levelParams=level,CustomProperties=CustomProperties}