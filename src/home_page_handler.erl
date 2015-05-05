-module(home_page_handler).
-author("karamjeets@dyomo.com").
-modified("sushmap@ybrantinc.com").

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
	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=1&format=long",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=4&skip=0&format=short",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_Videos} = ibrowse:send_req(Videos_Url,[],get,[],[]),
	ResponseParams_Videos = jsx:decode(list_to_binary(Response_Videos)),	
	VideosParams = proplists:get_value(<<"articles">>, ResponseParams_Videos),

	% Latestnews_Url = "http://api.contentapi.ws/news?channel=entertainment_people&limit=2&skip=0&format=short",
	Latestnews_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_people/_view/short?descending=true&limit=2&skip=0",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_Latestnews} = ibrowse:send_req(Latestnews_Url,[],get,[],[]),
	ResponseParams_Latestnews = jsx:decode(list_to_binary(Response_Latestnews)),	
	LatestnewsParams = proplists:get_value(<<"rows">>, ResponseParams_Latestnews),

	% Gallery_Url = "http://api.contentapi.ws/news?channel=image_galleries&limit=4&skip=0&format=short",
	% % io:format("movies url: ~p~n",[Url]), 
	% {ok, "200", _, Response_Gallery} = ibrowse:send_req(Gallery_Url,[],get,[],[]),
	% ResponseParams_Gallery = jsx:decode(list_to_binary(Response_Gallery)),	
	% GalleryParams = proplists:get_value(<<"articles">>, ResponseParams_Gallery),

	% Music_Url = "http://api.contentapi.ws/news?channel=entertainment_music&limit=4&skip=0&format=short",
	Music_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_music/_view/short?descending=true&limit=4&skip=0",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_Music} = ibrowse:send_req(Music_Url,[],get,[],[]),
	ResponseParams_Music = jsx:decode(list_to_binary(Response_Music)),	
	MusicParams = proplists:get_value(<<"rows">>, ResponseParams_Music),

	% Popularnews_Url = "http://api.contentapi.ws/news?channel=entertainment_people&limit=4&skip=6&format=short",
	Popularnews_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_people/_view/short?descending=true&limit=4&skip=6",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_Popularnews} = ibrowse:send_req(Popularnews_Url,[],get,[],[]),
	ResponseParams_Popularnews = jsx:decode(list_to_binary(Response_Popularnews)),	
	PopularnewsParams = proplists:get_value(<<"rows">>, ResponseParams_Popularnews),

	{ok, Body} = index_dtl:render([{<<"videoParam">>,Params},{<<"latestvideos">>,VideosParams},{<<"latestnews">>,LatestnewsParams},{<<"music">>,MusicParams},{<<"popularnews">>,PopularnewsParams}]),


    {Body, Req, State}.
