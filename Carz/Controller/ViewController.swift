//
//  ViewController.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private var teams = [
        Team(name: "Alpine", drivers: [
            Driver(firstName: "Esteban", lastName: "ocon", number: 31),
            Driver(firstName: "Fernando", lastName: "alonso", number: 14)
        ]),
        Team(name: "Mercedes", drivers: [
            Driver(firstName: "Lewis", lastName: "Hamilton", number: 44),
            Driver(firstName: "George", lastName: "Russell", number: 63)
        ]),
        Team(name: "Red Bull", drivers: [
            Driver(firstName: "Max", lastName: "Verstappen", number: 1),
            Driver(firstName: "Sergio", lastName: "Perez", number: 11)
        ]),
        Team(name: "Ferrari", drivers: [
            Driver(firstName: "Charles", lastName: "Leclerc", number: 16),
            Driver(firstName: "Carlos", lastName: "Sainz", number: 55)
        ])
    ]
    
    private lazy var dataSource = makeDataSource()
    let cellReuseIdentifier = "DriverCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.dataSource = dataSource
        
        updateSnapshot()
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<String, OutlineItem> {
        let teamCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Team> { cell, indexPath, team in
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(named: team.name)
            content.imageProperties.maximumSize = CGSize(width: .max, height: 70)
            cell.contentConfiguration = content
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
        }
        
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                switch item {
                case .team(let team):
                    return collectionView.dequeueConfiguredReusableCell(using: teamCellRegistration, for: indexPath, item: team)
                case .driver(let driver):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! DriverCollectionViewCell
                    cell.photoImageView.image = UIImage(named: driver.lastName.lowercased())
                    cell.nameLabel.text = "\(driver.firstName) \(driver.lastName.uppercased())"
                    cell.numberLabel.text = "#\(driver.number)"
                    return cell
                }
            }
        )
    }
    
    enum OutlineItem: Hashable {
        case team(Team)
        case driver(Driver)
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()
        
        for team in teams {
            let header = OutlineItem.team(team)
            sectionSnapshot.append([header])
            sectionSnapshot.append(team.drivers.map { OutlineItem.driver($0) }, to: header)
            
            //sectionSnapshot.expand([header])
        }
        
        
        dataSource.apply(sectionSnapshot, to: "Root", animatingDifferences: false)
    }
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {_, _ in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(76)
            ))

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(self.view.bounds.height)),
                subitems: [item]
            )

            return NSCollectionLayoutSection(group: group)
        }
    }
}

