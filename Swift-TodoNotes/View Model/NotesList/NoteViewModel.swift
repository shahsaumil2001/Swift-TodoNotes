//
//  NoteViewModel.swift
//
//

import CoreData

typealias GenericCompletion = (_ isSuccess: Bool) -> Void
class NoteListViewModel {

    // MARK: - Properties
    var notes: [NSManagedObject] = []
    var handleSuccess: (() -> Void)?
    var numberOfRows: Int {
        return self.notes.count
    }

    // MARK: - Function
    func getNote(_ indexPath: IndexPath) -> Note {
        return self.notes[indexPath.row] as? Note ?? Note()
    }

    ///
    /// The func is `fetchAllNotes` which fetch all Notes data from CoreData
    ///  A NoteListViewModel's `fetchAllNotes` method
    ///
    func fetchAllNotes() {
        if CoreDataManager.shared.fetchAllNotes() != nil {
            let notes = CoreDataManager.shared.fetchAllNotes()!
            self.notes = notes.sorted { object1, object2 in
                return ((object1).noteTime ?? Date()) > ((object2).noteTime ?? Date())
            }
        }
        self.handleSuccess?()
    }

    ///
    /// The func is `fetchAllPersons` which fetch all person data from CoreData
    ///  A NoteListViewModel's `fetchAllPersons` method
    ///
    func fetchAllPersons() -> [Note]? {
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext

        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
         */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: KeyConstants.note)

        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as? [Note]
        } catch let error as NSError {
            debugPrint("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    ///
    /// The func is `deleteNote` which will delete Note from CoreData
    ///  A NoteListViewModel's `deleteNote` method
    ///
    func deleteNote(indexToRemove: Int, completion: @escaping GenericCompletion) {
        // Delete Note from CoreData
        CoreDataManager.shared.delete(note: self.notes[indexToRemove] as? Note ?? Note())
        // Remove Note from local array
        self.notes.remove(at: indexToRemove)
        completion(true)
    }
}
