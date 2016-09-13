//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "\(Secrets.apiURL)repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
        
        print(urlString)
        
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    
    
    class func checkIfRepositoryIsStarred(fullName: String, completion:(Bool) -> ()) { // know we're going to be taking a boolean value in completion block because checking something
        
        let urlString = "\(Secrets.apiURL)user/starred/\(fullName)"
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else {fatalError("Invalid URL")}
        
        let request = NSMutableURLRequest(URL: unwrappedURL)// without mutable won't get access to .HTTPMethod or .addValue
        request.HTTPMethod = "GET"
        request.addValue("token \(Secrets.accessToken)", forHTTPHeaderField: "Authorization") //how we tell it it's the authenticated user, documentation requires that word token space is included with your actual accessToken. Request allows us to change header and what action/method we're trying to do or information we're hoping to access
        
        session.dataTaskWithRequest(request) { (data, response, error) in
            
            print(data)
            print(response)
            print(error)
            
            guard let urlResponse = response as? NSHTTPURLResponse else {return} // .statusCode comes from accessing the NSHTTPURLResponse. can also do assertionFailure w/ an error message in else block. Know we're looking solely at response from running through postman (got no data back but say change in status/response)
            
            if urlResponse.statusCode == 204 {
                completion(true) //because we're at the end of what we need to do, return completion block with boolean value and will check against it (conditional). Request has run through completion block, completion pass the boolean value you said you were going to give in the beginning.
            } else if urlResponse == 404 {
                completion(false)
                print("status code: \(urlResponse.statusCode)")
            } else {
                print("other status code: \(urlResponse.statusCode)")
            }
            
            }.resume()
    }
    
    
    
    //let starredURLString = "\(Secrets.apiURL)user/starred/\(fullName)?access_token=\(Secrets.accessToken)"
    
    //        guard let starredURL = NSURL(string: starredURLString) else {completion(nil);return}
    //
    //        NSURLSession.sharedSession().dataTaskWithURL(starredURL) { (starredData, starredResponse, starredError) in
    //
    //            guard let response = starredResponse as? NSHTTPURLResponse else {completion(nil);return}
    //            print("response: \(response)")
    //
    //            if response.statusCode == 204 {
    //                print("starred completion is true")
    //                completion(true)
    //
    //            } else {
    //                print("starred completion is false")
    //                completion(false)
    //            }
    //
    //
    //        }.resume()
    
    //}
    
    
    
    
    class func starRepository(fullName: String, completion:() ->()){
        //let starredURLString = "\(Secrets.apiURL)user/starred/\(fullName)?access_token=\(Secrets.accessToken)"
        
        let starredURLString = "\(Secrets.apiURL)user/starred/\(fullName)"
        
        guard let starredURL = NSURL(string: starredURLString) else {return}
        
        
        let session = NSURLSession.sharedSession() // when downloading etc, use NSURLSessionConfiguration.defaultSessionConfiguration, request.HTTPADditionalHeaders = ["Authorization: Secrets.accessTokern]
        
        let starItRequest = NSMutableURLRequest(URL: starredURL)  //use mutableURLRequest with httpheaderfield for authorization to be used with access token, if access token not already included in urlString
        starItRequest.HTTPMethod = "PUT"
        starItRequest.addValue("token \(Secrets.accessToken)", forHTTPHeaderField: "Authorization")
        
        let starItTask = session.dataTaskWithRequest(starItRequest) { (starItData, starItResponse, starItError) in
            guard let response = starItResponse as? NSHTTPURLResponse else {assertionFailure("didn't work");return}
            print(response)
            if response.statusCode == 204 { //can use range in conditional as well (eg. if 200...299, print "got a repsonse")
                print("repository is now starred is true")
                completion()
                
                // after consulting github documentation, don't need to check for 404
                //        } else if response.statusCode == 404 {
                //            print("repository was not starred, status code:\(response.statusCode)")
                //
                //            completion()
            } else {
                
                print("other status code: \(response.statusCode)")
                
            }
        }
        
        starItTask.resume()
    }
    
    
    
    class func unstarRepository(fullName: String, completion:() ->()){
        let starredURLString = "\(Secrets.apiURL)user/starred/\(fullName)?access_token=\(Secrets.accessToken)"
        
        guard let starredURL = NSURL(string: starredURLString) else {return}
        
        
        let session = NSURLSession.sharedSession()
        
        let unstarItRequest = NSMutableURLRequest(URL: starredURL)  //use mutableURLRequest with httpheaderfield for authorization to be used with access token, if access token not already included in urlString
        
        unstarItRequest.HTTPMethod = "DELETE"
        unstarItRequest.addValue("token " + Secrets.accessToken, forHTTPHeaderField: "Authorization")
        
        let unstarItTask = session.dataTaskWithRequest(unstarItRequest) { (unstarItData, unstarItResponse, unstarItError) in
            guard let response = unstarItResponse as? NSHTTPURLResponse else {assertionFailure("didn't work");return}
            print(response)
            if response.statusCode == 204 {
                completion()
                
                //        } else if response == 404 {
                //            completion()
            } else {
                print("other status code:\(response.statusCode)")
            }
        }
        
        unstarItTask.resume()
    }
    
    
}

/*
 
 
 print(starredURLString)
 
 //        starred/:owner/:repo
 //        /repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
 //
 
 guard let starredURL = NSURL(string:starredURLString) else {return}
 
 let starredSession = NSURLSession.sharedSession()
 
 
 
 let starredRequest = NSMutableURLRequest(URL: starredURL)
 starredRequest.HTTPMethod = "GET"
 //guard let unwrappedStarredURL = starredURL else {return}
 
 
 //let starredTask = starredSession.dataTaskWithURL(unwrappedStarredURL) {(starredData, starredResponse, starredError) in
 
 let starredTask = starredSession.dataTaskWithRequest(starredRequest) { (starredData, starredResponse, starredError) in
 
 print("this is the starred response: \(starredResponse)")
 print("this is the starred response: \(starredData)")
 print("this is the starred response: \(starredError)")
 
 guard let unwrappedStarredData = starredData else {return}
 
 let starredRepo : Bool = true
 
 do {
 if let starredRepoResponse = try NSJSONSerialization.JSONObjectWithData(unwrappedStarredData, options: []) as? Bool {
 
 if starredRepoResponse == starredRepo {
 completion(starredRepoResponse)
 }
 }
 
 } catch {
 print("catch error")
 }
 }
 
 starredTask.resume()
 */

