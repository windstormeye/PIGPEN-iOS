//
//  CustomStyle.swift
//  MessengerKit_Example
//
//  Created by Stephen Radford on 14/06/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import MessengerKit

struct CustomStyle: MSGMessengerStyle {
    
    var collectionView: MSGCollectionView.Type = CustomCollectionView.self
    
    var inputView: MSGInputView.Type = MSGTravInputView.self
    
    var headerHeight: CGFloat = 0
    
    var footerHeight: CGFloat = 0
    
    var backgroundColor: UIColor = .white
    
    var inputViewBackgroundColor: UIColor = .white
    
    var font: UIFont = .systemFont(ofSize: 14, weight: .bold)
    
    var inputFont: UIFont = .systemFont(ofSize: 14, weight: .bold)
    
    var inputPlaceholder: String = "Type something..."
    
    var inputTextColor: UIColor = .darkGray
    
    var inputPlaceholderTextColor: UIColor = .lightGray
    
    var outgoingTextColor: UIColor = .black
    
    var outgoingLinkColor: UIColor = .black
    
    var incomingTextColor: UIColor = .black
    
    var incomingLinkColor: UIColor = .black
    
    func size(for message: MSGMessage, in collectionView: UICollectionView) -> CGSize {
        var size: CGSize!
        
        switch message.body {
        case .text(let body):
            
            let bubble = CustomBubble()
            bubble.text = body
            bubble.font = font
            let bubbleSize = bubble.calculatedSize(in: CGSize(width: collectionView.bounds.width, height: .infinity))
            size = CGSize(width: collectionView.bounds.width, height: bubbleSize.height)
            
            break
            
            
        case .emoji:
            
            size = CGSize(width: collectionView.bounds.width, height: 60)
            
            break
            
        default:
            
            size = CGSize(width: collectionView.bounds.width, height: 175)
            
            break
        }
        
        return size
    }
    
    // MARK - Custom Properties
    
    var incomingBorderColor: UIColor = PJRGB(255, 240, 227)
    var outgoingBorderColor: UIColor = PJRGB(240, 240, 240)
    
}
