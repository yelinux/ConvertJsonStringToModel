//
//  OcTool.m
//  ConvertJsonStringToModel
//
//  Created by chenyehong on 2022/2/22.
//

#import "OcTool.h"

@implementation OcTool

+ (BOOL)isPureFloat: (id)obj{
    if ([obj isKindOfClass:[NSNumber class]]) {
        if (strcmp([obj objCType], @encode(float)) == 0 ||
            strcmp([obj objCType], @encode(CGFloat)) == 0) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isPureBool: (id)obj{
    if ([obj isKindOfClass:[NSNumber class]]) {
        if (strcmp([obj objCType], @encode(BOOL)) == 0) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isPureInt: (id)obj{
    NSScanner *scan = [NSScanner scannerWithString:[NSString stringWithFormat:@"%@", obj]];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}



@end
