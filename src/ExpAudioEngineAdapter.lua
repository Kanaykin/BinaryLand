require "src/base/Inheritance"

ExpAudioEngineAdapter =  inheritsFrom(nil)

---------------------------------
function ExpAudioEngineAdapter:init()
	cc.SimpleAudioEngine:getInstance();
end

---------------------------------
function ExpAudioEngineAdapter:playEffect(filePath, loop)
	ccexp.AudioEngine:play2d(filePath, loop);
end

---------------------------------
function ExpAudioEngineAdapter:stopEffect(soundId)
	--cc.SimpleAudioEngine:getInstance():stopEffect(soundId);
end

---------------------------------
function ExpAudioEngineAdapter:playMusic(filePath, loop)
	ccexp.AudioEngine:play2d(filePath, loop);
end

---------------------------------
function ExpAudioEngineAdapter:stopMusic(releaseData)
	-- cc.SimpleAudioEngine:getInstance():stopMusic(releaseData);
end

---------------------------------
function ExpAudioEngineAdapter:setEffectsVolume(value)
	-- cc.SimpleAudioEngine:getInstance():setEffectsVolume(value);
end

---------------------------------
function ExpAudioEngineAdapter:setMusicVolume(value)
	-- cc.SimpleAudioEngine:getInstance():setMusicVolume(value);
end
