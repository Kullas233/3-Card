function Find-Index
{
    Param(
        [Parameter(Mandatory=$True)]
        [String]$str,
        [Parameter(Mandatory=$True)]
        [String]$find,
        [Parameter(Mandatory=$True)]
        [Int]$num
    )
    
    $index = 0
    for($x = 0; $x -lt $num; $x++)
    {
        $index += $str.indexOf($find)+1
        $str = $str.Substring($str.indexOf($find)+1)
    }
    return $index
}

function Find-Hand
{
    Param(
        [Parameter(Mandatory=$True)]
        [String]$c1,
        [Parameter(Mandatory=$True)]
        [String]$c2,
        [Parameter(Mandatory=$True)]
        [String]$c3
    )

    for($x = 0; $x -lt ($data.Count/3); $x++)
    {
        if(($c1 -eq $data[$x, 0]) -or ($c1 -eq $data[$x, 1]) -or ($c1 -eq $data[$x, 2]))
        {
            if(($c2 -eq $data[$x, 0]) -or ($c2 -eq $data[$x, 1]) -or ($c2 -eq $data[$x, 2]))
            {
                if(($c3 -eq $data[$x, 0]) -or ($c3 -eq $data[$x, 1]) -or ($c3 -eq $data[$x, 2]))
                {
                    return $x
                }
            }
        }
    }
}

function Write-Hand
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$hand
    )
    $c1 = $data[$hand, 0]
    $c2 = $data[$hand, 1] 
    $c3 = $data[$hand, 2]

    Write-Host $c1 $c2 $c3
}

function Determine-Hand
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$hand
    )
    $straight = Check-Straight -hand $hand
    $flush = Check-Flush -hand $hand

    if($straight -and $flush)
    {
        return 1
    }

    $trio = Check-Trio -hand $hand
    if($trio)
    {
        return 2
    }
    if($straight)
    {
        return 3
    }
    if($flush)
    {
        return 4
    }

    $pair = Check-Pair -hand $hand
    if($pair)
    {
        return 5
    }
    return 6
}
function Compare-Hand
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$h1,
        [Parameter(Mandatory=$True)]
        [Int]$h2
    )
    $r1 = Determine-Hand -hand $h1
    $r2 = Determine-Hand -hand $h2

    if($r1 -lt $r2)
    {
        return $h1
    }
    elseif($r2 -lt $r1)
    {
        return $h2
    }
    else
    {
        if($r1 -eq 5)
        {
            return Compare-PairHC -h1 $h1 -h2 $h2
        }
        else
        {
            return Compare-HC -h1 $h1 -h2 $h2
        }
    }
}

function Compare-HC
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$h1,
        [Parameter(Mandatory=$True)]
        [Int]$h2
    )
    $c1 = $data[$h1, 0]
    $c2 = $data[$h1, 1] 
    $c3 = $data[$h1, 2]
    $temp1 = @()
    $temp1 += $order.IndexOf($c1.Substring(0, $c1.Length-1))
    $temp1 += $order.IndexOf($c2.Substring(0, $c2.Length-1))
    $temp1 += $order.IndexOf($c3.Substring(0, $c3.Length-1))
    $temp1 = $temp1 | Sort-Object -Descending

    $c1 = $data[$h2, 0]
    $c2 = $data[$h2, 1] 
    $c3 = $data[$h2, 2]
    $temp2 = @()
    $temp2 += $order.IndexOf($c1.Substring(0, $c1.Length-1))
    $temp2 += $order.IndexOf($c2.Substring(0, $c2.Length-1))
    $temp2 += $order.IndexOf($c3.Substring(0, $c3.Length-1))
    $temp2 = $temp2 | Sort-Object -Descending

    if($temp1[0] -gt $temp2[0])
    {
        return $h1
    }
    elseif($temp1[0] -lt $temp2[0])
    {
        return $h2
    }
    else
    {
        if($temp1[1] -gt $temp2[1])
        {
            return $h1
        }
        elseif($temp1[1] -lt $temp2[1])
        {
            return $h2
        }
        else
        {
            if($temp1[2] -gt $temp2[2])
            {
                return $h1
            }
            elseif($temp1[2] -lt $temp2[2])
            {
                return $h2
            }
            else
            {
                return -1
            }
        }
    }
}

