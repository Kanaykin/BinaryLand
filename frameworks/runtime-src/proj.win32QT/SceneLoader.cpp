#include "SceneLoader.h"
#include "CCLuaEngine.h"
#include <QtCore/QTextStream>
#include <QtCore/QFile>
#include <QtCore/QFileInfo>
#include <QtCore/QTextStream>

USING_NS_CC;

//----------------------------------------------
SceneLoader::PropertyContainer::PropertyContainer(lua_State* state, const std::vector<std::string>& depth) :
mState(state),
mDepth(depth)
{
}

//----------------------------------------------
SceneLoader::SceneLoader():
mState(0)
{
}

//----------------------------------------------
SceneLoader::~SceneLoader()
{
}

int getfield(lua_State* L, const char *key) {
	int result;
	lua_pushstring(L, key);
	lua_gettable(L, -2);  /* get background[key] */
	//if (!lua_isnumber(L, -1))
	//	error(L, "invalid component in background color");
	result = (int)lua_tonumber(L, -1);
	lua_pop(L, 1);  /* remove number */
	return result;
}

//----------------------------------------------
SceneLoader::PropertyContainer SceneLoader::getRootContainer()
{
	std::vector<std::string> empty;
	PropertyContainer container(mState, empty);
	return container;
}

//----------------------------------------------
int SceneLoader::PropertyContainer::getIntProperty(const std::string& key)
{
	lua_getglobal(mState, "G_Scene");
	if (!lua_istable(mState, -1))
	{
		return 0;
	}
	const int depth = pushDepth();
	int result = getfield(mState, key.c_str());;
	lua_pop(mState, depth);
	return result;
}

//----------------------------------------------
SceneLoader::PropertyContainer SceneLoader::PropertyContainer::getContainer(const std::string& key)
{
	std::vector<std::string> empty(mDepth);
	empty.push_back(key);
	PropertyContainer container(mState, empty);
	return container;
}

//----------------------------------------------
int SceneLoader::PropertyContainer::pushDepth()
{
	int depth = 0;
	for (std::vector<std::string>::const_iterator citer = mDepth.begin(); citer != mDepth.end(); ++citer){
		lua_pushstring(mState, (*citer).c_str());
		lua_gettable(mState, -2);
		if (!lua_istable(mState, -1)){
			lua_pop(mState, 1);
			return depth;
		}
		depth++;
	}
	return depth;
}

//----------------------------------------------
bool SceneLoader::PropertyContainer::getContainerContainer(const std::string& key, std::map<std::string, SceneLoader::PropertyContainer>& result)
{
	lua_getglobal(mState, "G_Scene");
	if (!lua_istable(mState, -1))
	{
		return false;
	}
	const int depth = pushDepth();

	lua_pushstring(mState, key.c_str());
	lua_gettable(mState, -2);
	if (!lua_istable(mState, -1)){
		lua_pop(mState, 1);
		return false;
	}

	lua_pushnil(mState);
	while (lua_next(mState, -2) != 0) {
		//if (lua_isstring(mState, -1)) {
			size_t len(0);
			const char* str = lua_tolstring(mState, -2, &len);
			std::vector<std::string> empty(mDepth);
			empty.push_back(key);
			empty.push_back(str);
			PropertyContainer val(mState, empty);
			result[str] = val;
		//}
		lua_pop(mState, 1);
	}

	lua_pop(mState, 1);
	lua_pop(mState, depth);
	return true;
}

//----------------------------------------------
bool SceneLoader::PropertyContainer::getVariantContainer(std::map<std::string, QVariant>& result)
{
	lua_getglobal(mState, "G_Scene");
	if (!lua_istable(mState, -1))
	{
		return false;
	}
	const int depth = pushDepth();

	/*lua_pushstring(mState, key.c_str());
	lua_gettable(mState, -2);
	if (!lua_istable(mState, -1)){
		lua_pop(mState, 1);
		return false;
	}*/

	lua_pushnil(mState);
	while (lua_next(mState, -2) != 0) {
		size_t len(0);
		const char* key = lua_tolstring(mState, -2, &len);
		if (lua_isnumber(mState, -1)) {
			const int val = lua_tonumber(mState, -1);
			result[key] = QVariant(val);
		}
		else if (lua_isboolean(mState, -1)){
			const bool val = lua_toboolean(mState, -1);
			result[key] = QVariant(val);
		}
		else if (lua_isstring(mState, -1)){
			const std::string val = lua_tostring(mState, -1);
			result[key] = QVariant(QString::fromStdString(val));
		}
		lua_pop(mState, 1);
	}

	//lua_pop(mState, 1);
	lua_pop(mState, depth);
	return true;
}

//----------------------------------------------
bool SceneLoader::PropertyContainer::getIntContainer(const std::string& key, std::map<int, int>& result)
{
	lua_getglobal(mState, "G_Scene");
	if (!lua_istable(mState, -1))
	{
		return false;
	}
	const int depth = pushDepth();

	lua_pushstring(mState, key.c_str());
	lua_gettable(mState, -2);
	if (!lua_istable(mState, -1)){
		lua_pop(mState, 1);
		return false;
	}
		
	lua_pushnil(mState);
	while (lua_next(mState, -2) != 0) {
		if (lua_isnumber(mState, -1)) {
			int val = lua_tonumber(mState, -1);
			int key = lua_tonumber(mState, -2);
			result[key] = val;
		}
		lua_pop(mState, 1);
	}

	lua_pop(mState, 1);
	lua_pop(mState, depth);
	return true;
}

//----------------------------------------------
std::string SceneLoader::prepareFile(const std::string& fileName)
{
	const QString requireStr("require ");
	QFile file(QString::fromStdString( fileName));
	if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
		return std::string();

	QString result;
	QTextStream instream(&file);
	while (!instream.atEnd()) {
		QString line = instream.readLine();
		result += line;
	}
	file.close();

	bool found = false;
	do {
		const int ind = result.indexOf(requireStr);
		found = false;
		if (ind != -1) {
			found = true;
			result.remove(ind, requireStr.length());
			const int ind1 = result.indexOf("\"", ind);
			const int ind2 = result.indexOf("\"", ind1 + 1);
			QString filePath = result.mid(ind1, ind2 - ind1);
			const QFileInfo info(filePath);
			result.remove(ind1 + 1, filePath.length() - 1);
			QString newFileName = info.baseName();
			std::string ghj = newFileName.toStdString();
			result.insert(ind1 + 1, newFileName);
		}
	} while (found);

	//const QFileInfo tmpinfo(QString::fromStdString(fileName));

	QString tmpname = QString::fromStdString(fileName);// +QString("~.lua");
	tmpname.replace(".lua", "");
	tmpname += QString("~.lua");
	QFile file_temp(tmpname);
	file_temp.open(QIODevice::WriteOnly | QIODevice::Text);
	QTextStream  out(&file_temp);
	out << result;

	return tmpname.toStdString();
}

//----------------------------------------------
bool SceneLoader::loadScene(const std::string& fileNameIn)
{
	std::string fileName = prepareFile(fileNameIn);
	LuaEngine* engine = LuaEngine::getInstance();
	lua_State* L = engine->getLuaStack()->getLuaState();

	std::string code("G_Scene = require \"");
	code.append(fileName);
	code.append("\"\n");

	const int reloadRes = engine->reload(fileName.c_str());
	if (engine->executeString(code.c_str())) {
		return false;
	}

	mState = L;

	lua_pop(L, 1);

	QString tmpFile = QString::fromStdString(fileName);
	QFile file_temp(tmpFile);
	file_temp.remove();

	return true;
}
