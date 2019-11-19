//
//  JSCoreSupport.m
//  JavaScriptCoreExamples
//
//  Created by Tolga Haliloğlu on 20.07.2019.
//  Copyright © 2019 TH. All rights reserved.
//

#import "JSCoreSupport.h"
#import "JSExportProtocols.h"

@implementation JSCoreSupport

+(JSContext *)getGlobalContext
{
    static JSContext *globalContext;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalContext = [[JSContext alloc] init];
        globalContext.exceptionHandler = ^(JSContext *context, JSValue *value) {
            NSLog(@"%@", value);
        };
        [JSExportProtocols loadClassesToContext:globalContext];
    });
    
    return globalContext;
}

+(void)runWithContext:(JSContext *)context
{
    NSString *jsStringPath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    if (jsStringPath){
        NSString *jsString = [NSString stringWithContentsOfFile:jsStringPath encoding:NSUTF8StringEncoding error:nil];
        [context evaluateScript:jsString];
    }
}

@end
