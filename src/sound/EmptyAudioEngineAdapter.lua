require "src/base/Inheritance"

EmptyAudioEngineAdapter =  inheritsFrom(nil)

---------------------------------
function EmptyAudioEngineAdapter:init()
	
end

---------------------------------
function EmptyAudioEngineAdapter:playEffect(filePath, loop)
	
end

---------------------------------
function EmptyAudioEngineAdapter:stopEffect(soundId)
	
end

---------------------------------
function EmptyAudioEngineAdapter:playMusic(filePath, loop)
	
end

---------------------------------
function EmptyAudioEngineAdapter:stopMusic(releaseData)
	
end

---------------------------------
function EmptyAudioEngineAdapter:setEffectsVolume(value)
	
end

---------------------------------
function EmptyAudioEngineAdapter:setMusicVolume(value)
	
end
