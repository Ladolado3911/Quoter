//
//  FilterPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/9/22.
//

import UIKit
import TTGTags

protocol InteractorToFilterPresenterProtocol: AnyObject {
    
    var vc: PresenterToFilterVCProtocol? { get set }
    
    func formatFetchedTags(filterObjects: [FilterObject])
    func formatListener()
    func reloadCollectionView()
    func demolish(completion: @escaping () -> Void)
    func dismiss()
    
}

class FilterPresenter: InteractorToFilterPresenterProtocol {
    var vc: PresenterToFilterVCProtocol?
    
    func formatFetchedTags(filterObjects: [FilterObject]) {
        let convertedToTags = filterObjects.map { $0.genre.capitalized }
        var resultArr: [TTGTextTag] = []
        for tag in convertedToTags {
            let content = TTGTextTagStringContent(text: tag)
            content.textColor = .black
            let style = TTGTextTagStyle()
            style.backgroundColor = .white
            style.textAlignment = .center
            style.extraSpace = CGSize(width: 10, height: 10)
            
            let selectedContent = TTGTextTagStringContent(text: tag)
            selectedContent.textColor = .white
            let selectedStyle = TTGTextTagStyle()
            selectedStyle.backgroundColor = .black
            selectedStyle.textAlignment = .center
            selectedStyle.extraSpace = CGSize(width: 10, height: 10)

            let selectedTextTag = TTGTextTag(content: content, style: style, selectedContent: selectedContent, selectedStyle: selectedStyle)
            resultArr.append(selectedTextTag)
        }
        vc?.displayFetchedTags(selectionLimit: UInt(convertedToTags.count - 1), resultArr: resultArr)
    }
    
    func formatListener() {
        vc?.addListener()
    }
    
    func reloadCollectionView() {
        vc?.reloadCollectionView()
    }
    
    func demolish(completion: @escaping () -> Void) {
        vc?.demolish(completion: completion)
    }
    
    func dismiss() {
        vc?.dismiss()
    }
}
