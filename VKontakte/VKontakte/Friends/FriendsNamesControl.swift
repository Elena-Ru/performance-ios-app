//
//  FriendsNamesControl.swift
//  VKontakte
//
//  Created by Елена Русских on 29.06.2022.
//

import UIKit

class FriendsNamesControl: UIControl, UIScrollViewDelegate {

    var controllerFriendsView: AllFriendsViewController!
    var buttonLetterArray = [UIButton]()
    var heightButton = 25
    var selectedLetter: UIButton? = nil

    
    var xControl: CGFloat?
    override init(frame: CGRect) {
    super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    }
    
    func createFriendsNamesControl(controller: AllFriendsViewController!) -> UIView{
        
        controllerFriendsView = controller

        //высота контролла зависит от длины массива с первыми символами
        let heightControl = CGFloat( 40 * (controller.firstLetterOfTheName.count))
        
        let friendsNameControl = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: 30,
                                                      height: heightControl))
        
        
        friendsNameControl.backgroundColor =  .clear
        friendsNameControl.layer.cornerRadius = 10
        friendsNameControl.translatesAutoresizingMaskIntoConstraints = false
        
        controller.view.addSubview(friendsNameControl)
        
      
        
        friendsNameControl.rightAnchor.constraint(equalTo: friendsNameControl.superview!.rightAnchor,
                                                  constant: -20).isActive = true
        

        friendsNameControl.topAnchor.constraint(equalTo: friendsNameControl.superview!.topAnchor,
                                                    constant: 100).isActive = true

 
        friendsNameControl.leftAnchor.constraint(equalTo: friendsNameControl.superview!.rightAnchor,
                                                 constant: -60).isActive = true
        
        friendsNameControl.bottomAnchor.constraint(equalTo: friendsNameControl.superview!.bottomAnchor,
                                                   constant: -50 ).isActive = true

        

        
        let scroll = UIScrollView()
        scroll.frame = friendsNameControl.bounds
        
        scroll.contentSize = CGSize(width: friendsNameControl.frame.width, height: friendsNameControl.frame.height + 50)
        scroll.indicatorStyle = .white
        scroll.backgroundColor = .clear
        scroll.alwaysBounceVertical = true

        friendsNameControl.addSubview(scroll)
        
        var yCoordinat = 10

        for i in 0..<controller.firstLetterOfTheName.count{
            let buttonLetter = UIButton(frame: CGRect(x: Int(bounds.width / 2 ),
                                                    y: yCoordinat,
                                                    width: 25,
                                                    height: heightButton))
            buttonLetter.setTitle(String(controller.firstLetterOfTheName[i]), for: .normal)
            buttonLetter.setTitleColor(.white, for: .normal)
            buttonLetter.titleLabel?.font = .boldSystemFont(ofSize: 21)
            buttonLetter.backgroundColor = .clear
            scroll.addSubview(buttonLetter)

            buttonLetter.addTarget(self, action: #selector(selectLetter(_:)), for:
            .touchUpInside)
            buttonLetterArray.append(buttonLetter)
            yCoordinat += (heightButton + 10)
        }
        return friendsNameControl
    }


    @objc private func selectLetter(_ sender: UIButton) {
        guard let index = self.buttonLetterArray.firstIndex(of: sender) else { return }
    self.selectedLetter = buttonLetterArray[index]
        controllerFriendsView.friendsTable.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
    }
    

  
}



