//
//  AppDelegate.m
//  SceneDelegateSwizzling
//
//  Created by Huan Lin on 5/26/25.
//

#import "AppDelegate.h"
#import <objc/runtime.h>
#import "FlutterEngine.h"
#import "FlutterViewController.h"
void FLTSwizzleMethods(Class class, SEL originalSelector, SEL swizzledSelector);

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions
{
  NSLog(@"Access VC before super call: %@", (FlutterViewController*)self.window.rootViewController);
  BOOL result = [super application:application didFinishLaunchingWithOptions:launchOptions];
  NSLog(@"Access VC after super call: %@", (FlutterViewController*)self.window.rootViewController);
  return result;
}

@end

@implementation FlutterAppDelegate {
  FlutterEngine *_recycledEngine;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
  // If didFinishLaunching is overwritten, swizzle it
  SEL originalSelector = @selector(application:didFinishLaunchingWithOptions:);
  Method subMethod = class_getInstanceMethod(self.class, originalSelector);
  Method superMethod = class_getInstanceMethod(FlutterAppDelegate.class, originalSelector);
  if (subMethod != superMethod) {
    SEL swizzledSelector = @selector(swizzled_application:didFinishLaunchingWithOptions:);
    FLTSwizzleMethods(self.class, originalSelector, swizzledSelector);
  }
  return YES;
}

- (BOOL)swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Set up window with dummy a vc and engine");
  FlutterViewController *vc = [[FlutterViewController alloc] init];
  self.window = [[UIWindow alloc] init];
  self.window.rootViewController = vc;
  
  BOOL result = [self swizzled_application:application didFinishLaunchingWithOptions:launchOptions];
  
  NSLog(@"Tear down window and recycle the engine");
  self->_recycledEngine = vc.engine;
  self.window = nil;

  return result;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"FlutterAppDelegate::didFinishLaunching");
  return YES;
}


#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
  // Called when a new scene session is being created.
  // Use this method to select a configuration to create the new scene with.
  return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

@end

void FLTSwizzleMethods(Class class, SEL originalSelector, SEL swizzledSelector) {
  
  Method originalMethod = class_getInstanceMethod(class, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
  
  BOOL didAddMethod =
  class_addMethod(class,
                  originalSelector,
                  method_getImplementation(swizzledMethod),
                  method_getTypeEncoding(swizzledMethod));
  
  if (didAddMethod) {
    class_replaceMethod(class,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}
