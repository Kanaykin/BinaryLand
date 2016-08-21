local map = {1,1,1,1,1,1,1,1,5,0,1,0,6,1,1,16,0,1,0,0,1,1,0,0,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,0,1,1,1,0,0,1,0,0,1,1,0,0,8,16,16,1,1,14,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_8_109"] = {
InTrap=false},
["6_8_108"] = {
InTrap=false},
["2_7_116"] = {
DestPoint='2,2'},
["5_2_116"] = {
DestPoint='5,8'},
["6_2_116"] = {
DestPoint='2,2'},
["2_1_112"] = {
BonusFile=''}}
return{ m = map,w=7,h=9,levelParams=level,CustomProperties=CustomProperties}