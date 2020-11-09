//
//  ComposeViewController.swift
//  KxMemo
//
//  Created by LEE Yong Seok on 2020/11/09.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil )
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alertView(message: "내용이 없어요!")
            return
        }
        
        let newMemo = Memo(content: memo)  // 새 메모를 생성
        Memo.dummyMemoList.append(newMemo) // 배열에
        
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        
        dismiss(animated: true, completion: nil)// 닫기
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController {
    
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}
