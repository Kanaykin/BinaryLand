local map = {1,1,1,1,1,1,5,8,0,1,0,16,16,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,16,0,16,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,16,0,1,1,1,0,0,0,0,0,16,1,0,0,7,2,0,1,0,1,1,1,1,1,0,1,0,0,3,1,0,1,0,1,0,0,3,0,0,1,0,1,0,0,0,1,0,1,2,6,0,1,7,1,7}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["1_17_109"] = {
InTrap=false},
["6_17_116"] = {
DestPoint='6,13'},
["1_16_116"] = {
DestPoint='1,1'},
["5_13_116"] = {
DestPoint='5,17'},
["1_12_116"] = {
DestPoint='6,12'},
["6_10_116"] = {
DestPoint='1,10'},
["4_8_116"] = {
DestPoint='1,8'},
["2_7_110"] = {
Count=10},
["3_7_106"] = {
CanAttack=true,
dog_id='4_5_107'},
["4_5_107"] = {
CanSearch=true},
["6_4_107"] = {
CanSearch=true},
["6_2_106"] = {
CanAttack=true,
dog_id='6_4_107'},
["1_1_108"] = {
InTrap=false},
["4_1_110"] = {
Count=10},
["6_1_110"] = {
Count=10}}
return{ m = map,w=6,h=18,levelParams=level,CustomProperties=CustomProperties}