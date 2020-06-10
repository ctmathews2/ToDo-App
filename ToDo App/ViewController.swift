import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, canReceive {
    
    // Global Variables
    let reuseIdentifier = "cell" // cell identifire in storyboard
    let myDatabase = Database.database().reference().child("TODOs")
    var username = ""
    var todoArray = [String]()
    
    // Connections
    @IBOutlet weak var titleBarText: UINavigationItem!
    @IBOutlet weak var testCollectionView: UICollectionView!
    
    // Initializers
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
    
    // Buttons
    @IBAction func addItem(_ sender: Any) {
        performSegue(withIdentifier: "goToAddScreen", sender: self)
    }
    
    @IBAction func nextView(_ sender: Any) {
        performSegue(withIdentifier: "goToAddScreen", sender: self)
    }
    
    // Segue and Protocols
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
    
    // Collection view
    // MARK: - UICollectionViewDataSource protocol
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Size: ",todoArray.count)
        return self.todoArray.count
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
            
            let firebaseArray = snapshot.value as? Array<String> ?? []
            for thing in firebaseArray {
                self.todoArray.append(thing)
            }
            self.testCollectionView.reloadData()
        })
    }
    
    
}
