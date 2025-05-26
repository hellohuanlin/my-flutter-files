@interface MyProhibitedRecognizer : UIGestureRecognizer<UIGestureRecognizerDelegate>

@end

@implementation MyProhibitedRecognizer


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
    otherGestureRecognizer.enabled = NO;
  }
  
  return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesBegan");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesEnded");
  self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesCancelled");
  self.state = UIGestureRecognizerStateFailed;
}

@end


