local map = {1,14,1,14,14,1,14,1,1,1,0,0,0,8,0,0,0,14,1,14,1,0,1,0,0,0,1,14,0,0,0,14,1,1,0,14,1,5,0,0,1,6,0,0,1,1,1,14,1,1,1,14,1,1}
local level = {
time = 120,
BonusLevel = ''
}
local CustomProperties = {
["2_6_112"] = {
BonusFile=''},
["4_6_112"] = {
BonusFile=''},
["5_6_112"] = {
BonusFile=''},
["7_6_112"] = {
BonusFile=''},
["9_5_112"] = {
BonusFile=''},
["2_4_112"] = {
BonusFile=''},
["1_3_112"] = {
BonusFile=''},
["5_3_112"] = {
BonusFile=''},
["9_3_112"] = {
BonusFile=''},
["2_2_109"] = {
InTrap=true},
["6_2_108"] = {
InTrap=false},
["3_1_112"] = {
BonusFile=''},
["7_1_112"] = {
BonusFile=''}}
return{ m = map,w=9,h=6,levelParams=level,CustomProperties=CustomProperties}