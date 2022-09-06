//
//  HomeCellFavority.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/08/30.
//

import UIKit

class HomeCellFavority: UITableViewCell {
    var delegate:HomeCollectionCellDelegate?
    var layoutWidth: CGFloat!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CellA_One", bundle: nil), forCellWithReuseIdentifier: "favoriteAnimal")
        collectionView.heightAnchor.constraint(equalToConstant: 189).isActive = true
        collectionView.collectionViewLayout = createCompositionalLayout()
//        layoutWidth = (contentView.frame.width - 130 + 28) / 5
        layoutWidth = (contentView.frame.width - 60) / 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFromNoti(_:)), name: Notification.Name("updateMyFavoriteCollection"), object: nil)
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HomeCellFavority: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sharedData.st.villagersInMyFavorite.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteAnimal", for: indexPath) as? CellA_One else{fatalError()}
        
//        cell.imageView.layer.cornerRadius = cell.imageView.frame.height / 4
        cell.imageView.layer.cornerRadius = layoutWidth / 2
        
        cell.nameLabel.text = sharedData.st.nameInMyFavorite[indexPath.item]
        //        cell.imageView.image = UIImage(data: sharedData.st.iconInMyFavorite[indexPath.item])
        DispatchQueue.main.async {
            guard let img = UIImage(data: sharedData.st.iconInMyFavorite[indexPath.item])else{return}
            let originalWidth: CGFloat = img.size.width
            let originalHeight: CGFloat = img.size.height
            let newWidth: CGFloat = 32
            let scale = newWidth / originalWidth
            let newHeight = originalHeight * scale
            let size = CGSize(width: newWidth, height: newHeight)
            let render = UIGraphicsImageRenderer(size: size)
            let renderImage = render.image{ context in
                        img.draw(in:CGRect(origin: .zero, size: size))
            }
            cell.imageView.image = renderImage
        }
        
        return cell
    }
}

extension HomeCellFavority: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapVillagerCell(sharedData.st.villagersInMyFavorite[indexPath.item])
    }
}

extension HomeCellFavority {  //CollectionView Layout
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            //Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
            
            //Group (row)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: NSCollectionLayoutDimension.fractionalWidth(0.25))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 30, bottom: 10, trailing: 30)
            
            return section
        }
        return layout
    }
}

extension HomeCellFavority{
    @objc func updateFromNoti(_ noti: Notification){
        collectionView.reloadData()
    }
}
