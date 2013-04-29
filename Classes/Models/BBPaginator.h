/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "BBStreamControllerDelegate.h"


@interface BBPaginator : RKPaginator //ß<
    //RKObjectPaginatorDelegate
//>


@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic, readonly) NSUInteger pageCount;
@property (nonatomic, readonly) NSUInteger currentPage;


-(BOOL)moreItemsExist;
-(void)setPageCount:(NSUInteger)pageCount;
-(void)setCurrentPage:(NSUInteger)currentPage;
-(void)setPaginatorLoading:(BOOL)loading;
-(NSDate*)latestFetchedActivityNewer;
-(void)handlePaginatorLoadNextPage;


-(id)initWithPatternURL:(NSURLRequest *)patternURL
        mappingProvider:(RKObjectMapping *)mappingProvider
            andDelegate:(id<BBStreamControllerDelegate>)delegate;


@end