//
//  DetailViewController.swift
//  KxMemo
//
//  Created by LEE Yong Seok on 2020/11/10.
//

import UIKit

class DetailViewController: UIViewController {

    var memo: Memo?
    // 선언과 동시에 클로져를 통해 초기화
    let formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .short
        format.locale = Locale(identifier: "KO_KR")
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
