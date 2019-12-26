//
//  JSCoreSupport.m
//  JavaScriptCoreExamples
//
//  Created by Tolga Haliloğlu on 20.07.2019.
//  Copyright © 2019 TH. All rights reserved.
//

#import "JSCoreSupport.h"
#import "JSExportProtocols.h"
#import "UIView+JavaScriptCoreDemo.h"

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

// =======================
// C API
// =======================

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

// =======================
#pragma mark UIViewClassCallbacks
// =======================
void uiview_class_init_cb(JSContextRef ctx, JSObjectRef object)
{
    
}

void uiview_class_finalize_cb(JSObjectRef object)
{
    UIView *view = (__bridge UIView *)JSObjectGetPrivate(object);
    view = nil;
}

bool uiview_class_has_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName)
{
    bool returnValue = false;
    NSString* propName = (NSString*)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, propertyName));
    
    if ([propName isEqualToString:@"setFrame"]){
        returnValue = true;
    } else if ([propName isEqualToString:@"backgroundColor"] ||
               [propName isEqualToString:@"addSubview"] ||
               [propName isEqualToString:@"addToSuperview"]){
        returnValue = false;
    }
    
    return returnValue;
}

JSValueRef uiview_class_get_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef* exception)
{
    JSValueRef returnValue = JSValueMakeNull(ctx);
    NSString* propName = (NSString*)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, propertyName));
    
    if ([propName isEqualToString:@"setFrame"]) {
        JSStringRef str = JSStringCreateWithUTF8CString("setFrame");
        returnValue = JSObjectMakeFunctionWithCallback(ctx, str, cb_set_frame);
        JSStringRelease(str);
    } else if ([propName isEqualToString:@"addSubview"]) {
        JSStringRef str = JSStringCreateWithUTF8CString("addSubview");
        returnValue = JSObjectMakeFunctionWithCallback(ctx, str, cb_add_subview);
        JSStringRelease(str);
    } else if ([propName isEqualToString:@"addToSuperview"]) {
        JSStringRef str = JSStringCreateWithUTF8CString("addToSuperview");
        returnValue = JSObjectMakeFunctionWithCallback(ctx, str, cb_addto_superview);
        JSStringRelease(str);
    } else if ([propName isEqualToString:@"backgroundColor"]) {
        UIView *view = (__bridge UIView *)JSObjectGetPrivate(object);
        JSValue *backgroundColorValue = [JSValue valueWithObject:view.backgroundColor inContext:[JSContext contextWithJSGlobalContextRef:(JSGlobalContextRef)ctx]];
        returnValue = [backgroundColorValue JSValueRef];
    }
    
    return returnValue;
}

bool uiview_class_set_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef* exception)
{
    bool returnValue = false;
    NSString* propName = (NSString*)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, propertyName));
    
    UIView *view = (__bridge UIView *)JSObjectGetPrivate(object);
    
    if ([propName isEqualToString:@"backgroundColor"]) {
//        TODO : NEED TO FIX THIS arguments[] BECOME NIL
//        JSValue *colorValue = [JSValue valueWithJSValueRef:value inContext:[JSContext contextWithJSGlobalContextRef:(JSGlobalContextRef)ctx]];
//        UIColor *backgroundColor = [colorValue toObjectOfClass:[UIColor class]];
//
//        [view setBackgroundColor:backgroundColor];
        returnValue = true;
    }
    
    return returnValue;
}

JSObjectRef uiview_class_construct_cb(JSContextRef ctx, JSObjectRef constructor, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception)
{
    UIView *view = [UIView new];
    
    // WORKAROUND
    view.backgroundColor = [UIColor blackColor];
    UIViewController *vc = [[JSContext contextWithJSGlobalContextRef:JSContextGetGlobalContext(ctx)][@"mainViewController"] toObjectOfClass:[UIViewController class]];
    [vc.view addSubview:view];
    
    JSClassRef classRef = JSClassCreate(&uiviewc_class_def);
    JSObjectRef objectRef = JSObjectMake(ctx, classRef, (__bridge_retained void *)(view));
    
//    JSValueProtect(ctx, objectRef);
    
    return objectRef;
}

// =======================
#pragma mark Functions
// =======================
JSValueRef cb_set_frame(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception) {
    
    JSValueRef returnValue = JSValueMakeBoolean(ctx, false);
    
    UIView *view = (__bridge UIView *)JSObjectGetPrivate(thisObject);
    
    if (argumentCount == 4) {
        int x = (int)JSValueToNumber(ctx, arguments[0], NULL);
        int y = (int)JSValueToNumber(ctx, arguments[1], NULL);
        int width = (int)JSValueToNumber(ctx, arguments[2], NULL);
        int height = (int)JSValueToNumber(ctx, arguments[3], NULL);
        
        CGRect newframe = CGRectMake(x, y, width, height);
        [view setFrame:newframe];
        
        returnValue = JSValueMakeBoolean(ctx, true);
    }
    
    return returnValue;
}

