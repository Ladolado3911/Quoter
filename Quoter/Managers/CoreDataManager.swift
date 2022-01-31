//
//  CoreDataManager.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/31/22.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static var context: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    static func clearQuotesAndAuthors() {
        guard let context = context else { return }
        let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
        let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")

        do {
            var arr: [NSManagedObject] = []
            let quotes = try context.fetch(requestQuotes)
            let authors = try context.fetch(requestAuthors)
            arr.append(contentsOf: quotes)
            arr.append(contentsOf: authors)
            arr.forEach { core in
                context.delete(core)
            }
            print(try context.fetch(requestQuotes))
            print(try context.fetch(requestAuthors))
        }
        catch {
            print(error)
        }
    }
    
    static func isAuthorInCoreData(authorName: String) -> Bool {
        guard let context = context else { return false }
        
        let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
        
        do {
            let authors = try context.fetch(requestAuthors)
            for authorCore in authors {
                if authorCore.name == authorName {
                    return true
                }
            }
            return false
        }
        catch {
            print(error)
            return false
        }
    }
    
    static func isQuoteInCoreData(quoteVM: QuoteVM) -> Bool {
        guard let context = context else { return false }
        
        let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
        
        do {
            let quotes = try context.fetch(requestQuotes)
            for quoteCore in quotes {
                if quoteCore.content == quoteVM.content {
                    return true
                }
            }
            return false
        }
        catch {
            print(error)
            return false
        }
    }
    
    static func addQuote(quoteVM: QuoteVM, authorImageData: Data) {
        guard let context = context else { return }

        let quote = QuoteCore(context: context)
        
        if CoreDataManager.isAuthorInCoreData(authorName: quoteVM.author) {
            quote.content = quoteVM.content
        }
        else {
            let author = AuthorCore(context: context)
            author.name = quoteVM.author
            author.image = authorImageData
        }
        
//        model2.firstName = model.givenName
//        model2.lastName = model.familyName
//        model2.mobile = model.phoneNumbers.first?.value.stringValue
        

        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    
    
}
