//
//  ContentWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/3/22.
//

import UIKit

class ExploreContentWorker {
    
    let imageWorker = ExploreImageWorker()
    let quoteWorker = ExploreQuoteWorker()
    
    var resultQuoteModels: [QuoteGardenQuoteModel] = []
    var resultImages: [UIImage?] = []
    
    let group = DispatchGroup()
    
    func getContent(genres: [String], completion: @escaping ([QuoteGardenQuoteModel], [UIImage?]) -> Void) {
        group.enter()
        imageWorker.get10LandscapeImages { result in
            switch result {
            case .success(let images):
                self.resultImages.append(contentsOf: images)
            case .failure(let error):
                print(error)
            }
            self.group.leave()
        }
        group.enter()
        quoteWorker.get10RandomQuotes(genre: genres.randomElement() ?? "") {  result in
            switch result {
            case .success(let quoteModels):
                self.resultQuoteModels.append(contentsOf: quoteModels)
            case .failure(let error):
                print(error)
            }
            self.group.leave()
        }
        group.notify(queue: .main) { 
            completion(self.resultQuoteModels, self.resultImages)
        }
    }
}
