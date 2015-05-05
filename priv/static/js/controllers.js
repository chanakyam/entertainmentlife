var app = angular.module('showbiz', []);

app.factory('entertainmentHomeService', function ($http) {
	return {		

		getlatestBiz: function (category, count, skip) {
			return $http.get('/api/latestBiz/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.articles;
			});
		},
		getlatestNews: function (category, count, skip) {
			return $http.get('/api/latestNews/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.articles;
			});
		},
		getVideo: function (category, count, skip) {
			return $http.get('/api/videos/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.articles;
			});

		},
		getlatestgallery: function (category, count, skip) {
			return $http.get('/api/gallery/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.articles;
			});
		}
	};
});
app.factory("flowplayer", function(){
	return flowplayer;
});

app.controller('EntertainmentHome', function($scope, entertainmentHomeService, $document, flowplayer) {
   $scope.latestBiz = entertainmentHomeService.getlatestBiz('showbiz_view',6,0);
   $scope.latestNews = entertainmentHomeService.getlatestNews('showbiz_view',5,6);
   $scope.gallery = entertainmentHomeService.getlatestgallery('image_gallery_view',8,0);
   $scope.video = entertainmentHomeService.getVideo("by_id_title_desc_thumb_date", 8, 0);
 
	//getting current year/month/date
	$scope.currentYear = (new Date).getFullYear();	 

});



