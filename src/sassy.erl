-module(sassy).
-export([compile/1, compile_file/1]).

-on_load(init/0).

-define(nif_stub, nif_stub_error(?LINE)).

nif_stub_error(Line) ->
    erlang:nif_error({nif_not_loaded,module,?MODULE,line,Line}).

init() ->
    PrivDir = case code:priv_dir(?MODULE) of
        {error, bad_name} ->
            EbinDir = filename:dirname(code:which(?MODULE)),
            AppPath = filename:dirname(EbinDir),
            filename:join(AppPath, "priv");
        Path ->
            Path
    end,
    erlang:load_nif(filename:join(PrivDir, ?MODULE), 0).

compile_file(Path) ->
    case file:read_file(Path) of
        {ok, Bin} ->
            compile(binary_to_list(Bin));
        Err ->
            Err
    end.

compile(_Str) ->
    ?nif_stub.
