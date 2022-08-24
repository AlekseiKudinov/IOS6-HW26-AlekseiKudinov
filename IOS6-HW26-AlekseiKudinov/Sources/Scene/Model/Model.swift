//
//  Model.swift
//  IOS6-HW26-AlekseiKudinov
//
//  Created by Алексей Кудинов on 21.08.2022.
//

import Foundation
import CoreData

protocol ModelInput: AnyObject {
    func fetchAllUsers(completion: @escaping ([NSManagedObject]?) -> ())
    func addObject(name: String, birthday: String?, gender: String?)
    func cleanCoreData() -> Bool
    func updateInfoObject(row: Int, name: String, birthday: String, gender: String)
    func deleteObject(row: Int)
}

class Model: ModelInput {

    static let instance = Model()

    var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "IOS6_HW26_AlekseiKudinov")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
    }()

    func cleanCoreData() -> Bool {
        let context = persistentContainer.viewContext
        let delete = NSBatchDeleteRequest(fetchRequest: User.fetchRequest())

        do {
            try context.execute(delete)
            return true
        } catch {
            return false
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
          do {
            try context.save()
          } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror)")
          }
        }
    }

    func fetchUser(index: Int) -> NSManagedObject? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            let users = try context.fetch(fetchRequest)
            return users[index]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
            return nil
        }
    }

    func fetchAllUsers(completion: @escaping ([NSManagedObject]?) -> ()) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            let peoples = try managedContext.fetch(fetchRequest)
            completion(peoples)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion(nil)
        }
    }

    func updateInfoObject(row: Int, name: String, birthday: String, gender: String) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            let users = try managedContext.fetch(fetchRequest)
            let user = users[row]
            user.setValue(name, forKey: "name")
            user.setValue(birthday, forKey: "birthday")
            user.setValue(gender, forKey: "gender")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
        } catch let error as NSError {
            print("Could not update. \(error)")
        }
    }

    func addObject(name: String, birthday: String?, gender: String?) {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        person.setValue(birthday ?? "", forKeyPath: "birthday")
        person.setValue(gender ?? "", forKeyPath: "gender")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }

    func deleteObject(row: Int) {
        let managedContext = persistentContainer.viewContext
        guard let person = self.fetchUser(index: row) else { return }
        managedContext.delete(person)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
}
