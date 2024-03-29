//
//  XFilterListView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/28.
//

import UIKit

class XFilterListView:XBaseView{
    
//    var editInfo : TYEditInfo

    private lazy var filterScrollView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 80)

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        view.register(cellType: XImageAndTextCell.self)
        view.dataSource = self
        view.delegate = self
//        view.selectItem(at: IndexPath(item: editInfo.filter.rawValue, section: 0), animated: true, scrollPosition: .top)
        
        return view
    }()
    
    
    
    override func configUI() {
        addSubview(filterScrollView)
        
        filterScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension XFilterListView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: XImageAndTextCell.self)
        cell.text = "测试"
        DispatchQueue.global().async {
            let image = XFilterManager.shared.brightness(to: UIImage(named: "image_02"))
            DispatchQueue.main.async {
                cell.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
    }
    
    
}
