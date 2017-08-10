-module(elru_srv).
-behaviour(gen_server).

-export([start_link/0, init/1, handle_call/3, handle_cast/2, new/1, add/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

new(Size) ->
    gen_server:call(?MODULE, {new, Size}).

add(Module, Func, List_Args) ->
    gen_server:call(?MODULE, {add, Module, Func, List_Args}).

init([]) ->
    {ok, {}}.

handle_call({new , Size}, _From, _State) ->
    {reply, ok, {ets:new(elru, [set]), 0, Size}};
handle_call({add, Module, Func, List_Args}, _From, State) ->
    

handle_cast(Args, State) ->
    {noreply, State}.