//
//  GalleryVC.swift
//  ScrollStackControllerDemo
//
//  Created by Daniele Margutti on 04/10/2019.
//  Copyright © 2019 ScrollStackController. All rights reserved.
//

import UIKit

public class GalleryVC: UIViewController, ScrollStackContainableController {
    
    @IBOutlet public var collectionView: UICollectionView!
    @IBOutlet public var pageControl: UIPageControl!

    public var urls: [URL] = [
        URL(string: "https://www.telegraph.co.uk/content/dam/Travel/2019/February/fuji.jpg?imwidth=450")!,
        URL(string: "https://japan-magazine.jnto.go.jp/jnto2wm/wp-content/uploads/1608_special_TOTO_main.jpg")!,
        URL(string: "https://millionmilesecrets.com/wp-content/uploads/Japan-Kyoto.jpg")!,
        URL(string: "https://media.cntraveller.in/wp-content/uploads/2019/07/Japan-leadraw-and-fine-866x487.jpg")!
    ]
        
    public static func create() -> GalleryVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GalleryVC") as! GalleryVC
        return vc
    }
    
    public func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: ScrollStackRow, in stackView: ScrollStack) -> CGFloat? {
        return 300
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    public func reloadContentFromStackViewRow() {
        
    }

    private func reloadData() {
        pageControl.numberOfPages = urls.count
        collectionView.reloadData()
    }
    
}

extension GalleryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        cell.url = urls[indexPath.item]
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
    
}

public class GalleryCell: UICollectionViewCell {
    
    @IBOutlet public var imageView: UIImageView!
    
    private var dataTask: URLSessionTask?
    
    public var url: URL? {
        didSet {
            dataTask?.cancel()

            guard let url = url else {
                self.imageView.image = nil
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
                let image = (data != nil ? UIImage(data: data!) : nil)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            dataTask?.resume()
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.url = nil
    }
    
}