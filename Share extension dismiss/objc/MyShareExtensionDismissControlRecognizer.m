//
//  MyShareExtensionDismissControlRecognizer.m
//  MyShareExtension
//
//  Created by Huan Lin on 3/28/25.
//

#import "MyShareExtensionDismissControlRecognizer.h"

@interface MyShareExtensionDismissControlRecognizer()<UIGestureRecognizerDelegate>

@end

@implementation MyShareExtensionDismissControlRecognizer {
  CGPoint _beganLocation;
  UIGestureRecognizer *_dismissRecognizer;
  MyShareExtensionSwipeDismissStrategy _dismissStrategy;
}

- (instancetype)initWithDismissStrategy:(MyShareExtensionSwipeDismissStrategy)strategy {
  self = [super init];
  if (self) {
    _dismissStrategy = strategy;
    self.delegate = self;
  }
  return self;
}

- (BOOL)isBackgroundDismissRecognizer: (UIGestureRecognizer *)gc {
  return [gc.name hasSuffix:@"UISheetInteractionBackgroundDismissRecognizer"];
}

- (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

  if (!_dismissRecognizer && [self isBackgroundDismissRecognizer:otherGestureRecognizer]) {
    _dismissRecognizer = otherGestureRecognizer;
    
    switch (_dismissStrategy) {
      case MyShareExtensionSwipeDismissStrategyTopRegion:
        [self setDismissRecognizerEnabledWithLocation:_beganLocation];
        break;
      case MyShareExtensionSwipeDismissStrategyProhibited:
        _dismissRecognizer.enabled = NO;
        break;
    }
  }
  
  return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  _beganLocation = [touches.anyObject locationInView:self.view];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  self.state = UIGestureRecognizerStateFailed;
}

- (void)setDismissRecognizerEnabledWithLocation: (CGPoint)location {
  _dismissRecognizer.enabled = location.y <= 50;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  switch (_dismissStrategy) {
    case MyShareExtensionSwipeDismissStrategyTopRegion:
      [self setDismissRecognizerEnabledWithLocation:[touch locationInView:touch.view]];
      break;
    case MyShareExtensionSwipeDismissStrategyProhibited:
      break;
  }
  return YES;
}

@end

