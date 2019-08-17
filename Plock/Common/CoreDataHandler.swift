
import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @discardableResult
    class func saveObject(memory: MemoryPlace) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Memory", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(memory.title, forKey: "title")
        manageObject.setValue(memory.address, forKey: "address")
        manageObject.setValue(memory.content, forKey: "content")
        manageObject.setValue(memory.date, forKey: "date")
        manageObject.setValue(memory.latitude, forKey: "latitude")
        manageObject.setValue(memory.longitude, forKey: "longitude")
        manageObject.setValue(memory.image, forKey: "image")
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [Memory]? {
        let context = getContext()
        var memory: [Memory]? = nil
        do {
            memory = try context.fetch(Memory.fetchRequest())
            return memory
        } catch {
            return memory
        }
    }
    
    @discardableResult
    class func deleteObject(memory: Memory) -> Bool {
        let context = getContext()
        context.delete(memory)
        do {
            try context.save()
            return true
        } catch { return false }
    }
    
    @discardableResult
    class func cleanDelete() -> Bool {
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Memory.fetchRequest())
        do {
            try context.execute(delete)
            return true
        } catch {
            return false
        }
    }
}
