//
//  JSCoreSupport.m
//  JavaScriptCoreExamples
//
//  Created by Tolga Haliloğlu on 20.07.2019.
//  Copyright © 2019 TH. All rights reserved.
//

#import "JSCoreSupport.h"
#import "JSExportProtocols.h"
#import "UIViewCAPI.hpp"

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

+(void)loadCApiClassesToContext:(JSContext *)context
{
    JSGlobalContextRef contextRef = [context JSGlobalContextRef];
    
    JSClassDefinition uiviewclassdefinition = kJSClassDefinitionEmpty;
    uiviewclassdefinition.className = "UIViewC";
    uiviewclassdefinition.initialize = uiview_class_init_cb;
    uiviewclassdefinition.finalize = uiview_class_finalize_cb;
    uiviewclassdefinition.hasProperty = uiview_class_has_property_cb;
    uiviewclassdefinition.setProperty = uiview_class_set_property_cb;
    uiviewclassdefinition.callAsConstructor = uiview_class_construct_cb;
    
    JSStringRef str = JSStringCreateWithUTF8CString("UIViewC");
    JSClassRef classDef = JSClassCreate(&uiviewclassdefinition);
    
    JSObjectRef containerConstructor = JSObjectMakeConstructor(contextRef,classDef,uiview_class_construct_cb);
    JSObjectSetProperty(contextRef, JSContextGetGlobalObject(contextRef), str, containerConstructor, kJSPropertyAttributeNone, NULL);
    
    JSStringRelease(str);
    JSClassRelease(classDef);
}

@end
