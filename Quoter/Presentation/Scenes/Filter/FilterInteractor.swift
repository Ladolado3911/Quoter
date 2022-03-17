//
//  FilterInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/9/22.
//

import UIKit
import TTGTags
import Combine

enum DismissType {
    case clear
    case filter
}

protocol VCToFilterInteractorProtocol: AnyObject {
    var presenter: InteractorToFilterPresenterProtocol? { get set }
    
    var selectedTagStrings: [String] { get set }
    var dismissClosure: (([String]) -> Void)? { get set }
    var dismissWithTimerClosure: (() -> Void)? { get set }
    
    func requestToPopulateTags()
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt)
    func addListener()
    func cancelListeners()
    func setSelected(allTags: [TTGTextTag])
    func demolishView(completion: @escaping () -> Void)
    func dismiss(isExploreFiltered: Bool, type: DismissType)
    func dismiss()
    func didTapOnDeselect(sender: UIButton, allSelectedTags: [TTGTextTag], allTags: [TTGTextTag])
}

class FilterInteractor: VCToFilterInteractorProtocol {
    var presenter: InteractorToFilterPresenterProtocol?
    
    let filterGenreWorker = FilterGenreWorker()

    private var cancellables: Set<AnyCancellable> = []
    let selectedCountSubject = PassthroughSubject<(() -> Void), Never>()
    
    var selectedTagStrings: [String] = []
    var dismissClosure: (([String]) -> Void)?
    var dismissWithTimerClosure: (() -> Void)?

    
    func requestToPopulateTags() {
        filterGenreWorker.getGenres { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let filterObjects):
                self.presenter?.formatFetchedTags(filterObjects: filterObjects)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addListener() {
        selectedCountSubject
            .sink { [weak self] closure in
                guard let self = self else { return }
                self.presenter?.formatListener()
            }
            .store(in: &cancellables)
    }
    
    func cancelListeners() {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    func setSelected(allTags: [TTGTextTag]) {
        for tag in allTags {
            if selectedTagStrings.contains(tag.content.getAttributedString().string) {
                tag.selected = true
            }
        }
        selectedCountSubject.send {}
        presenter?.reloadCollectionView()
    }
    
    func didTapOnDeselect(sender: UIButton, allSelectedTags: [TTGTextTag], allTags: [TTGTextTag]) {
        if sender.isSelected {
           allSelectedTags.forEach { tag in
                tag.selected = false
            }
        }
        else {
            allTags.forEach { tag in
                tag.selected = true
            }
        }
        selectedCountSubject.send {}
        selectedTagStrings.removeAll()
        presenter?.reloadCollectionView()
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        selectedCountSubject.send {}
        if tag.selected {
            selectedTagStrings.append(tag.content.getAttributedString().string)
        }
        else {
            selectedTagStrings.removeAll { $0 == tag.content.getAttributedString().string }
        }
    }
    
    func demolishView(completion: @escaping () -> Void) {
        presenter?.demolish(completion: completion)
    }
    
    func dismiss(isExploreFiltered: Bool, type: DismissType) {
        if let dismissClosure = dismissClosure {
            isExploreVCFiltered = isExploreFiltered
            switch type {
            case .clear:
                dismissClosure([""])
            case .filter:
                dismissClosure(selectedTagStrings)
            }
        }
    }
    
    func dismiss() {
        if let dismissWithTimerClosure = dismissWithTimerClosure {
            dismissWithTimerClosure()
        }
        //presenter?.dismiss()
    }
    
    
}
