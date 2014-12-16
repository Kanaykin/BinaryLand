
#ifndef BinaryLand_Logger_h
#define BinaryLand_Logger_h

#include <string>

namespace myextend {
    class Logger
    {
    public:
        Logger();
        
        static void setLogFile(const std::string& doc_path);
        
        virtual ~Logger(){}
    };
}

#endif
