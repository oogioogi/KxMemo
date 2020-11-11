//
//  DetailViewController.swift
//  KxMemo
//
//  Created by LEE Yong Seok on 2020/11/10.
//

import UIKit

class DetailViewController: UIViewController {

    var memo: Memo?
    var toKen: NSObjectProtocol? // addObserver 엔트리 해제용 토큰 변수
    
    // 선언과 동시에 클로져를 통해 초기화
    let formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .short
        format.locale = Locale(identifier: "KO_KR")
        return format
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }
    
    deinit {
        if let toKen = toKen {
            //NotificationCenter.default.removeObserver(toKen!) //엔트리 누적으로 메모리 누수 현상 발생 반드시 소멸자에서 Observer의 엔트리를 해제 한다
            NotificationCenter.default.removeObserver(toKen, name: ComposeViewController.editMemoDidInsert, object: nil)
        }
    }
    
    @IBOutlet weak var editTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toKen = NotificationCenter.default.addObserver(forName: ComposeViewController.editMemoDidInsert, object: nil, queue: OperationQueue.main) { [weak self](noti) in
            self?.editTableView.reloadData()
        }
    }
}
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            cell.textLabel?.text = memo?.content
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            return cell
            
        default:
            fatalError()
        }
        
    }
    
    
}

