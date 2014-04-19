%%------------------------------------------------------------------------------
%% Copyright (c) 2013-2014 Vasil Kolarov
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%------------------------------------------------------------------------------

-module(rivus_cep_clock_sup).
-behaviour(supervisor).
-export([start_link/0,
	 init/1,
	 start_clock_server/2]).

start_link () ->
    supervisor:start_link({local,?MODULE},?MODULE,[]).

start_clock_server(QueryPid, Interval) ->
    {ok, Pid} = supervisor:start_child(?MODULE, [QueryPid, Interval]),
    Pid.

init ([]) ->
    {ok,{{simple_one_for_one, 3, 180},
         [
          {undefined, {rivus_cep_clock_server, start_link, []},
           transient, brutal_kill, worker, [rivus_cep_clock_server]}
         ]}}.
