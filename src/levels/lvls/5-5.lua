local map = {1,1,1,1,1,1,1,1,1,1,1,0,1,0,12,1,0,0,0,0,0,0,0,1,0,1,1,0,16,0,0,1,0,0,1,0,0,0,0,0,16,0,1,0,0,1,1,0,0,16,0,0,16,1,0,0,1,0,0,16,0,0,0,0,1,0,0,1,0,0,0,0,0,0,16,1,0,0,1,16,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,1,0,1,0,0,1,16,16,0,1,0,0,0,1,0,0,0,0,0,0,1,0,8,0,1,0}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["4_10_113"] = {
ChestType=0,
Count=10},
["7_9_116"] = {
DestPoint='1,1'},
["8_8_116"] = {
DestPoint='1,1'},
["6_7_116"] = {
DestPoint='1,1'},
["9_7_116"] = {
DestPoint='1,1'},
["5_6_116"] = {
DestPoint='1,1'},
["9_5_116"] = {
DestPoint='3,5'},
["3_4_116"] = {
DestPoint='9,4'},
["3_2_116"] = {
DestPoint='1,1'},
["4_2_116"] = {
DestPoint='1,1'}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}