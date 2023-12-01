$DebugPreference = 'SilentlyContinue'

$muddledArray = Get-Content -Path ../puzzle_input.txt

$regex = '[^\d]'

$calibrationObjects = New-Object System.Collections.ArrayList


foreach ($muddledString in $muddledArray) {
    Write-Debug "Processing: $muddledString"

    $numbers = $muddledString -replace $regex, ''

    $calibrationObject = [PSCustomObject]@{
        orginalString    = $muddledString
        firstDigit       = $numbers[0]
        lastDigit        = $numbers[-1]
        calibrationValue = [String]::concat($numbers[0], $numbers[-1])
    }

    Write-Debug "First Digit: $($calibrationObject.firstDigit), Last Digit: $($calibrationObject.lastDigit), Calibration Value: $($calibrationObject.calibrationValue)"
    $calibrationObjects.Add($calibrationObject) | Out-Null
}

$sumValue = ($calibrationObjects | Measure-Object -Property calibrationValue -Sum).Sum

Write-Host "Sum Value is: $sumValue"