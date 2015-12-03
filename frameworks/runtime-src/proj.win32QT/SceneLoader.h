#ifndef SCENE_LOADER_H
#define SCENE_LOADER_H

#include <string>
#include <map>
#include <vector>
#include <QtCore/QVariant>

struct lua_State;

class SceneLoader
{
public:
	class PropertyContainer
	{
	public:
		PropertyContainer(){}
		PropertyContainer(lua_State* state, const std::vector<std::string>& depth);

		bool getIntContainer(const std::string& key, std::map<int, int>& result);
		bool getContainerContainer(const std::string& key, std::map<std::string, SceneLoader::PropertyContainer>& result);
		bool getVariantContainer(std::map<std::string, QVariant>& result);
		int getIntProperty(const std::string& key);

		PropertyContainer getContainer(const std::string& key);
	protected:
		int pushDepth();
	private:
		lua_State* mState;
		std::vector<std::string>			mDepth;
	};
	SceneLoader();
	~SceneLoader();

	PropertyContainer getRootContainer();

	bool loadScene(const std::string& fileName);

private:
	lua_State* mState;
};

#endif