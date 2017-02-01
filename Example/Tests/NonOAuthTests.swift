//
//  NonOAuthTests.swift
//  Tests
//
//  Created by Dalton Hinterscher on 1/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Spartan

class NonOAuthTests: BaseTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Spartan.loggingEnabled = true
    }
    
    func testThatGetAlbumRequestCorrectlyMapsASingleAlbum() {
        
        _ = Spartan.getAlbum(id: ALBUM_ID, success: { (album) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetAlbumsRequestCorrectlyMapsMultipleAlbums() {
        _ = Spartan.getAlbums(ids: [ALBUM_ID, ALBUM_ID, ALBUM_ID], success: { (albums) in
            self.validationExpectation.fulfill()
            XCTAssert(albums.count == 3)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetTracksRequestCorrectlyMapsTracksForAlbumWithGivenId() {
        
        _ = Spartan.getTracks(albumId: ALBUM_ID, success: { (pagingObject) in
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
        _ = Spartan.getTracks(albumId: ALBUM_ID, limit: limit, success: { (pagingObject) in
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
        _ = Spartan.getTracks(albumId: ALBUM_ID, limit: limit, offset: 2, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.id == trackOffsettedToId)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistRequestCorrectlyMapsASingleArtist() {
        
        _ = Spartan.getArtist(id: ARTIST_ID, success: { (artist) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistsRequestCorrectlyMapsMultipleArtists() {
       
        _ = Spartan.getArtists(ids: [ARTIST_ID, ARTIST_ID, ARTIST_ID], success: { (artists) in
            self.validationExpectation.fulfill()
            XCTAssert(artists.count == 3)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistAlbumsRequestCorrectlyMapsAllAlbums() {
        
        _ = Spartan.getArtistAlbums(artistId: ARTIST_ID, success: { (albums) in
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
        _ = Spartan.getArtistAlbums(artistId: ARTIST_ID, limit: limit, success: { (pagingObject) in
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
        let albumOffsettedToId = "2gYoPtUkgobS85ShWg16lR"
        _ = Spartan.getArtistAlbums(artistId: ARTIST_ID, limit: limit, offset: 2, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.id! == albumOffsettedToId)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistTopTracksCorrectlyMapsTracksForArtistWithGivenId() {
       
        _ = Spartan.getArtistsTopTracks(artistId: ARTIST_ID, country: .us, success: { (tracks) in
            self.validationExpectation.fulfill()
            XCTAssert(tracks.count >= 1)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetArtistRelatedArtistsCorrectlyMapsArtistsForArtistWithGivenId() {
        
        _ = Spartan.getArtistsRelatedArtists(artistId: ARTIST_ID, success: { (artists) in
            self.validationExpectation.fulfill()
            XCTAssert(artists.count >= 1)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSearchCorrectlyMapsForAlbumItemSearchType() {
        
        _ = Spartan.search(query: SEARCH_TERM, type: .album, success: { (pagingObject: PagingObject<SimplifiedAlbum>) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.type == Album.root)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSearchCorrectlyMapsForArtistItemSearchType() {
        
        _ = Spartan.search(query: SEARCH_TERM, type: .artist, success: { (pagingObject: PagingObject<Artist>) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.type == Artist.root)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    
    func testThatSearchCorrectlyMapsForPlaylistItemSearchType() {
        
        _ = Spartan.search(query: SEARCH_TERM, type: .playlist, success: { (pagingObject: PagingObject<SimplifiedPlaylist>) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.type == SimplifiedPlaylist.root)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    
    func testThatSearchCorrectlyMapsForTrackItemSearchType() {
        
        _ = Spartan.search(query: SEARCH_TERM, type: .track, success: { (pagingObject: PagingObject<SimplifiedTrack>) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.first!.type == SimplifiedTrack.root)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetTrackRequestCorrectlyMapsASingleTrack() {
        
        _ = Spartan.getTrack(id: TRACK_ID, success: { (track) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetTracksRequestCorrectlyMapsMultipleTracks() {
       
        _ = Spartan.getTracks(ids: [TRACK_ID, TRACK_ID, TRACK_ID], success: { (tracks) in
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
