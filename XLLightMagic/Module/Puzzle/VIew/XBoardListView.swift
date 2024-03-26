//
//  XBoardListView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/25.
//
import UIKit
class XBoardListView:XBaseCollectionViewCell{
    
    var imageArray: [String]?{
        didSet{
            guard let _ = imageArray else {return}
            self.collectionView.reloadData()
        }
    }
       
    var cellSize: CGSize = CGSize(width: 38, height: 45)
    var interItemSpacing: CGFloat = 25
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = interItemSpacing
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = UIColor.white
        cw.delegate = self
        cw.dataSource = self
        cw.register(cellType: XBoardLayoutCell.self)
        return cw
    }()
    
    override func configUI() {
        addSubview(self.collectionView)
        
        collectionView.snp_makeConstraints { make in
            make.edges.equalTo(xsnp.edges).priority(.low)
        }
    }
    
}

extension XBoardListView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: XBoardLayoutCell.self)
        if let images = self.imageArray {
            let str = images[indexPath.row]
            let image = UIImage(named: str)
            cell.image = image
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
       
        
    }
}

