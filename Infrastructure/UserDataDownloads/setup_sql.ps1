$sqlDownloadPath = "https://go.microsoft.com/fwlink/?linkid=866662"
$sqlFilePath = "C:\Startup\SQL2019-SSEI-Dev.exe"

function Download-File 
{
  param (
    [string]$url,
    [string]$saveAs
  )
 
  Write-Output "    Downloading $url to $saveAs"
  $downloader = new-object System.Net.WebClient
  $downloader.DownloadFile($url, $saveAs)
}

Download-File $sqlDownloadPath $sqlFilePath
