local map = {1,1,1,1,1,1,1,1,1,1,2,0,0,8,0,0,0,1,1,1,1,0,1,0,1,0,1,14,0,0,0,1,1,1,0,1,1,1,1,13,1,0,1,0,1,1,0,0,0,1,0,13,0,1,1,0,0,0,1,1,1,0,1,1,0,0,5,1,6,0,0,1,1,1,1,1,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_8_106"] = {
CanAttack=false},
["1_6_112"] = {
BonusFile=''},
["4_2_109"] = {
InTrap=false},
["6_2_108"] = {
InTrap=false}}
return{ m = map,w=9,h=9,levelParams=level,CustomProperties=CustomProperties}