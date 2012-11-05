//
//  LightControlAppDelegate.h
//  LightControl
//
//  Created by Anthony Gillet on 8/28/12.
//  
//

#import <UIKit/UIKit.h>

#define APPDELEGATE ((LightControlAppDelegate*)[[UIApplication sharedApplication] delegate])
#define LIGHT_DATABASE ((LightDatabase*)[APPDELEGATE lightDatabase])

@class LightTableViewController;
@class ThermostatTableViewController;
@class LightDatabase;

@interface LightControlAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UINavigationController*                 lightsNavController;
    LightTableViewController*               lightsController;
    UINavigationController*                 tempNavController;
    ThermostatTableViewController*          tempController;
    UINavigationController*                 camNavController;
    LightDatabase*                          lightDatabase;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, readonly) LightDatabase *lightDatabase;

@end
