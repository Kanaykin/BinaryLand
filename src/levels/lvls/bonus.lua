local map = {7,7,7,7,6,7,7,7,1,1,1,7,15,7,7,7}
local level = {
time = 120
}
local CustomProperties = {
["1_4_110"] = {
Count=10},
["2_4_110"] = {
Count=10},
["3_4_110"] = {
Count=10},
["4_4_110"] = {
Count=10},
["1_3_108"] = {
InTrap=false},
["2_3_110"] = {
Count=10},
["3_3_110"] = {
Count=10},
["4_3_110"] = {
Count=10},
["4_2_110"] = {
Count=10},
["1_1_112"] = {
BonusFile=''},
["2_1_110"] = {
Count=10},
["3_1_110"] = {
Count=10},
["4_1_110"] = {
Count=10}}
return{ m = map,w=4,h=4,levelParams=level,CustomProperties=CustomProperties}