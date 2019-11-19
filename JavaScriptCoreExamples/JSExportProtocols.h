//
//  JSExportProtocols.h
//  JavaScriptCoreExamples
//
//  Created by Tolga Haliloğlu on 20.07.2019.
//  Copyright © 2019 TH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

// PROTOCOLS

// NSObject
@protocol NSObjectExport <JSExport, NSObject>

+ (instancetype)new;

@end



// UIView
@protocol UIViewExport <JSExport, NSObjectExport>

@property (nonatomic) CGRect frame;
@property (nonatomic, copy) UIColor *backgroundColor;

- (void)addSubview:(UIView *)view;

JSExportAs(animate,
+ (void)__animateWithDuration:(NSTimeInterval)duration
           animations:(JSValue *)animationsFunction
           completion:(JSValue *)completionFunction);
@end



// UIWindow
@protocol UIWindowExport <JSExport, UIViewExport>

@property(nonatomic, weak) UIWindowScene *windowScene;
@property (nonatomic, retain) UIViewController *rootViewController;
- (void)makeKeyAndVisible;

@end



// UIColor
@protocol UIColorExport <JSExport, NSObjectExport>

+ (UIColor *)redColor;
+ (UIColor *)greenColor;
+ (UIColor *)blueColor;
+ (UIColor *)whiteColor;

@end



// UIViewController
@protocol UIViewControllerExport <JSExport, NSObjectExport>

@property (nonatomic, retain) UIView *view;

@end



// UINavigationController
@protocol UINavigationControllerExport <JSExport, UIViewControllerExport>

@property (nonatomic, copy) NSArray *viewControllers;

@end



@interface JSExportProtocols : NSObject

+(void)loadClassesToContext:(JSContext *)context;

@end
