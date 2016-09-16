//
//  NSDate+FADate.m
//  Gloocall
//
//  Created by Fadi on 5/4/16.
//  Copyright © 2016 Apprikot. All rights reserved.
//

#import "NSDate+FADate.h"

@implementation NSDate (FADate)

+ (nullable NSDate *)dateFromString:(nullable NSString*)string withFormat:(nullable NSString*)format Timezone:(nullable NSString*)zone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:zone]];//@"UTC"
    return [formatter dateFromString:string];
}

-(NSString*)getStringWithFormat:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

-(NSInteger) getDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    
    return [components day];
}

-(nullable NSString*) getDayString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:self];
    
    //return [[[NSDateFormatter alloc] init] shortWeekdaySymbols][[self getDay]-1];
}

-(NSInteger) getMonth
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    
    return [components month];
}

-(nullable NSString*) getMonthString
{
    return [[[NSDateFormatter alloc] init] shortMonthSymbols][[self getMonth]-1];
}

-(NSInteger) getYear
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    
    return [components year];
}

-(NSInteger) getSec
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:self];
    
    return [components second];
}

-(NSInteger) getMin
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:self];
    
    return [components minute];
}

-(NSInteger) getHour
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:self];
    
    return [components hour];
}


#pragma mark Differences

-(NSInteger)getDifferenceYears:(NSDate*)date
{
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitYear
                                                 fromDate: self toDate: date options: 0];
    return [components year];
}

-(NSInteger)getDifferenceMonths:(NSDate*)date
{
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth
                                                 fromDate: self toDate: date options: 0];
    return [components month];
}

-(NSInteger)getDifferenceDays:(NSDate*)date
{
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay
                                                 fromDate: self toDate: date options: 0];
    return [components day];
}

-(NSInteger)getDifferenceHour:(NSDate*)date
{
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitHour
                                                 fromDate: self toDate: date options: 0];
    return [components hour];
}

-(NSInteger)getDifferenceMinutes:(NSDate*)date
{
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitMinute
                                                 fromDate: self toDate: date options: 0];
    return [components minute];
}

-(NSInteger)getDifferenceSeconds:(NSDate*)date
{
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond
                                                 fromDate: self toDate: date options: 0];
    return [components second];
}
@end
