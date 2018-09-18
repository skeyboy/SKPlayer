//
//  BTInfo.m
//  SKPlayer
//
//  Created by sk on 2018/9/18.
//  Copyright © 2018 sk. All rights reserved.
//

#import "BTInfo.h"
//#import "transmission.h"
//#import "utils.h"
//#import "variant.h"

 @interface BTInfo()
{
//    tr_variant settings;
//    tr_session * session;
    const char * configDir;
//
   
}
@end
@implementation BTInfo
static BTInfo * btInfo = nil;
- (instancetype)init
{
    self = [super init];
    if (self) {
//         configDir = tr_getDefaultConfigDir("Transmission");

//        tr_variantInitDict (&settings, 0);
//        tr_sessionGetDefaultSettings (&settings);
//        configDir = tr_getDefaultConfigDir ("Transmission");
//        session = tr_sessionInit (configDir, true, &settings);
//
//        tr_variantFree (&settings);
    }
    return self;
}
+ (BTInfo *) share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        btInfo = [[BTInfo alloc] init];
    });
    return btInfo;
}
@end
