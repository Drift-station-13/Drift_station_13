/proc/call_lua(file, list/data)
	call("dmlua.dll", "clear_data")()
	for(var/I in data)
		var/X = data[I]
		if(!X)
			continue
		if(isnum(X))
			call("dmlua.dll", "set_data")("[I]", "1", "[X]")
		else if (istext(X))
			call("dmlua.dll", "set_data")("[I]", "0", X)
	return call("dmlua.dll", "run")("lua/[file].lua")

/proc/extern_print(text)
	if (istext(text))
		return call("dmlua.dll", "external_print")("[text]\n")