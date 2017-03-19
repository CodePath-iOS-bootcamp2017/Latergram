//
//  GalleryViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/12/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var galleryCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    
    var images: [UIImage] = []
    var photo: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCustomAlbumPhotos()
        self.setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCollectionView(){
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
        self.galleryCollectionViewFlowLayout.scrollDirection = .vertical
        self.galleryCollectionViewFlowLayout.minimumInteritemSpacing = 2
        self.galleryCollectionViewFlowLayout.minimumLineSpacing = 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(self.images.count)
        if self.images.count == 0 {
            self.nextBarButton.isEnabled = false
        }else{
            self.nextBarButton.isEnabled = true
        }
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        let image = self.images[indexPath.row]
        cell.galleryImageView.image = self.resize(image: image, newSize: self.calculateCellSize())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt called. Index = \(indexPath.row)")
        self.loadupSelectedImage(photoIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize()
    }
    
    func calculateCellSize() -> CGSize {
        let totalWidth = self.galleryCollectionView.bounds.width
        let cellSideLength = totalWidth/4-2
        return CGSize(width: cellSideLength, height: cellSideLength)
    }
    
    func fetchCustomAlbumPhotos()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                let allAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                let totalImages = allAssets.count
                print("Found \(totalImages) images")
                
                let imageManager = PHCachingImageManager()
                allAssets.enumerateObjects({ (asset: PHAsset, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .fastFormat
                    options.isSynchronous = true
                    
                    let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                    
                    imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: PHImageContentMode.aspectFit, options: options, resultHandler: { (image: UIImage?, metadata: [AnyHashable : Any]?) in
                            if let photo = image {
                                self.addImgToArray(uploadImage: photo, imageCount: totalImages)
                            }
                    })
                    
                })
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
    }
    
    func addImgToArray(uploadImage:UIImage, imageCount: Int)
    {
        self.images.append(uploadImage)
        
        if images.count == 1 {
            self.loadupSelectedImage(photoIndex: 0)
        }
        
        if images.count == imageCount{
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
            }
        }
    }
    
    func loadupSelectedImage(photoIndex: Int){
        DispatchQueue.main.async {
            self.selectedImageView.image = self.resize(image: self.images[photoIndex], newSize: CGSize(width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height/2))
        }
    }
    
    @IBAction func onCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareSegue" {
            let vc = segue.destination as! ShareViewController
            if let image = self.selectedImageView.image {
                vc.shareImage = image
            }else{
                if self.images.count > 0 {
                    vc.postImageView.image = self.images[0]
                }
            }
        }
    }
    

}
