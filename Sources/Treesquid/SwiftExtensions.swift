import Foundation

extension Array where Element: Comparable {
    func findIndexByValue(_ value: Element) -> Int? {
        if count == 0 { return nil }
        var lowerIndex = 0
        var upperIndex = count
        var middleIndex = lowerIndex + (upperIndex - lowerIndex) / 2
        var valueAtMiddle = self[middleIndex]
        while lowerIndex < upperIndex {
            if valueAtMiddle < value {
                lowerIndex = middleIndex + 1
            } else if valueAtMiddle > value {
                upperIndex = middleIndex - 1
            } else {
                return middleIndex
            }
            middleIndex = lowerIndex + (upperIndex - lowerIndex) / 2
            if middleIndex < 0 || middleIndex >= count {
                return nil
            }
            valueAtMiddle = self[middleIndex]
        }
        return nil
    }
    
    func insertionPoint(value: Element) -> (Bool, Int) {
        if count == 0 { return (false, 0) }
        var lowerIndex = 0
        var upperIndex = count
        var middleIndex = lowerIndex + (upperIndex - lowerIndex) / 2
        var valueAtMiddle = self[middleIndex]
        while lowerIndex < upperIndex {
            if valueAtMiddle < value {
                lowerIndex = middleIndex + 1
            } else if valueAtMiddle > value {
                upperIndex = middleIndex - 1
            } else {
                return (true, middleIndex)
            }
            middleIndex = lowerIndex + (upperIndex - lowerIndex) / 2
            if middleIndex < 0 {
                return (false, 0)
            }
            if middleIndex >= count {
                return (false, count)
            }
            valueAtMiddle = self[middleIndex]
        }
        // Note: middleIndex + 1 might be array.count (an index beyond the array).
        return (false, valueAtMiddle < value ? middleIndex + 1 : Swift.max(middleIndex - 1, 0))
    }
}
