local map = {0,0,8,0,0,0,0,0,0,0,0,0,14,0,18,17,0,15,12,0,18,17,0,12,13,0,18,17,0,0,0,0,5,6,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["1_4_112"] = {
BonusFile=require "src/levels/bonus"},
["6_4_112"] = {
BonusFile=require "src/levels/bonus"},
["1_3_113"] = {
ChestType=1,
Count=40},
["6_3_113"] = {
ChestType=0,
Count=20},
["3_1_109"] = {
InTrap=true},
["4_1_108"] = {
InTrap=false}}
return{ m = map,w=6,h=6,levelParams=level,CustomProperties=CustomProperties}