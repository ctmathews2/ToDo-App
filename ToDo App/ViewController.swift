import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, canReceive {
    
    static var sharedInstance = ViewController()
    // Global Variables
    let reuseIdentifier = "cell" // cell identifire in storyboard
    let myDatabase = Database.database().reference().child("TODOs")
    var username = ""
    var todoArray = [[String:String]]()
    var completedArray = [Bool]()
    
    // Cell size
    var cellWidth:CGFloat{
        return testCollectionView.frame.size.width * 0.75
    }
    var expandedHeight : CGFloat = 240
    var notExpandedHeight : CGFloat = 50
    var isExpanded = [Bool]()
    
    // Connections
    @IBOutlet weak var titleBarText: UINavigationItem!
    @IBOutlet weak var testCollectionView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // Initializers
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        let delimiter = "@"
        print(Auth.auth().currentUser != nil)
        let newstr = Auth.auth().currentUser?.email
        let token = newstr!.components(separatedBy: delimiter)
        for tok in token{
            print(tok)
        }
        username = token[0]
        updateToDoArray()
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        titleBarText.title = formattedDate
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        ViewController.sharedInstance = self
        super.viewDidLoad()
    }
    
    // Buttons
    @IBAction func addItem(_ sender: Any) {
        performSegue(withIdentifier: "goToAddScreen", sender: self)
    }
    @IBAction func signOutButton(_ sender: Any) {
       let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegueToReturnBack()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    // Segue and Protocols
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddScreen" {
            let secondVC = segue.destination as! AddInfoController
            secondVC.delegate = self
        }
    }
    
    func dataReceived(data: String, info: String) {
        todoArray.append(["title":data, "info":info])
        isExpanded.append(false)
        completedArray.append(false)
        myDatabase.child(username).setValue(todoArray)
        let indexPath = IndexPath(row: todoArray.count - 1, section: 0)
        testCollectionView.insertItems(at: [indexPath])
    }
    
    // Collection view
    // MARK: - UICollectionViewDataSource protocol
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todoArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.indexPath = indexPath
        // label.frame = CGRect(x:0,y:0,width:label.intrinsicContentSize.width,height:label.intrinsicContentSize.height)
        cell.myLabel.frame = CGRect(x:0,y:0,width: cellWidth, height: notExpandedHeight)
        //cell.myLabel.text = self.todoArray[indexPath.item]
        cell.myLabel.text = self.todoArray[indexPath.item]["title"]
        cell.infoLabel.frame = CGRect(x:0,y:notExpandedHeight,width: cellWidth, height: 150)
        cell.infoLabel.text = self.todoArray[indexPath.item]["info"]
        
        cell.testButtonOutlet.frame = CGRect(x:0,y:200,width: cellWidth, height: 40)
        
        //cell,infoLabel.text\\
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        if(completedArray[indexPath.row] == true){
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.myLabel.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.myLabel.attributedText = attributeString
        }
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    // test for size cell
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isExpanded[indexPath.row] == true{
            return CGSize(width: cellWidth, height: expandedHeight)
        }else{
            print("GOT HERE")
            return CGSize(width: cellWidth, height: notExpandedHeight)
        }
        
    }*/
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        self.testCollectionView.reloadItems(at: [indexPath])

    }
    
    // change background color when user touches cell
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.red
    }
    
    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.cyan
    }
    
    // funcs
    func updateToDoArray(){
        myDatabase.child(username).observeSingleEvent(of: .value, with: { snapshot in
            
            /*let firebaseArray = snapshot.value as? Array<String> ?? []
            for thing in firebaseArray {
                self.todoArray.append(thing)
            }*/
            let firebaseArray = snapshot.value as? [[String:String]] ?? []
            for thing in firebaseArray {
                self.todoArray.append(thing)
            }
            
            self.isExpanded = Array(repeating: false, count: self.todoArray.count)
            self.completedArray = Array(repeating: false, count: self.todoArray.count)
            self.testCollectionView.reloadData()
        })
    }
    
    
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isExpanded[indexPath.row] == true{
            return CGSize(width: cellWidth, height: expandedHeight)
        }else{
            return CGSize(width: cellWidth, height: notExpandedHeight)
        }
        
    }
    
}

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



