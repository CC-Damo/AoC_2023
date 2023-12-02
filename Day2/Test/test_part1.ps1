$gameOutcomes = @(
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
    "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
    "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
    "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
)

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