//
//  NSDate+FSDate.h
//  Fuelster
//
//  Created by Kareem on 28/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FSDate)
-(NSDate *)dateWithOutTime:(NSDate *)datDate;
-(NSString *)getDateFormatNotifyString:(NSDate *)datDate;
@end
