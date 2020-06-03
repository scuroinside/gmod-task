--[[
MIT License

Copyright (c) 2020 @scuroin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.]]

local timer, unpack, next = timer.Simple, unpack, next
local tasks, isrunning, k = {}, false
local rate = 0

module('task', package.seeall)

local function RunNextTask()
	local k = next(tasks, k)

	if k == nil then
		isrunning = false
		return
	end

	local data = tasks[k]
	data.func(unpack(data.args))
	tasks[k] = nil

	timer(rate, RunNextTask)
end

function GetTable()
	return tasks
end

function Remove(name)
	for k, data in next, tasks do
		if data.name == name then
			tasks[k] = nil
		end
	end
end

function RemoveID(id)
	tasks[id] = nil
end

function Create(name, f, ...)
	local id = 1 + #tasks
	tasks[id] = {
		name = name,
		func = f,
		args = {...}
	}

	if isrunning == false then
		isrunning = true
		timer(rate, RunNextTask)
	end

	return id
end
