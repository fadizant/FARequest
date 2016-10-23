//
//  NSDate+FADate.h
//
//  Created by Fadi on 5/4/16.
//  Copyright © 2016 Apprikot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FADate)
+ (nullable NSDate *)dateFromString:(nullable NSString*)string withFormat:(nullable NSString*)format Timezone:(nullable NSString*)zone;

-(nullable NSString*)getStringWithFormat:(nullable NSString*)format;
-(NSInteger) getDay;
-(nullable NSString*) getDayString;
-(NSInteger) getMonth;
-(nullable NSString*) getMonthString;
-(NSInteger) getYear;
-(NSInteger) getSec;
-(NSInteger) getMin;
-(NSInteger) getHour;
#pragma mark Differences

-(NSInteger)getDifferenceYears:(nullable NSDate*)date;
-(NSInteger)getDifferenceMonths:(nullable NSDate*)date;
-(NSInteger)getDifferenceDays:(nullable NSDate*)date;
-(NSInteger)getDifferenceHour:(nullable NSDate*)date;
-(NSInteger)getDifferenceMinutes:(nullable NSDate*)date;
-(NSInteger)getDifferenceSeconds:(nullable NSDate*)date;
@end
