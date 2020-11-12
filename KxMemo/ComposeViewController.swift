//
//  ComposeViewController.swift
//  KxMemo
//
//  Created by LEE Yong Seok on 2020/11/09.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var memoTextView: UITextView!
    
    var editTarget: Memo? // 편집 메모
    var originalMemoContent: String? // 이전 메모
    var willShowtoken: NSObjectProtocol? // 키보드 처리 되기전 노티피 케이션
    var willHidetoken: NSObjectProtocol?
    
    deinit {
        if let token = willShowtoken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHidetoken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalMemoContent = memo.content // 이전 메모
        }else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        
        memoTextView.delegate = self
        
        willShowtoken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else {return}
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoTextView.contentInset
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                
                inset = strongSelf.memoTextView.verticalScrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.verticalScrollIndicatorInsets = inset
            }
        })
        
        willHidetoken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongself = self else { return }
            
            var inset = strongself.memoTextView.contentInset
            inset.bottom = 0
            strongself.memoTextView.contentInset = inset
            
            inset = strongself.memoTextView.verticalScrollIndicatorInsets
            inset.bottom = 0
            strongself.memoTextView.verticalScrollIndicatorInsets = inset
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoTextView.becomeFirstResponder() // 메모 텍스트 뷰가 열리면 커서 두고 키보드가 열림
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        memoTextView.resignFirstResponder() // firstResponse 해제 
        navigationController?.presentationController?.delegate = nil
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

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {   // iOS 13.0 이상
                isModalInPresentation = original != edited  // true 이면 presentationControllerDidDismiss 함수 호출
            }else {
                print("IOS 13.0 이하 버전")
            }
        }
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "경고", message: "저장 할까요?", preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            self?.save(action)
        }
        alert.addAction(okAlertAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] action in
            self?.close(action)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ComposeViewController {
    
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let editMemoDidInsert = Notification.Name(rawValue: "editMemoDidInsert")
}
