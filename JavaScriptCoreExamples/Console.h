//
//  Console.h
//  JavaScriptCoreExamples
//
//  Created by Tolga Haliloğlu on 20.07.2019.
//  Copyright © 2019 TH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol ConsoleExport <JSExport>

+(void)log:(NSString *)message;

@end

@interface Console : NSObject <ConsoleExport>

+(void)log:(NSString *)message;

@end
