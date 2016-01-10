require "src/game_objects/BaseObject"

BushObject = inheritsFrom(BaseObject)
BushObject.mAnimation = nil

--------------------------------
function BushObject:init(field, node)
	BushObject:superClass().init(self, field, node);
	if tolua.type(self.mNode) == "cc.Sprite" then
		--self.mNode:setVisible(false);
		local textureName = tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName();
		
		local textureEmpty = cc.Director:getInstance():getTextureCache():getFileNameForTexture(tolua.cast(self.mNode, "cc.Sprite"):getTexture());
		local _, file = string.match(textureEmpty, '(.+)/(.+)%..+');
		local animationName = file .. "Animation.plist"
		debug_log("BushObject:init animationName ", animationName);

		local array = cc.FileUtils:getInstance():getValueMapFromFile(animationName);
		if array["frames"] then
			debug_log("BushObject:init array ", array["frames"]);
			local animation = PlistAnimation:create();
			animation:init(animationName, self.mNode, self.mNode:getAnchorPoint(), nil, 0.2);

			local repeatAnimation = RepeatAnimation:create();
			--repeatAnimation:init(delayAnim, true);
			repeatAnimation:init(animation, false);
			
			local delayAnim = DelayAnimation:create();
    		local texture = tolua.cast(self.mNode, "cc.Sprite"):getTexture();
    		local contentSize = texture:getContentSize();
    		delayAnim:init(repeatAnimation, math.random(0, 5000)/1000, texture, contentSize, textureName);

			self.mAnimation = delayAnim;
			self.mAnimation:play();
		end

		--debug_log("!!!! ", cc.Director:getInstance():getTextureCache():getCachedTextureInfo() )

		--info_log("BushObject Texture ", tolua.cast(self.mNode, "cc.Sprite"):getSpriteFrame():getTextureFilename());
	end
end

--------------------------------
function BushObject:tick(dt)
	--debug_log("BushObject:tick ", self.mAnimation);

	BushObject:superClass().tick(self, dt);
	if self.mAnimation then
		self.mAnimation:tick(dt);
	end
end