Console.log("Hello World");

var window = UIWindow.new();
window.windowScene = windowScene;

var navigationController = UINavigationController.new();

var mainViewController = UIViewController.new();
mainViewController.view.backgroundColor = UIColor.redColor();

var view1 = UIView.new();
view1.frame = {x:50, y:100, width:100, height:100};
view1.backgroundColor = UIColor.blueColor();

mainViewController.view.addSubview(view1);

navigationController.viewControllers = [mainViewController];

window.rootViewController = navigationController;

window.makeKeyAndVisible();

 UIView.animate(
 	1,
 	function(){
 		view1.frame = {x:50, y:200, width:100, height:100};
 	},
 	function(finished){
 		if(finished){
 			UIView.animate(
 				1,
 				function(){
 					view1.frame = {x:100, y:200, width:100, height:100};
 				},
 				function(finished){
 					if(finished){
 						view1.backgroundColor = UIColor.greenColor();
 					}
 				}
 			);
 		}
 	}
 );
