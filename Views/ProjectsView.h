//
//  ProjectsView.h
//  BowerBird
//
//  Created by Hamish Crittenden on 4/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectsView;

@protocol ProjectTableDataSource

-(NSDictionary *)projectsForProjectTable:(ProjectsView*)sender;

@end

@interface ProjectsView : UITableView

//@property (nonatomic, weak) id<ProjectTableDataSource> projects;

@end
