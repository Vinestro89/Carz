//
//  ViewController.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    // MARK: - Typealias
    private typealias DataSource = UICollectionViewDiffableDataSource<Team, Driver>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Team, Driver>
    private typealias TeamCellRegistration = UICollectionView.SupplementaryRegistration<TeamCollectionViewCell>
    private typealias DriverCellRegistration = UICollectionView.CellRegistration<DriverCollectionViewCell, Driver>
    
    
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.dataSource = dataSource
        updateSnapshot()
    }
    
    // MARK: - Cell registration
    private func teamCell(nibName: String) -> TeamCellRegistration {
        let nib = UINib(nibName: nibName, bundle: nil)
        return TeamCellRegistration(supplementaryNib: nib, elementKind: UICollectionView.elementKindSectionHeader) { cell, elementKind, indexPath in
            let team = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            cell.photoImageView.image = UIImage(named: team.name)
        }
    }
    
    private func driverCell(nibName: String) -> DriverCellRegistration {
        let nib = UINib(nibName: nibName, bundle: nil)
        return DriverCellRegistration(cellNib: nib) { cell, indexPath, driver in
            cell.photoImageView.image = UIImage(named: driver.lastName.lowercased())
            cell.nameLabel.text = "\(driver.firstName) \(driver.lastName.uppercased())"
            cell.numberLabel.text = "#\(driver.number)"
        }
    }
    
}

// MARK: - Data source and snapshot
extension ViewController {
    private func makeDataSource() -> DataSource {
        let driverCell = driverCell(nibName: "DriverCollectionViewCell")
        let dataSource = UICollectionViewDiffableDataSource<Team, Driver>(collectionView: collectionView) { (collectionView, indexPath, driver) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: driverCell, for: indexPath, item: driver)
        }
        
        // Team header
        let teamCell = self.teamCell(nibName: "TeamCollectionViewCell")
        dataSource.supplementaryViewProvider = { view, kind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: teamCell, for: indexPath)
        }
        
        return dataSource
    }
    
    private func updateSnapshot(animatingChanges: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections(teams)
        for team in teams {
            snapshot.appendItems(team.drivers, toSection: team)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingChanges)
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
            
            // header setup
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(128)
            )
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            sectionHeader.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        })
    }
}

