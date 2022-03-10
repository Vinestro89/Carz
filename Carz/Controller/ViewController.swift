//
//  ViewController.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private var drivers = [
        Section.alpine: [
            Driver(team: "Alpine", firstName: "Esteban", lastName: "ocon", number: 31),
            Driver(team: "Alpine", firstName: "Fernando", lastName: "alonso", number: 14)
        ],
        Section.mercedes: [
            Driver(team: "Mercedes", firstName: "Lewis", lastName: "Hamilton", number: 44),
            Driver(team: "Mercedes", firstName: "George", lastName: "Russell", number: 63)
        ],
        Section.redbull: [
            Driver(team: "Red Bull", firstName: "Max", lastName: "Verstappen", number: 1),
            Driver(team: "Red Bull", firstName: "Sergio", lastName: "Perez", number: 11)
        ],
        Section.ferrari: [
            Driver(team: "Ferrari", firstName: "Charles", lastName: "Leclerc", number: 16),
            Driver(team: "Ferrari", firstName: "Carlos", lastName: "Sainz", number: 55)
        ]
    ]
    
    private lazy var dataSource = makeDataSource()
    let cellReuseIdentifier = "DriverCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 180, height: 120)
            layout.estimatedItemSize = .zero
            layout.minimumInteritemSpacing = 10
        }
        
        collectionView.dataSource = dataSource
        
        updateSnapshot()
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Driver> {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, driver in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! DriverCollectionViewCell
                cell.nameLabel.text = "\(driver.firstName) \(driver.lastName.uppercased())"
                cell.numberLabel.text = "#\(driver.number)"
                return cell
            }
        )
    }
    
    enum Section: Int, CaseIterable {
        case alpine
        case redbull
        case mercedes
        case ferrari
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Driver>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(drivers[.alpine]!, toSection: .alpine)
        snapshot.appendItems(drivers[.redbull]!, toSection: .redbull)
        snapshot.appendItems(drivers[.mercedes]!, toSection: .mercedes)
        snapshot.appendItems(drivers[.ferrari]!, toSection: .ferrari)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