function Compare-PairHC
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$h1,
        [Parameter(Mandatory=$True)]
        [Int]$h2
    )
    $p1 = Get-PairCard -hand $h1
    $p2 = Get-PairCard -hand $h2

    if($order.IndexOf($p1) -gt $order.IndexOf($p2))
    {
        return $h1
    }
    elseif($order.IndexOf($p1) -lt $order.IndexOf($p2))
    {
        return $h2
    }
    
    for($x = 0; $x -lt 3; $x++)
    {
        if($data[$h1, $x].Substring(0, ($data[$h1, $x].Length-1)) -ne $p1)
        {
            $o1 = $data[$h1, $x].Substring(0, ($data[$h1, $x].Length-1))
        }
    }
    for($x = 0; $x -lt 3; $x++)
    {
        if($data[$h2, $x].Substring(0, ($data[$h2, $x].Length-1)) -ne $p2)
        {
            $o2 = $data[$h2, $x].Substring(0, ($data[$h2, $x].Length-1))
        }
    }

    if($order.IndexOf($o1) -gt $order.IndexOf($o2))
    {
        return $h1
    }
    elseif($order.IndexOf($o1) -lt $order.IndexOf($o2))
    {
        return $h2
    }
    return -1
}

function Check-Trio
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$hand
    )
    $c1 = $data[$hand, 0]
    $c2 = $data[$hand, 1] 
    $c3 = $data[$hand, 2]

    if(($c1.Substring(0, $c1.Length-1) -eq $c2.Substring(0, $c2.Length-1)) -and ($c2.Substring(0, $c2.Length-1) -eq $c3.Substring(0, $c3.Length-1)))
    {
        return $true
    }
    return $false
}

$order = @("2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A")
function Check-Straight
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$hand
    )
    $c1 = $data[$hand, 0]
    $c2 = $data[$hand, 1] 
    $c3 = $data[$hand, 2]

    $temp = @()
    $temp += $order.IndexOf($c1.Substring(0, $c1.Length-1))
    $temp += $order.IndexOf($c2.Substring(0, $c2.Length-1))
    $temp += $order.IndexOf($c3.Substring(0, $c3.Length-1))
    $temp = $temp | Sort-Object

    if(($temp[0]+2 -eq $temp[1]+1) -and ($temp[1]+1 -eq $temp[2]))
    {
        return $true
    }
    elseif($temp[0] -eq 0 -and $temp[1] -eq 1 -and $temp[2] -eq 12)
    {
        return $true
    }
    return $false
}

function Check-Flush
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$hand
    )
    $c1 = $data[$hand, 0]
    $c2 = $data[$hand, 1] 
    $c3 = $data[$hand, 2]

    if(($c1.Substring($c1.Length-1, 1) -eq $c2.Substring($c2.Length-1, 1)) -and ($c2.Substring($c2.Length-1, 1) -eq $c3.Substring($c3.Length-1, 1)))
    {
        return $true
    }
    return $false
}

function Get-PairCard
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$hand
    )
    $c1 = $data[$hand, 0]
    $c2 = $data[$hand, 1] 
    $c3 = $data[$hand, 2]

    if(($c1.Substring(0, $c1.Length-1) -eq $c2.Substring(0, $c2.Length-1)) -or ($c2.Substring(0, $c2.Length-1) -eq $c3.Substring(0, $c3.Length-1)))
    {
        return $c2.Substring(0, $c2.Length-1)
    }
    return $c1.Substring(0, $c1.Length-1)
}

