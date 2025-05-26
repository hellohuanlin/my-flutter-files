//
//  ViewController.h
//  SceneDelegateSwizzling
//
//  Created by Huan Lin on 5/26/25.
//

#import <UIKit/UIKit.h>
#import "FlutterEngine.h"

@interface FlutterViewController : UIViewController

@property (nonatomic, strong) FlutterEngine *engine;

@end

