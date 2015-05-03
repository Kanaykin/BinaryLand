
function debug_log(...)
    print("DEBUG: ", ...);
end

function info_log(...)
    release_print("INFO: ", ...);
end

function error_log(...)
    release_print("ERROR: ", ...);
end
