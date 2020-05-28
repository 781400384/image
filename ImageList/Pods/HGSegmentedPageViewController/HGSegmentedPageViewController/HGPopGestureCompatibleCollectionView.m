//
//  HGPopGestureCompatibleCollectionView.m
//  HGSegmentedPageViewController
//
//  Created by Arch on 2019/11/14.
//

#import "HGPopGestureCompatibleCollectionView.h"

@implementation HGPopGestureCompatibleCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
