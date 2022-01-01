/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Computed characteristic properties.
*/

import HomeKit

extension HMCharacteristic {
    /// Indicates whether you can write to the characteristic.
    var isWriteable: Bool {
        return properties.contains(HMCharacteristicPropertyWritable)
    }
    
    /// Indicates whether you can read from the characteristic.
    var isReadable: Bool {
        return properties.contains(HMCharacteristicPropertyReadable)
    }
    
    /// Indicates whether the characteristic is both readable and writable.
    var isReadWrite: Bool {
        return isReadable && isWriteable
    }
    
    /// Indicates whether the characteristic value is a floating point number.
    var isFloat: Bool {
        return metadata?.format == HMCharacteristicMetadataFormatFloat
    }
    
    /// Indicates whether the characteristic value is a signed integer.
    var isInt: Bool {
        return metadata?.format == HMCharacteristicMetadataFormatInt
    }
    
    /// Indicates whether the characteristic value is an unsigned integer.
    var isUInt: Bool {
        return metadata?.format == HMCharacteristicMetadataFormatUInt8
            || metadata?.format == HMCharacteristicMetadataFormatUInt16
            || metadata?.format == HMCharacteristicMetadataFormatUInt32
            || metadata?.format == HMCharacteristicMetadataFormatUInt64

    }
    
    /// Indicates whether the characteristic value is a number.
    var isNumeric: Bool {
        return isInt || isFloat || isUInt
    }
    
    /// Indicates whether the characteristic value is a Boolean.
    var isBool: Bool {
        return metadata?.format == HMCharacteristicMetadataFormatBool
    }
    
    /// The characteristic value as a float.
    var floatValue: Float? {
        return (value as? NSNumber)?.floatValue
    }
    
    /// The characteristic value as a decimal value.
    var decimalValue: Decimal? {
        return (value as? NSNumber)?.decimalValue
    }
    
    /// The difference between the characteristic’s maximum and minimum values.
    var span: Decimal {
        guard let max = metadata?.maximumValue?.decimalValue,
            let min = metadata?.minimumValue?.decimalValue  else {
                return 1.0
        }
        return max - min
    }
    
    /// Returns the value mappped by the given fraction
    /// to the characteristic's span, accounting for step size.
    func valueFor(fraction: Float) -> Decimal {
        let interval = metadata?.stepValue?.decimalValue ?? 1.0
        var inVal = (Decimal(Double(fraction)) * span) / interval
        var outVal: Decimal = 0.0
        NSDecimalRound(&outVal, &inVal, 0, .plain)
        return outVal * interval
    }

    /// A name that best represents the characteristic in the UI.
    var displayName: String {
        return metadata?.manufacturerDescription ?? localizedDescription
    }
    
    /// A string that represents the characteristic’s value.
    var formattedValueString: String {
        guard
            let value = value,
            let metadata = metadata else { return "—" }
        
        // Use the metadata to drive the string formatting.
        switch metadata.format {
        case HMCharacteristicMetadataFormatString:
            return value as? String ?? "—"
            
        case HMCharacteristicMetadataFormatInt,
             HMCharacteristicMetadataFormatUInt8,
             HMCharacteristicMetadataFormatUInt16,
             HMCharacteristicMetadataFormatUInt32,
             HMCharacteristicMetadataFormatUInt64:
            guard let intValue = value as? Int else { return "—" }
            return String(intValue) + symbol
            
        case HMCharacteristicMetadataFormatFloat:
            guard let floatValue = floatValue else { return "—" }
            return String(format: "%.1f", floatValue) + symbol
            
        case HMCharacteristicMetadataFormatBool:
            guard let boolValue = value as? Bool else { return "—" }
            return boolValue.string
            
        // This could be extended for other types, like data and collections.
        default:
            return "—"
        }
    }

    /// The symbol that's appropriate for the units of this characteristic.
    var symbol: String {
        guard let units = metadata?.units else { return "" }
        switch units {
        case HMCharacteristicMetadataUnitsPercentage: return "%"
        case HMCharacteristicMetadataUnitsPartsPerMillion: return "ppm"
        case HMCharacteristicMetadataUnitsCelsius: return "°C"
        case HMCharacteristicMetadataUnitsFahrenheit: return "°F"
        case HMCharacteristicMetadataUnitsSeconds: return "s"
        case HMCharacteristicMetadataUnitsLux: return "lx"
        case HMCharacteristicMetadataUnitsMicrogramsPerCubicMeter: return "μg/m³"
        case HMCharacteristicMetadataUnitsArcDegree: return "°"
        default: return ""
        }
    }
}
