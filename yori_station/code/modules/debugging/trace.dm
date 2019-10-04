// REPLACES THE /proc/stack_trace(msg) in code/__HELPERS/unsorted.dm
// its for TODO: FIX KILO SPAWN

/proc/stack_trace(msg)
    CRASH(msg)

/var/list/stack_trace_storage
/proc/gib_stack_trace()
    stack_trace_storage = list()
    stack_trace()
    stack_trace_storage.Cut(1, min(3,stack_trace_storage.len+1))
    . = stack_trace_storage

    stack_trace_storage = null

/world/Error(exception/E)
    if (stack_trace_storage)
        for (var/line in splittext(E.desc, "\n"))
            if (text2ascii(line) != 32)
                stack_trace_storage += line
        return
    ..()