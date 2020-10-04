//
//  HistoryViewController.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/1/20.
//

import UIKit

class HistoryViewController: UICollectionViewController {
    enum Section {
        case main
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, StudyDay>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, StudyDay>
//    private let viewModel = HistoryViewModel(history: [StudyDay.example, StudyDay.example])
//    private lazy var collectionView = makeCollectionView()
//    private lazy var dataSource = makeDataSource()
    // TODO: connect with Firestore
    private lazy var dataSource = makeDataSource()
    var history = [StudyDay]()

    override func viewDidLoad() {
        super.viewDidLoad()
        FirestoreManager.shared.getStudyDays(){(studyDays) in
            self.history = studyDays
        }
        // Do any additional setup after loading the view.
        configureLayout()
        applySnapshot(animatingDifferences: false)
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, studyDay ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "HistoryCollectionViewCell",
                    for: indexPath
                ) as? HistoryCollectionViewCell
                cell?.studyDay = studyDay
                return cell
            }
        )
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
      // 2
      var snapshot = Snapshot()
      // 3
      snapshot.appendSections([.main])
      // 4
      snapshot.appendItems(history)
      // 5
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Layout Handling

extension HistoryViewController {
    // From https://www.raywenderlich.com/8241072-ios-tutorial-collection-view-and-diffable-data-source
  private func configureLayout() {
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (_, layoutEnvironment) -> NSCollectionLayoutSection? in
      let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
      let size = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
        // change this value if you want to change the height of the cell
        heightDimension: NSCollectionLayoutDimension.absolute(150)
      )
      let itemCount = isPhone ? 1 : 3
      let item = NSCollectionLayoutItem(layoutSize: size)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
      return section
    })
  }
}
