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

	local fileName = nil

	if self.mCurrentLang == LocalizationManager.RUSSIAN_LANG then
		fileName = "localization/ru.json";
	else
		fileName = "localization/en.json";
	end
	local file_utils = cc.FileUtils:getInstance();
	local string = file_utils:getStringFromFile(fileName);
	info_log("LocalizationManager:init string ", string);
	if string then
		local parseTable = json.decode(string,1)
		self.mStrings[self.mCurrentLang] = parseTable;
	end
end

---------------------------------
function LocalizationManager:getStringForKey(key)
	return self.mStrings[self.mCurrentLang][key]
end
