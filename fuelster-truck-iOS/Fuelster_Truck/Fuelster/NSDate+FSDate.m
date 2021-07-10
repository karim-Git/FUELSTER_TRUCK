//
//  NSDate+FSDate.m
//  Fuelster
//
//  Created by Kareem on 28/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import "NSDate+FSDate.h"

@implementation NSDate (FSDate)

-(NSDate *)dateWithOutTime:(NSDate *)datDate
{
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
    
}

-(NSString *)getDateFormatNotifyString:(NSDate *)datDate
{
    NSDate * notifyDate = [self dateWithOutTime:datDate];
    NSDate * currentDate = [self dateWithOutTime:[NSDate date]];
    
    if ([notifyDate isEqualToDate:currentDate])
    {
        return  @"hh:mm a";
    }
    else
    {
    return @"MM-dd-yyyy";
    }
}

/*
+(NSString *)getFormattedDateString:(NSString *)dateString displayFormat:(NSString *)format
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT_JSON];
    NSDate * date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}
*/

@end
