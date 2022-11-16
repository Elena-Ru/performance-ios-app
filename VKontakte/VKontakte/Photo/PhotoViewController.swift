//
//  PhotoViewController.swift
//  VKontakte
//
//  Created by Елена Русских on 20.06.2022.
//

import UIKit
import SDWebImage
import SwiftUI
import RealmSwift

class PhotoViewController: UICollectionViewController {
    
    var friend: User?
    var friendID: Int?
    var friendPhotos: [Photo] = [Photo]()
    let session = Session.shared
    let apiManager = APIManager()
    var photoService: PhotoService?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
       collectionView.collectionViewLayout = createLayout()
       collectionView.dataSource = self
       collectionView.delegate = self

        if !self.friend!.isRealm {
            apiManager.getUserPhotos(token: session.token, idFriend: friendID!){ [weak self] items  in
                self?.friendPhotos = items
                do{
                    let realm = try Realm()
                    realm.beginWrite()
                    
                    for i in 0 ..< ((self?.friendPhotos.count)!){
                        self?.friendPhotos[i].owner = self?.friend
                        self?.friend?.photos.append((self?.friendPhotos[i])!)
                        self?.friend?.isRealm = true
                    }
                    try realm.commitWrite()
                }catch{
                    print(error)
                }
                self!.collectionView.reloadData()
            }
           
        } else {
            
            apiManager.getUserPhotosRealm(token: session.token, idFriend: friendID!, friend: friend!){ [weak self]  in
                    self?.loadData()
                    self?.collectionView.reloadData()
            }

        }
        photoService = PhotoService(container: collectionView)
    }
    
    
    func loadData(){
        do {
            let realm = try Realm()
            let photos = realm.objects(Photo.self).filter("owner.id == %@", self.friendID)
            self.friendPhotos = Array(photos)
        } catch{
            print(error)
        }
    }
        
        
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return friendPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoViewCell
        
            cell.photoIndex = indexPath.item
        
        let url = friendPhotos[indexPath.row].url
        
        cell.FriendPhoto.image = photoService?.photo(atIndexPath: indexPath, byUrl: url)
        
        cell.FriendPhoto.contentMode = .scaleAspectFill
        
        cell.ILikeControl.setPhotoUser(isUserLike: friendPhotos[indexPath.item].userLikes,
                                       likesCount:  friendPhotos[indexPath.item].count,
                                       cellIndex:  cell.photoIndex)
     
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime()
        groupAnimation.duration = 1

        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 0.2
        scaleDown.toValue = 1.0
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0

        groupAnimation.animations = [scaleDown,fade]
        cell.FriendPhoto.layer.add(groupAnimation, forKey: nil)
        
            return cell
        }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let newController = PhotoGalleryViewController()
        newController.modalPresentationStyle = .currentContext
        newController.friendPhotos = friendPhotos
        newController.photoIndex = indexPath.item
        self.navigationController?.pushViewController(newController, animated: true)

    }
    
        private func createLayout() -> UICollectionViewLayout{
            
            // здесь размеры айтема совпадают по размеру с размерами группы
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            //занимает по ширина половину экрана
            //   heightDimension: .fractionalWidth(0.25) - если захочу 4 в ряд и квадратики
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            // что выстроились айтемы в группе в 2 столбца
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            let spacing = CGFloat(10) // переменная для хранения расстояния
            //расстояние между айтемами (между столбцами)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            // расстояние между группами
            section.interGroupSpacing = spacing
            //отступы по краям слева и справа
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
        }
    
}

