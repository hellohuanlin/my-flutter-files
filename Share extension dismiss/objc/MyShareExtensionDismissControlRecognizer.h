//
//  MyShareExtensionDismissControlRecognizer.h
//  MyShareExtension
//
//  Created by Huan Lin on 3/28/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
  MyShareExtensionSwipeDismissStrategyTopRegion,
  MyShareExtensionSwipeDismissStrategyProhibited,
} MyShareExtensionSwipeDismissStrategy;

@interface MyShareExtensionDismissControlRecognizer : UIGestureRecognizer
- (instancetype)initWithDismissStrategy:(MyShareExtensionSwipeDismissStrategy)strategy;
@end

NS_ASSUME_NONNULL_END
