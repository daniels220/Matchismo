//
//  MGGameResult.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/24/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGameResult.h"

@implementation MGGameResult

-(id)initWithGameType:(NSString *)gameType {
	if (self = [super init]) {
		_gameType = gameType;
		_startTime = [NSDate date];
	}
	return self;
}

-(void)endGameWithScore:(NSInteger)score {
	//Not using setters because this is basically the other half of a constructor
	_endTime = [NSDate date];
	_score = score;
}

-(NSTimeInterval)duration {
	return [self.endTime timeIntervalSinceDate:self.startTime];
}

-(NSComparisonResult)compareByDate:(MGGameResult *)other {
	return [self.startTime compare:other.startTime];
}

-(NSComparisonResult)compareByDuration:(MGGameResult *)other {
	if (other.duration == self.duration)
		return NSOrderedSame;
	if (other.duration > self.duration)
		return NSOrderedAscending;
	return NSOrderedDescending;
}

-(NSComparisonResult)compareByScore:(MGGameResult *)other {
	if (other.score == self.score)
		return NSOrderedSame;
	if (other.score < self.score)
		return NSOrderedAscending;
	return NSOrderedDescending;
}

#define TYPE_KEY @"gameType"
#define START_TIME_KEY @"startTime"
#define END_TIME_KEY @"endTime"
#define SCORE_KEY @"score"
-(id)initFromPlist:(NSDictionary *)plist {
	if (self = [super init]) {
		_gameType = plist[TYPE_KEY];
		_startTime = plist[START_TIME_KEY];
		_endTime = plist[END_TIME_KEY];
		_score = [plist[SCORE_KEY] integerValue];
	}
	return self;
}

-(NSDictionary *)toPlist {
	return @{TYPE_KEY: self.gameType, START_TIME_KEY: self.startTime, END_TIME_KEY: self.endTime, SCORE_KEY: @(self.score)};
}

#define ALL_SCORES_KEY @"MGGameResult_AllResults."
+(NSArray *)allGameResults {
	NSArray* plistResults = [[NSUserDefaults standardUserDefaults] arrayForKey:ALL_SCORES_KEY];
	NSMutableArray* gameObjectResults = [NSMutableArray new];
	for (NSDictionary* plistResult in plistResults)
		[gameObjectResults addObject:[[MGGameResult alloc] initFromPlist:plistResult]];
	return gameObjectResults.copy;
}

-(void)synchronize {
	NSMutableArray* plistResults = [[[NSUserDefaults standardUserDefaults] arrayForKey:ALL_SCORES_KEY] mutableCopy];
	if (!plistResults) plistResults = [NSMutableArray new];
	[plistResults addObject:[self toPlist]];
	[[NSUserDefaults standardUserDefaults] setObject:plistResults forKey:ALL_SCORES_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
