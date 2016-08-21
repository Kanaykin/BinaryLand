local map = {0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,16,0,0,0,1,0,0,17,17,17,0,0,0,0,0,17,17,17,0,0,0,8,0,17,17,17,0,0,0,1,1,1,0,1,0,0,0,1,0,0,0,1,0,0,0,1,17,17,0,1,0,0,0,1,17,17,0,1,0,0,1,1,5,1,1,1,0,1,0,1,1,1,6,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["5_10_116"] = {
DestPoint='5,3'},
["3_2_109"] = {
InTrap=false},
["5_1_108"] = {
InTrap=false}}
return{ m = map,w=8,h=12,levelParams=level,CustomProperties=CustomProperties}