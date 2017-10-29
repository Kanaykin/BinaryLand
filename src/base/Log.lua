g_count_lines = 0
function debug_log(...)
    --print(tostring(g_count_lines), " DEBUG: ", ...);
    --g_count_lines = g_count_lines + 1;
end

function info_log(...)
    --release_print(tostring(g_count_lines), " INFO: ", ...);
    --g_count_lines = g_count_lines + 1;
end

function error_log(...)
    release_print(tostring(g_count_lines), " ERROR: ", ...);
    g_count_lines = g_count_lines + 1;
end
