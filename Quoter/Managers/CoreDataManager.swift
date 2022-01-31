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
            print(try context.fetch(requestQuotes))
            print(try context.fetch(requestAuthors))
        }
        catch {
            print(error)
        }
    }
    
    static func clearWhereverNeeded() {
        guard let context = context else { return }
        let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
        let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
        
        do {
            let quotes = try context.fetch(requestQuotes)
            let authors = try context.fetch(requestAuthors)
            for quote in quotes {
                if quote.content == nil {
                    context.delete(quote)
                }
            }
            for author in authors {
                if author.isFault {
                    print("faulty")
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
    
    static func deleteQuote(quoteVM: QuoteVM) {
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
    
    static func deleteAuthor(authorName: String) {
        guard let context = context else { return }
        let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
        do {
            let authors = try context.fetch(requestAuthors)
            for author in authors {
                if author.name == authorName {
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
    
    static func getQuote(quoteVM: QuoteVM) -> QuoteCore? {
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
    
    static func addPair(quoteVM: QuoteVM, authorImageData: Data?) {
        guard let context = context else { return }

        let quote = QuoteCore(context: context)
        
        let isAuthorInCore: Bool = CoreDataManager.isAuthorInCoreData(authorName: quoteVM.author)
        let isQuoteInCore: Bool = CoreDataManager.isQuoteInCoreData(quoteVM: quoteVM)
        
        if isAuthorInCore && isQuoteInCore {
//            quote.content = quoteVM.content
            print("CAN NOT ADD QUOTE, IT ALREADY EXISTS IN CORE DATA")
        }
        else if isAuthorInCore && !isQuoteInCore {
            print("THERE IS AUTHOR IN CORE BUT NOT THIS QUOTE, ADD THIS QUOTE AS NEW QUOTE")
            // get author and add this quote to that author
            if let authorObject = CoreDataManager.getAuthor(authorName: quoteVM.author) {
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
            author.name = quoteVM.author
            author.image = authorImageData
            quote.content = quoteVM.content
            //author.addToRelationship(quote)
            quote.relationship = author
            do {
                try context.save()
            }
            catch {
                print(error)
            }
        }
    }
    
    static func removePair(quoteVM: QuoteVM) {
        
        guard let context = context else { return }
        
        let isAuthorInCore: Bool = CoreDataManager.isAuthorInCoreData(authorName: quoteVM.author)
        let isQuoteInCore: Bool = CoreDataManager.isQuoteInCoreData(quoteVM: quoteVM)
        
        if isAuthorInCore && isQuoteInCore {
            print("REMOVE QUOTE. REMOVE AUTHOR IF IT IS EMPTY")
            let requestQuotes = NSFetchRequest<QuoteCore>(entityName: "QuoteCore")
            let requestAuthors = NSFetchRequest<AuthorCore>(entityName: "AuthorCore")
            do {
                //var savedQuote: QuoteCore?
                let quotes = try context.fetch(requestQuotes)
                //let authors = try context.fetch(requestAuthors)
                for quote in quotes {
                    if quote.content == quoteVM.content {
                        //savedQuote = quote
                        context.delete(quote)
                    }
                }
//                guard let savedQuote = savedQuote else {
//                    return
//                }
//                for author in authors {
//                    if author.name == quoteVM.author {
//                        author.removeFromRelationship(savedQuote)
//                    }
//                }
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
}
