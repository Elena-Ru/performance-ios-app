//
//  PhotoGalleryViewController.swift
//  VKontakte
//
//  Created by Елена Русских on 08.07.2022.
//

import UIKit

class PhotoGalleryViewController: UIViewController {
    
    var propertyAnimatorRight: UIViewPropertyAnimator! = nil
    var isRightAnimatorStarted : Bool = false
    var propertyAnimatorLeft: UIViewPropertyAnimator! = nil
    var isLeftAnimatorStarted : Bool = false
    
    var friendPhotos: [Photo] = [Photo]() 
    
    var currentView: UIImageView = {
        let viewC = UIImageView()
        viewC.translatesAutoresizingMaskIntoConstraints = false
        viewC.clipsToBounds = true
        viewC.contentMode = .scaleAspectFit
        viewC.isUserInteractionEnabled = true
        return  viewC
    }()

    var photoIndex: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItems()
        setConstraints()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
        currentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    @objc func viewPanned(_ recognizer: UIPanGestureRecognizer){
        
        if let direction = recognizer.direction {
  
               if direction == .left{
                  
//Запущена ли анимация в протиположную сторону?  Если да,  то делаем ее реверс
                   if isRightAnimatorStarted{
                       endPreviousAnimation(propertyAnimator: propertyAnimatorRight)
                   }

                     switch recognizer.state {
                    
                     case .began:
                        
                         isLeftAnimatorStarted = true
                         
                         //проверка индекса фотографии
                         if photoIndex == friendPhotos.count - 1 {
                             recognizer.state = .ended
                         }
                         
                         propertyAnimatorLeft = UIViewPropertyAnimator(duration: 0.5,
                                                                       curve: .easeIn,
                                                                       animations: {self.animateSizeView(animateDirection: direction)})
                         
                         propertyAnimatorLeft.addCompletion { position in
                             switch position {
                             case .end:
                                 guard self.photoIndex != self.friendPhotos.count - 1 else {break}
                                
                                 self.currentView.transform = .identity
                                 self.animatePropertyAnimtatorLeftComplition()
                                 self.photoIndex = self.photoIndex + 1
                                 self.viewDidLoad()
                             case .start:
                                 print("start")
                             case .current:
                                 print("current")
                             @unknown default:
                                 print("Error")
                                
                             }
                         }
                         
                     case .changed:
                         
                         setFractionComplete(prpertyAnimator: propertyAnimatorLeft)
                      
                     case .ended:
                         
                         guard photoIndex != friendPhotos.count - 1 else{
                             currentView.transform = .identity
                             break
                         }
                         self.changeStatusPropertyAnimator( propertyAnimator: propertyAnimatorLeft)
                         
                     default:
                         break
                     }
                   
                   
               } else if direction == .right {
                   
                   if isLeftAnimatorStarted{
                       endPreviousAnimation(propertyAnimator: propertyAnimatorLeft)
                   }
                    
                     switch recognizer.state {
                    
                     case .began:
                        
                         if photoIndex == 0 {
                             recognizer.state = .ended
                         }
                         
                       isRightAnimatorStarted = true
                       propertyAnimatorRight = UIViewPropertyAnimator(duration: 0.5,
                                                                   curve: .easeIn,
                                                                   animations: {self.animateSizeView(animateDirection: direction)})
                         
                         propertyAnimatorRight.addCompletion { position in
                             switch position {
                             case .end:
                             
                                 self.currentView.transform = .identity
                                 self.animatePropertyAnimtatorRightComplition()
                                 self.photoIndex = self.photoIndex - 1
                                 self.viewDidLoad()
                             case .start:
                                 print("start")
                             case .current:
                                 print("current")
                             @unknown default:
                                 print("error")
                             }
                         }
                     case .changed:
                         
                         setFractionComplete(prpertyAnimator: propertyAnimatorRight)
                         
                     case .ended:
                         
                         guard photoIndex != 0 else{
                             currentView.transform = .identity
                             break
                         }
    
                         self.changeStatusPropertyAnimator(propertyAnimator: propertyAnimatorRight)
                         
                     default:
                         break
                     }
               }
            }
        
        func setFractionComplete(prpertyAnimator: UIViewPropertyAnimator?){
            let percent = recognizer.translation(in: self.currentView).x / 100
            prpertyAnimator?.fractionComplete = max(0, min(1, abs(percent)))
         }
    }

    
    
    func setupItems(){
        //сюда вставить загурзку для фото
        //фото из запроса
        let url = URL(string: friendPhotos[photoIndex].url)
            if let data = try? Data(contentsOf: url!)
            {
                currentView.image = UIImage(data: data)
            }
       // currentView.image = friendPhotos[photoIndex]?.photo
        view.addSubview(currentView)
    }

    func setConstraints(){
        NSLayoutConstraint.activate([
            currentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            currentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            currentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            currentView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    func animateSizeView(animateDirection : PanDirection){
        let newTranslationX: CGFloat
        
        if animateDirection == .left{
            newTranslationX = -view.frame.width
        } else{
            newTranslationX = view.frame.width
        }
        
            UIView.animateKeyframes(withDuration: 0.5,
                                    delay: 0,
                                    options: []) {
                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: 0.25) { [self] in
                    currentView.frame.size = CGSize(width: (currentView.frame.width * 0.8), height: (currentView.frame.width * 0.8))}
                UIView.addKeyframe(withRelativeStartTime: 0.25,
                                   relativeDuration: 0.75) { [self] in
                    currentView.transform = CGAffineTransform(translationX: newTranslationX,
                                                              y: 0)}
            };
    }
    
    func animatePropertyAnimtatorRightComplition(){
    UIView.transition(with: self.currentView,
                      duration: 0.3,
                      options: .transitionFlipFromLeft,
                      animations: { [self] in
        
        //фото из запроса
        let url = URL(string: self.friendPhotos[photoIndex - 1].url)
        self.currentView.sd_setImage(with: url)

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.currentView.frame.origin.x += self.currentView.frame.width
               })
    },
                      completion: {_ in self.isRightAnimatorStarted.toggle()})
    }
    
    
    
    func animatePropertyAnimtatorLeftComplition(){
        
        UIView.transition(with: self.currentView,
                          duration: 0.3,
                          options: .transitionFlipFromLeft,
                          animations: { [self] in
            //фото из запроса
            
            let url = URL(string: self.friendPhotos[photoIndex + 1].url)
            self.currentView.sd_setImage(with: url)

            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseIn],
                           animations: {
                self.currentView.frame.origin.x -= self.currentView.frame.width
                   })
        },
                          completion:  {_ in self.isLeftAnimatorStarted.toggle()})
    }
    
    
   func changeStatusPropertyAnimator( propertyAnimator: UIViewPropertyAnimator){
        if propertyAnimator.fractionComplete > 0.5 {
            propertyAnimator.continueAnimation(withTimingParameters: nil,
                                                   durationFactor: 0.5)
        } else{
            propertyAnimator.isReversed = true
            propertyAnimator.continueAnimation(withTimingParameters: nil,
                                                   durationFactor: 0.5)
        }
    }
    
    
    
}

func endPreviousAnimation(propertyAnimator: UIViewPropertyAnimator)  {
    propertyAnimator.isReversed = true
    propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
}




public enum PanDirection: Int {
    case left, right
}

public extension UIPanGestureRecognizer {

   var direction: PanDirection? {
        let velocity = self.velocity(in: view)
       let deltaVelocity: CGFloat = 0
        switch velocity.x {
        case  let x where x > deltaVelocity: return .right
        case  let x where x < deltaVelocity: return .left
        default: return nil
        }
    }
}


  


