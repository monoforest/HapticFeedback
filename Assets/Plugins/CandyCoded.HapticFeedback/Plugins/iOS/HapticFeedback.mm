// Copyright (c) Scott Doxey. All Rights Reserved. Licensed under the MIT License. See LICENSE in the project root for license information.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 전역 변수로 피드백 제너레이터들을 유지
static UISelectionFeedbackGenerator *selectionFeedbackGenerator = nil;
static UINotificationFeedbackGenerator *notificationFeedbackGenerator = nil;

extern "C"
{
    void PerformHapticFeedback(const char* style) {
        const NSString* styleString = [NSString stringWithUTF8String: style];
        
        // Impact Feedback (UIImpactFeedbackGenerator)
        if ([styleString isEqualToString:@"light"] ||
            [styleString isEqualToString:@"medium"] ||
            [styleString isEqualToString:@"heavy"] ||
            [styleString isEqualToString:@"soft"] ||
            [styleString isEqualToString:@"rigid"]) {
            
            UIImpactFeedbackStyle feedbackStyle;
            
            if ([styleString isEqualToString:@"light"]) {
                feedbackStyle = UIImpactFeedbackStyleLight;
            } else if ([styleString isEqualToString:@"medium"]) {
                feedbackStyle = UIImpactFeedbackStyleMedium;
            } else if ([styleString isEqualToString:@"heavy"]) {
                feedbackStyle = UIImpactFeedbackStyleHeavy;
            } else if ([styleString isEqualToString:@"soft"]) {
                if (@available(iOS 13.0, *)) {
                    feedbackStyle = UIImpactFeedbackStyleSoft;
                } else {
                    feedbackStyle = UIImpactFeedbackStyleLight;
                }
            } else if ([styleString isEqualToString:@"rigid"]) {
                if (@available(iOS 13.0, *)) {
                    feedbackStyle = UIImpactFeedbackStyleRigid;
                } else {
                    feedbackStyle = UIImpactFeedbackStyleMedium;
                }
            }
            
            UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:feedbackStyle];
            [feedbackGenerator prepare];
            [feedbackGenerator impactOccurred];
            
        }
        // Selection Feedback (UISelectionFeedbackGenerator)
        else if ([styleString isEqualToString:@"selection"]) {
            if (selectionFeedbackGenerator == nil) {
                selectionFeedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
            }
            [selectionFeedbackGenerator prepare];
            [selectionFeedbackGenerator selectionChanged];
        }
        // Notification Feedback (UINotificationFeedbackGenerator)
        else if ([styleString isEqualToString:@"success"] ||
                 [styleString isEqualToString:@"warning"] ||
                 [styleString isEqualToString:@"error"]) {
            
            if (notificationFeedbackGenerator == nil) {
                notificationFeedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
            }
            
            [notificationFeedbackGenerator prepare];
            
            UINotificationFeedbackType feedbackType;
            if ([styleString isEqualToString:@"success"]) {
                feedbackType = UINotificationFeedbackTypeSuccess;
            } else if ([styleString isEqualToString:@"warning"]) {
                feedbackType = UINotificationFeedbackTypeWarning;
            } else {
                feedbackType = UINotificationFeedbackTypeError;
            }
            
            [notificationFeedbackGenerator notificationOccurred:feedbackType];
        }
        else {
            NSException* exception = [NSException
                                    exceptionWithName:NSInvalidArgumentException
                                    reason:@"Invalid feedback style."
                                    userInfo:nil];
            [exception raise];
        }
    }
    
    // 메모리 관리를 위한 정리 함수
    void CleanupHapticFeedback() {
        selectionFeedbackGenerator = nil;
        notificationFeedbackGenerator = nil;
    }
}
