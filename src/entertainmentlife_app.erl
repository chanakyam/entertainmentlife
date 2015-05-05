-module(entertainmentlife_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_',[
                {"/", home_page_handler, []},

                 {"/api/latestBiz/channel", channel_latestBiz_handler, []},
                 {"/api/latestNews/channel", channel_latestNews_handler, []},
                 {"/music", photo_gallery_handler, []},
                 {"/api/videos/channel", feed_videos_handler, []},
                 {"/termsandconditions", tnc_page_handler, []},
                 {"/more", more_handler, []},
                 {"/video", video_handler, []},
                 {"/more_news", more_news_handler, []},
                 {"/more_videos", more_videos_handler, []},
                 {"/api/news/count", news_count_handler, []},
                 {"/api/videos/count", videos_count_handler, []},
                 % {"/api/latestBiz/channel", channel_latestBiz_handler, []},
                 {"/api/gallery/channel", channel_gallery_handler, []},
                 

                
                           
                %%
                %% Release Routes
                %%
                {"/css/[...]", cowboy_static, {priv_dir, entertainmentlife, "static/css"}},
                {"/images/[...]", cowboy_static, {priv_dir, entertainmentlife, "static/images"}},
                {"/js/[...]", cowboy_static, {priv_dir, entertainmentlife, "static/js"}},
                {"/fonts/[...]", cowboy_static, {priv_dir, entertainmentlife, "static/fonts"}}
                % % %%
                %% Dev Routes
                %%
                % {"/css/[...]", cowboy_static, {dir, "priv/static/css"}},
                % {"/images/[...]", cowboy_static, {dir, "priv/static/images"}},
                % {"/js/[...]", cowboy_static, {dir,"priv/static/js"}},
                % {"/fonts/[...]", cowboy_static, {dir, "priv/static/fonts"}}
        ]}      
    ]),    

    {ok, _} = cowboy:start_http(http,100, [{port, 9917}],[{env, [{dispatch, Dispatch}]}
              ]),
    entertainmentlife_sup:start_link().
 

stop(_State) ->
    ok.

