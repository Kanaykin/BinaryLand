local map = {1,7,1,7,1,0,0,5,1,6,16,1,0,1,3,1,0,1,1,1,0,0,1,0,1,0,1,0,1,0,0,13,0,0,0,0,0,16,2,1,0,0,0,0,1,1,0,1,1,1,1,13,1,1,1,7,1,0,1,16,0,0,0,0,0,3,0,1,0,1,0,0,8,0,0,2,0,0,2,0,1,0,0,0,0,1,1,1,1,1,13,1,1,1,1,0,1,0,12,12,0,0,0,0,0,1,0,1,0,0,1,1,1,1,0,3,13,0,0,0,16}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_11_110"] = {
Count=10},
["4_11_110"] = {
Count=10},
["8_11_109"] = {
InTrap=false},
["10_11_108"] = {
InTrap=false},
["11_11_116"] = {
DestPoint='11,8'},
["4_10_107"] = {
CanSearch=false},
["5_8_116"] = {
DestPoint='1.8'},
["6_8_106"] = {
CanAttack=false,
dog_id='4_10_107'},
["1_6_110"] = {
Count=10},
["5_6_116"] = {
DestPoint='11,6'},
["11_6_107"] = {
CanSearch=true},
["10_5_106"] = {
CanAttack=false,
dog_id='11_6_107'},
["2_4_106"] = {
CanAttack=false,
dog_id='6_1_107'},
["11_3_113"] = {
ChestType=0,
Count=10},
["1_2_113"] = {
ChestType=0,
Count=10},
["6_1_107"] = {
CanSearch=false},
["11_1_116"] = {
DestPoint='8,1'}}
return{ m = map,w=11,h=11,levelParams=level,CustomProperties=CustomProperties}