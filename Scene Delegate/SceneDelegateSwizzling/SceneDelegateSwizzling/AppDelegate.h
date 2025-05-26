//
//  AppDelegate.h
//  SceneDelegateSwizzling
//
//  Created by Huan Lin on 5/26/25.
//

#import <UIKit/UIKit.h>

@interface FlutterAppDelegate: UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@interface AppDelegate : FlutterAppDelegate
@end


