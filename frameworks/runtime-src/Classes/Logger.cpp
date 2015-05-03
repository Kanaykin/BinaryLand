#include "Logger.h"

#include <fstream>
#include <string>
#include <stdio.h>
#include <iostream>
#include "cocos/platform/CCPlatformMacros.h"
#include "cocos/base/CCConsole.h"
#include "cocos/base/CCDirector.h"

namespace myextend {
    Logger::Logger(){
    }
    
    class HackConsole : public cocos2d::Console
    {
    public:
        HackConsole():mFile(0){}
        
        virtual void log(const char *buf){
            //fprintf(stdout, "cocos2d hack: %s", buf);
            //fflush(stdout);
            fputs (buf, mFile);
            fflush (mFile);
        }
        ~HackConsole() {
            if(mFile)
                fclose (mFile);
        }
        
        void init(const std::string& docPath) {
            mFile = fopen ((docPath + "/console.log").c_str(), "w");
            log("pipec");
            //fprintf(stdout, "cocos2d: %s", "temp");
            //fflush(stdout);
            //stdout = fopen(doc_path.c_str(), "w");
            CCLOG("[LUA-print] Logger::setLogFile %s", "");
        }
    private:
        FILE * mFile;
    };
    
    //---------------------------------
    void Logger::setLogFile(const std::string& doc_path)
    {
        //std::ofstream out(doc_path);
        //std::streambuf *coutbuf = std::cout.rdbuf(); //save old buf
        //std::cout.rdbuf(out.rdbuf()); //redirect std::cout to out.txt!
        
        cocos2d::Console* console = cocos2d::Director::getInstance()->getConsole();
        delete console;
        HackConsole* hack = new HackConsole();
        cocos2d::Director::getInstance()->setConsole(hack);
        hack->init(doc_path);
        
        //freopen ((doc_path + "/console.log").c_str(), "w", stdout);
        //fprintf(stdout, "cocos2d: %s", "temp");
        //fflush(stdout);
        //stdout = fopen(doc_path.c_str(), "w");
        //CCLOG("[LUA-print] Logger::setLogFile %s", "");
    }
}
