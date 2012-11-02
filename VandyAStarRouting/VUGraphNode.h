//
//  VUGraphNode.h
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VUGraphNode : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, retain) NSSet *neighbors;
@property (nonatomic, retain) NSString *identifer;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) BOOL isSpecialLocation;

+(VUGraphNode*)nodeWithLocation:(CLLocationCoordinate2D)loc Neighbors:(NSSet*)neighs Idenitifier:(NSString*)ident Title:(NSString*)tit andIsSpecialLocation:(BOOL)specLoc;
@end
