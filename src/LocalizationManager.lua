require "src/base/Inheritance"
require "json"

LocalizationManager =  inheritsFrom(nil)
LocalizationManager.mCurrentLang = nil;
LocalizationManager.RUSSIAN_LANG = 7;
LocalizationManager.ENGLISH_LANG = 0;
LocalizationManager.mStrings = nil;
LocalizationManager.mLabelKeys = nil;

---------------------------------
function LocalizationManager:init()
	self.mStrings = {};
	self.mLabelKeys = {};

	local lang = cc.Application:getInstance():getCurrentLanguage();
	info_log("LocalizationManager:init lang ", lang);

	self.mCurrentLang = lang;
	local curr = CCUserDefault:getInstance():getIntegerForKey("Language", -1);
	if curr ~= -1 then
		self.mCurrentLang = curr;
	else
		local statistic = extend.Statistic:getInstance();
		statistic:sendEvent("Game", "Language", lang == LocalizationManager.RUSSIAN_LANG and "rus" or "usa", -1);
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
function LocalizationManager:cacheKey(label, key)
	self.mLabelKeys[label] = key;
end

-------------------------------------------------
function LocalizationManager:updateLabels(node)
	local children = node:getChildren();
	debug_log("LocalizationManager:updateAllLabels children ", children);
	for i, child in ipairs(children) do
		self:updateLabels(child);
		local Type = tolua.type(child);
		if Type == "cc.Label" then
			local key = self.mLabelKeys[child];
			if key then
				debug_log("LocalizationManager:updateAllLabels key ", key);
				local label = tolua.cast(child, "cc.Label");
				local text = self:getStringForKey(key);
			    label:setString(text);
			end
		-- if tolua.inherit(child, "cc.Label") then
		-- 	debug_log("ChooseLangButton:updateLabels tolua.inherit ");
		-- end
		end
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