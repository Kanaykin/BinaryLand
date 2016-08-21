local map = {0,0,0,13,7,0,13,0,0,0,0,0,0,1,0,0,13,0,0,1,1,0,8,0,16,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,0,0,13,1,0,1,16,1,1,1,0,13,1,0,0,0,0,1,0,0,0,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["5_9_110"] = {
Count=10},
["7_7_116"] = {
DestPoint='1,1'},
["3_2_116"] = {
DestPoint='1,1'}}
return{ m = map,w=9,h=9,levelParams=level,CustomProperties=CustomProperties}