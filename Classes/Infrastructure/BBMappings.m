/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBMappings.h"
#import "BBModels.h"


@implementation BBMappings

+(void)mappingsForRKManager:(RKObjectManager*)manager
{
    
    RKObjectMapping *audioMapping = [RKObjectMapping mappingForClass:[BBAudio class]];
    audioMapping.forceCollectionMapping = YES;
    [audioMapping mapKeyOfNestedDictionaryToAttribute:@"dimensionName"];
    [audioMapping mapKeyPath:@"(dimensionName).Uri" toAttribute:@"uri"];
    [audioMapping mapKeyPath:@"(dimensionName).Width" toAttribute:@"width"];
    [audioMapping mapKeyPath:@"(dimensionName).Height" toAttribute:@"height"];
    //[videoMapping mapKeyPath:@"(dimensionName).MimeType" toAttribute:@"mimeType"];
    [manager.mappingProvider setMapping:audioMapping forKeyPath:@"Audio"];
    [manager.mappingProvider addObjectMapping:audioMapping];
    
    
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[BBVideo class]];
    videoMapping.forceCollectionMapping = YES;
    [videoMapping mapKeyOfNestedDictionaryToAttribute:@"dimensionName"];
    [videoMapping mapKeyPath:@"(dimensionName).Uri" toAttribute:@"uri"];
    [videoMapping mapKeyPath:@"(dimensionName).Width" toAttribute:@"width"];
    [videoMapping mapKeyPath:@"(dimensionName).Height" toAttribute:@"height"];
    //[videoMapping mapKeyPath:@"(dimensionName).MimeType" toAttribute:@"mimeType"];
    [manager.mappingProvider setMapping:videoMapping forKeyPath:@"Video"];
    [manager.mappingProvider addObjectMapping:videoMapping];

    
    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[BBImage class]];
    imageMapping.forceCollectionMapping = YES;
    [imageMapping mapKeyOfNestedDictionaryToAttribute:@"dimensionName"];
    [imageMapping mapKeyPath:@"(dimensionName).Uri" toAttribute:@"uri"];
    [imageMapping mapKeyPath:@"(dimensionName).Width" toAttribute:@"width"];
    [imageMapping mapKeyPath:@"(dimensionName).Height" toAttribute:@"height"];
    [imageMapping mapKeyPath:@"(dimensionName).MimeType" toAttribute:@"mimeType"];
    [manager.mappingProvider setMapping:imageMapping forKeyPath:@"Image"];
    [manager.mappingProvider addObjectMapping:imageMapping];


    RKObjectMapping *mediaResourceMapping = [RKObjectMapping mappingForClass:[BBMediaResource class]];
    [mediaResourceMapping mapKeyPath:@"MediaResourceType" toAttribute:@"mediaType"];
    [mediaResourceMapping mapKeyPath:@"UploadedOn" toAttribute:@"uploadedOn"];
    [mediaResourceMapping mapKeyPath:@"Metadata" toAttribute:@"metaData"];
    [mediaResourceMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [mediaResourceMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [mediaResourceMapping mapKeyPath:@"Image" toRelationship:@"imageMedia" withMapping:imageMapping];
    [mediaResourceMapping mapKeyPath:@"Video" toRelationship:@"videoMedia" withMapping:videoMapping];
    [mediaResourceMapping mapKeyPath:@"Audio" toRelationship:@"audioMedia" withMapping:audioMapping];
    [manager.mappingProvider addObjectMapping:mediaResourceMapping];
    

    RKObjectMapping *mediaMapping = [RKObjectMapping mappingForClass:[BBMedia class]];
    [mediaMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [mediaMapping mapKeyPath:@"IsPrimaryMedia" toAttribute:@"isPrimaryMedia"];
    [mediaMapping mapKeyPath:@"Licence" toAttribute:@"licence"];
    [mediaMapping mapKeyPath:@"MediaResource" toRelationship:@"mediaResource" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:mediaMapping forKeyPath:@"Media"];
    [manager.mappingProvider addObjectMapping:mediaMapping];
    
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[BBUser class]];
    [userMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [userMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:userMapping forKeyPath:@"User"];
    [manager.mappingProvider addObjectMapping:userMapping];
    
    
    RKObjectMapping *membershipMapping = [RKObjectMapping mappingForClass:[BBMembership class]];
    [membershipMapping mapKeyPath:@"GroupId" toAttribute:@"groupId"];
    [membershipMapping mapKeyPath:@"GroupType" toAttribute:@"groupType"];
    [membershipMapping mapKeyPath:@"PermissionIds" toAttribute:@"permissions"];
    [membershipMapping mapKeyPath:@"RoleIds" toAttribute:@"roleIds"];
    [manager.mappingProvider setMapping:membershipMapping forKeyPath:@"Memberships"];
    [manager.mappingProvider addObjectMapping:membershipMapping];
    
    
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[BBCategory class]];
    [categoryMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [categoryMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [categoryMapping mapKeyPath:@"Taxonomy" toAttribute:@"taxonomy"];
    [manager.mappingProvider setMapping:categoryMapping forKeyPath:@"Categories"];
    [manager.mappingProvider addObjectMapping:categoryMapping];
    
    
    RKObjectMapping *groupMapping = [RKObjectMapping mappingForClass:[BBGroup class]];
    [groupMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [groupMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [groupMapping mapKeyPath:@"GroupType" toAttribute:@"groupType"];
    [groupMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:groupMapping forKeyPath:@"Group"];
    [manager.mappingProvider addObjectMapping:groupMapping];
    
    
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[BBProject class]];
    [projectMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [projectMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [projectMapping mapKeyPath:@"GroupType" toAttribute:@"groupType"];
    [projectMapping mapKeyPath:@"UserCount" toAttribute:@"userCount"];
    [projectMapping mapKeyPath:@"SightingCount" toAttribute:@"observationCount"];
    [projectMapping mapKeyPath:@"PostCount" toAttribute:@"postCount"];
    [projectMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [projectMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:projectMapping forKeyPath:@"Project"];
    [manager.mappingProvider addObjectMapping:projectMapping];

    
    RKObjectMapping *authenticatedUser = [RKObjectMapping mappingForClass:[BBAuthenticatedUser class]];
    authenticatedUser.rootKeyPath = @"Model.AuthenticatedUser";
    [authenticatedUser mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [authenticatedUser mapKeyPath:@"AppRoot.Categories" toRelationship:@"categories" withMapping:categoryMapping];
    [authenticatedUser mapKeyPath:@"Projects" toRelationship:@"projects" withMapping:projectMapping];
    [authenticatedUser mapKeyPath:@"Memberships" toRelationship:@"memberships" withMapping:membershipMapping];
    [authenticatedUser mapKeyPath:@"DefaultLicence" toAttribute:@"defaultLicence"];
    [manager.mappingProvider setMapping:authenticatedUser forKeyPath:@"Model.AuthenticatedUser"];
    [manager.mappingProvider addObjectMapping:authenticatedUser];
    
    
    RKObjectMapping *authenticationMapping = [RKObjectMapping mappingForClass:[BBAuthentication class]];
    [authenticationMapping mapKeyPath:@"User" toRelationship:@"authenticatedUser" withMapping:userMapping];
    [manager.mappingProvider setMapping:authenticationMapping forKeyPath:@"Model.User"];
    [manager.mappingProvider addObjectMapping:authenticationMapping];
    
    
    RKObjectMapping *taxonomicRankMapping = [RKObjectMapping mappingForClass:[BBTaxonomicRanks class]];
    [taxonomicRankMapping mapKeyPath:@"RankName" toAttribute:@"name"];
    [taxonomicRankMapping mapKeyPath:@"RankType" toAttribute:@"type"];
    [manager.mappingProvider setMapping:taxonomicRankMapping forKeyPath:@"TaxonomicRanks"];
    
    
    RKObjectMapping *identificationMapping = [RKObjectMapping mappingForClass:[BBIdentification class]];
    [identificationMapping mapKeyPath:@"IsCustomIdentification" toAttribute:@"isCustomIdentification"];
    [identificationMapping mapKeyPath:@"Category" toAttribute:@"category"];
    [identificationMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [identificationMapping mapKeyPath:@"RankName" toAttribute:@"rankName"];
    [identificationMapping mapKeyPath:@"RankType" toAttribute:@"rankType"];
    [identificationMapping mapKeyPath:@"CommonGroupNames" toAttribute:@"commonGroupNames"];
    [identificationMapping mapKeyPath:@"CommonNames" toAttribute:@"commonNames"];
    [identificationMapping mapKeyPath:@"Taxonomy" toAttribute:@"taxonomy"];
    [identificationMapping mapKeyPath:@"Synonyms" toAttribute:@"synonyms"];
    [identificationMapping mapKeyPath:@"AllCommonNames" toAttribute:@"allCommonNames"];
    [identificationMapping mapKeyPath:@"Comments" toAttribute:@"comments"];
    [identificationMapping mapKeyPath:@"CreatedOnDescription" toAttribute:@"createdOnDescription"];
    [identificationMapping mapKeyPath:@"Ranks" toRelationship:@"ranks" withMapping:taxonomicRankMapping];
    [identificationMapping mapKeyPath:@"TotalVoteScore" toAttribute:@"totalVoteScore"];
    [identificationMapping mapKeyPath:@"UserVoteScore" toAttribute:@"userVoteScore"];
    [identificationMapping mapKeyPath:@"SightingId" toAttribute:@"sightingId"];
    [identificationMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [identificationMapping mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [manager.mappingProvider setMapping:identificationMapping forKeyPath:@"Identification"];
    [manager.mappingProvider addObjectMapping:identificationMapping];
    
    
    RKObjectMapping *sightingNoteDescriptionMapping = [RKObjectMapping mappingForClass:[BBSightingNoteDescription class]];
    [manager.mappingProvider setMapping:sightingNoteDescriptionMapping forKeyPath:@"Descriptions"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Group" toAttribute:@"group"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Label" toAttribute:@"label"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Text" toAttribute:@"text"];
    [manager.mappingProvider addObjectMapping:sightingNoteDescriptionMapping];
    
    
    RKObjectMapping *observationNoteMapping = [RKObjectMapping mappingForClass:[BBObservationNote class]];
    [manager.mappingProvider setMapping:observationNoteMapping forKeyPath:@"SightingNote"];
    [observationNoteMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [observationNoteMapping mapKeyPath:@"CreatedOn" toAttribute:@"createdOn"];
    [observationNoteMapping mapKeyPath:@"Descriptions" toRelationship:@"descriptions" withMapping:sightingNoteDescriptionMapping];
    [observationNoteMapping mapKeyPath:@"NoteComments" toAttribute:@"noteComments"];
    [observationNoteMapping mapKeyPath:@"Tags" toAttribute:@"tags"];
    [observationNoteMapping mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [observationNoteMapping mapKeyPath:@"TagCount" toAttribute:@"tagCount"];
    [observationNoteMapping mapKeyPath:@"DescriptionCount" toAttribute:@"descriptionCount"];
    [observationNoteMapping mapKeyPath:@"AllTags" toAttribute:@"allTags"];
    [observationNoteMapping mapKeyPath:@"TotalVoteScore" toAttribute:@"totalVoteScore"];
    [observationNoteMapping mapKeyPath:@"UserVoteScore" toAttribute:@"userVoteScore"];
    [observationNoteMapping mapKeyPath:@"SightingId" toAttribute:@"sightingId"];
    [manager.mappingProvider addObjectMapping:observationNoteMapping];
    
    
    RKObjectMapping *observationMapping = [RKObjectMapping mappingForClass:[BBObservation class]];
    [manager.mappingProvider setMapping:observationMapping forKeyPath:@"Observation"];
    [observationMapping mapKeyPath:@"ObservedOn" toAttribute:@"observedOnDate"];
    [observationMapping mapKeyPath:@"Title" toAttribute:@"title"];
    [observationMapping mapKeyPath:@"Address" toAttribute:@"address"];
    [observationMapping mapKeyPath:@"AnonymiseLocation" toAttribute:@"anonymiseLocation"];
    [observationMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [observationMapping mapKeyPath:@"IsIdentificationRequired" toAttribute:@"isIdentificationRequired"];
    [observationMapping mapKeyPath:@"Latitude" toAttribute:@"latitude"];
    [observationMapping mapKeyPath:@"Longitude" toAttribute:@"longitude"];
    [observationMapping mapKeyPath:@"Category" toAttribute:@"category"];
    [observationMapping mapKeyPath:@"Media" toRelationship:@"media" withMapping:mediaMapping];
    [observationMapping mapKeyPath:@"PrimaryMedia" toRelationship:@"primaryMedia" withMapping:mediaMapping];
    [observationMapping mapKeyPath:@"Projects" toRelationship:@"projects" withMapping:projectMapping];
    [observationMapping mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [observationMapping mapKeyPath:@"Notes" toRelationship:@"notes" withMapping:observationNoteMapping];
    [observationMapping mapKeyPath:@"Identifications" toRelationship:@"identifications" withMapping:identificationMapping];
    [observationMapping mapKeyPath:@"CommentCount" toAttribute:@"commentCount"];
    [observationMapping mapKeyPath:@"ProjectCount" toAttribute:@"projectCount"];
    [observationMapping mapKeyPath:@"NoteCount" toAttribute:@"noteCount"];
    [observationMapping mapKeyPath:@"IdentificationCount" toAttribute:@"identificationCount"];
    [observationMapping mapKeyPath:@"TotalVoteScore" toAttribute:@"totalVoteScore"];
    [observationMapping mapKeyPath:@"UserVoteScore" toAttribute:@"userVoteScore"];
    [observationMapping mapKeyPath:@"UserFavourited" toAttribute:@"userFavourited"];
    [observationMapping mapKeyPath:@"FavouritesCount" toAttribute:@"favouritesCount"];
    [manager.mappingProvider addObjectMapping:observationMapping];
    [manager.mappingProvider setMapping:observationMapping forKeyPath:@"Model.Observation"];
    
    
    RKObjectMapping *postMapping = [RKObjectMapping mappingForClass:[BBPost class]];
    [postMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [postMapping mapKeyPath:@"CreatedOnDescription" toAttribute:@"createdOnDescription"];
    [postMapping mapKeyPath:@"Group" toRelationship:@"group" withMapping:groupMapping];
    [postMapping mapKeyPath:@"GroupId" toAttribute:@"groupId"];
    [postMapping mapKeyPath:@"Message" toAttribute:@"message"];
    [postMapping mapKeyPath:@"PostType" toAttribute:@"postType"];
    [postMapping mapKeyPath:@"Subject" toAttribute:@"subject"];
    [postMapping mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [manager.mappingProvider addObjectMapping:postMapping];
    
    
    RKObjectMapping *activityMapping = [RKObjectMapping mappingForClass:[BBActivity class]];
    [activityMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [activityMapping mapKeyPath:@"CreatedDateTime" toAttribute:@"createdOn"];
    [activityMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [activityMapping mapKeyPath:@"CreatedDateTimeOrder" toAttribute:@"order"];
    [activityMapping mapKeyPath:@"Type" toAttribute:@"type"];
    [activityMapping mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [activityMapping mapKeyPath:@"ObservationAdded.Observation" toRelationship:@"observation" withMapping:observationMapping];
    [activityMapping mapKeyPath:@"SightingNoteAdded.SightingNote" toRelationship:@"observationNote" withMapping:observationNoteMapping];
    [activityMapping mapKeyPath:@"SightingNoteAdded.Sighting" toRelationship:@"observationNoteObservation" withMapping:observationMapping];
    [activityMapping mapKeyPath:@"IdentificationAdded.Sighting" toRelationship:@"identificationObservation" withMapping:observationMapping];
    [activityMapping mapKeyPath:@"IdentificationAdded.Identification" toRelationship:@"identification" withMapping:identificationMapping];
    [activityMapping mapKeyPath:@"PostAdded.Post" toRelationship:@"post" withMapping:postMapping];
    [activityMapping mapKeyPath:@"DeletedActivityItem.Message" toAttribute:@"deleted"];
    [manager.mappingProvider addObjectMapping:activityMapping];
    [manager.mappingProvider setSerializationMapping:activityMapping forClass:[BBActivity class]];
    
    
    RKObjectMapping *classificationMapping = [RKObjectMapping mappingForClass:[BBClassification class]];
    [classificationMapping mapKeyPath:@"Taxonomy" toAttribute:@"taxonomy"];
    [classificationMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [classificationMapping mapKeyPath:@"RankPosition" toAttribute:@"rankPosition"];
    [classificationMapping mapKeyPath:@"RankName" toAttribute:@"rankName"];
    [classificationMapping mapKeyPath:@"ParentRankName" toAttribute:@"parentRankName"];
    [classificationMapping mapKeyPath:@"Ranks" toAttribute:@"ranks"];
    [classificationMapping mapKeyPath:@"Category" toAttribute:@"category"];
    [classificationMapping mapKeyPath:@"SpeciesCount" toAttribute:@"speciesCount"];
    [classificationMapping mapKeyPath:@"CommonGroupNames" toAttribute:@"commonGroupNames"];
    [classificationMapping mapKeyPath:@"CommonNames" toAttribute:@"commonNames"];
    [classificationMapping mapKeyPath:@"Synonyms" toAttribute:@"synonyms"];
    [classificationMapping mapKeyPath:@"AllCommonNames" toAttribute:@"allCommonNames"];
    [manager.mappingProvider addObjectMapping:classificationMapping];
    
    
    RKObjectMapping *classificationPaginationMapping = [RKObjectMapping mappingForClass:[BBClassificationPaginator class]];
    classificationPaginationMapping.rootKeyPath = @"Model.Species";
    [classificationPaginationMapping mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [classificationPaginationMapping mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [classificationPaginationMapping mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [classificationPaginationMapping mapKeyPath:@"PagedListItems" toRelationship:@"ranks" withMapping:classificationMapping];
    [manager.mappingProvider setMapping:classificationPaginationMapping forKeyPath:@"Model.Species"];
    
    
    RKObjectMapping *projectPaginationMapping = [RKObjectMapping mappingForClass:[BBProjectPaginator class]];
    projectPaginationMapping.rootKeyPath = @"Model.Projects";
    [projectPaginationMapping mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [projectPaginationMapping mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [projectPaginationMapping mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [projectPaginationMapping mapKeyPath:@"PagedListItems" toRelationship:@"projects" withMapping:projectMapping];
    [manager.mappingProvider setMapping:projectPaginationMapping forKeyPath:@"Model.Projects"];
            
    
    RKObjectMapping *activityPaginationMapping = [RKObjectMapping mappingForClass:[BBActivityPaginator class]];
    activityPaginationMapping.rootKeyPath = @"Model.Activities";
    [activityPaginationMapping mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [activityPaginationMapping mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [activityPaginationMapping mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [activityPaginationMapping mapKeyPath:@"PagedListItems" toRelationship:@"activities" withMapping:activityMapping];
    [manager.mappingProvider setMapping:activityPaginationMapping forKeyPath:@"Model.Activities"];
    
    
    RKObjectMapping *sightingPaginationMapping = [RKObjectMapping mappingForClass:[BBSightingPaginator class]];
    sightingPaginationMapping.rootKeyPath = @"Model.Sightings";
    [sightingPaginationMapping mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [sightingPaginationMapping mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [sightingPaginationMapping mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [sightingPaginationMapping mapKeyPath:@"PagedListItems" toRelationship:@"sightings" withMapping:observationMapping];
    [manager.mappingProvider setMapping:sightingPaginationMapping forKeyPath:@"Model.Sightings"];
    
    
    // this is duplicate as API is unstable 
    RKObjectMapping *jsonResponse = [RKObjectMapping mappingForClass:[BBJsonResponse class]];
    jsonResponse.rootKeyPath = @"Model";
    [jsonResponse mapKeyPath:@"Success" toAttribute:@"success"];
    [manager.mappingProvider addObjectMapping:jsonResponse];
    [manager.mappingProvider setMapping:jsonResponse forKeyPath:@"Model.Success"];
    
    /*
    RKObjectMapping *jsonResponseMapping = [RKObjectMapping mappingForClass:[BBJsonResponse class]];
    jsonResponseMapping.rootKeyPath = @"Model.JsonResult";
    [jsonResponseMapping mapKeyPath:@"Success" toAttribute:@"success"];
    [jsonResponseMapping mapKeyPath:@"Action" toAttribute:@"action"];
    [manager.mappingProvider setMapping:jsonResponseMapping forKeyPath:@"Model.JsonResult"];
    [manager.mappingProvider setSerializationMapping:[jsonResponseMapping inverseMapping] forClass:[BBJsonResponse class]];
    */
    
    RKObjectMapping *mediaResourceCreateMapping = [RKObjectMapping mappingForClass:[BBMediaResourceCreate class]];
    [mediaResourceCreateMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [mediaResourceCreateMapping mapKeyPath:@"Type" toAttribute:@"type"];
    [mediaResourceCreateMapping mapKeyPath:@"Usage" toAttribute:@"usage"];
    [mediaResourceCreateMapping mapKeyPath:@"File" toAttribute:@"file"];
    [mediaResourceCreateMapping mapKeyPath:@"FileName" toAttribute:@"fileName"];
    [manager.mappingProvider addObjectMapping:mediaResourceCreateMapping];
    [manager.mappingProvider setSerializationMapping:[mediaResourceCreateMapping inverseMapping] forClass:[BBMediaResourceCreate class]];
    
    
    RKObjectMapping *observationMediaCreateMapping = [RKObjectMapping mappingForClass:[BBObservationMediaCreate class]];
    observationMediaCreateMapping.rootKeyPath = @"Media";
    [observationMediaCreateMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [observationMediaCreateMapping mapKeyPath:@"MediaResourceId" toAttribute:@"mediaResourceId"];
    [observationMediaCreateMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [observationMediaCreateMapping mapKeyPath:@"Licence" toAttribute:@"licence"];
    [observationMediaCreateMapping mapKeyPath:@"IsPrimaryMedia" toAttribute:@"isPrimaryMedia"];
    [manager.mappingProvider addObjectMapping:observationMediaCreateMapping];
    [manager.mappingProvider setSerializationMapping:[observationMediaCreateMapping inverseMapping] forClass:[BBObservationMediaCreate class]];
    
    
    RKObjectMapping *observationCreateMapping = [RKObjectMapping mappingForClass:[BBObservationCreate class]];
    [observationCreateMapping mapKeyPath:@"Title" toAttribute:@"title"];
    [observationCreateMapping mapKeyPath:@"ObservedOn" toAttribute:@"observedOn"];
    [observationCreateMapping mapKeyPath:@"Latitude" toAttribute:@"latitude"];
    [observationCreateMapping mapKeyPath:@"Longitude" toAttribute:@"longitude"];
    [observationCreateMapping mapKeyPath:@"Address" toAttribute:@"address"];
    [observationCreateMapping mapKeyPath:@"IsIdentificationRequired" toAttribute:@"isIdentificationRequired"];
    [observationCreateMapping mapKeyPath:@"AnonymiseLocation" toAttribute:@"anonymiseLocation"];
    [observationCreateMapping mapKeyPath:@"Category" toAttribute:@"category"];
    [observationCreateMapping mapKeyPath:@"Media" toRelationship:@"media" withMapping:observationMediaCreateMapping];
    [observationCreateMapping mapKeyPath:@"ProjectIds" toAttribute:@"projectIds"];
    [manager.mappingProvider addObjectMapping:observationCreateMapping];
    [manager.mappingProvider setSerializationMapping:[observationCreateMapping inverseMapping] forClass:[BBObservationCreate class]];
    
    
    RKObjectMapping *sightingNoteDescriptionCreateMapping = [RKObjectMapping mappingForClass:[BBSightingNoteDescriptionCreate class]];
    [sightingNoteDescriptionCreateMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [sightingNoteDescriptionCreateMapping mapKeyPath:@"Value" toAttribute:@"value"];
    [manager.mappingProvider addObjectMapping:sightingNoteDescriptionCreateMapping];
    [manager.mappingProvider setSerializationMapping:[sightingNoteDescriptionCreateMapping inverseMapping] forClass:[BBSightingNoteDescriptionCreate class]];
    
    
    RKObjectMapping *sightingNoteCreateMapping = [RKObjectMapping mappingForClass:[BBSightingNoteCreate class]];
    [sightingNoteCreateMapping mapKeyPath:@"SightingId" toAttribute:@"sightingId"];
    [sightingNoteCreateMapping mapKeyPath:@"Descriptions" toRelationship:@"descriptions" withMapping:sightingNoteDescriptionCreateMapping];
    [sightingNoteCreateMapping mapKeyPath:@"Tags" toAttribute:@"tags"];
    [sightingNoteCreateMapping mapKeyPath:@"Taxonomy" toAttribute:@"taxonomy"];
    [manager.mappingProvider addObjectMapping:sightingNoteCreateMapping];
    [manager.mappingProvider setSerializationMapping:[sightingNoteCreateMapping inverseMapping] forClass:[BBSightingNoteCreate class]];
    
    
    RKObjectMapping *identifySightingMapping = [RKObjectMapping mappingForClass:[BBIdentifySightingEdit class]];
    [identifySightingMapping mapKeyPath:@"SightingId" toAttribute:@"sightingId"];
    [identifySightingMapping mapKeyPath:@"Taxonomy" toAttribute:@"taxonomy"];
    [identifySightingMapping mapKeyPath:@"IsCustomIdentification" toAttribute:@"isCustomIdentification"];
    [manager.mappingProvider addObjectMapping:identifySightingMapping];
    [manager.mappingProvider setSerializationMapping:[identifySightingMapping inverseMapping] forClass:[BBIdentifySightingEdit class]];
    
    
    RKObjectMapping *voteCreateMapping = [RKObjectMapping mappingForClass:[BBVoteCreate class]];
    //[voteCreateMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    //[voteCreateMapping mapKeyPath:@"subId" toAttribute:@"subIdentifier"];
    //[voteCreateMapping mapKeyPath:@"contributionType" toAttribute:@"contributionType"];
    //[voteCreateMapping mapKeyPath:@"subContributionType" toAttribute:@"subContributionType"];
    [voteCreateMapping mapKeyPath:@"Score" toAttribute:@"score"];
    [manager.mappingProvider addObjectMapping:voteCreateMapping];
    [manager.mappingProvider setSerializationMapping:[voteCreateMapping inverseMapping] forClass:[BBVoteCreate class]];
    
    
    RKObjectMapping *subVoteCreateMapping = [RKObjectMapping mappingForClass:[BBSubVoteCreate class]];
    //[subVoteCreateMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    //[subVoteCreateMapping mapKeyPath:@"subId" toAttribute:@"subIdentifier"];
    //[subVoteCreateMapping mapKeyPath:@"contributionType" toAttribute:@"contributionType"];
    //[subVoteCreateMapping mapKeyPath:@"subContributionType" toAttribute:@"subContributionType"];
    [subVoteCreateMapping mapKeyPath:@"Score" toAttribute:@"score"];
    [manager.mappingProvider addObjectMapping:subVoteCreateMapping];
    [manager.mappingProvider setSerializationMapping:[subVoteCreateMapping inverseMapping] forClass:[BBSubVoteCreate class]];
    
    
    RKObjectMapping *modelIdMapping = [RKObjectMapping mappingForClass:[BBModelId class]];
    [modelIdMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [manager.mappingProvider addObjectMapping:modelIdMapping];
    [manager.mappingProvider setSerializationMapping:[modelIdMapping inverseMapping] forClass:[BBModelId class]];
    
    
    RKObjectMapping *projectIdMapping = [RKObjectMapping mappingForClass:[BBProjectId class]];
    [projectIdMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [manager.mappingProvider addObjectMapping:projectIdMapping];
    [manager.mappingProvider setSerializationMapping:[projectIdMapping inverseMapping] forClass:[BBProjectId class]];
    
    
    RKObjectMapping *favouriteMapping = [RKObjectMapping mappingForClass:[BBFavouriteId class]];
    [favouriteMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [manager.mappingProvider addObjectMapping:favouriteMapping];
    [manager.mappingProvider setSerializationMapping:[favouriteMapping inverseMapping] forClass:[BBFavouriteId class]];
    
    
    // using escapeRoutedPath:NO prevents url encoding: http://stackoverflow.com/questions/9688113/avoid-uri-encoding-on-restkit-routers
    [manager.router routeClass:[BBMediaResourceCreate class] toResourcePath:@"/mediaresources" forMethod:RKRequestMethodPOST];
    [manager.router routeClass:[BBObservationCreate class] toResourcePath:@"/observations" forMethod:RKRequestMethodPOST];
    [manager.router routeClass:[BBIdentifySightingEdit class] toResourcePath:@"/:sightingId/identifications" forMethod:RKRequestMethodPOST escapeRoutedPath:NO];
    [manager.router routeClass:[BBSightingNoteCreate class] toResourcePathPattern:@"/:sightingId/notes" forMethod:RKRequestMethodPOST escapeRoutedPath:NO];
    [manager.router routeClass:[BBFavouriteId class] toResourcePath:@"/favourites" forMethod:RKRequestMethodPOST escapeRoutedPath:NO];
    [manager.router routeClass:[BBProjectId class] toResourcePath:@"/:identifier/members" forMethod:RKRequestMethodPOST escapeRoutedPath:NO];// this may not be serverside refactored yet
    [manager.router routeClass:[BBVoteCreate class] toResourcePath:@"/:identifier/vote" forMethod:RKRequestMethodPOST escapeRoutedPath:NO];
    [manager.router routeClass:[BBSubVoteCreate class] toResourcePath:@"/:identifier/:subIdentifier/vote" forMethod:RKRequestMethodPOST escapeRoutedPath:NO];
    [manager.router routeClass:[BBAuthenticatedUser class] toResourcePath:@"/account/profile" forMethod:RKRequestMethodGET escapeRoutedPath:NO];
}

@end