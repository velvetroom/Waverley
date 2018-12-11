import Foundation
import CloudKit

class Syncher:Synch {
    var updates:(([String:TimeInterval]) -> Void)!
    var loaded:((Note) -> Void)!
    
    func start() {
        DispatchQueue.global(qos:.background).async {
            self.register()
            self.fetch()
        }
    }
    
    func load(_ id:String) {
        print("load \(id)")
        DispatchQueue.global(qos:.background).async {
            CKContainer(identifier:"iCloud.Waverley").publicCloudDatabase.fetch(withRecordID:.init(recordName:id))
            { record, _ in
                if let json = record?["json"] as? CKAsset,
                    let data = try? Data(contentsOf:json.fileURL),
                    let note = try? JSONDecoder().decode(Note.self, from:data) {
                    self.loaded(note)
                }
            }
        }
    }
    
    func save(_ account:[String:TimeInterval]) {
        DispatchQueue.global(qos:.background).async {
            NSUbiquitousKeyValueStore.default.set(account, forKey:"waverley.notes")
            NSUbiquitousKeyValueStore.default.synchronize()
        }
    }
    
    func save(_ note:Note) {
        DispatchQueue.global(qos:.background).async {
            let record = CKRecord(recordType:"Note", recordID:.init(recordName:note.id))
            record["json"] = CKAsset(fileURL:Storer.note(note))
            let operation = CKModifyRecordsOperation(recordsToSave:[record])
            operation.savePolicy = .allKeys
            CKContainer(identifier:"iCloud.Waverley").publicCloudDatabase.add(operation)
        }
    }
    
    private func register() {
        NotificationCenter.default.addObserver(forName:NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object:nil, queue:OperationQueue()) { _ in self.fetch() }
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    private func fetch() {
        print("fetching in main \(Thread.main == Thread.current)")
        if let account = NSUbiquitousKeyValueStore.default.dictionary(
            forKey:"waverley.notes") as? [String:TimeInterval] {
            updates(account)
        }
    }
}
