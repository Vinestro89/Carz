//
//  ViewController.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Team, ListItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Team, ListItem>
    private typealias TeamCellRegistration = UICollectionView.CellRegistration<TeamCollectionViewCell, Team>
    private typealias DriverCellRegistration = UICollectionView.CellRegistration<DriverCollectionViewCell, Driver>
    
    let headerReuseIdentifier = "TeamCellReuseIdentifier"
    let cellReuseIdentifier = "DriverCellReuseIdentifier"
    private enum ListItem: Hashable {
        case team(Team)
        case driver(Driver)
    }
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.dataSource = dataSource
        
        // MARK: - Cell registration
        let teamCellRegistration = TeamCellRegistration { cell, indexPath, team in
            // App crashes here because photoImageView is nil, WTF ?!
            cell.photoImageView.image = UIImage(named: team.name)
        }
        
        let driverCellRegistration = DriverCellRegistration { cell, indexPath, driver in
            cell.photoImageView.image = UIImage(named: driver.lastName.lowercased())
            cell.nameLabel.text = "\(driver.firstName) \(driver.lastName.uppercased())"
            cell.numberLabel.text = "#\(driver.number)"
        }
        
        // MARK: - Initialize data source
        dataSource = UICollectionViewDiffableDataSource<Team, ListItem>(collectionView: collectionView) { (collectionView, indexPath, listItem) -> UICollectionViewCell? in
            switch listItem {
            case .team(let team):
                return collectionView.dequeueConfiguredReusableCell(using: teamCellRegistration, for: indexPath, item: team)
            case .driver(let driver):
                return collectionView.dequeueConfiguredReusableCell(using: driverCellRegistration, for: indexPath, item: driver)
            }
        }
        
        // MARK: - Setup snapshot
        var snapshot = Snapshot()
        snapshot.appendSections(teams)
        dataSource.apply(snapshot)
        
        for team in teams {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            
            let teamListItem = ListItem.team(team)
            sectionSnapshot.append([teamListItem])
            
            let drivers = team.drivers.map { ListItem.driver($0) }
            sectionSnapshot.append(drivers, to: teamListItem)
            
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

