//
//  ViewController.m
//  SceneDelegateSwizzling
//
//  Created by Huan Lin on 5/26/25.
//

#import "FlutterViewController.h"

@interface FlutterViewController ()

@end

@implementation FlutterViewController

- (instancetype)init {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    _engine = [[FlutterEngine alloc] init];
  }
  return self;
}

@end
