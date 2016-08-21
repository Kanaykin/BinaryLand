local map = {1,1,1,1,1,1,1,1,1,1,16,1,5,1,6,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,1,13,0,0,1,1,0,1,1,1,1,0,1,1,1,0,1,7,7,7,0,0,1,1,0,1,1,1,1,0,1,1,1,0,0,0,8,0,0,0,1,1,0,1,1,1,1,1,0,1,1,0,1,7,0,0,0,0,1,1,14,1,1,1,1,1,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_10_116"] = {
DestPoint='2,2'},
["4_10_109"] = {
InTrap=false},
["6_10_108"] = {
InTrap=false},
["4_6_110"] = {
Count=10},
["5_6_110"] = {
Count=10},
["6_6_110"] = {
Count=10},
["4_2_110"] = {
Count=10},
["2_1_112"] = {
BonusFile=''}}
return{ m = map,w=9,h=11,levelParams=level,CustomProperties=CustomProperties}