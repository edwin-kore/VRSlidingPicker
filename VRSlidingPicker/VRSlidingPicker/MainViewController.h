//
//  MainViewController.h
//  VRSlidingPicker
//
//  Created by Venu on 8/5/15.
//  Copyright (c) 2015 VRCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@end

@interface NotesObject : NSObject{
    
}
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *notesDescription;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;

- (void)createNotesObjectWithDictionary:(NSDictionary*)dict;

@end