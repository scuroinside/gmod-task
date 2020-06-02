# Task
A simple module that allows you to delay some not-so-needed actions for Garry's Mod

# Usage
### task.Create(any_name, function_action, vararg_args)
Creates a new delayed task
Returns: number_index
### task.RemoveID(number_index)
Deletes a task by index
### task.Remove(any_name)
Deletes every task with given name
### task.GetTable()
Returns a table with existing tasks
