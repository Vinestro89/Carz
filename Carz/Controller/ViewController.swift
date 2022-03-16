//
//  ViewController.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    let headerReuseIdentifier = "TeamCellReuseIdentifier"
    let cellReuseIdentifier = "DriverCellReuseIdentifier"
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.dataSource = dataSource
        
        updateSnapshot()
    }
}

// MARK: - UICollectionViewDiffableDataSource
extension ViewController {
    // This method is finally the equivalent of this good 'ol itemForRowAtIndexPath
    func makeDataSource() -> UICollectionViewDiffableDataSource<Team, Driver> {
        let dataSource = UICollectionViewDiffableDataSource<Team, Driver>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! DriverCollectionViewCell
                cell.photoImageView.image = UIImage(named: item.lastName.lowercased())
                cell.nameLabel.text = "\(item.firstName) \(item.lastName.uppercased())"
                cell.numberLabel.text = "#\(item.number)"
                return cell
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerReuseIdentifier, for: indexPath) as? TeamCollectionViewCell
            
            let team = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            cell?.photoImageView.image = UIImage(named: team.name)
            
            return cell
        }
        
        return dataSource
    }
}

// MARK: - Compositional layout
extension ViewController {
    // Here, you decide what size your item will look like
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
          
            let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(76)
          )
          let itemCount = 1
          let item = NSCollectionLayoutItem(layoutSize: size)
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
          let section = NSCollectionLayoutSection(group: group)
          section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
          section.interGroupSpacing = 10
          
            // Supplementary header view setup
          let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(70)
          )
          let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
          )
          section.boundarySupplementaryItems = [sectionHeader]
          return section
        })
    }
}

// MARK: - NSDiffableDataSourceSectionSnapshot
extension ViewController {
    // Populate the snapshot with your data and apply it to the data source
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Team, Driver>()
        
        snapshot.appendSections(teams)
        for team in teams {
            snapshot.appendItems(team.drivers, toSection: team)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

