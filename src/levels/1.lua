local map = {0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,17,0,0,0,0,0,0,17,0,0,0,0,0,0,17,0,17,17,4,0,0,0,0,0,0,0,0,0,5,6,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["3_1_109"] = {
InTrap=false},
["4_1_108"] = {
InTrap=false}}
return{ m = map,w=7,h=7,levelParams=level,CustomProperties=CustomProperties}