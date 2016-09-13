//
//  GithubRepository.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubRepository {// class we wrote to hold each repository
    var fullName: String
    var htmlURL: NSURL
    var repositoryID: String
    
    init(dictionary: NSDictionary) { // initializer takes dictionary, which is what we're passing in to access certain keys and map
        guard let
            name = dictionary["full_name"] as? String,
            valueAsString = dictionary["html_url"] as? String,
            valueAsURL = NSURL(string: valueAsString),
            repoID = dictionary["id"]?.stringValue
            else { fatalError("Could not create repository object from supplied dictionary") }
        
        htmlURL = valueAsURL
        fullName = name
        repositoryID = repoID
    }
    
}
