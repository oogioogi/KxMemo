//
//  MemoListTableViewController.swift
//  KxMemo
//
//  Created by LEE Yong Seok on 2020/11/09.
//

import UIKit

class MemoListTableViewController: UITableViewController {

    // 선언과 동시에 클로져를 통해 초기화
    let formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .short
        format.locale = Locale(identifier: "KO_KR")
        return format
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        print(#function) // 로그 출력
    }
    
    
    var toKen: NSObjectProtocol? // addObserver 엔트리 해제용 토큰 변수
    
    deinit {
        if toKen != nil {
            //NotificationCenter.default.removeObserver(toKen!) //엔트리 누적으로 메모리 누수 현상 발생 반드시 소멸자에서 Observer의 엔트리를 해제 한다
            NotificationCenter.default.removeObserver(toKen!, name: ComposeViewController.newMemoDidInsert, object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //코드에서 볼 수 있듯이 closure의 선언부에 [weak self] param in을 명시해주고 self가 사용되는 곳에 self를 optional로 사용해주면 strong reference cycle 상황을 피해 갈 수 있게 된다.
        //어떠한 상황에서 strong reference cycle이 발생하는지 사전에 알기 어렵기 때문에 만약 closure 내부에서 self를 사용하게 된다면 [weak self] param in을 항상 먼저 명시해주는 습관을 기르면 더 좋지 않을까 싶다.

        toKen = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) { [weak self](noti) in
            self?.tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Memo.dummyMemoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let target = Memo.dummyMemoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(from: target.insertData)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
