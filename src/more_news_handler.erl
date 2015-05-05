-module(more_news_handler).
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
	% {PageBinary, _} = cowboy_req:qs_val(<<"p">>, Req),
	% PageNum = list_to_integer(binary_to_list(PageBinary)),
	% SkipItems = (PageNum-1) * ?NEWS_PER_PAGE,
	% {CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
	% Category = binary_to_list(CategoryBinary),

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=5&format=long",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	% Url_all_news = string:concat("http://api.contentapi.ws/news?channel=starstyle&limit=10&format=short&skip=", integer_to_list(SkipItems)),
	% Url_all_news = "http://api.contentapi.ws/news?channel=entertainment_people&limit=10&format=short&skip=0",
	Url_all_news = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_people/_view/short?descending=true&limit=10&skip=0",
	% io:format("all news : ~p~n",[Url_all_news]),
	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(ResponseAllNews)),
	ResAllNews = proplists:get_value(<<"rows">>, ResponseParams),

	Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=4&skip=0&format=short",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_Videos} = ibrowse:send_req(Videos_Url,[],get,[],[]),
	ResponseParams_Videos = jsx:decode(list_to_binary(Response_Videos)),	
	VideosParams = proplists:get_value(<<"articles">>, ResponseParams_Videos),

	% Gallery_Url = "http://api.contentapi.ws/news?channel=image_galleries&limit=8&skip=0&format=short",
	% {ok, "200", _, Response_Gallery} = ibrowse:send_req(Gallery_Url,[],get,[],[]),
	% ResponseParams_Gallery = jsx:decode(list_to_binary(Response_Gallery)),	
	% GalleryParams = proplists:get_value(<<"articles">>, ResponseParams_Gallery),

	% Popularnews_Url = "http://api.contentapi.ws/news?channel=entertainment_people&limit=4&skip=6&format=short",
	% io:format("movies url: ~p~n",[Url]), 
	Popularnews_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_people/_view/short?descending=true&limit=4&skip=6",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_Popularnews} = ibrowse:send_req(Popularnews_Url,[],get,[],[]),
	ResponseParams_Popularnews = jsx:decode(list_to_binary(Response_Popularnews)),	
	PopularnewsParams = proplists:get_value(<<"rows">>, ResponseParams_Popularnews),

	{ok, Body} = more_news_dtl:render([{<<"videoParam">>,Params},{<<"allnews">>,ResAllNews},{<<"latestvideos">>,VideosParams},{<<"popularnews">>,PopularnewsParams}]),
    {Body, Req, State}.



