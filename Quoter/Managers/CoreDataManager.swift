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
    
    static func printCoreDataItems() {
        guard let context = context else { return }
        
        let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
        let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
        
        do {
            print(try context.fetch(requestQuotes) as? [QuoteCore])
            print(try context.fetch(requestAuthors) as? [AuthorCore])
        }
        catch {
            print(error)
        }
    }
    
    static func clearWhereverNeeded() {
        guard let context = context else { return }
        let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
        requestAuthors.returnsObjectsAsFaults = false
        do {
            let authors = try context.fetch(requestAuthors)
            for author in authors {
                if author.relationship?.allObjects.count == 0 {
                    context.delete(author)
                }
            }
            try context.save()
        }
        catch {
            print(error)
        }
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
            try context.save()
            print(try context.fetch(requestQuotes))
            print(try context.fetch(requestAuthors))
        }
        catch {
            print(error)
        }
    }
    
    static func deleteQuote(quoteVM: QuoteGardenQuoteVM) {
        guard let context = context else { return }
        let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
        do {
            let quotes = try context.fetch(requestQuotes)
            for quote in quotes {
                if quote.content == quoteVM.content {
                    context.delete(quote)
                }
            }
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    static func deleteQuote(content: String) {
        guard let context = context else { return }
        let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
        do {
            let quotes = try context.fetch(requestQuotes)
            for quote in quotes {
                if quote.content == content {
                    context.delete(quote)
                }
            }
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    static func deleteAuthor(authorName: String) {
        guard let context = context else { return }
        let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
        requestAuthors.returnsObjectsAsFaults = false
        do {
            let authors = try context.fetch(requestAuthors)
            for author in authors {
                if author.name == authorName {
//                    author.relationship?.allObjects.forEach {
//                        if let object = $0 as? NSManagedObject {
//                            context.delete(object)
//                        }
//                    }
                    context.delete(author)
                }
            }
            try context.save()
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
    
    static func isQuoteInCoreData(quoteVM: QuoteGardenQuoteVM) -> Bool {
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
    
    static func getAuthor(authorName: String) -> AuthorCore? {
        guard let context = context else { return nil }
        
        let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
        
        do {
            let authors = try context.fetch(requestAuthors)
            for authorCore in authors {
                if authorCore.name == authorName {
                    return authorCore as? AuthorCore
                }
            }
            return nil
        }
        catch {
            print(error)
            return nil
        }
    }
    
    static func getAuthors() -> [AuthorCore]? {
        guard let context = context else { return nil }
        let authorsRequest = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
        do {
            let authors = try context.fetch(authorsRequest)
            if let casted = authors as? [AuthorCore] {
                return casted
            }
            else {
                return nil
            }
        }
        catch {
            print(error)
            return nil
        }
    }
    
    static func getAuthorImageAsync(author: AuthorCoreVM, completion: @escaping (Result<Data?, Error>) -> Void) {
        guard let context = context else { return }
        let request = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { result in
            let imageData = result.finalResult?.first { $0.name == author.name }?.image ?? UIImage(named: "unknown")?.pngData()
            completion(.success(imageData))
        }
        do {
            let asyncResult = try context.execute(asyncRequest)
            //print(asyncResult)
        }
        catch {
            completion(.failure(error))
        }
    }
    
    static func getQuote(quoteVM: QuoteGardenQuoteVM) -> QuoteCore? {
        guard let context = context else { return nil }
        
        let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
        
        do {
            let quotes = try context.fetch(requestQuotes)
            for quoteCore in quotes {
                if quoteCore.content == quoteVM.content {
                    return quoteCore as? QuoteCore
                }
            }
            return nil
        }
        catch {
            print(error)
            return nil
        }
    }
    
    static func addPair(quoteVM: QuoteGardenQuoteVM, authorImageData: Data?) {
        guard let context = context else { return }

        let quote = QuoteCore(context: context)
        
        let isAuthorInCore: Bool = CoreDataManager.isAuthorInCoreData(authorName: quoteVM.authorName)
        let isQuoteInCore: Bool = CoreDataManager.isQuoteInCoreData(quoteVM: quoteVM)
        
        if isAuthorInCore && isQuoteInCore {
            print("CAN NOT ADD QUOTE, IT ALREADY EXISTS IN CORE DATA")
        }
        else if isAuthorInCore && !isQuoteInCore {
            print("THERE IS AUTHOR IN CORE BUT NOT THIS QUOTE, ADD THIS QUOTE AS NEW QUOTE")
            // get author and add this quote to that author
            if let authorObject = CoreDataManager.getAuthor(authorName: quoteVM.authorName) {
                quote.content = quoteVM.content
                authorObject.addToRelationship(quote)
                //quote
                do {
                    try context.save()
                }
                catch {
                    print(error)
                }
            }
        }
        else if !isAuthorInCore && isQuoteInCore {
            print("AUTHOR IS NOT IN CORE AND QUOTE IS IN CORE. DELETE RUBBISH QUOTE FROM CORE")
            CoreDataManager.deleteQuote(quoteVM: quoteVM)
        }
        else {
            print("THERE IS NOTHING LIKE THIS IN CORE. NO AUTHOR AND NO QUOTE. ADD BOTH")
            let author = AuthorCore(context: context)
            author.name = quoteVM.authorName
            author.image = authorImageData
            quote.content = quoteVM.content
            author.addToRelationship(quote)
            //quote.relationship = author
            do {
                try context.save()
            }
            catch {
                print(error)
            }
        }
    }
    
    static func removePair(quoteVM: QuoteGardenQuoteVM) {
        
        guard let context = context else { return }
        
        let isAuthorInCore: Bool = CoreDataManager.isAuthorInCoreData(authorName: quoteVM.authorName)
        let isQuoteInCore: Bool = CoreDataManager.isQuoteInCoreData(quoteVM: quoteVM)
        
        if isAuthorInCore && isQuoteInCore {
            print("REMOVE QUOTE. REMOVE AUTHOR IF IT IS EMPTY")
            //let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
            let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
            do {
                //let quotes = try context.fetch(requestQuotes)
                let authors = try context.fetch(requestAuthors)
                for author in authors {
                    if author.name == quoteVM.authorName {
                        if let set = author.relationship,
                           let objects = set.allObjects as? [QuoteCore] {
                            for quote in objects {
                                if quote.content == quoteVM.content {
                                    author.removeFromRelationship(quote)
                                    context.delete(quote)
                                }
                            }
                        }
                    }
                }
                CoreDataManager.clearWhereverNeeded()
                try context.save()
            }
            catch {
                print(error)
            }
        }
        else if isAuthorInCore && !isQuoteInCore {
            print("THERE IS ERROR. IDEA IS ON, AUTHOR IS IN CORE AND QUOTE IS NOT IN CORE")

        }
        else if !isAuthorInCore && isQuoteInCore {
            print("SUPER ERROR. IDEA IS ON, AUTHOR IS NOT IN CORE AND QUOTE IS IN CORE. REMOVE RUBBISH QUOTE")
            CoreDataManager.deleteQuote(quoteVM: quoteVM)
        }
        else {
            print("THIS IS ERROR. IDEA IS ON AND NOTHING IS IN CORE")
        }
    }
    
    static func removePair(quoteVM: QuoteGardenQuoteVM, completion: @escaping () -> Void) {
        
        guard let context = context else { return }
        
        let isAuthorInCore: Bool = CoreDataManager.isAuthorInCoreData(authorName: quoteVM.authorName)
        let isQuoteInCore: Bool = CoreDataManager.isQuoteInCoreData(quoteVM: quoteVM)
        
        if isAuthorInCore && isQuoteInCore {
            print("REMOVE QUOTE. REMOVE AUTHOR IF IT IS EMPTY")
            //let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
            let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
            do {
                //let quotes = try context.fetch(requestQuotes)
                let authors = try context.fetch(requestAuthors)
                for author in authors {
                    if author.name == quoteVM.authorName {
                        if let set = author.relationship,
                           let objects = set.allObjects as? [QuoteCore] {
                            for quote in objects {
                                if quote.content == quoteVM.content {
                                    author.removeFromRelationship(quote)
                                    context.delete(quote)
                                }
                            }
                        }
                    }
                }
                CoreDataManager.clearWhereverNeeded()
                try context.save()
            }
            catch {
                print(error)
            }
        }
        else if isAuthorInCore && !isQuoteInCore {
            print("THERE IS ERROR. IDEA IS ON, AUTHOR IS IN CORE AND QUOTE IS NOT IN CORE")

        }
        else if !isAuthorInCore && isQuoteInCore {
            print("SUPER ERROR. IDEA IS ON, AUTHOR IS NOT IN CORE AND QUOTE IS IN CORE. REMOVE RUBBISH QUOTE")
            CoreDataManager.deleteQuote(quoteVM: quoteVM)
        }
        else {
            print("THIS IS ERROR. IDEA IS ON AND NOTHING IS IN CORE")
        }
        completion()
    }
}
