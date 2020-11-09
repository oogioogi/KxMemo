//
//  UIViewController+Alert.swift
//  KxMemo
//
//  Created by LEE Yong Seok on 2020/11/09.
//

import UIKit

extension UIViewController {
    
    func alertView(title: String = "알림", message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) // UIAlertcontroller 로 얼럿 박스 만듦!
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)             // UIAlertAction  으로 액션을 만들고 addAction으로 붙인다.
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
