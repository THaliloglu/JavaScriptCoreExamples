//
//  UIView+JavaScriptCoreDemo.h
//  JavaScriptCoreDemo
//
//  Created by Tolga Haliloğlu on 28/03/2017.
//  Copyright © 2017 Cocoaist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface UIView (JavaScriptCoreDemo)

+ (void)__animateWithDuration:(NSTimeInterval)duration
                   animations:(JSValue *)animationsFunction
                   completion:(JSValue *)completionFunction;

// TODO : FIX CRASH PROBLEM
//+ (void)__animateWithDuration:(NSTimeInterval)duration
//                      context:(JSContextRef)context
//             animationsObject:(JSObjectRef)animationsObject
//             completionObject:(JSObjectRef)completionObject;

@end
