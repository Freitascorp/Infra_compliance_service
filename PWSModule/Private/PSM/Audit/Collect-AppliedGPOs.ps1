function Collect-AppliedGPOs {
    $gpoList = @()
    try {
        $gp = gpresult /r /scope computer 2>$null
        $start = $false
        foreach ($l in $gp) {
            if ($l -match 'Applied Group Policy Objects') { $start = $true; continue }
            if (-not $start) { continue }
            if ($l -match 'The computer is a part of') { break }
            $t = $l.Trim()
            if ($t -and $t -notmatch '^-{2,}$' -and $t -ne 'Local Group Policy') {
                $gpoList += $t
            }
        }
    } catch { }
    return $gpoList
}

