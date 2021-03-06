/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@protocol BBStreamControllerDelegate <NSObject>

@required
-(void)pagingLoadingComplete;
-(void)pageLoadingStarted;
-(void)pullToRefreshCompleted;
-(void)displayItems;
-(void)addItemsToTableDataSource:(NSArray*)items;
@property (nonatomic, readwrite) BOOL loading;
@property (nonatomic, readwrite) BOOL noMoreResultsAvail;
@end