//
//  CollectionViewController.swift
//  Incredible Landscapes
//
//  Created by Ryan Than on 2/15/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var landscapeImages = [String]() //Array to store images
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Append the images to the array
        for i in 1...20 {
            landscapeImages.append("landscape" + String(i))
        }
        
        collectionView.collectionViewLayout = generateLayout() //Set the collection view layout
    }
    
    //Prepare to send data to Detailed View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageSegue" { //If the user clicks on a cell
            let indexPath = collectionView?.indexPath(for: sender as! CollectionViewCell) //Cast the sender as CollectionViewCell
            let detailVC = segue.destination as! DetailViewController //Get the desination view controller
            detailVC.imageName = landscapeImages[(indexPath?.row)!] //Assign the imageName with the correct image
        }
    }


    // MARK: Collection View

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return landscapeImages.count
    }
    
    //Function to draw each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        let image = UIImage(named: landscapeImages[indexPath.row])
        cell.imageView.image = image
        
        return cell
    }
    
    //Function to create + return the header/footer
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header = SupplementaryView() //Initialize a SupplementaryView for the header
        var footer = SupplementaryView() //Initialize a SupplementaryView for the footer
        if kind == UICollectionView.elementKindSectionHeader{ //If kind is a header
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerIdentifier", for: indexPath) as! SupplementaryView //Cast the header as a SupplementaryView
            header.headerLabel.text = "Incredible Landscapes"
            return header
        } else if kind == UICollectionView.elementKindSectionFooter{ //If kind is a footer
            footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerIdentifier", for: indexPath) as! SupplementaryView //Cast the footer as a SupplementaryView
            footer.footerLabel.text = "Images from: https://www.theactivetimes.com/travel/50-most-incredible-landscapes-whole-entire-world"
            return footer
        } else { //If kind is neither for some reason, throw an error
            fatalError()
        }
    }

    // MARK: Layout

    //Function to generate the overall layout for the collection view
    func generateLayout() -> UICollectionViewLayout {
        //Create item size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        //Create an item layout
        let photoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        //Item spacing
        photoItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        //Create group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15))
        //Create a group arranged horizontally
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: photoItem, count: 2)
        //Create a section with one group
        let section = NSCollectionLayoutSection(group: group)
        //Create a header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        //Create a footer
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        //Add the header and footer to the section
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        //Create and return the layout object
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
