//
//  OAuthTests.swift
//  Spartan
//
//  Created by Dalton Hinterscher on 1/21/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Spartan

class OAuthTests: BaseTests {
    
    private let categoryId = "party"
    private let artistToFollowId = "74ASZWbe4lXaubB36ztrGX"
    private let userToFollowId = "onehintwonder"
    private let spartanUserId = "spartangithub"
    private let spartanPlaylistId = "53DijuDdXcYn54z0OUr8FY"
    
    private let trackIdsToSave = ["3TwtrR1yNLY1PMPsrGQpOp", "0B5KeB25moPkcQUnbDvj3t", "5OVofGV3opkR1hq0C9RSCu"]
    private let trackIdsToRemove = ["3TwtrR1yNLY1PMPsrGQpOp", "0B5KeB25moPkcQUnbDvj3t"]
    private let trackIdToNeverRemove = "5OVofGV3opkR1hq0C9RSCu"
    private let trackUrisToSave = ["spotify:track:3TwtrR1yNLY1PMPsrGQpOp", "spotify:track:0B5KeB25moPkcQUnbDvj3t", "spotify:track:5OVofGV3opkR1hq0C9RSCu"]
    private let trackUrisToRemove = ["spotify:track:3TwtrR1yNLY1PMPsrGQpOp", "spotify:track:0B5KeB25moPkcQUnbDvj3t"]
    
