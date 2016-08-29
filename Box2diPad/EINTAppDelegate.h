//
//  EINTAppDelegate.h
//  Box2diPad
//
//

#import <UIKit/UIKit.h>

@class EINTViewController;

@interface EINTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) EINTViewController *viewController;

+(EINTViewController*)getRootViewController;
@end
