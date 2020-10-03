//
//  HistoryViewController.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/1/20.
//

import UIKit

class HistoryViewController: UIViewController {
    private let viewModel = HistoryViewModel(history: [StudyDay.example, StudyDay.example])
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = makeDataSource()
    // TODO: connect with Firestore
    var history = [StudyDay.example, StudyDay.example]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CHICKEN")

        collectionView.dataSource = dataSource
        view.addSubview(collectionView)
        updateList()
        // Do any additional setup after loading the view.
    }
}

private extension HistoryViewController {
    func makeCollectionView() -> UICollectionView {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }
}

private extension HistoryViewController {
    func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, StudyDay> {
        UICollectionView.CellRegistration { cell, _, studyDay in
            // Configuring each cell's content:
            var config = cell.defaultContentConfiguration()
            config.text = studyDay.dayString
            config.secondaryText = studyDay.dayHours.toString()
            cell.contentConfiguration = config

            // Configuring a trailing swipe action for deleting a contact:
            /*
             cell.trailingSwipeActionsConfiguration = UISwipeActionsConfiguration(
                 actions: [UIContextualAction(
                     style: .destructive,
                     title: "Delete",
                     handler: { [weak self] _, _, completion in
                         self?.deleteContact(withID: contact.id)
                         self?.updateList()
                         completion(true)
                     }
                 )]
             )
             */

            // Showing a disclosure indicator as the cell's accessory:
            cell.accessories = [.disclosureIndicator()]
        }
    }
}

private extension HistoryViewController {
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, StudyDay> {
        let cellRegistration = makeCellRegistration()

        return UICollectionViewDiffableDataSource<Section, StudyDay>(
            collectionView: collectionView,
            cellProvider: { view, indexPath, item in
                view.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
}

enum Section: CaseIterable {
    case favorites
    case all
}

private extension HistoryViewController {
    func updateList() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, StudyDay>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.favorites, toSection: .favorites)
        snapshot.appendItems(viewModel.all, toSection: .all)
        dataSource.apply(snapshot)
    }
}

/*
 class SectionDecorationViewController: UIViewController {

     static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

     var currentSnapshot: NSDiffableDataSourceSnapshot<Int, Int>! = nil
     var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
     var collectionView: UICollectionView! = nil

     override func viewDidLoad() {
         super.viewDidLoad()
         navigationItem.title = "Section Background Decoration View"
         configureHierarchy()
         configureDataSource()
     }
 }

 extension SectionDecorationViewController {
     /// - Tag: Background
     func createLayout() -> UICollectionViewLayout {
         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)

         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

         let section = NSCollectionLayoutSection(group: group)
         section.interGroupSpacing = 5
         section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

         let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
             elementKind: SectionDecorationViewController.sectionBackgroundDecorationElementKind)
         sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
         section.decorationItems = [sectionBackgroundDecoration]

         let layout = UICollectionViewCompositionalLayout(section: section)
         layout.register(
             SectionBackgroundDecorationView.self,
             forDecorationViewOfKind: SectionDecorationViewController.sectionBackgroundDecorationElementKind)
         return layout
     }
 }

 extension SectionDecorationViewController {
     func configureHierarchy() {
         collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
         collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         collectionView.backgroundColor = .systemBackground
         view.addSubview(collectionView)
         collectionView.delegate = self
     }
     func configureDataSource() {

         let cellRegistration = UICollectionView.CellRegistration<ListCell, Int> { (cell, indexPath, identifier) in
             // Populate the cell with our item description.
             let sectionIdentifier = self.currentSnapshot.sectionIdentifiers[indexPath.section]
             let numberOfItemsInSection = self.currentSnapshot.numberOfItems(inSection: sectionIdentifier)
             let isLastCell = indexPath.item + 1 == numberOfItemsInSection
             cell.label.text = "\(indexPath.section),\(indexPath.item)"
             cell.seperatorView.isHidden = isLastCell
         }

         dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
             (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
             // Return the cell.
             return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
         }

         // initial data
         let itemsPerSection = 5
         let sections = Array(0..<5)
         currentSnapshot = NSDiffableDataSourceSnapshot<Int, Int>()
         var itemOffset = 0
         sections.forEach {
             currentSnapshot.appendSections([$0])
             currentSnapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
             itemOffset += itemsPerSection
         }
         dataSource.apply(currentSnapshot, animatingDifferences: false)
     }
 }

 extension SectionDecorationViewController: UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         collectionView.deselectItem(at: indexPath, animated: true)
     }
 }
 */
