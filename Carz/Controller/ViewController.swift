//
//  ViewController.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellReuseIdentifier = "DriverCellReuseIdentifier"
}

private extension ViewController {
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Driver> {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, driver in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! DriverCollectionViewCell
                
                cell.nameLabel.text = "\(driver.firstName) \(driver.lastName)"
                cell.numberLabel.text = "\(driver.number)"
                
                return cell
            }
        )
    }
    
    enum Section: Int, CaseIterable {
        case alpine
        case redbull
        case ferrari
        case mercedes
    }
}

