//
//  NSMutableURLRequest+NSMutableRequestHeaders.h
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 17/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (NSMutableRequestHeaders)


- (void)setupRequestHeadersAllowSession:(BOOL) allow;
- (void)setupPostBodyHeader:(id)postBody;

@end