    private let albumIdsToSave = ["5MqEXYwwyJYjOb3g7vJ9ZY", "3o03nl4jDQYUDuX9d8lylY", "1wPbjuINyeQRPPGdLeE4ZH"]
    private let albumIdsToRemove = ["5MqEXYwwyJYjOb3g7vJ9ZY", "3o03nl4jDQYUDuX9d8lylY"]
    private let albumIdToNeverRemove = "1wPbjuINyeQRPPGdLeE4ZH"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Spartan.loggingEnabled = true
        Spartan.authorizationToken = "BQDx206q5Z8ZOTn7H4FX6oLOOooqhyd3kRE3O2tOHI5xyrA9DVxpABuTUXROB1z2ORAE_2Ck8knN0ENQ59Dh8G4BLnfEYMCO9jFAtHFCKmPic_czPjEqHkHyvlV2jE-UmVIrN0BN5eFCCN_iSAOgcO722PNBhUj6STCaXOpyescFSmTHxSuU4vlv_pVJYUXEaxULWRDoDTrngwrQQxUf0JFveY8OOGcnB51CdGwYldF6RZ4aUBGTUUIf99zn4EdkD27reCRCal30_Kvd4AOmNmyo-S4FPqgbxpR8iBFxLfSKDwKWX_mOQlTor80"
    }
    
    func testThatGetAudioAnalysisRequestCorrectlyMapsAudioAnalysisForGivenTrackIdWithAuthorizationToken() {
        
        _ = Spartan.getAudioAnaylsis(trackId: trackId, success: { (audioAnalysis) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMeRequestCorrectlyMapsUserAssociatedWithAuthorizationToken() {
        
        _ = Spartan.getMe(success: { (user) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetAudioFeaturesRequestCorrectlyMapsAudioFeaturesObjectForGivenTrackWithIdWithAuthorizationToken() {
        
        _ = Spartan.getAudioFeatures(trackId: trackId, success: { (audioFeaturesObject) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
         }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
         })
        
        waitForRequestToFinish()
    }
    
    func testThatGetAudioFeaturesRequestCorrectlyMapsAudioFeaturesObjectsForGivenTracksWithIdsWithAuthorizationToken() {
        
        _ = Spartan.getAudioFeatures(trackIds: [trackId, trackId, trackId], success: { (audioFeaturesObjects) in
            self.validationExpectation.fulfill()
            XCTAssert(audioFeaturesObjects.count == 3)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetFeaturedPlaylistsRequestsCorrectlyMapsFeaturedPlaylistsObjectWithAuthorizationToken() {
        
        _ = Spartan.getFeaturedPlaylists(success: { (featuredPlaylistsObject) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetNewReleasesRequestsCorrectlyMapsAlbumObjectsWithAuthorizationToken() {
        
        _ = Spartan.getNewReleases(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetCategoriesRequestsCorrectlyMapsCategoryObjectsWithAuthorizationToken() {
        
        _ = Spartan.getCategories(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatGetCategoryRequestCorrectlyMapsCategoryObjectWithAuthorizationToken() {
        
        _ = Spartan.getCategory(id: categoryId, success: { (category) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetCategorysPlaylistsRequestsCorrectlyMapsCategoryObjectsWithAuthorizationToken() {
        
        _ = Spartan.getCategorysPlaylists(categoryId: categoryId, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMeRequestCorrectlyMapsUserObjectWithAuthorizationToken() {
        
        _ = Spartan.getMe(success: { (user) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMyFollowedArtistsRequestCorrectlyMapsArtistObjectsWithAuthorizationToken() {
        
        _ = Spartan.getMyFollowedArtists(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatFollowRequestCorrectlyWorksForArtistTypeWithAuthorizationToken() {
        
        _ = Spartan.follow(ids: [artistToFollowId], type: .artist, success: { 
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatFollowRequestCorrectlyWorksForUserTypeWithAuthorizationToken() {
        
        _ = Spartan.follow(ids: [userToFollowId], type: .user, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatUnfollowRequestCorrectlyWorksForArtistTypeWithAuthorizationToken() {
        
        _ = Spartan.unfollow(ids: [artistToFollowId], type: .artist, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatUnfollowRequestCorrectlyWorksForUserTypeWithAuthorizationToken() {
        
        _ = Spartan.unfollow(ids: [userToFollowId], type: .user, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatFollowContainsRequestCorrectlyWorksForArtistTypeWithAuthorizationToken() {
        
        _ = Spartan.getIsFollowing(ids: [artistToFollowId, artistToFollowId, artistToFollowId], type: .artist, success: { (followingBools) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatFollowContainsRequestCorrectlyWorksForUserTypeWithAuthorizationToken() {
        
        _ = Spartan.getIsFollowing(ids: [userToFollowId, userToFollowId, userToFollowId], type: .user, success: { (followingBools) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatFollowPlaylistRequestCorrectlyFollowsPlaylistForGivenIdWithAuthorizationToken() {
        
        _ = Spartan.followPlaylist(ownerId: spartanUserId, playlistId: spartanPlaylistId, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatUnfollowPlaylistRequestCorrectlyUnfollowsPlaylistForGivenIdWithAuthorizationToken() {
        
        let playlistName = UUID.init().uuidString
        _ = Spartan.createPlaylist(userId: spartanUserId, name: playlistName, success: { (playlist) in
            
            _ = Spartan.unfollowPlaylist(ownerId: self.spartanUserId, playlistId: playlist.id! as! String, success: {
                self.validationExpectation.fulfill()
                XCTAssert(true)
            }, failure: { (error) in
                self.validationExpectation.fulfill()
                XCTFail(error.errorMessage)
            })
        
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSaveTracksRequestCorrectlySavesTracksForUserWithAuthorizationToken() {
        
        _ = Spartan.saveTracks(trackIds: trackIdsToSave, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetSavedTracksRequestCorrectlyGetsSavedTracksForUserWithAuthorizationToken() {
        
        _ = Spartan.getSavedTracks(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatRemoveSavedTracksRequestCorrectlyRemovesTracksForUserWithAuthorizationToken() {
        
        _ = Spartan.removeSavedTracks(trackIds: trackIdsToRemove, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSavedTracksContainCorrectlyReturnsBoolArrayForUserWithAuthorizationToken() {
        
        _ = Spartan.tracksAreSaved(trackIds: [trackIdToNeverRemove, trackId], success: { (savedBools) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSaveAlbumsRequestCorrectlySavesAlbumsForUserWithAuthorizationToken() {
        
        _ = Spartan.saveAlbums(albumIds: albumIdsToSave, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetSavedAlbumsRequestCorrectlyGetsSavedAlbumsForUserWithAuthorizationToken() {
        
        _ = Spartan.getSavedAlbums(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatRemoveSavedAlbumsRequestCorrectlyRemovesAlbumsForUserWithAuthorizationToken() {
        
        _ = Spartan.removeSavedAlbums(albumIds: albumIdsToRemove, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSavedAlbumsContainCorrectlyReturnsBoolArrayForUserWithAuthorizationToken() {
        
        _ = Spartan.albumsAreSaved(albumIds: [albumIdToNeverRemove, albumId], success: { (savedBools) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMyTopArtistsRequestCorrectlyMapsTopArtistsWithAuthorizationToken() {
        
        _ = Spartan.getMyTopArtists(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMyTopTracksRequestCorrectlyMapsTopTracksWithAuthorizationToken() {
        
        _ = Spartan.getMyTopArtists(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    
    func testThatGetRecommendationsRequestCorrectlyMapsReccomendationsObjectWithAuthorizationToken() {
        
        let minAttributes: [(TuneableTrackAttribute, Float)] = [(.energy, 0.4)]
        let maxAttributes: [(TuneableTrackAttribute, Float)] = [(.energy, 0.6)]
        
        _ = Spartan.getRecommendations(minAttributes: minAttributes, maxAttributes: maxAttributes, seedArtists: ["4NHQUGzhtTLFvgF5SZesLK"], success: { (recomendationsObject) in
            self.validationExpectation.fulfill()
            XCTAssert(recomendationsObject.tracks.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
        
    }
    
    func testThatGetUsersPlaylistsRequestCorrectlyGetsUsersPlaylistsWithAuthorizationToken() {
        
        _ = Spartan.getUsersPlaylists(userId: spartanUserId, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMyPlaylistsRequestCorrectlyGetsMyPlaylistsWithAuthorizationToken() {
        
        _ = Spartan.getMyPlaylists(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetUsersPlaylistRequestCorrectlyGetsUserPlaylistWithIdWithAuthorizationToken() {
        
        _ = Spartan.getUsersPlaylist(userId: spartanUserId, playlistId: spartanPlaylistId, success: { (playlist) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatGetPlaylistTracksRequestCorrectlyGetsPlaylistTracksWithAuthorizationToken() {
        
        _ = Spartan.getPlaylistTracks(userId: spartanUserId, playlistId: spartanPlaylistId, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatCreatePlaylistRequestCorrectlyCreatesPlaylistWithAuthorizationToken() {
        
        let playlistName = UUID.init().uuidString
        _ = Spartan.createPlaylist(userId: spartanUserId, name: playlistName, success: { (playlist) in
            
            _ = Spartan.unfollowPlaylist(ownerId: self.spartanUserId, playlistId: playlist.id as! String, success: nil, failure: nil)
            
            self.validationExpectation.fulfill()
            XCTAssert(playlist.name == playlistName)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatChangePlaylistDetailsCorrectlyChangesPlaylistDetailsWithAuthorizationToken() {
        
        let originalPlaylistName = UUID.init().uuidString
        let changedPlaylistName = UUID.init().uuidString
        _ = Spartan.createPlaylist(userId: spartanUserId, name: originalPlaylistName, success: { (playlist) in
            
            _ = Spartan.changePlaylistDetails(userId: self.spartanUserId, playlistId: playlist.id! as! String, name: changedPlaylistName, isPublic: false, isCollaborative: false, success: { () in
                
                self.validationExpectation.fulfill()
                XCTAssert(true)
                
            }, failure: { (error) in
                self.validationExpectation.fulfill()
                XCTFail(error.errorMessage)
            })
            
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatAddTracksToPlaylistRequestCorrectlyAddsTracksToPlaylistWithAuthorizationToken() {
        
        _ = Spartan.addTracksToPlaylist(userId: spartanUserId, playlistId: spartanPlaylistId, trackUris: trackUrisToSave, success: { (snapshotResponse) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatRemoveTracksFromPlaylistRequestCorrectlyRemovesTracksFromPlaylistWithAuthorizationToken() {
        
        _ = Spartan.removeTracksFromPlaylist(userId: spartanUserId, playlistId: spartanPlaylistId, trackUris: trackUrisToRemove, success: { (snapshotResponse) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatReorderPlaylistsTracksRequestCorrectlyReordersPlaylistTracksWithAuthorizationToken() {
        
        _ = Spartan.reorderPlaylistsTracks(userId: spartanUserId, playlistId: spartanPlaylistId, rangeStart: 0, insertBefore: 1, success: { (snapshotResponse) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatReplacePlaylistsTracksRequestCorrectlyReplacesPlaylistTracksWithAuthorizationToken() {
        
        _ = Spartan.replacePlaylistsTracks(userId: spartanUserId, playlistId: spartanPlaylistId, trackUris: [trackUrisToRemove.first!], success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetUsersAreFollowingPlaylistsRequestCorrectlyWorksWithAuthorizationToken() {
        
        _ = Spartan.getUsersAreFollowingPlaylists(ownerId: spartanUserId, playlistId: spartanPlaylistId, userIds: [spartanUserId, "onehintwonder"], success: { (followings) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatGetAlbumRequestCorrectlyMapsASingleAlbum() {
        
        _ = Spartan.getAlbum(id: albumId, success: { (album) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetAlbumsRequestCorrectlyMapsMultipleAlbums() {
        _ = Spartan.getAlbums(ids: [albumId, albumId, albumId], success: { (albums) in
            self.validationExpectation.fulfill()
            XCTAssert(albums.count == 3)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetTracksRequestCorrectlyMapsTracksForAlbumWithGivenId() {
        
        _ = Spartan.getTracks(albumId: albumId, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetTracksRequestCorrectlyMapsFiveTracksForAlbumWithGivenIdWithLimit() {
        
        let limit = 5
        _ = Spartan.getTracks(albumId: albumId, limit: limit, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count == limit)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetTracksRequestCorrectlyMapsFiveTracksForAlbumWithGivenIdWithLimitAndOffset() {
        
        let limit = 5
        let trackOffsettedToId = "6ClztHzretmPHCeiNqR5wD"
        _ = Spartan.getTracks(albumId: albumId, limit: limit, offset: 2, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert((pagingObject.items.first!.id as! String) == trackOffsettedToId)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistRequestCorrectlyMapsASingleArtist() {
        
        _ = Spartan.getArtist(id: artistId, success: { (artist) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistsRequestCorrectlyMapsMultipleArtists() {
        
        _ = Spartan.getArtists(ids: [artistId, artistId, artistId], success: { (artists) in
            self.validationExpectation.fulfill()
            XCTAssert(artists.count == 3)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistAlbumsRequestCorrectlyMapsAllAlbums() {
        
        _ = Spartan.getArtistAlbums(artistId: artistId, success: { (albums) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistAlbumsRequestCorrectlyMapsFiveAlbumsForArtistWithGivenIdWithLimit() {
        let limit = 5
        _ = Spartan.getArtistAlbums(artistId: artistId, limit: limit, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count == 5)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistAlbumsRequestCorrectlyMapsFiveAlbumsForArtistWithGivenIdWithLimitAndOffset() {
        let limit = 5
        let albumOffsettedToId = "5XGwgWYQQK8tHwoNuLMCP9"
        _ = Spartan.getArtistAlbums(artistId: artistId, limit: limit, offset: 2, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert((pagingObject.items.first!.id! as! String) == albumOffsettedToId)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistTopTracksCorrectlyMapsTracksForArtistWithGivenId() {
        
        _ = Spartan.getArtistsTopTracks(artistId: artistId, country: .us, success: { (tracks) in
            self.validationExpectation.fulfill()
            XCTAssert(tracks.count >= 1)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistRelatedArtistsCorrectlyMapsArtistsForArtistWithGivenId() {
        
        _ = Spartan.getArtistsRelatedArtists(artistId: artistId, success: { (artists) in
            self.validationExpectation.fulfill()
            XCTAssert(artists.count >= 1)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSearchCorrectlyMapsForAlbumItemSearchType() {
        
        _ = Spartan.search(query: searchTerm, type: .album, success: { (pagingObject: PagingObject<SimplifiedAlbum>) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.type == Album.root)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSearchCorrectlyMapsForArtistItemSearchType() {
        
        _ = Spartan.search(query: searchTerm, type: .artist, success: { (pagingObject: PagingObject<Artist>) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.type == Artist.root)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSearchCorrectlyMapsForPlaylistItemSearchType() {
        
        _ = Spartan.search(query: searchTerm, type: .playlist, success: { (pagingObject: PagingObject<SimplifiedPlaylist>) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.type == SimplifiedPlaylist.root)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    
    func testThatSearchCorrectlyMapsForTrackItemSearchType() {
        
        _ = Spartan.search(query: searchTerm, type: .track, success: { (pagingObject: PagingObject<SimplifiedTrack>) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.type == SimplifiedTrack.root)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetTrackRequestCorrectlyMapsASingleTrack() {
        
        _ = Spartan.getTrack(id: trackId, success: { (track) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetTracksRequestCorrectlyMapsMultipleTracks() {
        
        _ = Spartan.getTracks(ids: [trackId, trackId, trackId], success: { (tracks) in
            self.validationExpectation.fulfill()
            XCTAssert(tracks.count == 3)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetUserRequestCorrectlyMapsUser() {
        
        _ = Spartan.getUser(id: "onehintwonder", success: { (user) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
}
