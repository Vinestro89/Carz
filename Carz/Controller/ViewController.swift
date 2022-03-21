//
//  ViewController.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    // MARK: - Typealias
    private typealias DataSource = UICollectionViewDiffableDataSource<Team, OutlineItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Team, OutlineItem>
    private typealias TeamCellRegistration = UICollectionView.CellRegistration<TeamCollectionViewCell, Team>
    private typealias DriverCellRegistration = UICollectionView.CellRegistration<DriverCollectionViewCell, Driver>
    
    
    private lazy var dataSource = makeDataSource()
    private enum OutlineItem: Hashable {
        case team(Team)
        case driver(Driver)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.dataSource = dataSource
        updateSnapshot()
    }
    
    // MARK: - Cell registration
    private func teamCell(nibName: String) -> TeamCellRegistration {
        let nib = UINib(nibName: nibName, bundle: nil)
        return TeamCellRegistration(cellNib: nib) { cell, indexPath, team in
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
        let teamCell = teamCell(nibName: "TeamCollectionViewCell")
        let driverCell = driverCell(nibName: "DriverCollectionViewCell")
        
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .team(let team):
                return collectionView.dequeueConfiguredReusableCell(using: teamCell, for: indexPath, item: team)
            case .driver(let driver):
                return collectionView.dequeueConfiguredReusableCell(using: driverCell, for: indexPath, item: driver)
            }
        }
                
        return dataSource
    }
    
    private func updateSnapshot(animatingChanges: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections(teams)
        dataSource.apply(snapshot)
        
        for team in teams {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()
            
            let header = OutlineItem.team(team)
            sectionSnapshot.append([header])
            
            let drivers = team.drivers.map { OutlineItem.driver($0) }
            sectionSnapshot.append(drivers, to: header)
            
            sectionSnapshot.expand([header])
            
            dataSource.apply(sectionSnapshot, to: team, animatingDifferences: false)
        }
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
            
            return section
        })
    }
}

