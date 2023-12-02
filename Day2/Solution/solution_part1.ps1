$gameOutcomes = Get-Content -Path ../puzzle_input.txt

function Get-GameObject {
    param (
        [String]$GameInput
    )

    $gameID = $GameInput.Split(':')[0].Trim().Split(' ')[1]
    $turns = $GameInput.Split(':')[1].Trim().Split(';').Trim()
    $turnArray = @()

    foreach($turn in $turns){
        $cGreen = $null
        $cRed = $null
        $cBlue = $null

        $cubes = $turn.Split(', ').Trim()
        foreach($cube in $cubes){
            $splitColour = $cube.Split(' ').Trim()
            switch($splitColour[1]){
                "red" {$cRed = $splitColour[0]}
                "green" {$cGreen = $splitColour[0]}
                "blue" {$cBlue = $splitColour[0]}
            }
        }

        $object = [PSCustomObject]@{
            green = $cGreen
            red = $cRed
            blue = $cBlue
        }
        $turnArray += $object
    }

    return [PSCustomObject]@{
        gameId = $gameID
        turns = $turnArray
    }
    
}

function Get-IsValidGame {
    param (
        [psobject]$GameObject
    )

    $red = ($GameObject.turns | Measure-Object -Maximum red).Maximum
    $green = ($GameObject.turns | Measure-Object -Maximum green).Maximum
    $blue = ($GameObject.turns | Measure-Object -Maximum blue).Maximum


    if(($red -gt 12) -or ($green -gt 13) -or ($blue -gt 14)){
        return $false
    }else{
        return $true
    }
    
}

$games = $gameOutcomes | ForEach-Object {Get-GameObject $_}

$validGames = $games | ForEach-Object {if(Get-IsValidGame $_){$_}}

$maxValue = ($validGames | Measure-Object -Sum gameId).Sum

Write-Host "The Answer is: $maxValue"