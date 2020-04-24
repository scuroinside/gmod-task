local timer = timer.Simple
local unpack = unpack
local next = next
local print = print
local hook = hook.Add
local tasks, isrunning, rate = 
	{}, false, 1 / 3

local function RunNextTask()
	local k = next(tasks)

	if k == nil then
		isrunning = false
		return
	end

	local data = tasks[k]
	data.func(unpack(data.args))
	tasks[k] = nil
	timer(rate, RunNextTask)
end

module('task', package.seeall)

function GetTable()
	return tasks
end

function Remove(name)
	tasks[name] = nil
end

function Create(name, f, ...)
	tasks[name] = {
		func = f,
		args = {...}
	}

	if isrunning == false then
		isrunning = true
		timer(rate, RunNextTask)
	end
end
