//
//  MemoryCache.swift
//  Nevermore
//
//  Created by 蒋永翔 on 17/3/21.
//  Copyright © 2017年 dingo. All rights reserved.
//

import UIKit

open class MemoryCache {
    /// `NSNotificationCenter` observers
    fileprivate var notificationObserver: NSObjectProtocol!

    /// The dictionary that holds the cached values
    var cacheDictionary: [AnyKey: Any] = [:]

    /// The number of items in the cache
    open var count: Int {
        return cacheDictionary.count
    }
    
    /// The limit of the amount of items that can be held in the cache. This defaults to 0, which means there is no limit.
    open var countLimit: UInt = 0 {
        didSet {
            evictItemsIfNeeded()
        }
    }
    
    // MARK: - Initialization methods
    
    public init() {
        let removalBlock = { [unowned self] (_: Notification!) -> Void in
            self.cacheDictionary.removeAll()
        }
        
        notificationObserver = NotificationCenter.default
            .addObserver(forName: NSNotification.Name.UIApplicationDidReceiveMemoryWarning,
                object: nil,
                queue: OperationQueue.main,
                using: removalBlock)
        }
    
    deinit {
        NotificationCenter.default.removeObserver(notificationObserver)
    }
    

    /// Evicts items if the `countLimit` has been reached.
    
    func evictItemsIfNeeded() {
        if countLimit > 0 && cacheDictionary.count > Int(countLimit) {
            var keys = Array(cacheDictionary.keys)
            while cacheDictionary.count > Int(countLimit) {
                let key = keys.remove(at: 0)
                cacheDictionary.removeValue(forKey: key)
            }
        }
    }
    
    /// MARK: - Public methods
    
    /**
     *    Adds an item to the cache for any given `Hashable` key
     *
     *  - parameter item  :   The item to be cached
     *  - parameter key   :   The key with which to cache the item
     */
    
    open func set<K: Hashable>(item: Any, for key: K) {
        cacheDictionary[AnyKey(key)] = item
        evictItemsIfNeeded()
    }
    
    /**
     *    Gets an item from the cache if it exists for a given `Hashable` key
     *
     *  - parameter key   :   The key whose item should be fetched
     *  - returns         :   The item from the cache if it exists, or `nil` if an item could not be found
     */
    open func item<T, K: Hashable>(for key: K) -> T? {
        if let item = cacheDictionary[AnyKey(key)] as? T {
            return item
        }
        return nil
    }
    
    /**
     *    Removes an item from the cache if it exists for a given `Hashable` key
     *
     *  - parameter key   :   The key whose item should be removed
     */

    open func remove<K: Hashable>(for key: K) {
        cacheDictionary[AnyKey(key)] = nil
    }
    
    /**
     *    Remove all items for any key that matches the given filter
     *
     *  - parameter filter   :   Closure that returns true for keys that should be removed
     */
    open func remove<K: Hashable>(matching filter: (K) -> Bool) {
        for key in cacheDictionary.keys {
            guard let key = key.underlying as? K else { continue }
            if filter(key) {
                remove(for: key)
            }
        }
    }
    
    /**
     *    Clear all caches
     */
    open func removeAll() {
        cacheDictionary.removeAll()
    }
    
    // MARK: - Subscript methods
    
    /// A subscript method that allows `Int` key subscripts.

    open subscript(key: Int) -> Any? {
        get {
            return item(for: key)
        }
        set {
            if let newValue = newValue {
                set(item: newValue, for: key)
            } else {
                remove(for: key)
            }
        }
    }
    
    /// A subscript method that allows `Float` key subscripts.

    open subscript(key: Float) -> Any? {
        get {
            return item(for: key)
        }
        set {
            if let newValue = newValue {
                set(item: newValue, for: key)
            } else {
                remove(for: key)
            }
        }
    }
    
    /// A subscript method that allows `String` key subscripts.

    open subscript(key: String) -> Any? {
        get {
            return item(for: key)
        }
        set {
            if let newValue = newValue {
                set(item: newValue, for: key)
            } else {
                remove(for: key)
            }
        }
    }
}
