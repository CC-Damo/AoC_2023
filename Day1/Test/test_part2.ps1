$DebugPreference = 'SilentlyContinue'

function ConvertString-ToNumberFormat {
    param (
        [String]$textString
    )

    $replacementString = $textString

    $numberWordMappings = @{
        "one" = "o1e"
        "two" = "t2o"
        "three" = "t3e"
        "four" = "f4r"
        "five" = "f5e"
        "six" = "s6x"
        "seven" = "s7n"
        "eight" = "e8t"
        "nine" = "n9e"
    }

    foreach($key in $numberWordMappings.Keys){
        $replacementString = $replacementString -replace $key, $numberWordMappings[$key]
    }
    return $replacementString
        
}

$muddledArray = @( 
                'two1nine',
                'eightwothree',
                'abcone2threexyz',
                'xtwone3four',
                '4nineeightseven2',
                'zoneight234',
                '7pqrstsixteen'
                )

$regex = '[^\d]'

$calibrationObjects = New-Object System.Collections.ArrayList

foreach($muddledString in $muddledArray){
    Write-Debug "Processing: $muddledString"
    $convertedString = ConvertString-ToNumberFormat $muddledString

    $numbers = $convertedString -replace $regex, ''

   $calibrationObject = [PSCustomObject]@{
       orginalString = $muddledString
       firstDigit = $numbers[0]
       lastDigit    = $numbers[-1]
       calibrationValue = [String]::concat($numbers[0], $numbers[-1])
   }

   Write-Debug "First Digit: $($calibrationObject.firstDigit), Last Digit: $($calibrationObject.lastDigit), Calibration Value: $($calibrationObject.calibrationValue)"
   $calibrationObjects.Add($calibrationObject) | Out-Null
}

$sumValue = ($calibrationObjects | Measure-Object -Property calibrationValue -Sum).Sum

Write-Host "Sum Value is: $sumValue"
