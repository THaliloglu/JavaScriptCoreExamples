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

// =================
// C API
// =================

+(void)loadCApiClassesToContext:(JSContext *)context
{
    JSGlobalContextRef contextRef = [context JSGlobalContextRef];
    JSStringRef str = JSStringCreateWithUTF8CString("UIViewC");
    
//    JSClassDefinition uiviewclassdefinition = kJSClassDefinitionEmpty;
//    uiviewclassdefinition.className = "UIViewC";
//    uiviewclassdefinition.initialize = uiview_class_init_cb;
//    uiviewclassdefinition.finalize = uiview_class_finalize_cb;
//    uiviewclassdefinition.hasProperty = uiview_class_has_property_cb;
//    uiviewclassdefinition.setProperty = uiview_class_set_property_cb;
//    uiviewclassdefinition.getPropertyNames = uiview_class_get_property_names_cb;
//    uiviewclassdefinition.callAsConstructor = uiview_class_construct_cb;
//
//    JSClassRef classDef = JSClassCreate(&uiviewclassdefinition);
    
    JSClassRef classDef = JSClassCreate(&uiviewc_class_def);
    
    JSObjectRef containerConstructor = JSObjectMakeConstructor(contextRef,classDef,uiview_class_construct_cb);
    JSObjectSetProperty(contextRef, JSContextGetGlobalObject(contextRef), str, containerConstructor, kJSPropertyAttributeNone, NULL);
    
    JSStringRelease(str);
    JSClassRelease(classDef);
}

// UIViewClassCallbacks
void uiview_class_init_cb(JSContextRef ctx, JSObjectRef object)
{
    
}

void uiview_class_finalize_cb(JSObjectRef object)
{
    
}

bool uiview_class_has_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName)
{
    return false;
}

JSValueRef uiview_class_get_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef* exception)
{
    return NULL;
}

bool uiview_class_set_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef* exception)
{
    return false;
}

void uiview_class_get_property_names_cb(JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames)
{
    UIView *view = (__bridge UIView *)JSObjectGetPrivate(object);
    view = nil;
}

JSObjectRef uiview_class_construct_cb(JSContextRef ctx, JSObjectRef constructor, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception)
{
    JSGlobalContextRef contextRef = [[JSCoreSupport getGlobalContext] JSGlobalContextRef];
    UIView *view = [UIView new];
    
    JSClassRef classRef = JSClassCreate(&uiviewc_class_def);
    JSObjectRef objectRef = JSObjectMake(contextRef, classRef, (__bridge void *)(view));
    
    return objectRef;
}

// Class Definition
static const JSClassDefinition uiviewc_class_def =
{
    0,                                                  // version The version number of this structure.
    kJSClassAttributeNone,                              // attributes

    "UIViewC",                                          // className
    NULL,                                               // parentClass A JSClass to set as the class's parent class.

    NULL,                                               // staticValues A JSStaticValue array containing the class's statically declared value properties.
    NULL,                                               // staticFunctions A JSStaticFunction array containing the class's statically declared function properties.

    uiview_class_init_cb,                               // initialize The callback invoked when an object is first created.
    uiview_class_finalize_cb,                           // finalize The callback invoked when an object is finalized (prepared for garbage collection).
    uiview_class_has_property_cb,                       // hasProperty The callback invoked when determining whether an object has a property. If this field is NULL, getProperty is called instead.
    uiview_class_get_property_cb,                       // getProperty The callback invoked when getting a property's value.
    uiview_class_set_property_cb,                       // setProperty The callback invoked when setting a property's value.
    NULL,                                               // deleteProperty The callback invoked when deleting a property.
    uiview_class_get_property_names_cb,                 // getPropertyNames The callback invoked when collecting the names of an object's properties.
    NULL,                                               // callAsFunction The callback invoked when an object is called as a function.
    uiview_class_construct_cb,                          // callAsConstructor The callback invoked when an object is used as a constructor in a 'new' expression.
    NULL,                                               // hasInstance The callback invoked when an object is used as the target of an 'instanceof' expression.
    NULL                                                // convertToType The callback invoked when converting an object to a particular JavaScript type.
};

@end
