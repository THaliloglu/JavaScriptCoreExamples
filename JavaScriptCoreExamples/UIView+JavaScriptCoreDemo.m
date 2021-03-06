//
//  UIView+JavaScriptCoreDemo.m
//  JavaScriptCoreDemo
//
//  Created by Tolga Haliloğlu on 28/03/2017.
//  Copyright © 2017 Cocoaist. All rights reserved.
//

#import "UIView+JavaScriptCoreDemo.h"

@implementation UIView (JavaScriptCoreDemo)

+ (void)__animateWithDuration:(NSTimeInterval)duration
                   animations:(JSValue *)animationsFunction
                   completion:(JSValue *)completionFunction
{
    void(^animations)(void) = NULL;
    if (!animationsFunction.isUndefined) {
        animations = ^() {
            [animationsFunction callWithArguments:nil];
        };
    }
    
    void(^completion)(BOOL) = NULL;
    if (!completionFunction.isUndefined) {
        completion = ^(BOOL finished) {
            NSMutableArray *parameters = [[NSMutableArray alloc] init];
            if (finished) {
                [parameters addObject:@YES];
            } else {
                [parameters addObject:@NO];
            }
            
            [completionFunction callWithArguments:parameters];
        };
    }
    
    [self animateWithDuration:duration animations:animations completion:completion];
}

// TODO : FIX CRASH PROBLEM
//+ (void)__animateWithDuration:(NSTimeInterval)duration
//                      context:(JSContextRef)context
//             animationsObject:(JSObjectRef)animationsObject
//             completionObject:(JSObjectRef)completionObject
//{
//    void(^animations)(void) = NULL;
//    if (!JSValueIsUndefined(context, animationsObject) && JSObjectIsFunction(context, animationsObject)) {
//        animations = ^() {
//            JSObjectCallAsFunction(context, animationsObject, NULL, 0, NULL, NULL);
//        };
//    }
//
//    void(^completion)(BOOL) = NULL;
//    if (!JSValueIsUndefined(context, completionObject) && JSObjectIsFunction(context, completionObject)) {
//        completion = ^(BOOL finished) {
//            JSValueRef finishedRef = JSValueMakeBoolean(context, finished);
//            JSValueRef args[] = { finishedRef };
//            JSObjectCallAsFunction(context, completionObject, NULL, 1, args, NULL);
//        };
//    }
//
//    [self animateWithDuration:duration animations:animations completion:completion];
//}

@end
