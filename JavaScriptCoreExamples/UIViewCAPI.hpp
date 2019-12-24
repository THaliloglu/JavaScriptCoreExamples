//
//  UIViewCAPI.hpp
//  JavaScriptCoreExamples
//
//  Created by Tolga Haliloğlu on 24.12.2019.
//  Copyright © 2019 TH. All rights reserved.
//

#ifndef UIViewCAPI_hpp
#define UIViewCAPI_hpp

#include <stdio.h>
#include <JavaScriptCore/JavaScriptCore.h>

// Callbacks
//static void uiview_class_init_cb(JSContextRef ctx, JSObjectRef object);
//static void uiview_class_finalize_cb(JSObjectRef object);
//
//static bool uiview_class_has_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName);
//static JSValueRef uiview_class_get_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef* exception);
//static bool uiview_class_set_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef* exception);
//
//static void uiview_class_get_property_names_cb(JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames);
//
//static JSObjectRef uiview_class_construct_cb(JSContextRef ctx, JSObjectRef constructor, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception);


static void uiview_class_init_cb(JSContextRef ctx, JSObjectRef object)
{
    
}

static void uiview_class_finalize_cb(JSObjectRef object)
{
    
}

static bool uiview_class_has_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName)
{
    return false;
}

static JSValueRef uiview_class_get_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef* exception)
{
    return NULL;
}

static bool uiview_class_set_property_cb(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef* exception)
{
    return false;
}

static void uiview_class_get_property_names_cb(JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames)
{
    
}

static JSObjectRef uiview_class_construct_cb(JSContextRef ctx, JSObjectRef constructor, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception)
{
    
//    JSClassRef classRef = JSClassCreate(&uiviewc_class_def);
//    JSObjectRef objectRef = JSObjectMake(<#JSContextRef ctx#>, <#JSClassRef jsClass#>, <#void *data#>)
    
    return NULL;
}

// Class Definition
//static const JSClassDefinition uiviewc_class_def =
//{
//    0,                                                  // version The version number of this structure.
//    kJSClassAttributeNone,                              // attributes
//
//    "UIViewC",                                          // className
//    NULL,                                               // parentClass A JSClass to set as the class's parent class.
//
//    NULL,                                               // staticValues A JSStaticValue array containing the class's statically declared value properties.
//    NULL,                                               // staticFunctions A JSStaticFunction array containing the class's statically declared function properties.
//
//    uiview_class_init_cb,                                      // initialize The callback invoked when an object is first created.
//    uiview_class_finalize_cb,                                  // finalize The callback invoked when an object is finalized (prepared for garbage collection).
//    uiview_class_has_property_cb,                              // hasProperty The callback invoked when determining whether an object has a property. If this field is NULL, getProperty is called instead.
//    uiview_class_get_property_cb,                              // getProperty The callback invoked when getting a property's value.
//    uiview_class_set_property_cb,                              // setProperty The callback invoked when setting a property's value.
//    NULL,                                               // deleteProperty The callback invoked when deleting a property.
//    uiview_class_get_property_names_cb,                        // getPropertyNames The callback invoked when collecting the names of an object's properties.
//    NULL,                                               // callAsFunction The callback invoked when an object is called as a function.
//    uiview_class_construct_cb,                                 // callAsConstructor The callback invoked when an object is used as a constructor in a 'new' expression.
//    NULL,                                               // hasInstance The callback invoked when an object is used as the target of an 'instanceof' expression.
//    NULL                                                // convertToType The callback invoked when converting an object to a particular JavaScript type.
//};

#endif /* UIViewCAPI_hpp */
