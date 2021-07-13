//
//  SIPClient.m
//  pjsip-sample-configuration
//
//  Created by Now Software on 5/28/21.
//

#import "SIPClient.h"

#pragma mark -


@interface SIPClient ()

@end


@implementation SIPClient

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
   
    
    
    
    return self;
}





@end


