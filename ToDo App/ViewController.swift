import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, canReceive {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    let myDatabase = Database.database().reference().child("TODOs")
    var username = ""
    var todoArray = [String]()
    
    @IBOutlet weak var titleBarText: UINavigationItem!
    
    @IBAction func addItem(_ sender: Any) {
        let totalAmount = todoArray.count+1
        todoArray.append("\(totalAmount)")
        let indexPath = IndexPath(row: todoArray.count - 1, section: 0)
        testCollectionView.insertItems(at: [indexPath])
        print("This is the right button")
    }
    
    @IBAction func nextView(_ sender: Any) {
        performSegue(withIdentifier: "goToAddScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddScreen" {
            let secondVC = segue.destination as! AddInfoController
            secondVC.delegate = self
        }
    }
    
    func dataReceived(data: String) {
        todoArray.append(data)
        myDatabase.child(username).setValue(todoArray)
        let indexPath = IndexPath(row: todoArray.count - 1, section: 0)
        testCollectionView.insertItems(at: [indexPath])
    }
    
    func updateToDoArray(){
        myDatabase.child(username).observeSingleEvent(of: .value, with: { snapshot in
            
            let firebaseArray = snapshot.value as? Array<String> ?? []
            for thing in firebaseArray {
                print("Thing: ", thing)
                self.todoArray.append(thing)
            }
            self.testCollectionView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let delimiter = "@"
        let newstr = Auth.auth().currentUser?.email
        var token = newstr!.components(separatedBy: delimiter)
        username = token[0]
        
        updateToDoArray()
    }
    
    
    override func viewDidLoad() {
        titleBarText.title = "Hello!"
        super.viewDidLoad()
    }
    
    @IBOutlet weak var testCollectionView: UICollectionView!
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Size: ",todoArray.count)
        return self.todoArray.count
        // Get database list size
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.todoArray[indexPath.item]
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        /*let totalAmount = items.count+1
        items.append("\(totalAmount)")
        let indexPath = IndexPath(row: items.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])*/
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
}