JSValueRef cb_add_subview(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception) {
    JSValueRef returnValue = JSValueMakeBoolean(ctx, false);
    
    UIView *view = (__bridge UIView *)JSObjectGetPrivate(thisObject);
    
    if (argumentCount == 1) {
//        TODO : NEED TO FIX THIS arguments[] BECOME NIL
//        JSObjectRef valueObjectRef = JSValueToObject(ctx, arguments[0], NULL);
//        UIView *subView = (__bridge UIView *)JSObjectGetPrivate(valueObjectRef);
//        [view addSubview:subView];
        
        returnValue = JSValueMakeBoolean(ctx, true);
    }
    
    return returnValue;
}

JSValueRef cb_addto_superview(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception) {
    JSValueRef returnValue = JSValueMakeBoolean(ctx, false);
    
    UIView *view = (__bridge UIView *)JSObjectGetPrivate(thisObject);
    
    if (argumentCount == 1) {
//        TODO : NEED TO FIX THIS arguments[] BECOME NIL
//        JSObjectRef valueObjectRef = JSValueToObject(ctx, arguments[0], NULL);
//        UIView *superView = (__bridge UIView *)JSObjectGetPrivate(valueObjectRef);
//
//        JSValue *superViewValue = [JSValue valueWithJSValueRef:arguments[0] inContext:[JSContext contextWithJSGlobalContextRef:JSContextGetGlobalContext(ctx)]];
//        UIView *superView = [superViewValue toObjectOfClass:[UIView class]];
//
//        [superView addSubview:view];
//
//        returnValue = JSValueMakeBoolean(ctx, true);
    }
    
    return returnValue;
}

JSValueRef static_cb_animate(JSContextRef ctx, JSObjectRef function, JSObjectRef object, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception){
    JSValueRef returnValue = JSValueMakeBoolean(ctx, false);
    
    if (argumentCount == 3) {
//        int duration = (int)JSValueToNumber(ctx, arguments[0], NULL);
//        JSObjectRef animationsFunction = JSValueToObject(ctx, arguments[1], NULL);
//        JSObjectRef completionFunction = JSValueToObject(ctx, arguments[2], NULL);
        
//        [UIView __animateWithDuration:duration context:ctx animationsObject:animationsFunction completionObject:completionFunction];
        
//        TODO : NEED TO FIX THIS arguments[] BECOME NIL
//        JSValue *animationsValue = [JSValue valueWithJSValueRef:animationsFunction inContext:[JSContext currentContext]];
//        JSValue *completionValue = [JSValue valueWithJSValueRef:completionFunction inContext:[JSContext currentContext]];
//        [UIView __animateWithDuration:duration animations:animationsValue completion:completionValue];
        
        returnValue = JSValueMakeBoolean(ctx, true);
    }
    
    return returnValue;
}

static JSStaticFunction staticFunctions[] = {
    { "animate", static_cb_animate, kJSPropertyAttributeReadOnly | kJSPropertyAttributeDontDelete },
    { 0, 0, 0 }
};

// =======================
#pragma mark Class Definition
// =======================
static const JSClassDefinition uiviewc_class_def =
{
    0,                                                  // version The version number of this structure.
    kJSClassAttributeNone,                              // attributes

    "UIViewC",                                          // className
    NULL,                                               // parentClass A JSClass to set as the class's parent class.

    NULL,                                               // staticValues A JSStaticValue array containing the class's statically declared value properties.
    staticFunctions,                                    // staticFunctions A JSStaticFunction array containing the class's statically declared function properties.

    uiview_class_init_cb,                               // initialize The callback invoked when an object is first created.
    uiview_class_finalize_cb,                           // finalize The callback invoked when an object is finalized (prepared for garbage collection).
    uiview_class_has_property_cb,                       // hasProperty The callback invoked when determining whether an object has a property. If this field is NULL, getProperty is called instead.
    uiview_class_get_property_cb,                       // getProperty The callback invoked when getting a property's value.
    uiview_class_set_property_cb,                       // setProperty The callback invoked when setting a property's value.
    NULL,                                               // deleteProperty The callback invoked when deleting a property.
    NULL,                                               // getPropertyNames The callback invoked when collecting the names of an object's properties.
    NULL,                                               // callAsFunction The callback invoked when an object is called as a function.
    uiview_class_construct_cb,                          // callAsConstructor The callback invoked when an object is used as a constructor in a 'new' expression.
    NULL,                                               // hasInstance The callback invoked when an object is used as the target of an 'instanceof' expression.
    NULL                                                // convertToType The callback invoked when converting an object to a particular JavaScript type.
};

@end
