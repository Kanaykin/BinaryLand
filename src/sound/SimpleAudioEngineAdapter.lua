require "src/base/Inheritance"

SimpleAudioEngineAdapter =  inheritsFrom(nil)

---------------------------------
function SimpleAudioEngineAdapter:init()
end

---------------------------------
function SimpleAudioEngineAdapter:playEffect(filePath, loop)
	return cc.SimpleAudioEngine:getInstance():playEffect(filePath, loop);
end

---------------------------------
function SimpleAudioEngineAdapter:stopEffect(soundId)
	cc.SimpleAudioEngine:getInstance():stopEffect(soundId);
end

---------------------------------
function SimpleAudioEngineAdapter:playMusic(filePath, loop)
	return cc.SimpleAudioEngine:getInstance():playMusic(filePath, loop);
end

---------------------------------
function SimpleAudioEngineAdapter:stopMusic(releaseData)
	cc.SimpleAudioEngine:getInstance():stopMusic(releaseData);
end

---------------------------------
function SimpleAudioEngineAdapter:setEffectsVolume(value)
	cc.SimpleAudioEngine:getInstance():setEffectsVolume(value);
end

---------------------------------
function SimpleAudioEngineAdapter:getEffectsVolume()
	return cc.SimpleAudioEngine:getInstance():getEffectsVolume();
end

---------------------------------
function SimpleAudioEngineAdapter:setMusicVolume(value)
	cc.SimpleAudioEngine:getInstance():setMusicVolume(value);
end
