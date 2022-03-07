//
//  OcTool.h
//  ConvertJsonStringToModel
//
//  Created by chenyehong on 2022/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OcTool : NSObject

+ (BOOL)isPureFloat: (id)obj;
+ (BOOL)isPureBool: (id)obj;
+ (BOOL)isPureInt: (id)obj;


@end

NS_ASSUME_NONNULL_END
