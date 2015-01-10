lostBulletin = _.template("<div class='col-md-1'></div><div class='col-md-4 bulletin'><h3><%= name %></h3> <%=animal_breed %><br><%= animal_gender%><br>Lost at: <%= where_lost %></div><div class='col-md-1'></div>") //this is a template, call it to build bulletins
navBar = _.template('<nav class="navbar navbar-inverse"><ul class="nav navbar-nav"><%= items %></ul></nav>')
navItem = _.template('<li id="<%= path.substring(1, path.length) %>"><a href="<%= path %>"><%= name %></a></li>')
navItemActive = _.template('<li class="active"><a href="<%= path %>"><%= name %><span class="sr-only">(current)</span></a></li>')
var buildNav = function(){

	url = document.URL
	currentPath = url.substring(url.indexOf('/', url.indexOf('/')+3), url.length)
	
	pages = [{path:'/', name:'Home'},
	{path:'/lost/new', name:'Report Missing Pet'},
	{path:'/found/new', name:'Report Found Pet'},
	{path:'/lost', name:'Pets Reported Missing Nearby'},
	{path:'/found', name:'Pets Found Nearby'},
	{path:'/profile', name:'Edit Profile'}
	]

var items = ""
$.each(pages, function(i, x){
	console.log(x.name)
	if(x.path == currentPath)
		items+= navItemActive(x)
	else
		items+= navItem(x)
})



	nav = navBar({items:items})
	$("#main").prepend(nav)
}
var backgrounds = ["http://peacelovefoster.files.wordpress.com/2012/11/09.jpg",
		"http://www.animalcareclinicslo.com/wp-content/uploads/2011/03/dog-and-tennis-ball.jpg",
		"http://www.petmeds.org/wp-content/uploads/2012/09/26901192_Abir_with_TB.jpg",
		"http://www.imgion.com/images/01/White-Cute-Puppy-.jpg",
		"http://animalfair.com/wp-content/uploads/2013/09/macexplorer.com-puppy-dog-26.jpg"]
$(document).ready(function(){
	console.log('running')
	i = Math.floor(Math.random() * (backgrounds.length));
	console.log(i)
	img = "url("+backgrounds[i]+")"
	console.log(img)
	$('body').css("background-image", img);
	$('body').css("background-size", '100%');

})
// <img src= <%= image_url %>