$c = Get-Content parser\parser.asm
$out = New-Object System.Collections.Generic.List[string]
for ($i = 0; $i -lt $c.Count; $i++) {
  $out.Add($c[$i])
  if ($c[$i] -match '^    mov  \[r13 \+ AST\.col\], cx$' -and
      $c[$i-1] -match '^    mov  cx, word \[rel par_last_is_float\]$' -and
      $c[$i+1] -match '^\.sep:$') {
    $out.Add('    ; a pointer parameter needs its element width too, or p + 1')
    $out.Add('    ; inside the function walks one byte instead of one element')
    $out.Add('    mov  ecx, dword [rel par_last_ptr_elem]')
    $out.Add('    mov  [r13 + AST.child_count], ecx')
  }
}
Set-Content parser\parser.asm $out
Select-String -Path parser\parser.asm -Pattern "par_last_ptr_elem" | Measure-Object | Select-Object Count
