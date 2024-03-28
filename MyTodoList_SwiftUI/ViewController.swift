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

   var data: [Todo] = [Todo(title: "one", isComplete: false, date: Date.now),
                     Todo(title: "two", isComplete: false, date: Date.now),
                     Todo(title: "three", isComplete: false, date: Date.now)]
   
//   var data: [Todo] = [Todo(title: "one", date: Date.now),
//                     Todo(title: "two", date: Date.now),
//                     Todo(title: "three", date: Date.now)]
   
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
       
       // 셀부분에 스위치 달아주기
       let switchControl = UISwitch(frame: .infinite)
       switchControl.setOn(data[indexPath.row].isComplete, animated: true)
       
       // 셀에 달린 스위치와 테이블 뷰를 서로 매칭시키고, 데이터 보관해두기
       switchControl.tag = indexPath.row
       data[indexPath.row].isComplete = switchControl.isOn
       
       //액세서리 뷰에 switchControl 달아주기
       cell.accessoryView = switchControl
       
       print(switchControl.isOn, switchControl.tag, indexPath.row)
       
       if switchControl.isOn == true {
          cell.textLabel?.attributedText = data[indexPath.row].title.strikeThrough()
       }
       else{
          cell.textLabel?.attributedText = data[indexPath.row].title.removeStrikeThrough()
       }
       // 여기에서 if문 제어가 되면 cell.textLabel의 프로퍼티에 접근해서 on/off 상황에 맞는 메소드를 만들어 대입해주면 된다.
      // 그런데 switchControl.isOn을 제어가 불가능하다 !! 왜??
       // 데이터가 변경되고 난 후 reload 되지 않았기 때문임.
       
       //스위치의 값이 변경되었을 때, tableViewEx reload 실행
       switchControl.addTarget(self, action: #selector(didTap(_:)), for: .valueChanged)
       
       return cell
    }
   
   //object C 의 문법?!
   @objc
   func didTap(_ sender: UISwitch) {
      
      data[sender.tag].isComplete = sender.isOn
      self.tableViewEx.reloadData()
   }
      
      /* 행이 선택되었을 때 호출 */
      // indexPath: 테이블뷰에서 선택된 Row(행)을 찾는 경로 이를 바탕으로 어떤 행이 선택되었는지 파악할 수 있습니다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       // 선택된 셀 애니메이션 실행
       tableViewEx.deselectRow(at: indexPath, animated: true)
    }
      
   @IBAction func btnNewCreate(_ sender: UIButton) {
      
      //알림창 인스턴스 생성
      let controller = UIAlertController(title:nil, message: "Write Text", preferredStyle: UIAlertController.Style.alert)
      
      //생성한 인스턴스 안에 textField 생성
      controller.addTextField()
      
      //알림창에서 처리할 항목 생성
      let confirm = UIAlertAction(title: "확인", style: .default) { action in
         if let titleTextField = controller.textFields?.first {
            self.data.append(Todo(title: titleTextField.text!, isComplete: false, date: Date.now))
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

// 취소선 속성 부여를 위한 String Class 확장하기
extension String {
   func strikeThrough() -> NSMutableAttributedString {
      let attributeString = NSMutableAttributedString(string: self)
      attributeString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
      return attributeString
   }

   func removeStrikeThrough() -> NSMutableAttributedString {
      let attributeString = NSMutableAttributedString(string: self)
      attributeString.removeAttribute(NSMutableAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
      return attributeString
   }
}
