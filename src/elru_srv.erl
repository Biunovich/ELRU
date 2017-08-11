-module(elru_srv).
-behaviour(gen_server).
-include("elru.hrl").

-export([start_link/0, init/1, handle_call/3, handle_cast/2, new/1, add/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

new(Size) ->
    gen_server:call(?MODULE, {new, Size}).

add(Module, Func, List_Args) ->
    gen_server:call(?MODULE, {add, Module, Func, List_Args}).

init([]) ->
    {ok, {}}.

handle_call({new , MaxSize}, _From, _State) ->
    {reply, ok, {ets:new(elru, [set]), MaxSize}};
handle_call({add, Module, Func, List_Args}, _From, {Id, MaxSize}) ->
    Bin = erlang:term_to_binary([Module, Func, List_Args]),
    Hash = crypto:hash(md5, Bin),
    case ets:lookup(Id, Hash) of
        [{Key, Value}] ->
            ets:delete(Id, Key),
            ets:insert(Id, {Key, Value}),
            {reply, Value, {Id, MaxSize}};
        _ -> 
            Res = Module:Func(List_Args),
            ets:insert(Id, {Hash, Res}),
            gen_server:cast(?MODULE, {check_size}),
            {reply, Res, {Id, MaxSize}}
    end.

handle_cast({check_size}, {Id, MaxSize}) ->
    Size = ets:info(Id, size),
    if 
        Size > MaxSize ->
            Key = ets:last(Id),
            Val = ets:lookup(Id, Key),
            ets:delete(Id, Key),
            ?LOG("Delete ~p",[Val]),
            {noreply, {Id, MaxSize}};
        true -> 
            {noreply, {Id, MaxSize}}
    end.