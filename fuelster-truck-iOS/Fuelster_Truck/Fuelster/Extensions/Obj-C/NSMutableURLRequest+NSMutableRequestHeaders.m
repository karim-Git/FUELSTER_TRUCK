//
//  NSMutableURLRequest+NSMutableRequestHeaders.m
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 17/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import "NSMutableURLRequest+NSMutableRequestHeaders.h"

@implementation NSMutableURLRequest (NSMutableRequestHeaders)


- (void)setupRequestHeadersAllowSession:(BOOL) allow
{
    [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];

    if (allow) {
        [self setValue:[defs objectForKey:@"authToken"] forHTTPHeaderField:@"x-header-authtoken"];
        [self setValue:[defs objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshToken"];

    }
    //kTruckId @"57e13a1f85084d196e8f0b97"
    //57e3ae7db430f0646c84eb29
    //[defs objectForKey:@"_id"]
    //57e54cc0f417f9355e59c158
    
    
    NSLog(@" HEADEER truck id %@",[defs objectForKey:@"_id"]);
    [self setValue:[defs objectForKey:@"_id"] forHTTPHeaderField:@"truck"];
    [self setValue:@"1.0.0" forHTTPHeaderField:@"X-APP-VERSION"];
    [self setValue:@"driver" forHTTPHeaderField:@"role"];
    [self setValue:@"iOS" forHTTPHeaderField:@"os-type"];

}


- (void)setupPostBodyHeader:(id)postBody
{
    if (!postBody) {
        return;
    }
    
    NSError *err;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postBody options:NSJSONWritingPrettyPrinted error:&err];
    
    if (err) {
        
        //NSLog(@" json object error %@",err.description);
    }
    else
    {
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        //if (postLength > 0) {
            [self setHTTPBody:postData];
            [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
        //}
    }
}


@end
