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
   
   // 구조체형태의 배열을 선언해줌으로써, 유지보수성, 캡슐화 구현?!
   
   //var data = ["one", "two", "three"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
       tableViewEx.frame = view.bounds
       tableViewEx.dataSource = self
       tableViewEx.delegate = self
          
       tableViewEx.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
       
       if switchControl.isOn == true {
          cell.textLabel?.attributedText = data[indexPath.row].title.strikeThrough()
       }
       else{
          cell.textLabel?.attributedText = data[indexPath.row].title.removeStrikeThrough()
       }
       // 여기에서 if문 제어가 되면 cell.textLabel의 프로퍼티에 접근해서 on/off 상황에 맞는 메소드를 만들어 대입해주면 된다.
      // 그런데 switchControl.isOn을 제어가 불가능하다 !! 왜??
       // 데이터가 변경되고 난 후 reload 되지 않았기 때문임.
       
       //스위치의 값이 변경되었을 때, didTap() 실행
       switchControl.addTarget(self, action: #selector(didTap(_:)), for: .valueChanged)
       
       return cell
    }
   
   //switch가 선택되었으므로 tableView 내의 데이터가 변화가 생김, 따라서 reloadData() 메소드 실행
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
   
   // Asks the delegate for the editing style of a row at a particular loacation in a table view
   // 테이블 뷰 특정 부분의 row 편집 스타일을 delegate에게 요청한다.
   // 삼항 연산자의 결과를 표현하는 부분에서 나오는 프로퍼티는 enum으로 구성되어 있다. .delete .insert .none
   // indexPath.row 의 값이 0부터 시작하므로 컴파일 완료시 .delete로 설정됨
   func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
      return indexPath.row >= 0 ? .delete : .none
   }
   
   //
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
      guard editingStyle == .delete else { return }
      
      // 데이터 배열에서 실제 값 삭제
      data.remove(at: indexPath.row)
      
      // 테이블 뷰에서 행 삭제
      tableViewEx.deleteRows(at: [indexPath], with: .fade)
   }
   
   // indexPath.row 값이 0 이상인 셀만 이동이 가능하도록 설정
   func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return indexPath.row >= 0
   }
   
   // 이동가능한 셀에 삼단바를 표시
   func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

   }
   
   @IBAction func btnCreate(_ sender: UIButton) {
      
      //알림창 인스턴스 생성
      let controller = UIAlertController(title:nil, message: "Write Text", preferredStyle: UIAlertController.Style.alert)
      
      //생성한 인스턴스 안에 textField 생성
      controller.addTextField()
      
      //알림창에서 처리할 항목 생성
      let confirm = UIAlertAction(title: "확인", style: .default) { action in
         if let titleTextField = controller.textFields?.first {
            self.data.append(Todo(title: titleTextField.text!, isComplete: false, date: Date.now))
         }
      
         self.tableViewEx.reloadData()
         // data 배열에 항목이 업데이트 되었으니 tableView를 Reload 동작
      }
      let close = UIAlertAction(title: "닫기", style: .destructive)
      
      //화면에 띄워주기
      controller.addAction(confirm)
      controller.addAction(close)
      present(controller, animated: true, completion: nil)
   }
   
   @IBAction func btnEdit(_ sender: UIButton) {
      
      sender.isSelected.toggle()  // bool 값을 껐다 켰다를 반복
      
      if sender.isSelected {
         sender.setTitle("Done", for: .normal)
         tableViewEx.isEditing = true // tableView를 편집모드로 진입
         tableViewEx.delegate = self  // 셀 편집 기능 활성화
         
         
      }
      else{
         sender.setTitle("Edit", for: .normal)
         tableViewEx.isEditing = false
      }
      
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

extension ViewController {
   
   // 아래 메소드가 실행되는 시점은 언제이지? Delete 버튼이 눌렸을 때?
   func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      indexPath.row >= 0
   }
}