function Check-Pair
{
    Param(
        [Parameter(Mandatory=$True)]
        [Int]$hand
    )
    $c1 = $data[$hand, 0]
    $c2 = $data[$hand, 1] 
    $c3 = $data[$hand, 2]

    if(($c1.Substring(0, $c1.Length-1) -eq $c2.Substring(0, $c2.Length-1)) -or ($c2.Substring(0, $c2.Length-1) -eq $c3.Substring(0, $c3.Length-1)) -or ($c1.Substring(0, $c1.Length-1) -eq $c3.Substring(0, $c3.Length-1)))
    {
        return $true
    }
    return $false
}

function Get-Data
{
    $strdata = Get-Content -Path "C:\Users\kulla\OneDrive\Documents\3-card\combs.txt"

    $data = New-Object 'object[,]' $strdata.Count,3
    
    for($y = 0; $y -lt $strdata.Count; $y++)
    {
        for($x = 0; $x -lt 6; $x+=2)
        {
            $i1 = Find-Index -str $strdata[$y] -find "'" -num ($x+1)
            $i2 = Find-Index -str $strdata[$y] -find "'" -num ($x+2)
            $data[$y, ($x/2)] = $strdata[$y].Substring($i1 ,$i2-$i1-1)
        } 
    }
}

if($data.Count -eq 0)
{
    $strdata = Get-Content -Path "C:\Users\kulla\OneDrive\Documents\3-card\combs.txt"

    $data = New-Object 'object[,]' $strdata.Count,3
    
    for($y = 0; $y -lt $strdata.Count; $y++)
    {
        for($x = 0; $x -lt 6; $x+=2)
        {
            $i1 = Find-Index -str $strdata[$y] -find "'" -num ($x+1)
            $i2 = Find-Index -str $strdata[$y] -find "'" -num ($x+2)
            $data[$y, ($x/2)] = $strdata[$y].Substring($i1 ,$i2-$i1-1)
        } 
    }
}



#Compare 1 to All
$check = Find-Hand -c1 "KD" -c2 "2H" -c3 "3S"
Write-Hand -hand $check
$wins = 0
$losses = 0
$pushes = 0
for($x = 0; $x -lt ($data.Count/3); $x++)
{
    $res = Compare-Hand -h1 $check -h2 $x
    if($res -eq $check)
    {
        $wins++
    }
    elseif($res -eq -1)
    {
        $pushes++
    }
    else
    {
        $losses++
    }
}
"wins: " + $wins
[math]::Round((($wins/22100)*100), 5)
"losses: " + $losses
[math]::Round((($losses/22100)*100), 5)
"pushes: " + $pushes
[math]::Round((($pushes/22100)*100), 5)

#Comare All to All
<#for($y = 0; $y -lt ($data.Count/3); $y++)
{
    $total = 0
    Write-Hand -hand $y
    for($x = 0; $x -lt ($data.Count/3); $x++)
    {
        $res = Compare-Hand -h1 $y -h2 $x
        if($res -eq $y)
        {
            $total++
        }
        elseif($res -eq -1)
        {
            continue
        }
        else
        {
            $total--
        }
    }
    $total
}#>


#Compare 2 Selected
<#$check1 = Find-Hand -c1 "2S" -c2 "3S" -c3 "4s"
$check2 = Find-Hand -c1 "3S" -c2 "4S" -c3 "5s"
compare-hand -h1 $check1 -h2 $check2#>


#Test Functions for All
<#for($x=0; $x -lt ($data.Count/3); $x++)
{
    Write-Hand -hand $x
    $t = Check-Trio -hand $x
    $s = Check-Straight -hand $x
    $f = Check-Flush -hand $x
    $p = Check-Pair -hand $x
    "Straight: $s"
    "Flush:    $f"
    "Trio:     $t"
    "Pair:     $p"
}#>


#Test Functions for 1
<#$check = Find-Hand -c1 "2S" -c2 "2C" -c3 "2D"
Write-Hand -hand $check
$t = Check-Trio -hand $check
$s = Check-Straight -hand $check
$f = Check-Flush -hand $check
$p = Check-Pair -hand $check
"Straight: $s"
"Flush:    $f"
"Trio:     $t"
"Pair:     $p"#>