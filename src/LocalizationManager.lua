require "src/base/Inheritance"
require "json"

LocalizationManager =  inheritsFrom(nil)
LocalizationManager.mCurrentLang = nil;
LocalizationManager.RUSSIAN_LANG = 7;
LocalizationManager.ENGLISH_LANG = 0;
LocalizationManager.mStrings = nil;

---------------------------------
function LocalizationManager:init()
	self.mStrings = {}

	local lang = cc.Application:getInstance():getCurrentLanguage();
	info_log("LocalizationManager:init lang ", lang);

	self.mCurrentLang = lang;
	local curr = CCUserDefault:getInstance():getIntegerForKey("Language", -1);
	if curr ~= -1 then
		self.mCurrentLang = curr;
	end
	self:setCurrentLanguage(self.mCurrentLang);

	local fileName = nil

	self:loadStrings(LocalizationManager.RUSSIAN_LANG, "localization/ru.json");
	self:loadStrings(LocalizationManager.ENGLISH_LANG, "localization/en.json");
end

---------------------------------
function LocalizationManager:loadStrings(lang, fileName)
	local file_utils = cc.FileUtils:getInstance();
	local string = file_utils:getStringFromFile(fileName);
	--info_log("LocalizationManager:init string ", string);
	if string then
		local parseTable = json.decode(string,1)
		self.mStrings[lang] = parseTable;
	end

end

---------------------------------
function LocalizationManager:getStringForKey(key)
	return self.mStrings[self.mCurrentLang][key]
end

---------------------------------
function LocalizationManager:setCurrentLanguage(lang)
	self.mCurrentLang = lang;
	CCUserDefault:getInstance():setIntegerForKey("Language", self.mCurrentLang);
end

---------------------------------
function LocalizationManager:getCurrentLanguage()
	return self.mCurrentLang;
end