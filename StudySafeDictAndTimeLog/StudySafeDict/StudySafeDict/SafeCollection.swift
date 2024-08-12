//
//  SafeCollection.swift
//  StudySafeDict
//
//  Created by MacBook Pro on 8/12/24.
//

import Foundation
// MARK: - SafeArray
public final class PThreadSafeArray<Element> {
    deinit {
        pthread_rwlock_destroy(&_lock)
    }
    
    private var _lock: pthread_rwlock_t
    
    fileprivate var _elements: NSMutableArray = .init()
    
    public init() {
        self._lock = pthread_rwlock_t()
        let status = pthread_rwlock_init(&_lock, nil)
#if DEBUG
        assert(status == 0)
#endif
    }
    convenience init(_ list: [Element]) {
        self.init()
        self._elements = NSMutableArray(array: list)
    }
    
    public private(set) var values: [Element] {
        get {
            defer {
                pthread_rwlock_unlock(&_lock)
            }
            pthread_rwlock_rdlock(&_lock)
            
            if let values = Array(_elements) as? [Element] {
                return values
            }
            return []
        }
        set {
            defer {
                pthread_rwlock_unlock(&_lock)
            }
            pthread_rwlock_wrlock(&_lock)
            _elements = NSMutableArray(array: newValue)
        }
    }
    
    var count: Int {
        defer {
            pthread_rwlock_unlock(&_lock)
        }
        pthread_rwlock_rdlock(&_lock)
        
        return _elements.count
    }
    var first: Element? {
        defer {
            pthread_rwlock_unlock(&_lock)
        }
        pthread_rwlock_rdlock(&_lock)
        
        return _elements.firstObject as? Element
    }
    var last: Element? {
        defer {
            pthread_rwlock_unlock(&_lock)
        }
        pthread_rwlock_rdlock(&_lock)
        
        return _elements.lastObject as? Element
    }
    
    public subscript(index: Int) -> Element? {
        get {
            defer {
                pthread_rwlock_unlock(&_lock)
            }
            pthread_rwlock_rdlock(&_lock)
            
            if index >= 0, index < _elements.count, let value = _elements[index] as? Element {
                return value
            }
            return nil
        }
        
        set(newValue) {
            defer {
                pthread_rwlock_unlock(&_lock)
            }
            pthread_rwlock_wrlock(&_lock)
            
            if let value = newValue, index >= 0 && index < _elements.count {
                _elements[index] = value
            }
        }
    }
    public func append(items: [Element]?) {
        defer {
            pthread_rwlock_unlock(&_lock)
        }
        pthread_rwlock_wrlock(&_lock)
        guard let items = items, items.count > 0 else {
            return
        }
        _elements.addObjects(from: items)
    }
    public func append(item: Element?) {
        defer {
            pthread_rwlock_unlock(&_lock)
        }
        pthread_rwlock_wrlock(&_lock)
        guard let item = item else {
            return
        }
        _elements.addObjects(from: [item])
    }
    public func insert(_ item: Element?, at i: Int?) {
        defer {
            pthread_rwlock_unlock(&_lock)
        }
        pthread_rwlock_wrlock(&_lock)
        guard let item = item, let i = i, i >= 0, i <= _elements.count else {
            return
        }
        _elements.insert(item, at: i)
    }

    public func remove(at position: Int) {
        defer {
            pthread_rwlock_unlock(&_lock)
        }
        pthread_rwlock_wrlock(&_lock)
        
        if _elements.count <= position || position < 0 {
            return
        }
        _elements.removeObject(at: position)
    }

    public func enumerated() -> EnumeratedSequence<[Element]> {
        defer {
            pthread_rwlock_unlock(&_lock)
        }
        pthread_rwlock_rdlock(&_lock)
        
        if let values = _elements as? [Element] {
            return values.enumerated()
        }
        return [].enumerated()
    }
    
    public func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        defer {
            pthread_rwlock_unlock(&_lock)
        }
        pthread_rwlock_wrlock(&_lock)
        
        let elemetents = _elements.filter { item in
            
            isIncluded(item as! Element)
        }
        if let array = elemetents as? [Element] {
            return array
        }
        return []
    }
}
// MARK: - SafeDict
public final class PThreadSafeDictionary<Key, Value> where Key: Hashable {
    deinit {
        pthread_rwlock_destroy(&lock)
    }
    
    private var lock: pthread_rwlock_t
    
    fileprivate var _elements = NSMutableDictionary()
    
    public init() {
        self.lock = pthread_rwlock_t()
        let status = pthread_rwlock_init(&lock, nil)
#if DEBUG
        assert(status == 0)
#endif
    }
    
    convenience init(_elements: [Key: Value]) {
        self.init()
        self._elements = NSMutableDictionary(dictionary: _elements)
    }
    
    private(set) var elements: [Key: Value] {
        get {
            pthread_rwlock_rdlock(&lock)
            defer {
                pthread_rwlock_unlock(&lock)
            }
            
            if let tempElements = _elements.copy() as? [Key: Value] {
                return tempElements
            }
            return [:]
        }
        set {
            pthread_rwlock_wrlock(&lock)
            defer {
                pthread_rwlock_unlock(&lock)
            }
            
            _elements = NSMutableDictionary(dictionary: newValue)
        }
    }
    
    var values: [Value] {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return _elements.allValues as? [Value] ?? []
    }
    
    var keys: [Key] {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        
        return _elements.allKeys as? [Key] ?? []
    }
    public subscript(key: Key) -> Value? {
        get {
            pthread_rwlock_rdlock(&lock)
            defer {
                pthread_rwlock_unlock(&lock)
            }
            
//            return _elements.object(forKey: key) as? Value
            return _elements[key] as? Value
        }
        set {
            pthread_rwlock_wrlock(&lock)
            defer {
                pthread_rwlock_unlock(&lock)
            }
            
            _elements[key] = newValue
        }
    }
    var count: Int {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
            
        return _elements.count
    }
    // MARK: test
    func testSetByObjectForKey(key: Key, item: Value?) -> Void {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        if let item = item {
            if let key = key as? NSCopying {
                _elements.setObject(item, forKey: key)
            } else {
                _elements[key] = item
            }
        } else {
            _elements.removeObject(forKey: key)
        }
    }
    func testGetByObjectForKey(key: Key) -> Value? {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return _elements.object(forKey: key) as? Value
    }
}
