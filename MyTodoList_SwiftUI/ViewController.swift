//
//  ViewController.swift
//  MyTodoList_SwiftUI
//
//  Created by 김광민 on 2024/03/21.
//

import UIKit

struct Todo {
   var title : String
   var isComplete : Bool
   var date : Date
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
      
   @IBOutlet weak var tableViewEx: UITableView!

   var data: [Todo] = [Todo(title: "one", isComplete: true, date: Date.now),
                     Todo(title: "two", isComplete: false, date: Date.now)]
   // 구조체형태의 배열을 선언해줌으로써, 유지보수성, 캡슐화 구현?!
   
   //var data = ["one", "two", "three"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
       tableViewEx.frame = view.bounds
       tableViewEx.dataSource = self
       tableViewEx.delegate = self
          
       tableViewEx.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       //view.addSubview(tableViewEx)
    }
      
      /* [필수] 테이블의 행 수를 보고합니다. */
      // section: 테이블뷰의 section을 나타내는 식별자 입니다. 이를 바탕으로 해당 섹션의 count를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
      /* [필수] 테이블의 각 행에 대한 셀을 제공합니다. */
      // indexPath: 테이블뷰에서 Row(행)을 찾는 경로입니다. 이를 바탕으로 적절한 cell을 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       //dequeueReusableCell와 register 메소드 관련해서는 아래를 참고하자
       //inuplace.tistory.com/1174
       
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       cell.textLabel?.text = data[indexPath.row].title
       
//       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//       cell.textLabel?.text = data[indexPath.row]
       
       // 셀부분에 스위치 달아주기
       let switchControl = UISwitch(frame: .infinite)
       switchControl.setOn(true, animated: true)
       
       switchControl.tag = indexPath.row
       cell.accessoryView = switchControl
       
       return cell
       
    }
      
      /* 행이 선택되었을 때 호출 */
      // indexPath: 테이블뷰에서 선택된 Row(행)을 찾는 경로 이를 바탕으로 어떤 행이 선택되었는지 파악할 수 있습니다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(data[indexPath.row])")
        tableViewEx.deselectRow(at: indexPath, animated: true)
       
//       let header = tableViewEx.tableHeaderView(tableView, 0)
//       let footer = tableViewEx.tableFooterView(tableView, 1)
//
    }
   
   @IBAction func btnNewCreate(_ sender: UIButton) {
      //알림창 인스턴스 생성
      let controller = UIAlertController(title:nil, message: "Write Text", preferredStyle: UIAlertController.Style.alert)
      
      //생성한 인스턴스 안에 textField 생성
      controller.addTextField()
      
      //알림창에서 처리할 항목 생성
      let confirm = UIAlertAction(title: "확인", style: .default) { action in
         if let titleTextField = controller.textFields?.first {
            self.data.append(Todo(title: titleTextField.text!, isComplete: true, date: Date.now))
         }

//      let confirm = UIAlertAction(title: "확인", style: .default) { action in
//         if let titleTextField = controller.textFields?.first {
//            self.data.append(Todo(title: titleTextField.text!, isComplete: true, date: Date.now))
//         }
      
         self.tableViewEx.reloadData()
         // data 배열에 항목이 업데이트 되었으니 tableView를 Reload 동작
      }
      let close = UIAlertAction(title: "닫기", style: .destructive)
      
      //화면에 띄워주기
      controller.addAction(confirm)
      controller.addAction(close)
      present(controller, animated: true, completion: nil)
   }
}
