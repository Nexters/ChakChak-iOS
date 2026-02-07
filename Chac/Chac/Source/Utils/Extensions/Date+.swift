//
//  DateFormatterUtil.swift
//  CoreKit
//
//  Created by 이원빈 on 11/14/24.
//

import Foundation

final public class DateFormatterUtil {
    private static var cachedFormatters: [String: DateFormatter] = [:]
    private static let lock = NSLock()
    
    static public func formatter(
        format: String,
        locale: Locale = .current,
        timeZone: TimeZone = .current
    ) -> DateFormatter {
        
        lock.lock()
        defer { lock.unlock() }
        
        if let formatter = cachedFormatters[format] {
            formatter.locale = locale
            formatter.timeZone = timeZone
            return formatter
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        formatter.timeZone = timeZone
        
        cachedFormatters[format] = formatter
        return formatter
    }
}

// MARK: - 자주쓰이는 포맷 미리 정의
public extension DateFormatter {
    static let mmDDhhMM = DateFormatterUtil.formatter(
        format: "M월 d일 a h:mm",
        locale: Locale(identifier: "ko_KR")
    )
    
    static let yyyyMMdd = DateFormatterUtil.formatter(
        format: "yyyy년 MM월 dd일"
    )
}

/*
 DateFormatter 는 초기화 비용이 많이 든다. Date 타입 -> String 타입으로 변경할 때마다 DateFormatter 를 초기화시키는 것을
 방지하기 위해 dictionary cache 를 이용하여 불필요한 초기화를 방지해주는 클래스
 */
