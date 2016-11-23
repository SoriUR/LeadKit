//
//  FixedPageCursor.swift
//  LeadKit
//
//  Created by Ivan Smolin on 23/11/16.
//  Copyright © 2016 Touch Instinct. All rights reserved.
//

import RxSwift

/// Paging cursor implementation with enclosed cursor for fetching results
public class FixedPageCursor<Cursor: CursorType>: CursorType where Cursor.LoadResultType == CountableRange<Int> {

    public typealias LoadResultType = CountableRange<Int>

    private let cursor: Cursor

    private let pageSize: Int

    /// Initializer with enclosed cursor
    ///
    /// - Parameters:
    ///   - cursor: enclosed cursor
    ///   - pageSize: number of items loaded at once
    public init(cursor: Cursor, pageSize: Int) {
        self.cursor = cursor
        self.pageSize = pageSize
    }

    public var exhausted: Bool {
        return cursor.exhausted && cursor.count == count
    }

    public private(set) var count: Int = 0

    public subscript(index: Int) -> Cursor.Element {
        return cursor[index]
    }

    public func loadNextBatch() -> Observable<LoadResultType> {
        return Observable.create { [weak self] observer in
            guard let strongSelf = self else {
                observer.onError(CursorError.deallocated)

                return Disposables.create()
            }

            if strongSelf.exhausted {
                observer.onError(CursorError.exhausted)

                return Disposables.create()
            }

            let restOfLoaded = strongSelf.cursor.count - strongSelf.count

            if restOfLoaded >= strongSelf.pageSize || strongSelf.cursor.exhausted {
                let startIndex = strongSelf.count
                strongSelf.count += min(restOfLoaded, strongSelf.pageSize)

                observer.onNext(startIndex..<strongSelf.count)

                return Disposables.create()
            }

            return strongSelf.cursor.loadNextBatch()
                .map { [weak self] _ -> Observable<LoadResultType> in
                    guard let strongSelf = self else {
                        throw CursorError.deallocated
                    }

                    return strongSelf.loadNextBatch()
                }
                .subscribe()
        }
    }
    
}
