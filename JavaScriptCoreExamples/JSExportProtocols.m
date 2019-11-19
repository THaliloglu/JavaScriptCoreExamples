//
//  JSExportProtocols.m
//  JavaScriptCoreExamples
//
//  Created by Tolga Haliloğlu on 20.07.2019.
//  Copyright © 2019 TH. All rights reserved.
//

#import "JSExportProtocols.h"
#import "Console.h"
#import <objc/runtime.h>

@implementation JSExportProtocols

+(void)loadClassesToContext:(JSContext *)context
{
    // NSObject
    class_addProtocol([NSObject class], @protocol(NSObjectExport));
    class_addProtocol(object_getClass([NSObject class]), @protocol(NSObjectExport));
    context[@"NSObject"] = [NSObject class];
    
    // UIView
    class_addProtocol([UIView class], @protocol(UIViewExport));
    class_addProtocol(object_getClass([UIView class]), @protocol(UIViewExport));
    context[@"UIView"] = [UIView class];
    
    // UIWindow
    class_addProtocol([UIWindow class], @protocol(UIWindowExport));
    class_addProtocol(object_getClass([UIWindow class]), @protocol(UIWindowExport));
    context[@"UIWindow"] = [UIWindow class];
        
    // UIColor
    class_addProtocol([UIColor class], @protocol(UIColorExport));
    class_addProtocol(object_getClass([UIColor class]), @protocol(UIColorExport));
    context[@"UIColor"] = [UIColor class];
    
    // UIViewController
    class_addProtocol([UIViewController class], @protocol(UIViewControllerExport));
    class_addProtocol(object_getClass([UIViewController class]), @protocol(UIViewControllerExport));
    context[@"UIViewController"] = [UIViewController class];
    
    // UINavigationController
    class_addProtocol([UINavigationController class], @protocol(UINavigationControllerExport));
    class_addProtocol(object_getClass([UINavigationController class]), @protocol(UINavigationControllerExport));
    context[@"UINavigationController"] = [UINavigationController class];
    
    context[@"Console"] = [Console class];
}

@end
