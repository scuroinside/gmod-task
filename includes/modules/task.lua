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

task = {}
local timer, unpack, next, assert, isfunction = timer.Simple, unpack, next, assert, isfunction
local rate = 1 / 16

do
	local tsks, rntsk = {}, false

	local function RunNextTask()
		local k = next(tsks)

		if k == nil then
			rntsk = false
			return
		end

		local data = tsks[k]
		data.func(unpack(data.args))
		tsks[k] = nil

		timer(rate, RunNextTask)
	end

	function task.GetTable()
		return tasks
	end

	function task.Remove(name)
		for k, data in next, tsks do
			if data.name == name then
				tsks[k] = nil
			end
		end
	end

	function task.RemoveID(id)
		tsks[id] = nil
	end

	function task.Create(name, fn, ...)
		assert(isfunction(fn) == true)
		local id = 1 + #tsks
		tsks[id] = {
			name = name,
			func = fn,
			args = {...}
		}

		if rntsk == false then
			rntsk = true
			timer(rate, RunNextTask)
		end

		return id
	end
end

do
	local thrds, rnthrd, rmprv, k = {}, false

	local function RunNextThread()
		local lastk = k
		k = next(thrds, k)

		if rmprv == true and lastk ~= nil then
			thrds[lastk] = nil
		end

		if k == nil then
			k = next(thrds)

			if k == nil then
				rnthrd = false
				return
			end
		end

		local fn = thrds[k]
		rmprv = fn()

		timer(rate, RunNextThread)
	end

	function task.CreateThread(name, fn)
		assert(isfunction(fn) == true)
		thrds[name] = fn

		if rnthrd == false then
			rnthrd = true
			timer(rate, RunNextThread)
		end
	end

	function task.RemoveThread(name)
		thrds[name] = nil
		if next(thrds) == nil then
			rnthrd = false
		end
	end

	function task.GetThreadsTable()
		return thrds
	end
end
