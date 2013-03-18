//
//  MGGameResult.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/24/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGGameResult : NSObject

@property (strong,nonatomic,readonly) NSString* gameType;
@property (strong,nonatomic,readonly) NSDate* startTime;
@property (strong,nonatomic,readonly) NSDate* endTime;
@property (nonatomic,readonly) NSTimeInterval duration;
@property (nonatomic,readonly) NSInteger score;

-(id)initWithGameType:(NSString*)gameType;
-(void)endGameWithScore:(NSInteger)score;
-(id)initFromPlist:(NSDictionary*)plist;
-(NSDictionary*)toPlist;

-(NSComparisonResult)compareByDate:(MGGameResult*)other;
-(NSComparisonResult)compareByScore:(MGGameResult*)other;
-(NSComparisonResult)compareByDuration:(MGGameResult*)other;

+(NSArray*)allGameResults;
-(void)synchronize;

@end
