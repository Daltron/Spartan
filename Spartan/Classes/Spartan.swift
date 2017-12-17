/*
 
 The MIT License (MIT)
 Copyright (c) 2017 Dalton Hinterscher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Alamofire

public class Spartan: NSObject {

    /* Token that is included with each request that requires OAuth authentication. If the request you 
       make requries OAuth and this is nil, the response status code will be a 401 Unauthorized
     */
    public static var authorizationToken: String?
    
    /* When enabled, will log each network request and its response in the console */
    public static var loggingEnabled: Bool = true {
        didSet {
            SpartanRequestManager.default.loggingEnabled = loggingEnabled
        }
    }
    
    /* API Documentation: https://developer.spotify.com/web-api/get-album */
    
    @discardableResult
    public class func getAlbum(id: String,
                               market: CountryCode? = nil,
                               success: @escaping ((Album) -> Void),
                               failure: ((SpartanError) -> Void)?) -> Request {
        
        var parameters: [String: Any] = [:]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return Album.find(id: id, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-several-albums */
    
    @discardableResult
    public class func getAlbums(ids: [String],
                                market: CountryCode? = nil,
                                success: @escaping (([Album]) -> Void),
                                failure: ((SpartanError) -> Void)?) -> Request {
        
        var parameters: [String: Any] = ["ids" : ids.joined(separator: ",")]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return Album.all(parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-albums-tracks */
    
    @discardableResult
    public class func getTracks(albumId:String,
                                limit:Int = 20,
                                offset:Int = 0,
                                market: CountryCode? = nil,
                                success: @escaping ((PagingObject<SimplifiedTrack>) -> Void),
                                failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(SimplifiedAlbum.pluralRoot)/\(albumId)/\(Track.pluralRoot)")
        var parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-artist */
    
    @discardableResult
    public class func getArtist(id: String,
                                success: @escaping ((Artist) -> Void),
                                failure: ((SpartanError) -> Void)?) -> Request {
        return Artist.find(id: id,
                           success: success,
                           failure: failure)
    }
   
    
    /* API Documentation: https://developer.spotify.com/web-api/get-several-artists */
    
    @discardableResult
    public class func getArtists(ids: [String],
                                 success: @escaping (([Artist]) -> Void),
                                 failure: ((SpartanError) -> Void)?) -> Request {
        
        let parameters = ["ids" : ids.joined(separator: ",")]
        return Artist.all(parameters: parameters,
                          success: success,
                          failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-artists-albums */
    
    @discardableResult
    public class func getArtistAlbums(artistId: String,
                                      limit:Int = 20,
                                      offset:Int = 0,
                                      albumTypes: [AlbumType] = [.album, .single, .appearsOn, .compilation],
                                      market: CountryCode? = nil,
                                      success: @escaping ((PagingObject<SimplifiedAlbum>) -> Void),
                                      failure: ((SpartanError) -> Void)?) -> Request {
        
        var albumTypesString: [String] = []
        for type in albumTypes {
            albumTypesString.append(type.rawValue)
        }
        let url = SpartanURL(url: "\(Artist.pluralRoot)/\(artistId)/\(Album.pluralRoot)")
        var parameters = ["limit" : limit, "offset" : offset, "album_type" : albumTypesString.joined(separator: ",")] as [String: Any]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
   
    
    /* API Documentation: https://developer.spotify.com/web-api/get-artists-top-tracks */
    
    @discardableResult
    public class func getArtistsTopTracks(artistId: String,
                                          country: CountryCode,
                                          success: @escaping (([Track]) -> Void),
                                          failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(Artist.pluralRoot)/\(artistId)/top-tracks")
        let parameters = ["country" : country.rawValue]
        return SpartanRequestManager.default.mapObjects(.get,
                                                        url: url,
                                                        parameters: parameters,
                                                        keyPath: Track.pluralRoot,
                                                        success: success,
                                                        failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-related-artists */
    
    @discardableResult
    public class func getArtistsRelatedArtists(artistId: String,
                                               success: @escaping (([Artist]) -> Void),
                                               failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(Artist.pluralRoot)/\(artistId)/related-artists")
        return SpartanRequestManager.default.mapObjects(.get,
                                                        url: url,
                                                        keyPath: Artist.pluralRoot,
                                                        success: success,
                                                        failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/search-item */
    
    @discardableResult
    public class func search<T: SpartanBaseObject>(query: String,
                                                   type: ItemSearchType,
                                                   market: CountryCode? = nil,
                                                   limit: Int = 20,
                                                   offset: Int = 0,
                                                   success: @escaping ((PagingObject<T>) -> Void),
                                                   failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "search")
        var parameters: [String: Any] = ["q" : query, "type" : type.rawValue, "limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       keyPath: ItemSearchType.pluralRoot(for: type),
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-track */
    
    @discardableResult
    public class func getTrack(id: String,
                               market: CountryCode? = nil,
                               success: @escaping ((Track) -> Void),
                               failure: ((SpartanError) -> Void)?) -> Request {
        
        var parameters: [String: Any] = [:]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return Track.find(id: id,
                          parameters: parameters,
                          success: success,
                          failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-several-tracks */
    
    @discardableResult
    public class func getTracks(ids: [String],
                                market: CountryCode? = nil,
                                success: @escaping (([Track]) -> Void),
                                failure: ((SpartanError) -> Void)?) -> Request {
        
        var parameters: [String: Any] = ["ids": ids.joined(separator: ",")]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return Track.all(parameters: parameters,
                         success: success,
                         failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-profile */
    
    @discardableResult
    public class func getUser(id: String,
                              success: @escaping ((PublicUser) -> Void),
                              failure: ((SpartanError) -> Void)?) -> Request {
        return PublicUser.find(id: id, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-audio-analysis */

    @discardableResult
    public class func getAudioAnaylsis(trackId: String,
                                       success: @escaping ((AudioAnalysis) -> Void),
                                       failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(AudioAnalysis.root)/\(trackId)")
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-audio-features */
    
    @discardableResult
    public class func getAudioFeatures(trackId: String,
                                       success: @escaping ((AudioFeaturesObject) -> Void),
                                       failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(AudioFeaturesObject.pluralRoot)/\(trackId)")
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       success: success,
                                                       failure: failure)
    }
    
    /* API Documentation: https://developer.spotify.com/web-api/get-several-audio-features */
    
    @discardableResult
    public class func getAudioFeatures(trackIds: [String],
                                       success: @escaping (([AudioFeaturesObject]) -> Void),
                                       failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(AudioFeaturesObject.pluralRoot)")
        let parameters = ["ids" : trackIds.joined(separator: ",")]
        return SpartanRequestManager.default.mapObjects(.get,
                                                        url: url,
                                                        parameters: parameters,
                                                        keyPath: "audio_features",
                                                        success: success,
                                                        failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-featured-playlists */
    
    @discardableResult
    public class func getFeaturedPlaylists(locale: String? = nil, country: CountryCode? = nil, timestamp: String? = nil, limit: Int = 20, offset: Int = 0, success: @escaping ((FeaturedPlaylistsObject) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "browse/featured-playlists")
        var parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "locale", param: locale, parameters: &parameters)
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        checkOptionalParamAddition(paramName: "timestamp", param: timestamp, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-new-releases */
    
    @discardableResult
    public class func getNewReleases(country: CountryCode? = nil,
                                     limit: Int = 20,
                                     offset: Int = 0,
                                     success: @escaping ((PagingObject<SimplifiedAlbum>) -> Void),
                                     failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "browse/new-releases")
        var parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       keyPath: Album.pluralRoot,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-categories */
    
    @discardableResult
    public class func getCategories(locale: String? = nil,
                                    country: CountryCode? = nil,
                                    limit: Int = 20,
                                    offset: Int = 0,
                                    success: @escaping ((PagingObject<CategoryObject>) -> Void),
                                    failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "browse/\(CategoryObject.pluralRoot)")
        var parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "locale", param: locale, parameters: &parameters)
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       keyPath: CategoryObject.pluralRoot,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-category */
    
    @discardableResult
    public class func getCategory(id: String,
                                  locale: String? = nil,
                                  country: CountryCode? = nil,
                                  success: @escaping ((CategoryObject) -> Void),
                                  failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "browse/\(CategoryObject.pluralRoot)/\(id)")
        var parameters: [String: Any] = [:]
        checkOptionalParamAddition(paramName: "locale", param: locale, parameters: &parameters)
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-categorys-playlists */
    
    @discardableResult
    public class func getCategorysPlaylists(categoryId: String,
                                            locale: String? = nil,
                                            country: CountryCode? = nil,
                                            limit: Int = 20,
                                            offset: Int = 0,
                                            success: @escaping ((PagingObject<SimplifiedPlaylist>) -> Void),
                                            failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "browse/\(CategoryObject.pluralRoot)/\(categoryId)/\(Playlist.pluralRoot)")
        var parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "locale", param: locale, parameters: &parameters)
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       keyPath: Playlist.pluralRoot,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-current-users-profile */
    
    @discardableResult
    public class func getMe(success: @escaping ((PrivateUser) -> Void),
                            failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me")
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-followed-artists */
    
    @discardableResult
    public class func getMyFollowedArtists(limit: Int = 20,
                                           after: String? = nil,
                                           success: @escaping ((PagingObject<Artist>) -> Void),
                                           failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL(url: "me/following?type=artist")
        var parameters: [String: Any] = ["limit" : limit]
        checkOptionalParamAddition(paramName: "after", param: after, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       keyPath: Artist.pluralRoot,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/follow-artists-users */
    
    @discardableResult
    public class func follow(ids: [String],
                             type: FollowType,
                             success: (() -> Void)?,
                             failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/following?type=\(type.rawValue)&ids=\(ids.joined(separator: ","))")
        return SpartanRequestManager.default.makeRequest(.put,
                                                         url: url,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/follow-artists-users */
    
    @discardableResult
    public class func unfollow(ids: [String],
                               type: FollowType,
                               success: (() -> Void)?,
                               failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/following?type=\(type.rawValue)&ids=\(ids.joined(separator: ","))")
        return SpartanRequestManager.default.makeRequest(.delete,
                                                         url: url,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }
    
    /* API Documentation: https://developer.spotify.com/web-api/check-current-user-follows */
    
    @discardableResult
    public class func getIsFollowing(ids: [String],
                                     type: FollowType,
                                     success: @escaping (([Bool]) -> Void),
                                     failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL(url: "me/following/contains?type=\(type.rawValue)&ids=\(ids.joined(separator: ","))")
        return SpartanRequestManager.default.mapBoolArray(.get,
                                                          url: url,
                                                          success: success,
                                                          failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/follow-playlist */
    
    @discardableResult
    public class func followPlaylist(ownerId: String,
                                     playlistId: String,
                                     isPublic: Bool = true,
                                     success: (() -> Void)?,
                                     failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "users/\(ownerId)/\(Playlist.pluralRoot)/\(playlistId)/followers")
        let parameters: [String: Any] = ["public" : isPublic]
        return SpartanRequestManager.default.makeRequest(.put,
                                                         url: url,
                                                         parameters: parameters,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/unfollow-playlist */
    
    @discardableResult
    public class func unfollowPlaylist(ownerId: String,
                                       playlistId: String,
                                       success: (() -> Void)?,
                                       failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "users/\(ownerId)/\(Playlist.pluralRoot)/\(playlistId)/followers")
        return SpartanRequestManager.default.makeRequest(.delete,
                                                         url: url,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }
    
    /* API Documentation: https://developer.spotify.com/web-api/save-tracks-user */
    
    @discardableResult
    public class func saveTracks(trackIds: [String],
                                 success: (() -> Void)?,
                                 failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/\(Track.pluralRoot)?ids=\(trackIds.joined(separator: ","))")
        return SpartanRequestManager.default.makeRequest(.put,
                                                         url: url,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-saved-tracks */
    
    @discardableResult
    public class func getSavedTracks(limit: Int = 20,
                                     offset: Int = 0,
                                     market: CountryCode? = nil,
                                     success: @escaping ((PagingObject<SavedTrack>) -> Void),
                                     failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL(url: "me/\(Track.pluralRoot)")
        var parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/remove-tracks-user */
    
    @discardableResult
    public class func removeSavedTracks(trackIds: [String],
                                        success: (() -> Void)?,
                                        failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/\(Track.pluralRoot)?ids=\(trackIds.joined(separator: ","))")
        return SpartanRequestManager.default.makeRequest(.delete,
                                                         url: url,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/check-users-saved-tracks */
    
    @discardableResult
    public class func tracksAreSaved(trackIds: [String],
                                     success: @escaping (([Bool]) -> Void),
                                     failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/\(Track.pluralRoot)/contains?ids=\(trackIds.joined(separator: ","))")
        return SpartanRequestManager.default.mapBoolArray(.get,
                                                          url: url,
                                                          success: success,
                                                          failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/save-albums-user */
    
    @discardableResult
    public class func saveAlbums(albumIds: [String],
                                 success: (() -> Void)?,
                                 failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL(url: "me/\(Album.pluralRoot)?ids=\(albumIds.joined(separator: ","))")
        return SpartanRequestManager.default.makeRequest(.put,
                                                         url: url,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-saved-albums */
    
    @discardableResult
    public class func getSavedAlbums(limit: Int = 20,
                                     offset: Int = 0,
                                     market: CountryCode? = nil,
                                     success: @escaping ((PagingObject<SavedAlbum>) -> Void),
                                     failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/\(Album.pluralRoot)")
        var parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/remove-albums-user */
    
    @discardableResult
    public class func removeSavedAlbums(albumIds: [String],
                                        success: (() -> Void)?,
                                        failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/\(Album.pluralRoot)?ids=\(albumIds.joined(separator: ","))")
        return SpartanRequestManager.default.makeRequest(.delete,
                                                         url: url,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }

    
    /* API Documentation: https://developer.spotify.com/web-api/check-users-saved-albums */
    
    @discardableResult
    public class func albumsAreSaved(albumIds: [String],
                                     success: @escaping (([Bool]) -> Void),
                                     failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL(url: "me/\(Album.pluralRoot)/contains?ids=\(albumIds.joined(separator: ","))")
        return SpartanRequestManager.default.mapBoolArray(.get,
                                                          url: url,
                                                          success: success,
                                                          failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/ */
    
    @discardableResult
    public class func getMyTopArtists(limit: Int = 20,
                                      offset: Int = 0,
                                      timeRange: TimeRange = .mediumTerm,
                                      success: @escaping ((PagingObject<Artist>) -> Void),
                                      failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/top/\(Artist.pluralRoot)")
        let parameters: [String: Any] = ["limit" : limit, "offset" : offset, "time_range" : timeRange.rawValue]
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }

    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/ */
    
    @discardableResult
    public class func getMyTopTracks(limit: Int = 20,
                                     offset: Int = 0,
                                     timeRange: TimeRange = .mediumTerm,
                                     success: @escaping ((PagingObject<Track>) -> Void),
                                     failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/top/\(Track.pluralRoot)")
        let parameters: [String: Any] = ["limit" : limit, "offset" : offset, "time_range" : timeRange.rawValue]
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-recommendations */
    
    @discardableResult
    public class func getRecommendations(limit: Int = 20,
                                         market: CountryCode? = nil,
                                         minAttributes: [(TuneableTrackAttribute, Float)]? = nil,
                                         maxAttributes: [(TuneableTrackAttribute, Float)]? = nil,
                                         targetAttributes: [(TuneableTrackAttribute, Float)]? = nil,
                                         seedArtists: [String]? = nil, seedGenres: [String]? = nil,
                                         seedTracks: [String]? = nil,
                                         success: @escaping ((RecommendationsObject) -> Void),
                                         failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "recommendations")
        var parameters: [String: Any] = ["limit" : limit]
        
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        checkOptionalTuneableTrackAttributeTupleParamAddition(prefix: "max", attributes: maxAttributes, parameters: &parameters)
        checkOptionalTuneableTrackAttributeTupleParamAddition(prefix: "min", attributes: minAttributes, parameters: &parameters)
        checkOptionalTuneableTrackAttributeTupleParamAddition(prefix: "target", attributes: targetAttributes, parameters: &parameters)
        checkOptionalArrayParamAddition(paramName: "seed_artists", param: seedArtists, parameters: &parameters)
        checkOptionalArrayParamAddition(paramName: "seed_genres", param: seedGenres, parameters: &parameters)
        checkOptionalArrayParamAddition(paramName: "seed_tracks", param: seedTracks, parameters: &parameters)
        
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-users-playlists */
    
    @discardableResult
    public class func getUsersPlaylists(userId: String,
                                        limit: Int = 20,
                                        offset: Int = 0,
                                        success: @escaping ((PagingObject<SimplifiedPlaylist>) -> Void),
                                        failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)")
        let parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }

    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-users-playlists */
    
    @discardableResult
    public class func getMyPlaylists(limit: Int = 20,
                                     offset: Int = 0,
                                     success: @escaping ((PagingObject<SimplifiedPlaylist>) -> Void),
                                     failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "me/\(Playlist.pluralRoot)")
        let parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-playlist */

    @discardableResult
    public class func getUsersPlaylist(userId: String,
                                       playlistId: String,
                                       fields: [String]? = nil,
                                       market: CountryCode? = nil,
                                       success: @escaping ((Playlist) -> Void),
                                       failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)")
        var parameters: [String: Any] = [:]
        checkOptionalParamAddition(paramName: "fields", param: fields?.joined(separator: ","), parameters: &parameters)
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-playlists-tracks */
    
    @discardableResult
    public class func getPlaylistTracks(userId: String,
                                        playlistId: String,
                                        limit: Int = 20,
                                        offset: Int = 0,
                                        fields: [String]? = nil,
                                        market: CountryCode? = nil,
                                        success: @escaping ((PagingObject<PlaylistTrack>) -> Void),
                                        failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)")
        var parameters: [String: Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "fields", param: fields?.joined(separator: ","), parameters: &parameters)
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.get,
                                                       url: url,
                                                       parameters: parameters,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/create-playlist */
    
    @discardableResult
    public class func createPlaylist(userId: String,
                                     name: String,
                                     isPublic: Bool = true,
                                     isCollaborative: Bool = false,
                                     success: @escaping ((Playlist) -> Void),
                                     failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)")
        let parameters: [String: Any] = ["name" : name, "public" : isPublic, "collaborative" : isCollaborative]
        return SpartanRequestManager.default.mapObject(.post,
                                                       url: url,
                                                       parameters: parameters,
                                                       encoding: JSONEncoding.default,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/change-playlist-details */
    
    @discardableResult
    public class func changePlaylistDetails(userId: String,
                                            playlistId: String,
                                            name: String,
                                            isPublic: Bool,
                                            isCollaborative: Bool,
                                            success: (() -> Void)?,
                                            failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)")
        let parameters: [String: Any] = ["name" : name, "public" : isPublic, "collaborative" : isCollaborative]
        return SpartanRequestManager.default.makeRequest(.put,
                                                         url: url,
                                                         parameters: parameters,
                                                         encoding: JSONEncoding.default,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/add-tracks-to-playlist */
    
    @discardableResult
    public class func addTracksToPlaylist(userId: String,
                                          playlistId: String,
                                          trackUris: [String],
                                          position: Int? = nil,
                                          success: ((SnapshotResponse) -> Void)?,
                                          failure: ((SpartanError) -> Void)?) -> Request {
        
        var urlString = "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)?uris=\(trackUris.joined(separator: ","))"
        if let position = position {
            urlString += "&position=\(position)"
        }
        let url = SpartanURL(url: urlString)
        
        return SpartanRequestManager.default.mapObject(.post,
                                                       url: url,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/remove-tracks-playlist */
    
    @discardableResult
    public class func removeTracksFromPlaylist(userId: String,
                                               playlistId: String,
                                               trackUris: [String],
                                               success: ((SnapshotResponse) -> Void)?,
                                               failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)")
        var trackUrisArray: [[String: String]] = []
        for trackUri in trackUris {
            trackUrisArray.append(["uri" : trackUri])
        }
        let parameters: [String: Any] = ["tracks" : trackUrisArray]
        return SpartanRequestManager.default.mapObject(.delete,
                                                       url: url,
                                                       parameters: parameters,
                                                       encoding: JSONEncoding.default,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/reorder-playlists-tracks */
    
    @discardableResult
    public class func reorderPlaylistsTracks(userId: String,
                                             playlistId: String,
                                             rangeStart: Int,
                                             rangeLength: Int = 1,
                                             insertBefore: Int,
                                             snapshotId: String? = nil,
                                             success: ((SnapshotResponse) -> Void)?,
                                             failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)")
        var parameters: [String: Any] = ["range_start" : rangeStart, "range_length" : rangeLength, "insert_before" : insertBefore]
        checkOptionalParamAddition(paramName: "snapshot_id", param: snapshotId, parameters: &parameters)
        return SpartanRequestManager.default.mapObject(.put,
                                                       url: url,
                                                       parameters: parameters,
                                                       encoding: JSONEncoding.default,
                                                       success: success,
                                                       failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/replace-playlists-tracks */
    
    @discardableResult
    public class func replacePlaylistsTracks(userId: String,
                                             playlistId: String,
                                             trackUris: [String],
                                             success: (() -> Void)?,
                                             failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)?uris=\(trackUris.joined(separator: ","))")
        return SpartanRequestManager.default.makeRequest(.put,
                                                         url: url,
                                                         emptyBody: true,
                                                         success: success,
                                                         failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/check-user-following-playlist */
    
    @discardableResult
    public class func getUsersAreFollowingPlaylists(ownerId: String,
                                                    playlistId: String,
                                                    userIds: [String],
                                                    success: (([Bool]) -> Void)?,
                                                    failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL(url: "\(PublicUser.pluralRoot)/\(ownerId)/\(Playlist.pluralRoot)/\(playlistId)/followers/contains?ids=\(userIds.joined(separator: ","))")
        return SpartanRequestManager.default.mapBoolArray(.get,
                                                          url: url,
                                                          success: success,
                                                          failure: failure)
    }
    
    private class func checkOptionalParamAddition(paramName: String,
                                                  param: Any?, parameters: inout [String: Any]) {
        if let param = param {
            parameters[paramName] = param
        }
    }
    
    private class func checkOptionalArrayParamAddition(paramName: String,
                                                       param: [String]?,
                                                       parameters: inout [String: Any]) {
        if let param = param {
            parameters[paramName] = param.joined(separator: ",")
        }
    }
    
    private class func checkOptionalTuneableTrackAttributeTupleParamAddition(prefix: String,
                                                                             attributes: [(TuneableTrackAttribute, Float)]?, 
                                                                             parameters: inout [String: Any]) {
        
        guard let attributes = attributes else {
            return
        }
        
        for (attribute, value) in attributes {
            parameters["\(prefix)_\(attribute.rawValue)"] = value
        }
    }
    
}
