import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["1", "2"]
    var todoArray = [String]()
    
    @IBOutlet weak var titleBarText: UINavigationItem!
    
    // New View Controller or Alert Notifaction for user input
    // Segue? to store data
    
    @IBAction func addItem(_ sender: Any) {
        let totalAmount = items.count+1
        items.append("\(totalAmount)")
        let indexPath = IndexPath(row: items.count - 1, section: 0)
        testCollectionView.insertItems(at: [indexPath])
        print("This is the right button")
    }
    
    @IBAction func nextView(_ sender: Any) {
        performSegue(withIdentifier: "goToAddScreen", sender: self)
    }
    override func viewDidLoad() {
        titleBarText.title = "Hello!"
        
        let myDatabase = Database.database().reference().child("TODOs")

        let listOfToDo = ["Feed dog", "Feed self", "Do things"]
        myDatabase.child("Chandler").setValue(listOfToDo)
        let delimiter = "@"
        let newstr = Auth.auth().currentUser?.email
        var token = newstr!.components(separatedBy: delimiter)
        let username = token[0]
        myDatabase.child(username).setValue(listOfToDo)
        
        /*myDatabase.observe(.value, with: { snapshot in
            //print("VALUES: ", snapshot.value as Any)
            for child in snapshot.children{
                print(child)
            }
            
            
            
        })*/
        print("CHILDS OF USERNAME: ")
        /*myDatabase.child(username).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                print(child)
            }
        })*/
        
        
        myDatabase.child(username).observeSingleEvent(of: .value, with: { snapshot in
            
            //todoArray.append(snapshot.valueInExportFormat())
            print("HERE ----->",snapshot.value as Any)
            let testArray = snapshot.value as? Array<String> ?? []
            for thing in testArray {
                print("Thing: ", thing)
            }
            for child in snapshot.children{
                print("HERE AGAIN ---->", child as? String ?? "")
            }
            
        })
        
        
        super.viewDidLoad()
    }
    
    @IBOutlet weak var testCollectionView: UICollectionView!
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
        // Get database list size
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let totalAmount = items.count+1
        items.append("\(totalAmount)")
        let indexPath = IndexPath(row: items.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
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
