//
//  ComposeViewController.swift
//  KxMemo
//
//  Created by LEE Yong Seok on 2020/11/09.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBOutlet weak var memoTextView: UITextView!
    var editTarget: Memo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
        }else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
    }
    // 닫기
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil )
    }
    
    // 저장
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alertView(message: "내용이 없어요!")
            return
        }
        
//        let newMemo = Memo(content: memo)  // 새 메모를 생성
//        Memo.dummyMemoList.append(newMemo) // 배열에
        
        if let target = editTarget {
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.editMemoDidInsert, object: nil)
        }else {
            DataManager.shared.AddNewMemo(memo) // 새 메모를 생성
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
        dismiss(animated: true, completion: nil)// 닫기
    }
}

extension ComposeViewController {
    
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let editMemoDidInsert = Notification.Name(rawValue: "editMemoDidInsert")
}
