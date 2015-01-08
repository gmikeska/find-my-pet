frontpageAlert = _.template("<div><h3><%=dogname %></h3> Found at: <%=location %></div>")

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