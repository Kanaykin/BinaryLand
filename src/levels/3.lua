local map = {16,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,6,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["1_7_116"] = {
DestPoint='3,7'},
["4_1_109"] = {
InTrap=false},
["5_1_108"] = {
InTrap=false}}
return{ m = map,w=7,h=7,levelParams=level,CustomProperties=CustomProperties}