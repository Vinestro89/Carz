//
//  ViewController.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
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
}

// MARK: - Compositional layout
extension ViewController {
    // Here, you decide what size your item will look like
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

// MARK: - NSDiffableDataSourceSectionSnapshot
extension ViewController {
    enum OutlineItem: Hashable {
        case team(Team)
        case driver(Driver)
    }
    
    // Populate the snapshot with your data and apply it to the data source
    func updateSnapshot(animatingChange: Bool = false) {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()
        
        for team in teams {
            let header = OutlineItem.team(team)
            sectionSnapshot.append([header])
            sectionSnapshot.append(team.drivers.map { OutlineItem.driver($0) }, to: header)
            
            // Remove this comment if you want the sections expanded by default
            //sectionSnapshot.expand([header])
        }
        
        
        dataSource.apply(sectionSnapshot, to: "Root", animatingDifferences: false)
    }
}

