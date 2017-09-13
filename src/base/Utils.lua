utils = {
	
}

utils.getfield = function (f)
  local v = _G    -- start with the table of globals
  for i, w in pairs(v) do
    if w == f then
    	return i;
    end
  end
  return nil
end
