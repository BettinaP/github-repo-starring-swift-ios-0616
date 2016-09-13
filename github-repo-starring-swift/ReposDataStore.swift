//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    private init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(completion: () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    //
    //    Create a method in ReposDataStore called toggleStarStatusForRepository(repository: completion:) that, given a GithubRepository object, checks to see if it's starred or not and then either stars or unstars the repo. That is, it should toggle the star on a given repository. In the completion closure, there should be a Bool parameter called starred that is true if the repo was just starred, and false if it was just unstarred.
    func  toggleStarStatusForRepository(repository: GithubRepository, completion:(Bool) -> ()){
        
        
        GithubAPIClient.checkIfRepositoryIsStarred(repository.fullName) { (isStarred) in // through check function we wrote in GithubAPIClient, we have access to/return a boolean value that will tell us if something is starred (completion true) or not starred(false)
            
            
            var toggleStar = Bool()
            
            if isStarred {
                
                GithubAPIClient.unstarRepository(repository.fullName, completion: {
                    
                })
                
                toggleStar = false
                
            } else {
                
                GithubAPIClient.starRepository(repository.fullName, completion: {
                    
                })
                toggleStar = true
            }
            
            completion(toggleStar)
            
            //   or can do    if isStarred == true {
            //                GithubAPIClient.unstarRepository(repository.fullName, completion: {
            //                    completion(true) //don't need to actually pass completion(true)/completion with boolean value if toggle method is written without Bool and in star/unstar
            //                                       methods, completion didn't take in anything so we just returned completion()
            //                    print("repo is now unstarred")
            //                })
            //
            //            } else {
            //
            //                GithubAPIClient.starRepository(repository.fullName, completion: {
            //                    completion(false)
            //                    print("repo is now starred")
            //                })
            //                
            //            }
            
        }
        
    }
    
}
