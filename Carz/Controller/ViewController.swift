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
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.bounds.width, height: 120)
            layout.estimatedItemSize = .zero
            layout.minimumInteritemSpacing = 10
        }
        
        collectionView.dataSource = dataSource
        
        updateSnapshot()
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<String, OutlineItem> {
        let teamCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Team> { cell, indexPath, team in
            var content = cell.defaultContentConfiguration()
            content.text = team.name
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
            
            sectionSnapshot.expand([header])
        }
        
        
        dataSource.apply(sectionSnapshot, to: "Root", animatingDifferences: false)
    }
}

