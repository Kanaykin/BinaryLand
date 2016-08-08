local map = {0,11,0,8,0,0,11,3,2,1,0,1,0,1,0,1,1,1,0,1,1,1,0,1,7,3,0,6,5,7,0,2}
local level = {
time = 30
}
local CustomProperties = {
["2_4_110"] = {
Count=10},
["7_4_110"] = {
Count=10},
["8_4_107"] = {
CanSearch=false},
["1_3_106"] = {
CanAttack=false,
dog_id='2_1_107'},
["6_2_-1"] = {
Count=40},
["1_1_110"] = {
Count=10},
["2_1_107"] = {
CanSearch=false},
["6_1_110"] = {
Count=10},
["8_1_106"] = {
CanAttack=false,
dog_id='8_4_107'}}
return{ m = map,w=8,h=4,levelParams=level,CustomProperties=CustomProperties}