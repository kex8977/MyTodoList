import UIKit

struct Todo {
   let id : Int
   var title : String
   var isComplete : Bool
}

class ViewController: UIViewController {
    let mainTableView = UITableView(frame: .zero, style: .insetGrouped)
    let btnCreate: UIButton = .init(frame: .init(x: 220, y: 60, width: 150, height: 50))
   
    var data = [["Test 1-1","Test 1-2"],["Test 2-1"]]
    var header = ["Group 1", "Group 2"]

    override func viewDidLoad() {
        super.viewDidLoad()
       
       //let btnCreate: UIButton = .init(frame: .init(x: 220, y: 60, width: 150, height: 50))
       btnCreate.backgroundColor = .orange
       btnCreate.setTitle("Create by UIkit", for: .normal)
       
       self.view.addSubview(btnCreate)
       self.view.addSubview(mainTableView)
       // UIKit 방식으로 table View와 btnCreate를 화면에 생성
       
       self.mainTableView.dataSource = self
       //tableView의 DataSource로 Self(=ViewController)를 할당해줌
       //ViewController를 UITableViewDataSource으로 확장해시켜줌

       self.mainTableView.translatesAutoresizingMaskIntoConstraints = false
       self.btnCreate.translatesAutoresizingMaskIntoConstraints = false
       // autolayout을 사용하기 위해 무조건 false로 설정해야하는 값, 기본값이 true임
       
       btnCreate.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
       btnCreate.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100).isActive = true
       btnCreate.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 100).isActive = true
       //제약조건 설정하는 방법1 : Anchor별로 제약조건 설정해주기
       //equalTo 인자에 self.view.safeAreaLayoutGuide.앵커들. 으로 설정해주면, 화면 밖으로 나가지 않게끔 해준다는 기능이라고 함
       //isActive의 기본값이 False이기에 직접 설정해야함
       
        NSLayoutConstraint.activate([
         self.mainTableView.topAnchor.constraint(equalTo: self.btnCreate.bottomAnchor),
            self.mainTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.mainTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.mainTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
       //제약조건 설정하는 방법2 : NSLayoutConstraint.active() 사용해서 배열로 넘겨주기
       //isActive의 기본값이 true로 됨
       
       //제약조건 설정하는 방법3 : SnapKit 사용하기... 추후 공부하자
       
       //topAnchor와 같은 부분이 화면의 일부분인지?
       //현재 btnCreate의 위치가 이상한데, 이것을 UIkit 방식으로 왼쪽 상단에 이쁘게 배치하려면 어떻게 해야하는지?
    }
   
   @IBAction func btnCreate(_ sender: UIButton) {
      
   }
}

extension ViewController: UITableViewDataSource {
   
   //UITableViewDataSource를 사용하기 위한 필수 메서드1
   //TableView의 section이 몇 개의 row를 포함할 것인지 반환하는 메서드
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return data[section].count
   }
   
   //UITableViewDataSource를 사용하기 위한 필수 메서드2
   //cell 생성을 위한 메서드, 몇번째 section에 row인지
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
      //reuseIdentifier 는 재사용할 때 사용하는 옵션이라고 하는데..?
      
      cell.textLabel?.text = data[indexPath.section][indexPath.row]
      return cell
   }
   
   //header 배열의 개수 = Section의 개수
   func numberOfSections(in tableView: UITableView) -> Int {
      return header.count
   }
   
   //header 배열을 갖고와서 화면에 만들어주기
   func tableView(_ tableView:UITableView, titleForHeaderInSection section: Int) -> String? {
      return header[section]
   }
}
extension ViewController: UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.cellForRow(at: indexPath)?.backgroundColor = .yellow
   }
}


//현재 완성부분
//tableView는 만들기는 함
//만든 tableview에 btnCreate버튼이 안보임
//가려진건가?
