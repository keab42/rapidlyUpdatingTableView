//
//  dummyConversationModel.h
//  RapidlyUpdatingTableTest
//
//  Created by Matthew Keable on 15/05/2016.
//  Copyright © 2016 Matthew Keable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DummyConversationModel : NSManagedObject

@property (nullable, nonatomic, retain) NSString *titleText;
@property (nullable, nonatomic, retain) NSString *dummyText;
@property (nullable, nonatomic, retain) NSDate *timeStamp;
@property (nullable, nonatomic, retain) NSNumber *sectionId;

@end
