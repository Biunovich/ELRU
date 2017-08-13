# ELRU
Implementation of LRU cache in Erlang OTP application
This application store results of functions in ets based database. It calculate hash of ```[ModuleName, FunctionName, ListOfArgs]``` and store it in database.

# Usage

Add in rebar.config file :
```erlang
{elru, "1.0.0"}
```
Then create new LRU cache :
```erlang
Size = 12.
elru:new(Size).
```
To add new element (execute function) or get value (if this function have been executed) type :
```erlang
elru:add(ModuleName, FunctionName, [Arg1, Arg2, .., ArgN]).
```
# Examle
```erlang
elru:new(12).
elru:add(test, add, [1,2]).
```
