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

function Get-MinimumPowers {
    param (
        [psobject]$GameObject
    )

    [int]$red = ($GameObject.turns | Measure-Object -Maximum red).Maximum
    [int]$green = ($GameObject.turns | Measure-Object -Maximum green).Maximum
    [int]$blue = ($GameObject.turns | Measure-Object -Maximum blue).Maximum

    return $red * $green * $blue
    
}

$games = $gameOutcomes | ForEach-Object {Get-GameObject $_}
$PowerOf = 0
$games | ForEach-Object { $PowerOf += Get-MinimumPowers $_}

Write-Host "Max PowerOf $PowerOf"