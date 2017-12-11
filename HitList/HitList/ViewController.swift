/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var meters: [NSManagedObject] = []
var metersFromDatabase: [NSManagedObject] = []
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "The List"
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "Cell")
    fetchJson()
  
  
  }
 
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    
    //Generating core data fetch request
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Meter")
    
    do {
      metersFromDatabase = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }
  
 
  func fetchJson()
  {
    
    //Fetching up the data from the json vua json serialization
    if let path = Bundle.main.path(forResource: "meter", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
         if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let meters = jsonResult["data"] as? [Any] {
          // do stuff
          
          for index in meters
          {
              print(index)
            saveToDataBase(meterDictionary: index as! NSDictionary)
            
          }
        }
      }
      catch {
        // handle error
      }
    }
    
}

//Saving data to the database
  
  func saveToDataBase(meterDictionary: NSDictionary) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "Meter",
                                            in: managedContext)!
    
  let meter = NSManagedObject(entity: entity,
                                 insertInto: managedContext)
    
    
    //Saving the meters data from the api to the database
    meter.setValue(meterDictionary["Nameofequipment"], forKeyPath: "nameOfEquipment")
    meter.setValue(meterDictionary["EquipmentId"], forKeyPath: "equipmentId")
    meter.setValue(meterDictionary["Location"], forKeyPath: "location")
    meter.setValue(meterDictionary["Units"], forKeyPath: "units")
    meter.setValue(meterDictionary["Minvalue"], forKeyPath: "minValue")
    meter.setValue(meterDictionary["Maxvalue"], forKeyPath: "maxValue")
    meter.setValue(meterDictionary["Formulae"], forKeyPath: "formulae")
    meter.setValue(meterDictionary["inputValues"], forKeyPath: "inputValues")
    meter.setValue(meterDictionary["inputValues"], forKeyPath: "outputValues")
    meter.setValue(meterDictionary["ShiftTime"], forKeyPath: "shiftTime")
    meter.setValue(meterDictionary["Readings"], forKeyPath: "readings")
    meter.setValue(meterDictionary["Notes"], forKeyPath: "notes")
    meter.setValue(meterDictionary["RecordedBy"], forKeyPath: "recordedBy")
    meter.setValue(meterDictionary["Instructions"], forKeyPath: "instructions")
    
    do {
      try managedContext.save()
      meters.append(meter)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return meters.count
  }
/// Table representing Name of equipments
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let metersDatabase = metersFromDatabase[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath)
    cell.textLabel?.text = metersDatabase.value(forKeyPath: "nameOfEquipment") as? String
    return cell
  }
}
