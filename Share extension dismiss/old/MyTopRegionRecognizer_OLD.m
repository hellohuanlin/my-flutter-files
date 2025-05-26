
@interface MyTopRegionRecognizer : UIGestureRecognizer<UIGestureRecognizerDelegate>

@end

@implementation MyTopRegionRecognizer {
  CGPoint _beganLocation;
  UIGestureRecognizer *_dismissalRecognizer;
}


- (instancetype)init
{
  self = [super init];
  if (self) {
    self.delegate = self;
  }
  return self;
}

- (BOOL)isDismisalGestureRecognizer: (UIGestureRecognizer *)gc {
  return [gc.name hasSuffix:@"UISheetInteractionBackgroundDismissRecognizer"];
}

- (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  
  if ([self isDismisalGestureRecognizer:otherGestureRecognizer]) {
    // found it
    NSLog(@"shouldRequireFailureOfGestureRecognizer");
    
    // We need this here again, so that the first `shouldReceiveTouch` knows nothing about the dismissalRecognizer, and `shouldReceiveTouch` is called before `shouldRequireFailureOfGestureRecognizer`.
    // If we remove this chunk, the first interraction won't work.
    // But we only need it once.
    
    if (_dismissalRecognizer == nil) {
      _dismissalRecognizer = otherGestureRecognizer;
      
      if (_beganLocation.y > 50) {
        NSLog(@"_beganLocation.y > 50");
        _dismissalRecognizer.enabled = NO;
      } else {
        NSLog(@"_beganLocation.y < 50");
        _dismissalRecognizer.enabled = YES;
      }
    }
  }
  
  return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesBegan");
  _beganLocation = [touches.anyObject locationInView:self.view];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesEnded");
  // We have to fail the state, so that other recognizers can proceed.
  // Otherwise, when we release the finger, we can't scroll the list anymore, because it's swallowing it (for some unknown reason).
  self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesCancelled");
  self.state = UIGestureRecognizerStateFailed;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  NSLog(@"shouldReceiveTouch");
  
  // We need this chunk here, so that we can enable/dislable dismisalReocngizer. If we only put it in `shouldRequireFailureOfGestureRecognizer`, and after we disable dismisalRecongizer, `shouldRequireFailureOfGestureRecognizer` won't be called again. But shouldReceiveTouch is called for every touch.
  if ([touch locationInView:touch.view].y > 50) {
    _dismissalRecognizer.enabled = NO;
  } else {
    // After user started dragging the top bar, and dismissal reconigzer is in the progress
    // If we immediately touch end (without dismiss it), and then immediately move the list under list area, `shouldReceiveTouch` won't be called, probably because dismissal require like half a second to confirm the cancel (e.g. in case of double tap, etc). So when we immediately release, then touch again, `shouldReceiveTouch` won't be called, and we will drag the whole thing again.
    // So we have to wait for half second in order to start dismissal, which is probably ok.
    _dismissalRecognizer.enabled = YES;
  }
  
  // We need this to return YES so that touchesBegan is called.
  return YES;
}

@end



