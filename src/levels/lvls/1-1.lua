local map = {1,0,0,0,8,0,0,0,1,1,0,0,0,1,0,0,1,0,1,1,1,13,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,1,0,1,0,0,0,5,1,6,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["4_1_109"] = {
InTrap=false},
["6_1_108"] = {
InTrap=false}}
return{ m = map,w=9,h=6,levelParams=level,CustomProperties=CustomProperties}