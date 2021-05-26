//
//  AuthManager.swift
//  spotify
//
//  Created by thunder on 3/03/21.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    private var onRefreshBlocks = [((String) -> Void)]()

    struct Constants {
        static let clientID = ""
        static let clientSecret = ""
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.google.com"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init () {}
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let finalString = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        
        return URL(string: finalString)
    }
    
    var isSingedIn: Bool {
        return accessTocken != nil
    }
    
    private var accessTocken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshTocken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshTocken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
     
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    
    public func exchangeCodeForToken(code:String, completion: @escaping (Bool) -> Void) {
        // get token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                         value: "\(Constants.redirectURI)")
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)",
                         forHTTPHeaderField: "Authorization")
        
        
        let task =  URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("SUCCESS:\(json)")
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
                
            }
            
        }
        task.resume()
    }
    
    
    // supplyies valid token to be used with API calls.
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            // append the completion
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshTocken {
            // refresh token
            refreshIfNeeded{ [weak self] success in
                if let token = self?.accessTocken, success {
                    completion(token)
                }
            }
        } else if let token = accessTocken {
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: ((Bool) -> Void)?) {
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshTocken else {
            completion?(true)
            return
        }
        
        guard let refreshTocken = self.refreshTocken else {
            return
        }
        
        // refresh token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "refresh_token"),
            URLQueryItem(name: "refresh_token",
                         value: refreshTocken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure to get base64")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)",
                         forHTTPHeaderField: "Authorization")
        
        
        let task =  URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            
            guard let data = data,
                  error == nil else {
                completion?(false)
                return
            }
            
            do {
                print("Successfully refresh token:\(data)")

                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach {$0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            }
            catch {
                print(error.localizedDescription)
                completion?(false)
                
            }
            
        }
        task.resume()

        
    }
    
    private func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token,
                                       forKey: "access_token")
        
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.setValue(refresh_token,
                                           forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey: "expirationDate")
    }
    
    
    public func signOut(completion: (Bool) -> Void) {
        
        UserDefaults.standard.setValue(nil,
                                       forKey: "access_token")
        UserDefaults.standard.setValue(nil,
                                       forKey: "refresh_token")
        UserDefaults.standard.setValue(nil,
                                       forKey: "expirationDate")
        completion(true)
    }
}
