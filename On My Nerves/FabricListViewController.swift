//
//  FabricListViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/1/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

class FabricListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var fabricsTable: UITableView!
    @IBOutlet weak var newFabricButton: UIButton!
    @IBOutlet weak var reorderButton: UIButton!
    
    var fabricName: UILabel?
    
    @IBAction func startEditing(_ sender: AnyObject) {
        fabricsTable.isEditing = !fabricsTable.isEditing
        newFabricButton.isEnabled = !fabricsTable.isEditing
        
        if (fabricsTable.isEditing) {
            reorderButton.setTitle("Done", for: UIControlState())
        } else {
            reorderButton.setTitle("Reorder", for: UIControlState())
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Fabric list"
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, canMoveRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
    var valueToPass:Int!
    var fromTableView:Bool = false
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        valueToPass = indexPath.row
        fromTableView = true
        performSegue(withIdentifier: "fabricSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // keep getting an error when trying to have two segues
        // so going to do this less elegant solution approach
        if (segue.identifier == "fabricSegue") {

            let viewController = segue.destination as! AddEditFabricsViewController
            
            if (fromTableView) {
               
//                println("you clicked a cell!")
                viewController.passedValue = valueToPass
                
            } else {

//                println("you clicked the + button!")
                viewController.passedValue = nil
                
            }

           fromTableView = false

        }
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAtIndexPath fromIndexPath: IndexPath, toIndexPath: IndexPath) {

        // need to move the objects first
        let fabricToMove = fabrics[fromIndexPath.row]
        fabrics.remove(at: fromIndexPath.row)
        fabrics.insert(fabricToMove, at: toIndexPath.row)
        
        // now the arrays for the data we're saving to disk
        let nameToMove = fabricNamesArray[fromIndexPath.row]
        fabricNamesArray.remove(at: fromIndexPath.row)
        fabricNamesArray.insert(nameToMove, at: toIndexPath.row)

        let timeToMove = fabricTimesArray[fromIndexPath.row]
        fabricTimesArray.remove(at: fromIndexPath.row)
        fabricTimesArray.insert(timeToMove, at: toIndexPath.row)

        // resave everything
        UserDefaults.standard.set(fabricNamesArray, forKey: "fabricNames")
        UserDefaults.standard.set(fabricTimesArray, forKey: "fabricTimes")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fabrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {

        let cell = fabricsTable.dequeueReusableCell(withIdentifier: "fabricCell")! as UITableViewCell
        
        (cell.contentView.viewWithTag(1) as! UIImageView).image = createDarkBlueImage()
        (cell.contentView.viewWithTag(2) as! UILabel).text = fabrics[indexPath.row].fabricName
        (cell.contentView.viewWithTag(3) as! UILabel).text = "\(fabrics[indexPath.row].fabricTime)"
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (fabrics.count == 0) {
            reorderButton.isEnabled = false
        } else {
            reorderButton.isEnabled = true
        }
        
        fabricsTable.reloadData()
    }
    
    // swipe to left is considered editing
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        
        // swipe to the left
        if (editingStyle == UITableViewCellEditingStyle.delete) {

            let index = indexPath.row
            
            // delete the object
            fabrics.remove(at: index)
            
            // delete stuff on the array to be saved to disk
            fabricNamesArray.remove(at: index)
            fabricTimesArray.remove(at: index)

            // resave everything
            UserDefaults.standard.set(fabricNamesArray, forKey: "fabricNames")
            UserDefaults.standard.set(fabricTimesArray, forKey: "fabricTimes")
            
            fabricsTable.reloadData()
        }
    }
    
    func createDarkBlueImage() -> UIImage {
        
        let size = CGSize(width: 100, height: 100)
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        UIColor(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0).setFill()
        
        UIRectFill(rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
}
