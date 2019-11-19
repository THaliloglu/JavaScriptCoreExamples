//
//  JSCoreSupport.h
//  JavaScriptCoreExamples
//
//  Created by Tolga Haliloğlu on 20.07.2019.
//  Copyright © 2019 TH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSCoreSupport : NSObject

+(JSContext *)getGlobalContext;
+(void)runWithContext:(JSContext *)context;

@end
