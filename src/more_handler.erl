-module(more_handler).	
-include("includes.hrl").
-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{CategoryBinary, _} = cowboy_req:qs_val(<<"id">>, Req),
	Category = binary_to_list(CategoryBinary),
	
	% for video display
	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=2&format=long",
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[ResponseParams] = proplists:get_value(<<"articles">>, ResponseParams_mlb),


	% Url_all_news = string:concat("http://api.contentapi.ws/t?id=",Category),
	Url_all_news = string:concat("http://contentapi.ws:5984/contentapi_text_maxcdn/",Category),
	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResAllNews = string:sub_string(ResponseAllNews, 1, string:len(ResponseAllNews) -1 ),
	Params = jsx:decode(list_to_binary(ResAllNews)),

	% Latestnews_Url = "http://api.contentapi.ws/news?channel=entertainment_people&limit=4&skip=0&format=short",
	Latestnews_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_people/_view/short?descending=true&limit=4&skip=0",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_Latestnews} = ibrowse:send_req(Latestnews_Url,[],get,[],[]),
	ResponseParams_Latestnews = jsx:decode(list_to_binary(Response_Latestnews)),	
	LatestnewsParams = proplists:get_value(<<"rows">>, ResponseParams_Latestnews),

	% Popularnews_Url = "http://api.contentapi.ws/news?channel=entertainment_people&limit=4&skip=6&format=short",
	% io:format("movies url: ~p~n",[Url]), 
	Popularnews_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_people/_view/short?descending=true&limit=4&skip=4",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_Popularnews} = ibrowse:send_req(Popularnews_Url,[],get,[],[]),
	ResponseParams_Popularnews = jsx:decode(list_to_binary(Response_Popularnews)),	
	PopularnewsParams = proplists:get_value(<<"rows">>, ResponseParams_Popularnews),	

	{ok, Body} = more_dtl:render([{<<"videoParam">>,ResponseParams},{<<"allnews">>,Params},{<<"latestnews">>,LatestnewsParams},{<<"popularnews">>,PopularnewsParams}]),
    {Body, Req, State}.
