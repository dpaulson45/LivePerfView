[cmdletbinding()]
param(

[int]$SampleInterval=3,
[int]$RefreshRate=30,
[int]$MaxHistory=100,
[string]$LogDirectory = (Get-Location).Path,
[array]$Servers = "masteryoda1,masteryoda,dpaul092316".Split(","),
[int]$InstanceLimit=3,
[int]$LoopMax = 2,
[switch]$FormDisplay = $true

)

if($PSBoundParameters["Verbose"]){$Script:VerboseEnabled = $true}
##########################################
#
# Counter XML Functions 
#
##########################################

Function Get-CountersXMLInformation {
$xmlResults = [xml]@"
<Counters>
<Counter Name= "\LogicalDisk(*)\Avg. Disk sec/Read">
	<ObjectName>LogicalDisk</ObjectName>
    <CounterName>Avg. Disk sec/Read</CounterName>
	<Threshold>
		<Average>0.020</Average>
		<Maxspike>0.001</Maxspike>
		<WarningSpike>0.001</WarningSpike>
	</Threshold>
	<ThresholdWeight>
		<WarningThreshold>1</WarningThreshold>
		<MaxThreshold>5</MaxThreshold>
		<DoubleMaxThreshold>15</DoubleMaxThreshold>
	</ThresholdWeight>
	<HealthLevelLimit>
		<HealthLevelOne>5</HealthLevelOne>
		<HealthLevelTwo>15</HealthLevelTwo>
		<HealthLevelThree>30</HealthLevelThree>
	</HealthLevelLimit>
    <MonitorCheckType>DeepGreaterThanThresholdCheck</MonitorCheckType>
	</Counter>
<Counter Name= "\LogicalDisk(*)\Avg. Disk sec/Write">
	<ObjectName>LogicalDisk</ObjectName>
    <CounterName>Avg. Disk sec/Write</CounterName>
	<Threshold> 
		<Average>0.020</Average>
		<Maxspike>0.001</Maxspike>
		<WarningSpike>0.001</WarningSpike>
	</Threshold>
	<ThresholdWeight>
		<WarningThreshold>1</WarningThreshold>
		<MaxThreshold>5</MaxThreshold>
		<DoubleMaxThreshold>15</DoubleMaxThreshold>
	</ThresholdWeight>
	<HealthLevelLimit>
		<HealthLevelOne>5</HealthLevelOne>
		<HealthLevelTwo>15</HealthLevelTwo>
		<HealthLevelThree>30</HealthLevelThree>
	</HealthLevelLimit>
    <MonitorCheckType>DeepGreaterThanThresholdCheck</MonitorCheckType>
	</Counter>
<Counter Name= "\Processor(_Total)\% Processor Time">
	<ObjectName>Processor</ObjectName>
    <CounterName>% Processor Time</CounterName>
	<Threshold>
		<Average>70</Average>
		<Maxspike>95</Maxspike>
		<WarningSpike>80</WarningSpike>
	</Threshold>
	<ThresholdWeight>
		<WarningThreshold>1</WarningThreshold>
		<MaxThreshold>5</MaxThreshold>
		<DoubleMaxThreshold></DoubleMaxThreshold>
	</ThresholdWeight>
	<HealthLevelLimit>
		<HealthLevelOne>5</HealthLevelOne>
		<HealthLevelTwo>15</HealthLevelTwo>
		<HealthLevelThree></HealthLevelThree>
	</HealthLevelLimit>
    <MonitorCheckType>NormalGreaterThanThresholdCheck</MonitorCheckType>
	</Counter>
<Counter Name= "\System\Processor Queue Length">
	<ObjectName>System</ObjectName>
    <CounterName>Processor Queue Length</CounterName>
	<Threshold>
		<Average>2</Average>
		<Maxspike>70</Maxspike>
		<WarningSpike>50</WarningSpike>
	</Threshold>
	<ThresholdWeight>
		<WarningThreshold>1</WarningThreshold>
		<MaxThreshold>5</MaxThreshold>
		<DoubleMaxThreshold>15</DoubleMaxThreshold>
	</ThresholdWeight>
	<HealthLevelLimit>
		<HealthLevelOne>5</HealthLevelOne>
		<HealthLevelTwo>15</HealthLevelTwo>
		<HealthLevelThree>30</HealthLevelThree>
	</HealthLevelLimit>
    <MonitorCheckType>NormalGreaterThanThresholdCheck</MonitorCheckType>
	</Counter>
<Counter Name= "\System\Context Switches/sec">
	<ObjectName>System</ObjectName>
    <CounterName>Context Switches/sec</CounterName>
	<Threshold>
		<Average>40000</Average>
		<Maxspike>150000</Maxspike>
		<WarningSpike>100000</WarningSpike>
	</Threshold>
	<ThresholdWeight>
		<WarningThreshold>1</WarningThreshold>
		<MaxThreshold>5</MaxThreshold>
		<DoubleMaxThreshold></DoubleMaxThreshold>
	</ThresholdWeight>
	<HealthLevelLimit>
		<HealthLevelOne>5</HealthLevelOne>
		<HealthLevelTwo>15</HealthLevelTwo>
		<HealthLevelThree></HealthLevelThree>
	</HealthLevelLimit>
    <MonitorCheckType>NormalGreaterThanThresholdCheck</MonitorCheckType>
	</Counter>
<Counter Name = "\Memory\Available MBytes">
	<ObjectName>Memory</ObjectName>
    <CounterName>Available MBytes</CounterName>
	<Threshold>
		<Average>1536</Average>
		<Maxspike>512</Maxspike>
		<WarningSpike>1024</WarningSpike>
	</Threshold>
	<ThresholdWeight>
		<WarningThreshold>1</WarningThreshold>
		<MaxThreshold>5</MaxThreshold>
		<DoubleMaxThreshold></DoubleMaxThreshold>
	</ThresholdWeight>
	<HealthLevelLimit>
		<HealthLevelOne>5</HealthLevelOne>
		<HealthLevelTwo>15</HealthLevelTwo>
		<HealthLevelThree></HealthLevelThree>
	</HealthLevelLimit>
    <MonitorCheckType>NormalLessThanThresholdCheck</MonitorCheckType>
	</Counter>
<Counter Name= "\LogicalDisk(*)\% Idle Time">
	<ObjectName>LogicalDisk</ObjectName>
    <CounterName>% Idle Time</CounterName>
	<Threshold>
		<Average>80</Average>
		<Maxspike>30</Maxspike>
		<WarningSpike>50</WarningSpike>
	</Threshold>
	<ThresholdWeight>
		<WarningThreshold>1</WarningThreshold>
		<MaxThreshold>5</MaxThreshold>
		<DoubleMaxThreshold></DoubleMaxThreshold>
	</ThresholdWeight>
	<HealthLevelLimit>
		<HealthLevelOne>5</HealthLevelOne>
		<HealthLevelTwo>15</HealthLevelTwo>
		<HealthLevelThree></HealthLevelThree>
	</HealthLevelLimit>
    <MonitorCheckType>NormalLessThanThresholdCheck</MonitorCheckType>
    </Counter>
</Counters>
"@
$xmlResults
}
##########################################
#
# Counter XML Functions 
#
##########################################
##########################################
#
# Health XML Functions 
#
##########################################

Function Get-HealthReportXML{

$xmlHealthLevels = [xml] @"
<HealthLevels>
    <HealthLevel Name="Healthy">
        <Level>0</Level>
        <Description>The component is in a good running condition with no issues detected</Description>
        <Color>Green</Color>
    </HealthLevel>
    <HealthLevel Name = "Degraded">
        <Level>1</Level>
        <Description>The component is in a working state, but there are good sings that end users experience are seeing issues</Description>
        <Color>Yellow</Color>
    </HealthLevel>
    <HealthLevel Name = "Poor">
        <Level>2</Level>
        <Description>The component is in a running state, but there are indications of end users might not being able to function correctly </Description>
        <Color>Orange</Color>
    </HealthLevel>
    <HealthLevel Name = "Major Issues">
        <Level>3</Level>
        <Description>The component is seeing major issues that needs to be addressed as soon as possible</Description>
        <Color>Red</Color>
    </HealthLevel>
</HealthLevels>
"@
return $xmlHealthLevels 
}

#This function get the Health Level Name from the int value you provide from the script's HealthLevels variable 
Function Get-NameFromHealthLevel {
param(
[Parameter(Mandatory=$true,Position=1)][int]$iLevel)
    Write-VerboseOutput "Function Name From Health Level"
    Write-VerboseOutput "Passed: $iLevel"
    $r = $Script:HealthLevels.HealthLevels.HealthLevel | ?{$_.Level -eq $iLevel}
    [string]$name = $r.Name
    Write-VerboseOutput "Return: $name"
    return $name
}

##########################################
#
# Health XML Functions 
#
##########################################



##########################################
#
# Script Functions
#
##########################################

#Create and set the Script Location Directory 
Function Create-LogFileScript {
    
    Write-Host "Creating the Log File for the Script"
    $Script:ScriptLogPath = Create-LogFile -LogLocation $LogDirectory -LogFileName "Logging" -LogFileExt ".txt"
    Write-VerboseOutput "Setting the Script Log Path: $ScriptLogPath"
    Write-ToLogScript "Starting the Script"    
}

#Writes the data that you pass to it to the $Script:ScriptLogPath 
Function Write-ToLogScript{
param(
[Parameter(Mandatory=$true,Position=1)]$Data)
    Write-ToLog $Data $Script:ScriptLogPath 
}

Function Write-VerboseOutput ($message) {

    Write-Verbose $message
    if($VerboseEnabled)
    {
        Write-ToLogScript $message 
    }

}

Function Write-Red ($message) {

    if($VerboseEnabled)
    {
        Write-ToLogScript $message
    }
    Write-Host $message -ForegroundColor Red
}

Function Write-Green ($message) {

    if($VerboseEnabled)
    {
        Write-ToLogScript $message
    }
    Write-Host $message -ForegroundColor Green
}

Function Write-Grey ($message) {

    if($VerboseEnabled)
    {
        Write-ToLogScript $message
    }
    Write-Host $message -ForegroundColor Gray
}

#This Functions builds the Counters that we are going to monitor for the script 
Function Get-CountersToMonitorScript {
    $CounterList = @() 
    $xmlCounters = Get-CountersXMLInformation 
    Write-VerboseOutput "List of counters that we are going to monitor:" 
    foreach($counter in $xmlCounters.Counters.Counter){
        foreach($counterName in $counter.Name){
            $CounterList += $counterName
            Write-VerboseOutput $counterName
        }
    }
    Write-VerboseOutput "End Of Counter List"
    $Script:CounterList = $CounterList
    return $xmlCounters
}

#This function will test a list of servers to see if they are up and return the list of up servers 

Function Test-ServerList{
param(
[Parameter(Mandatory=$true,Position=1)][array]$Server_List)
    
    $New_List = @() 
    Write-Grey "Checking to see if the servers are up in this list:"
    foreach($server in $Server_List) { Write-Grey $server }
    Write-Host ""
    Write-Grey "Checking their status..." 
    foreach($server in $Server_List) {
        if(Test-SingleMachineStatus $server) {
            $wData = "The Server $server is currently up and running"
            Write-Green $wData 
            $New_List += $server
        }
        else{
            $wData = "The Server $server is currently down and unreachable" 
            Write-Red $wData 
        }

    }
    Write-Host ""
    return $New_List 
}

Function Build-ArrayMasterObjectScript {
    $mcmd = Measure-Command{
        $xmlCounters = Get-CountersToMonitorScript
        #Testing to see if the servers are up in order to update the list                
        $upServers = Test-ServerList $Servers
        Write-Grey "Building the objects for the script to manage"
        Write-Grey "This may take some time..." 
        $Global:aMasterObject = Build-ServerObjectWithCounterObjects $upServers $xmlCounters
    }
    $wD = $mcmd.TotalSeconds
    $wT = "Building of the objects took $wD total seconds" 
    Write-ToLogScript $wT
    Set-ObjectToDefaultSettingsForHealthReport $aMasterObject 
    Write-Grey "Done building the objects..." 
    Write-Host 
}



##########################################
#
# Script Functions
#
##########################################

##########################################
#
# Script Building Data Objects Functions 
#
##########################################

#Builds the single instance object
Function Build-SingleInstanceObject{
param(
[Parameter(Mandatory=$true,Position=1)]$FullCounterName)
    Write-VerboseOutput("Calling: Build-SingleInstanceObject")
    Write-VerboseOutput("Passed: " + $FullCounterName) 
    $objCurrentTime = New-Object PerformanceHealth.TimeProps
    [array]$objHistoryProps = Create-ArrayObjectForClass "PerformanceHealth.TimeProps" 
    [string]$instanceName = Get-InstanceNameFromFullCounterName $fullCounterName
    $hReport = New-Object PerformanceHealth.HealthReport
    [PerformanceHealth.InstancesObject]$instanceObject = New-Object PerformanceHealth.InstancesObject
    $instanceObject.Name = $instanceName
    $instanceObject.FullName = $fullCounterName
    $instanceObject.Current = $objCurrentTime
    [array]$instanceObject.HistoryValues = $objHistoryProps
    $instanceObject.HealthReport = $hReport 
    return $instanceObject

}

#builds the HealthLevelLimit object based off the counter's xml 
Function Build-HealthLevelObjectOffThresholdList {
param(
[Parameter(Mandatory=$true,Position=1)]$thresholdList)
    Write-VerboseOutput("Calling: Build-HealthLevelObjectOffThresholdList") 
    [PerformanceHealth.CounterHealthLevelLimit]$healthLevelLimitObj = New-Object PerformanceHealth.CounterHealthLevelLimit
    $healthLevelLimitObj.HealthLevelOne = $thresholdList.HealthLevelOne
    $healthLevelLimitObj.HealthLevelTwo = $thresholdList.HealthLevelTwo
    $healthLevelLimitObj.HealthLevelThree = $thresholdList.HealthLevelThree
    return $healthLevelLimitObj
}

#Builds the Threshold Weight Object based of the counter's xml
Function Build-ThresholdWeightObjectOffThresholdList{
param(
[Parameter(Mandatory=$true,Position=1)]$thresholdList)
    Write-VerboseOutput("Calling: Build-ThresholdWeightObjectOffThresholdList")
    [PerformanceHealth.CounterThresholdWeight]$thresholdWeightObj = New-Object PerformanceHealth.CounterThresholdWeight
    $thresholdWeightObj.WarningThreshold = $thresholdList.WarningThreshold
    $thresholdWeightObj.MaxThreshold = $thresholdList.MaxThreshold
    $thresholdWeightObj.DoubleMaxThreshold = $thresholdList.DoubleMaxThreshold
    return $thresholdWeightObj
}

#Builds the threshold object 
Function Build-ThresholdObjectOffThresholdList{
param(
[Parameter(Mandatory=$true,Position=1)]$thresholdList)
    Write-VerboseOutput("Calling: Build-ThresholdObjectOffThresholdList")
    [PerformanceHealth.CounterThresholds]$thresholdObject = New-Object PerformanceHealth.CounterThresholds
    $thresholdObject.Average = $thresholdList.Average
    $thresholdObject.MaxSpike = $thresholdList.MaxSpike
    $thresholdObject.WarningSpike = $thresholdList.WarningSpike
    return $thresholdObject 
}


#This function builds the instances of the counter set collection 
Function Build-InstanceSetCollectionObject{
param(
[Parameter(Mandatory=$true,Position=1)][string]$server,
[Parameter(Mandatory=$true,Position=2)]$CounterName)
    Write-VerboseOutput("Calling: Build-InstanceSetCollectionObject")
    Write-VerboseOutput("Passed: " + $server)
    $aInstancesObjects= @()
    $allInstances = Get-AllServerCounterInstances $counterName $server
    foreach($instance in $allInstances) {
        $aInstancesObjects += Build-SingleInstanceObject $instance
    }
    return $aInstancesObjects
}

#This Function builds the counter set collections for the counters 
Function Build-CounterSetCollectionObject{
param(
[Parameter(Mandatory=$true,Position=1)][string]$server,
[Parameter(Mandatory=$true,Position=2)]$counterObject)
    Write-VerboseOutput("Calling: Build-CounterSetCollectionObject")
    Write-VerboseOutput("Passed: " + $server)
    $counterName = Get-CounterNameFromFullCounterName $counterObject.Name
    $instanceSetCollection = Build-InstanceSetCollectionObject $server $counterObject.Name
    $thresholdObject = Build-ThresholdObjectOffThresholdList $counterObject.Threshold
    $thresholdWeightObj = Build-ThresholdWeightObjectOffThresholdList $counterObject.ThresholdWeight
    $healthLevelLimitObj = Build-HealthLevelObjectOffThresholdList $counterObject.HealthLevelLimit
    $hReport = New-Object PerformanceHealth.HealthReport
    [PerformanceHealth.CounterSetObject]$counterSetObject = New-Object PerformanceHealth.CounterSetObject
    $counterSetObject.Name = $counterName 
    $counterSetObject.Threshold = $thresholdObject
    $counterSetObject.ThresholdWeight = $thresholdWeightObj
    $counterSetObject.HealthLevelLimit = $healthLevelLimitObj
    $counterSetObject.HealthReport = $hReport 
    $counterSetObject.Instances = $instanceSetCollection 
    $counterSetObject.DetectIssueType = $counterObject.MonitorCheckType
    return $counterSetObject

}



#This Function builds all the counter objects for the single server 
Function Build-SingleServerCounterDataObjects{
param(
[Parameter(Mandatory=$true,Position=1)][string]$server,
[Parameter(Mandatory=$true,Position=2)][xml]$xmlCounterList)
    Write-VerboseOutput("Calling: Build-SingleServerCounterDataObjects")
    Write-VerboseOutput("Passed: " + $server)
    $aCounterDataObject = @() 
    foreach($counterObject in $xmlCounterList.Counters.Counter) {
        $counterSetCollection = Build-CounterSetCollectionObject $server $counterObject
        $hReport = New-Object PerformanceHealth.HealthReport
        [PerformanceHealth.CounterDataObject]$CounterDataObject = New-Object PerformanceHealth.CounterDataObject
        $CounterDataObject.ObjectName = $counterObject.ObjectName
        $CounterDataObject.CounterName = $counterObject.CounterName
        $CounterDataObject.HealthReport = $hReport
        $CounterDataObject.CounterSet = $counterSetCollection
        $CounterDataObject.ServerName = $server
        $aCounterDataObject += $CounterDataObject
    }
    return $aCounterDataObject 
}


#This function builds each Server Object correctly and adds it to the array 
Function Build-ServerObjectWithCounterObjects{
param(
[Parameter(Mandatory=$true,Position=1)][array]$Server_List,
[Parameter(Mandatory=$true,Position=2)][xml]$xmlCounterList)
    Write-VerboseOutput("Calling: Build-ServerObjectWithCounterObjects")
    $aServerObjects = @() 
    foreach($server in $Server_List) {
        $counterData = Build-SingleServerCounterDataObjects $server $xmlCounterList
        $hReport = New-Object PerformanceHealth.HealthReport
        [PerformanceHealth.ServerPerformanceObject]$serverObj = New-Object PerformanceHealth.ServerPerformanceObject
        $serverObj.ServerName = $server
        $serverObj.HealthReport = $hReport
        $serverObj.CounterData = $counterData
        $aServerObjects += $serverObj 
        Write-Verbose "Finished building server object $server" 
    }

    return $aServerObjects 
}

#This function will set the whole object to the default health level 
Function Set-ObjectToDefaultSettingsForHealthReport{
param(
[Parameter(Mandatory=$true,Position=1)]$aObject)
#Default Lvl 
    $hLevel = 0 
    $hName = Get-NameFromHealthLevel $hLevel 
    $hTime = Get-Date 
    foreach($server in $aObject) {

        $server.HealthReport.Status = $hName
        $server.HealthReport.LastChangeTime = $hTime
    
        foreach($counterData in $server.CounterData){
        
            $counterData.HealthReport.Status = $hName
            $counterData.HealthReport.LastChangeTime = $hTime
            $counterData.CounterSet.HealthReport.Status = $hName
            $counterData.CounterSet.HealthReport.LastChangeTime = $hTime
            foreach($instance in $counterData.CounterSet.Instances) {

               $instance.HealthReport.Status = $hName
               $instance.HealthReport.LastChangeTime = $hTime

            }
        }

    }


}

##########################################
#
# Script Building Data Objects Functions 
#
##########################################

##########################################
#
# Default Functions 
#
##########################################

#Creates a folder
Function Create-Folder{
param(
[Parameter(Mandatory=$true,Position=1)][string]$Folder,
[Parameter(Mandatory=$false,Position=2)][Switch]$WriteOut = $false)
    if((Test-Path -Path $Folder) -eq $false) {
        if($WriteOut){Write-Host "Creating Folder $Folder"}
        [System.IO.Directory]::CreateDirectory($Folder) | Out-Null
    }
    else{if($WriteOut){Write-Host "Folder $Folder is already created"}}
}

#Creates a file in the directory that you specify with the Ext
#It won't make the same file twice, so it will append "-N" to the file name
Function Create-FileAppendNumber{
param(
[Parameter(Mandatory=$true,Position=1)][string]$FileDirectory,
[Parameter(Mandatory=$true,Position=2)][string]$FileName,
[Parameter(Mandatory=$true,Position=3)][string]$FileExt
)
    [bool]$bEndsWith = $FileDirectory.EndsWith("\")
    if($bEndsWith){
        $FullFilePath = $FileDirectory + $FileName + $FileExt
    }
    else{$FullFilePath = $FileDirectory + "\" + $FileName + $FileExt}
    $FullFileName = $FileName + $FileExt

    if(Test-Path -Path $FullFilePath){
        $i = 0 
        do{
            $i++
            if($bEndsWith){ $FullFilePath = $FileDirectory + $FileName +"-$i" + $FileExt}
            else{$FullFilePath = $FileDirectory + "\" + $FileName + "-$i" + $FileExt}
            $FullFileName = $FileName + "-$i" + $FileExt
        }while(Test-Path -Path $FullFilePath)
    }
    New-Item -Name $FullFileName -Path $FileDirectory -ItemType File | Out-Null
    return $FullFilePath
}


#Creates a Log File and returns the Full Log Path 
Function Create-LogFile {
param(
[Parameter(Mandatory=$true,Position=1)][string]$LogLocation, 
[Parameter(Mandatory=$true,Position=2)][string]$LogFileName, 
[Parameter(Mandatory=$true,Position=3)][string]$LogFileExt )
    
    Create-Folder $LogLocation
    $FullLogPath = Create-FileAppendNumber -FileDirectory $LogLocation -FileName $LogFileName -FileExt $LogFileExt
    return $FullLogPath
}


#Writes data to a log file and includes the time 
Function Write-ToLog{
param(
[Parameter(Mandatory=$true,Position=1)]$WriteData,
[Parameter(Mandatory=$true,Position=2)][string]$LogPath)
    
    Function Get-DateTimeLogFormat {
        $date = Get-Date
        $dtFormat = "[" + $date.Month + "/" + $date.Day + "/" + $date.Year + " " + $date.Hour + ":" + $date.Minute + ":" + $date.Second + "]"
        return $dtFormat
    }
    
    if(Test-Path -Path $LogPath){
        $time = Get-DateTimeLogFormat
        if($WriteData.Gettype().Name -eq "String"){
            $log = $time + " : " + $WriteData 
            $log | Out-File $LogPath -Append 
        }
        else{
            $wTime = $time + " : " 
            $wTime | Out-File $LogPath -Append
            $WriteData | Out-File $LogPath -Append
        }
    }
    else{
        Write-Error "Error Incorrect Log Path provided"   
    }
}

#This function return a bool if a single server is up 
Function Test-SingleMachineStatus{
param(
[Parameter(Mandatory=$true,Position=1)][string]$Machine_Name)
    $bResult = Test-Connection $Machine_Name -Quiet
    return $bResult 
}


#returns the counter name from the full counter name 
#Example: \LogicalDisk(C:)\Avg. Disk sec/Read ==> Counter: "Avg. Disk sec/Read"
Function Get-CounterNameFromFullCounterName{
param(
[Parameter(Mandatory=$true,Position=1)][string]$FullCounterName)

    $index = $fullCounterName.LastIndexOf("\")
    $counter = $fullCounterName.Substring($index + 1) 
    return $counter 
}

#This function will strip the computer name from the the counter 
Function Strip-ComputerNameFromPathCounter ($inString){
    $p = $inString.IndexOf("\",2)
    $cName = $inString.Substring($p) 
    return $cName
}

#This function gets all the counter instances off a server 
Function Get-AllServerCounterInstances{
param(
[Parameter(Mandatory=$true,Position=1)]$currentObjectCounter,
[Parameter(Mandatory=$true,Position=2)][string]$serverName)

    $ListOfCounterInstances = Get-Counter -Counter $currentObjectCounter -ComputerName $serverName
    $aCounterInstances = @() 
    foreach($samples in $ListOfCounterInstances.CounterSamples){
        foreach($instance in $samples.path){
            $aCounterInstances += Strip-ComputerNameFromPathCounter $instance
        }
    }
    return $aCounterInstances
}

#This class creates an object that is already in an array 
Function Create-ArrayObjectForClass{
param(
[Parameter(Mandatory=$true,Position=1)][string]$class) 
    $array = @() 
    $add = New-Object $class 
    $array += $add
    return $array 
}

#Returs the Instance name from the full counter name 
#Example: \LogicalDisk(C:)\Avg. Disk sec/Read ==> Instance: "C:"
Function Get-InstanceNameFromFullCounterName{
param(
[Parameter(Mandatory=$true,Position=1)][string]$fullCounterName)

    $index = $fullCounterName.IndexOf("(")
    $indexEnd = $fullCounterName.IndexOf(")")
    if($index -ne -1 -and $indexEnd -ne -1) {
        $instance = $fullCounterName.Substring($index,$indexEnd - $index + 1) 
        return $instance
    }
    else{
        return $null
    }

}


#This function pulls out a list from an array for a particular attribute, because on Windows 2008 we aren't able to do the same as in Windows 2012+
Function Get-AttributeFromAListofTheSameObjects{
param(
[Parameter(Mandatory=$true,Position=1)][array]$Object,
[Parameter(Mandatory=$true,Position=2)][string]$attribute)
    #First we determine if the attribute is valid 
    $gm = $Object | gm 
    $valid = $false
    foreach($name in $gm) {
        if($name.Name -eq $attribute) {$valid=$true; break}
    }
    if($valid){
        $aReturn = @() 
        foreach($obj in $Object){
            $aReturn += $obj.$attribute 
        }
    }
    else{
        $objName = $Object.GetType().Name
        Write-Red "Incorrect value provided to Get-AttributeFromAListofTheSameObjects $objName. Attribute $attribute" 
        return $null 
    }
    return $aReturn
}


#This will get the counter Information based off the counter set and for a particular sample interval and max sample timeframe 
Function Get-BulkCounterInformation{
Param(
[Parameter(Mandatory=$true,Position=1)]$counters,
[Parameter(Mandatory=$true,Position=2)]$serverName,
[Parameter(Mandatory=$true,Position=3)]$sInterval,
[Parameter(Mandatory=$true,Position=4)]$mSamples)
    Write-VerboseOutput "Gathering information with Get-BulkCounterInformation"
    $aResults = Get-Counter -Counter $counters -ComputerName $serverName -SampleInterval $sInterval -MaxSamples $mSamples
    return $aResults 
}

#This function will return an Index value of what you are looking for 
#This is to replace something like this $serverIndex = $serverObjects.ServerName.IndexOf($server.ServerName), as this doesn't work in Windows Server 2008
Function Get-IndexOfFromAList {
param(
[Parameter(Mandatory=$true,Position=1)][array]$list,
[Parameter(Mandatory=$true,Position=2)]$value)
    [int]$index = 0
    foreach($item in $list){
        if($item -eq $value){return $index}
        else{$index++}
    }
    Write-Warning "Unable to find $value in the List that was passed."
    $index = -1
    return $index 
}

#This will provide the double average from a list of numbers 
Function Get-AverageFromList{
param(
[Parameter(Mandatory=$true,Position=1)][array]$list)
    [double]$dTotal = 0
    $iCount = $list.Count 
    foreach($v in $list){$dTotal += $v}
    $dTotal = $dTotal / $iCount
    return $dTotal
}

#This Function will get the highest value from the list 
Function Get-HighestValueFromList{
param(
[Parameter(Mandatory=$true,Position=1)][array]$list)

    $high = $list[0] #Don't want to set it to your own value like 0, as we could be dealing with negative numbers 
    foreach($v in $list) {
        if($v -gt $high){$high = $v}
    }
    return $high
}

#This function will get the lowest value from the list 
Function Get-MinValueFromList{
param(
[Parameter(Mandatory=$true,Position=1)][array]$list)
    
    $low = $list[0] 
    foreach($v in $list) {
        if($v -lt $low) {$low = $v}
    }
    return $low 
}

#This function will return all values above a threshold 
Function Get-ValuesAboveThresholdFromList{
param(
[Parameter(Mandatory=$true,Position=1)][array]$List,
[Parameter(Mandatory=$true,Position=2)][double]$thresholdValue)
    
    $spikes = @()
    foreach($v in $List) {
        if($v -ge $thresholdValue){$spikes += $v}
    }
    #If we don't have any values, we should return a null value 
    if($spikes.Count -eq 0){$spikes = $null}
    return $spikes

}

#This Function will return an array of all the values that go below a threshold 
Function Get-ValuesBelowThresholdFromList{
param(
[Parameter(Mandatory=$true,Position=1)][array]$List,
[Parameter(Mandatory=$true,Position=2)][double]$thresholdValue)

    $spikes = @()
    foreach($v in $List) {
        if($v -le $thresholdValue){$spikes += $v}
    }
    #if we  don't have any values, we should return a null value 
    if($spikes.Count -eq 0){$spikes = $null}
    return $spikes
}

#This function will round the double to the nearest value that you would like 
Function Round-DoubleUp{
param(
[Parameter(Mandatory=$true,Position=1)][double]$dInput,
[Parameter(Mandatory=$false,Position=2)][int]$Round = 3)
    
    $dReturn = [System.Math]::Round($dInput,$Round)
    return $dReturn
}

##########################################
#
# Default Functions 
#
##########################################
##########################################
#
# Data Collection Functions 
#
##########################################

#This function will go through and add all the counters to the history section 
Function Adjust-CounterValuesFromCurrentToHistory{
Param(
[Parameter(Mandatory=$true,Position=1)][array]$aCounterObj,
[Parameter(Mandatory=$true,Position=2)][int]$HistoryMax)
    Write-VerboseOutput("Calling: Adjust-CounterValuesFromCurrentToHistory")

    foreach($customObject in $aCounterObj) {
        $currentHistoryLength = $customObject.HistoryValues.Count 
        if($currentHistoryLength -lt $HistoryMax) {
            $add = New-Object PerformanceHealth.TimeProps
            $customObject.HistoryValues += $add   
        }
        if($customObject.HistoryValues[0].Time -eq $null) {         
        $customObject.HistoryValues[0].Time = $customObject.Current.Time
        $customObject.HistoryValues[0].Value = $customObject.Current.Value                   
        }
        else{
            #Windows Server 2008 Issues with Arrays again, need to have everything in a list first 
            #Original
            #$copyTime = $customObject.HistoryValues.Time.Clone()
            #$copyValues = $customObject.HistoryValues.Value.Clone()
            $customObject_HistoryValues_Time_List = Get-AttributeFromAListofTheSameObjects $customObject.HistoryValues "Time"
            $customObject_HistoryValues_Value_List = Get-AttributeFromAListofTheSameObjects $customObject.HistoryValues "Value" 
            $copyTime = $customObject_HistoryValues_Time_List.Clone()
            $copyValues = $customObject_HistoryValues_Value_List.Clone() 
            $mainIndex = 0
            $secIndex = 0
            $HisCount = $customObject.HistoryValues.Count 

            while($mainIndex -lt $HisCount) {
                if($mainIndex -eq 0){
                    $customObject.HistoryValues[$mainIndex].Time = $customObject.Current.Time
                    $customObject.HistoryValues[$mainIndex].Value = $customObject.Current.Value 
                    $mainIndex++
                }
                else{
                    $customObject.HistoryValues[$mainIndex].Time = $copyTime[$secIndex]
                    $customObject.HistoryValues[$mainIndex].Value = $copyValues[$secIndex]   
                    $mainIndex++
                    $secIndex++
                }
            }
        }
    }

}


#This Function locates and pulls out the data for a single server from the raw data collected 
Function Pull-AllServerDataPointsFromRawCounterData{
param(
[Parameter(Mandatory=$true,Position=1)]$rawData,
[Parameter(Mandatory=$true,Position=2)][string]$serverName)
    Write-VerboseOutput("Calling: Pull-AllServerDataPointsFromRawCounterData") 
    Write-VerboseOutput "Working on pulling data for server: $serverName into an object to be able to add to the master object"
    $objCollection = @() 
    foreach($currentTimeCollection in $rawData) {
        $time = $currentTimeCollection.Timestamp
        $serverData = $currentTimeCollection.CounterSamples | ?{$_.Path -like "\\$serverName\\*"}
        $obj = New-Object -TypeName PSObject 
        $obj | Add-Member -MemberType NoteProperty -Name Time -Value $time 
        $obj | Add-Member -MemberType NoteProperty -Name CounterSamples -Value $serverData
        $objCollection += $obj
    }
    return $objCollection
}


#This function rebuilds the data collection into a easier object to manage 
Function Rebuild-RawDataFromCounterCollection{
param(
[Parameter(Mandatory=$true,Position=1)]$rawData,
[Parameter(Mandatory=$true,Position=2)]$serverLists)
    Write-VerboseOutput("Calling: Rebuild-RawDataFromCounterCollection")
    $aServerObjects = @()
    foreach($server in $serverLists){
        $data = Pull-AllServerDataPointsFromRawCounterData -rawData $rawData -serverName $server
        $obj = New-Object -TypeName PSObject 
        $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $server 
        $obj | Add-Member -MemberType NoteProperty -Name DataCollection -Value $data
        $aSErverObjects += $obj 
    }
    return $aServerObjects 
}

#This function is going to be collecting the data from the servers that you pass it and store it in the serverObjects array 
Function Collect-DataCounterDataManager {
param(
[Parameter(Mandatory=$true,Position=1)]$serverObjects,
[Parameter(Mandatory=$true,Position=2)]$counterLists,
[Parameter(Mandatory=$true,Position=3)]$sInterval,
[Parameter(Mandatory=$true,Position=4)]$mSamples,
[Parameter(Mandatory=$false,Position=5)][switch]$ShowMCMD=$false)
    Write-VerboseOutput("Calling: Collect-DataCounterDataManager")
    #We need to pass the serverObjects varaible to a different function to get the list of servers because in Windows 2008 it isn't able to get a list of objects the same way 
    $serverList = Get-AttributeFromAListofTheSameObjects -Object $serverObjects -attribute "ServerName"
    $rawData = Get-BulkCounterInformation -counters $counterLists -serverName $serverList -sInterval $sInterval -mSamples $mSamples
    $mcmd = Measure-Command{
        $orgData = Rebuild-RawDataFromCounterCollection -rawData $rawData -serverLists $serverList
        foreach($server in $orgData) {
            $serverIndex = Get-IndexOfFromAList -list $serverList -value $server.ServerName
            foreach($run in $server.DataCollection){
                $time = $run.Time
                $runCounterSamples = $run.CounterSamples
                foreach($counterData in $serverObjects[$serverIndex].CounterData){
                    foreach($instances in $counterData.CounterSet.Instances) {
                        $sName = $server.ServerName
                        $pathComp = "\\$sName" + $instances.FullName
                        $runCounterSamples_Path_List = Get-AttributeFromAListofTheSameObjects -Object $runCounterSamples -attribute "Path"
                        $index = Get-IndexOfFromAList -list $runCounterSamples_Path_List $pathComp
                        if($index -ne -1){
                            $instances.Current.Time = $time 
                            $instances.Current.Value = $runCounterSamples[$index].CookedValue 
                        }
                        else{
                            $instances.Current.Time = $time
                            $instances.Current.Value = $null
                        }
                    }

                    Adjust-CounterValuesFromCurrentToHistory -aCounterObj $counterData.CounterSet.Instances -HistoryMax $Script:MaxHistory 
                }
            }
        }
    }
    $Wd = $mcmd.TotalSeconds
    $wt = "Rebuilding of the Raw data collected and placed into the main object took $Wd total Seconds" 
    Write-ToLogScript $wt
    if($ShowMCMD){Write-Host $wt}
}

##########################################
#
# Data Collection Functions 
#
##########################################

##########################################
#
# Detecting Issues Functions 
#
##########################################

#This Function will remove the default date and time values to avoid them in the calculations 
Function Strip-DefaultDateTimeFromHistory{
param(
[Parameter(Mandatory=$true,Position=1)][array]$HistoryValues)
    $test_Date_Time = New-Object DateTime 
    if($test_Date_Time -eq ($HistoryValues[$HistoryValues.count -1].Time)) {
        #If we have the default date time value in the last array value, we need to remove it 
        $rArray = @() 
        $i = 0
        while($i -lt ($HistoryValues.count -1)) {
            $rArray += $HistoryValues[$i++]
        }
        return $rArray
    }
    return $HistoryValues
}

#This function will get the standard results for Avg Min Max Spikes to avoid from writing the same thing over and over again in later functions 
Function Get-Avg_Min_Max_Spikes_Results{
param(
[Parameter(Mandatory=$true,Position=1)][array]$HistoryValues,
[Parameter(Mandatory=$true,Position=2)]$Threshold)
    
    [hashtable]$results = @{}
    $update_HistoryValues = Strip-DefaultDateTimeFromHistory $HistoryValues
    $instanceObject_HistoryValues_Value = Get-AttributeFromAListofTheSameObjects $update_HistoryValues "Value" 
    $avgResults = Get-AverageFromList $instanceObject_HistoryValues_Value
    $minResults = Get-MinValueFromList $instanceObject_HistoryValues_Value
    $maxResults = Get-HighestValueFromList $instanceObject_HistoryValues_Value
    $aSpikes = Get-ValuesAboveThresholdFromList -List $instanceObject_HistoryValues_Value -thresholdValue $Threshold
    $aSpikeDips = Get-ValuesBelowThresholdFromList -List $instanceObject_HistoryValues_Value -thresholdValue $Threshold
    $avgResults = Round-DoubleUp -dInput $avgResults
    $minResults = Round-DoubleUp -dInput $minResults 
    $maxResults = Round-DoubleUp -dInput $maxResults
    $results.AvgResults = $avgResults
    $results.MinResults = $minResults
    $results.MaxResults = $maxResults
    $results.aSpikes = $aSpikes
    $results.aSpikeDips = $aSpikeDips
    return $results 
}

#This function goes through each of the objects in the array to determine which logic function we need to use to determine if there is an issue or not
Function Detect-Issue{
Param(
[Parameter(Mandatory=$true,Position=1)]$aObject)

    Write-Verbose "Entering the detect issues function"
    foreach($srvObj in $aObject){
        foreach($CounterDataObject in $srvObj.CounterData){
            switch($CounterDataObject.CounterSet.DetectIssueType) {
            "DeepGreaterThanThresholdCheck" {Write-Verbose "Working on server $srvObj. It was selected for DeepGreaterThanThresholdCheck"; Detect-IssueDeepGtThresholdCheck $CounterDataObject}
            "NormalGreaterThanThresholdCheck" {Write-Verbose "Working on server $srvObj. It was selected for NormalGreaterThanThresholdCheck"; Detect-IssueNormalGtThresholdCheck $CounterDataObject}
            "NormalLessThanThresholdCheck" {Write-Verbose "Working on server $srvObj. It was selected for NormalLessThanThresholdCheck"; Detect-NormalLessThanThresholdCheck $CounterDataObject}
            default {Write-Error "Something went wrong"; Write-ToLogScript "Error in Detect-Issues"; Write-ToLogScript $CounterDataObject.CounterSet.DetectIssueType}
            }
        }
    }
}

#This function is to return a value for the health level based on the values provided 
Function Get-HealthLevelFromWeightValue{
param(
[Parameter(Mandatory=$true,Position=1)][int]$iWeightValue,
[Parameter(Mandatory=$true,Position=2)][array]$Array_Levels,
[Parameter(Mandatory=$true,Position=3)][int]$LevelStartValue)
    Write-Verbose "Function Get-HealthLevelFromWeightValue"
    Write-Verbose "WeightValue provided: $iWeightValue" 

    if($Array_Levels.Count -lt 2){Write-Error "Don't know how to handle this low value"}
    $iFirst_Index = 0
    $iSecond_Index = 1
    $iMax_Index = $Array_Levels.Count 
    if($iWeightValue -lt $Array_Levels[$iFirst_Index]){$wv = "iWeightValue (" + $iWeightValue + ") is less than the first array level of " + $Array_Levels[$iFirst_Index] + ". Returning the default value minus 1 " + --$LevelStartValue; Write-Verbose $wv; return $LevelStartValue}
    while($iFirst_Index -lt $iMax_Index){
        if($iSecond_Index -ne $iMax_Index){
            if($iWeightValue -ge $Array_Levels[$iFirst_Index] -and $iWeightValue -lt $Array_Levels[$iSecond_Index]){break}
        }
        else{
            #We just need to break because we should be at the correct level for the last level
            break;
        }
        $wv = "iWeightvalue (" + $iWeightValue + ") is not equal or greater than " + $Array_Levels[$iFirst_Index] + " AND less than " + $Array_Levels[$iSecond_Index]
        Write-Verbose $wv
        $iFirst_Index++
        $iSecond_Index++
        $LevelStartValue++
    }
    Write-Verbose "Returning level $LevelStartValue" 
    return $LevelStartValue
}

#This function is to update the object in the same basic way that all the detect issue functions should do 
Function Update-HealthReportInstanceObject{
param(
[Parameter(Mandatory=$true,Position=1)]$Instance_Object,
[Parameter(Mandatory=$true,Position=2)]$To_Log,
[Parameter(Mandatory=$true,Position=3)]$Health_Level,
[Parameter(Mandatory=$true,Position=4)][string]$Default_Display_Results)
    Write-Verbose "Function Update Health Report Instance Object" 
    Write-Verbose "Health Level: $Health_Level"
    
    $old_Health_Status = $Instance_Object.HealthReport.Status
    $new_Health_Status = Get-NameFromHealthLevel -iLevel $Health_Level

    if($old_Health_Status -ne $new_Health_Status -or $Instance_Object.HealthReport.DisplayInfo -eq $null) {
        
        $old_Health_Change_Time = $Instance_Object.HealthReport.LastChangeTime
        $new_Health_Change_Time = $Instance_Object.Current.Time
        Write-ToLogScript $To_Log
        Write-ToLogScript "History Values"
        Write-ToLogScript $Instance_Object.HistoryValues 
        $ToLog = "[INFO]: Status changed from: '$old_Health_Status' to '$new_Health_Status'"
        Write-ToLogScript $ToLog
        Write-Verbose $ToLog
        $ToLog = "[INFO]: Last Change Time was at: '$old_Health_Change_Time'"
        Write-ToLogScript $ToLog
        Write-Verbose $ToLog
        $ToLog = "[INFO]: New Health Change Time: '$new_Health_Change_Time'"
        Write-ToLogScript $ToLog
        Write-Verbose $ToLog
        #Now we need to set the object instance to show this update 
        $Instance_Object.HealthReport.Status = $new_Health_Status
        $Instance_Object.HealthReport.LastChangeTime = $new_Health_Change_Time
        $Instance_Object.HealthReport.Reason = $To_Log
        $Instance_Object.HealthReport.DisplayInfo = $Default_Display_Results

    }

}

<#

This function is to do a deep analysis of data to determine how bad the issue is. We place in the threshold values that we don't want to go over,
however sometimes for particular counters that might not be too bad and be causing a major issue. We want to know if we are going well above our thresholds.
This function should help determine if there is a major issue or not. 

Process Check: 
    
    1. Determine if the Avg of the counter is above double the Threshold Limit. Mark the counter as critical. 
        A. If the counter is averaging at or above this, we don't care what the spikes are at. We will just write down the Avg, Min, Max and flag it and move on
    2. Determine if the Avg of the counter is above the Avg Threshold Limit. 
        A. If no values go above the Warning Threshold, this counter instance will just be marked as Degraded. 
        B. If there are values above the Warning Threshold, we need to determine how many. If the count is greater than 5, then we need to mark the counter to the next level. (Poor)
        C. If there are values above the Max Threshold, we need to determine how many. If the count is greater than 3, then we need to mark the counter to the next level. (Poor) 
        D. If there are values above double the Max Threshold, we need to determine how many. If the cout is greater than 2, then we need to mark the counter to Critical. If it is just one, we will mark this as a Poor health state. 
    3. If the counter is below the Threshold Limit, then we need to deteremine if there are spikes above the thresholds 
        A. If there are no values go above the Warning Threshold, this counter will just be marked as Healthy 
        B. If there are values above the Warning Threshold, we need to determine how many. If the count is greater than 5, we need to mark the counter to the next level. (Degraded) 
        C. If there are values above the Max Threshold, we need to determine how many. If the count is greater than 3, then we need to mark the counter to the next level of Poor. At minimum, we will mark this as Degraded
        D. If there are values above double the Max Threshold, we need to determine the count. If the count is greater than 2, then we need to mark the counter to Critical. If it is just one, we will mark this as a Poor Health State.

Health Levels 

0 = Healthy 
1 = Degraded 
2 = Poor 
3 = Critical 


#>

Function Detect-IssueDeepGtThresholdCheck{
param(
[Parameter(Mandatory=$true,Position=1)]$CounterDataObject)
    Write-Verbose "Function Detect-IssuesDeepGtThresholdCheck"
    #First we are going to set all the Threshold Values and default varialables that we will use in the function 
    $threshold_Max = $CounterDataObject.CounterSet.Threshold.MaxSpike
    $threshold_Warning = $CounterDataObject.CounterSet.Threshold.WarningSpike
    $threshold_Avg = $CounterDataObject.CounterSet.Threshold.Average
    $server_Name = $CounterDataObject.ServerName
    $object_Name = $CounterDataObject.ObjectName
    $counter_Name = $CounterDataObject.CounterName
    $dThreshold_Avg = $threshold_Avg * 2
    $dThreshold_Max = $threshold_Max * 2
    
    #These Variables are to help determine if we need to increase the level of health of the counter 
    $weight_Threshold_Warning = $CounterDataObject.CounterSet.ThresholdWeight.WarningThreshold
    $weight_Threshold_MaxThreshold = $CounterDataObject.CounterSet.ThresholdWeight.MaxThreshold
    $weight_Threshold_Double_MaxThreshold = $CounterDataObject.CounterSet.ThresholdWeight.DoubleMaxThreshold

    $Health_Level_One = $CounterDataObject.CounterSet.HealthLevelLimit.HealthLevelOne
    $Health_Level_Two = $CounterDataObject.CounterSet.HealthLevelLimit.HealthLevelTwo
    $Health_Level_Three = $CounterDataObject.CounterSet.HealthLevelLimit.HealthLevelThree

    #This is a private function for this function to reduce the amount of code
    #not going to pass anything because we should have access to the variables  
    Function Get-PrivateHealthLevelCounter{

        #We shouldn't care if either of these are null the math should still be the same 
        Write-Verbose "Either d_Max_Spikes or Max_Spikes or both were not null"
        Write-Verbose "Determining the values to add"
        #If we have values in both of them, we need to determene how many values we have in each threshold. 
        $d_Max_Spikes_Count = $d_Max_Spikes.count
        Write-Verbose "d_Max_Spikes_count: $d_Max_Spikes_Count"
        $Max_Spikes_Count = $Max_Spikes.count - $d_Max_Spikes_Count #We don't want to count these twice 
        Write-Verbose "Max_Spikes_Count: $Max_Spikes_Count"
        $Warning_Spikes_Count = $aSpikes.count - $d_Max_Spikes_Count - $Max_Spikes_Count
        Write-Verbose "Warning_Spikes_Count: $Warning_Spikes_Count" 
        Write-Verbose "Current value of iHealthCounter: $iHealthCounter" 
        $iHealthCounter = $iHealthCounter + ($d_Max_Spikes_Count * $weight_Threshold_Double_MaxThreshold) + ($Max_Spikes_Count * $weight_Threshold_MaxThreshold) + ($Warning_Spikes_Count + $weight_Threshold_Warning)
        Write-Verbose "iHealthCounter end result: $iHealthCounter"

        return $iHealthCounter 
    }

    Function Get-PrivateHealthLevelCounterNoValuesOverMaxThreshold{
        #We don't have any major spikes but we still need to determine the value of the Warning spikes 
        Write-Verbose "No major spikes over the Max Threshold"
        Write-Verbose "Checking the warning spikes to see if we need to increase the health of the counter" 
        $Warning_Spikes_Count = $aSpikes.count 
        Write-Verbose "Warning_Spikes_Count: $Warning_Spikes_Count"
        $iHealthCounter += ($weight_Threshold_Warning * $Warning_Spikes_Count)
        Write-Verbose "iHealthCounter: $iHealthCounter" 
        return $iHealthCounter
    }

    #For each of the instances we are going to deteremine if they are seeing any issues.
    foreach($instanceObject in $CounterDataObject.CounterSet.Instances) {
        
        $results = Get-Avg_Min_Max_Spikes_Results -HistoryValues $instanceObject.HistoryValues -Threshold $threshold_Warning
        $avgResults = $results.avgResults 
        $minResults = $results.minResults 
        $maxResults = $results.maxResults 
        $aSpikes = $results.aSpikes 
        $instance_Name = $instanceObject.Name
        
        $default_Display_Results = "Min: $minResults Avg: $avgResults Max: $maxResults"
        $default_Server_Object_Counter_String = "Server: $server_Name Object: $object_Name Counter: $counter_Name Instance: $instance_Name. "

        #First we are going to check if the Avgerage is above double the average limit 
        #If it is we need to mark that as critical. We should never be averaging that high 
        if($avgResults -ge $dThreshold_Avg) {
            Write-Verbose "The avg is greater than double the Threshold Avg" 
            Write-Verbose "avgResults: $avgResults   dThreshold_Avg: $dThreshold_Avg" 
            $default_Display_Message = "[Critical]: " + $default_Server_Object_Counter_String + "This counter is currently above double the average threshold ( " + $dThreshold_Avg + " ). Current values " + $default_Display_Results 
            Write-Verbose "Marking the instance as critical" 
            $health_Level = 3 
        }#End $avgResults -ge $dThreshold_Avg
        
        elseif ($avgResults -ge $threshold_Avg) {
            #If the average results is above the threshold limit, we are going to at least mark this counter as degraded - Health Level One
            Write-Verbose "The avg is greater than the Threshold Avg"
            Write-Verbose "avgResults: $avgResults   threshold_Avg: $threshold_Avg"
            $iHealthCounter = $Health_Level_One # Setting the level to at least a one  
            #From there, will depend on if we have spikes above the Warning threshold limits or Max Threshold limits 
            if($aSpikes -ne $null){
                Write-Verbose "We do have some spikes on this counter greater than the warning threshold looking into this" 
                #We do have at least one instance of a spike occurrance. Now we need to determine if we have multiple and which kind.
                $d_Max_Spikes = Get-ValuesAboveThresholdFromList -List $aSpikes -thresholdValue $dThreshold_Max
                $Max_Spikes = Get-ValuesAboveThresholdFromList -List $aSpikes -thresholdValue $threshold_Max 
                if($d_Max_Spikes -ne $null -or $Max_Spikes -ne $null) {
                    $iHealthCounter = Get-PrivateHealthLevelCounter

                } # end $d_Max_Spikes -ne $null -or $Max_Spikes -ne $null
                else{
                    $iHealthCounter = Get-PrivateHealthLevelCounterNoValuesOverMaxThreshold
                }
                $health_Level = Get-HealthLevelFromWeightValue -iWeightValue $iHealthCounter -Array_Levels $Health_Level_One,$Health_Level_Two,$Health_Level_Three -LevelStartValue 1 
                #now we need to verify that nothing odd happend
                if($health_Level -lt 1){
                        $wt = "[ERR]: Something didn't calculate correctly in the  Detect-IssueDeepGtThresholdCheck function we should have returned a value of 1 for the health but didn't"
                        Write-ToLogScript $wt
                        $health_Level = 1
                }
                #now to set the default string for a message 
                switch($health_Level){
                    1{$default_Display_Message = "[DEG]: " + $default_Server_Object_Counter_String + "This counter is currently above the average threshold (" + $threshold_Avg + ") with some spikes, but not enough to increase the level. Current values: " + $default_Display_Results;break}
                    2{$default_Display_Message = "[POOR]: " + $default_Server_Object_Counter_String + "This counter is currently above the average threshold (" + $threshold_Avg + ") with some spikes that increased the level to poor. Current values: " + $default_Display_Results;break}
                    3{$default_Display_Results = "[Critical]: " + $default_Server_Object_Counter_String + "This counter is currently above the average threshold (" + $threshold_Avg + ") with a spikes that inceased the level to critical. Current values: " + $default_Display_Results; break }
                }
            }
            #there are no spikes so we are just going to return a degraded results 
            else{
                $health_Level = 1 
                $default_Display_Message = "[DEG]: " + $default_Server_Object_Counter_String + "This counter is currently above the average threshold (" + $threshold_Avg + ") with no spikes above the warning threshold (" + $threshold_Warning + "). Current Values: " + $default_Display_Results
            }

        }#End $avgResults -ge $threshold_Avg
        else{
            #We are not above the Threshold avg so we are going to see if we have spikes and so on 
            Write-Verbose "We are not above the average threshold for this counter" 
            Write-Verbose "Checking to see if we have any spikes above the warning level" 
            $iHealthCounter = 0 # setting to 0 because we are below the threshold average from there we can increase if we have enough spikes 
            if($aSpikes -ne $null){
                #We had some spikes now we need to see if we have some major spikes 
                $d_Max_Spikes = Get-ValuesAboveThresholdFromList -List $aSpikes -thresholdValue $dThreshold_Max
                $Max_Spikes = Get-ValuesAboveThresholdFromList -List $aSpikes -thresholdValue $threshold_Max 
                if($d_Max_Spikes -ne $null -or $Max_Spikes -ne $null){
                    $iHealthCounter = Get-PrivateHealthLevelCounter 
                }#end $d_Max_Spikes -ne $null -or $Max_Spikes -ne $null
                else{
                    $iHealthCounter = Get-PrivateHealthLevelCounterNoValuesOverMaxThreshold 
                }
                $health_Level = Get-HealthLevelFromWeightValue -iWeightValue $iHealthCounter -Array_Levels $Health_Level_One,$Health_Level_Two,$Health_Level_Three -LevelStartValue 0
                if($health_Level -lt 0){
                       $wt = "[ERR]: Something didn't calculate correctly in the  Detect-IssueDeepGtThresholdCheck function we should have returned a value of 1 for the health but didn't"
                       Write-ToLogScript $wt
                       $health_Level = 0
                }
                $cString = $default_Server_Object_Counter_String = "This counter is currently below the average threshold (" + $threshold_Avg + ") and had some spikes that were greater than the Warning threshold (" + $threshold_Warning + ") " 
                switch($health_Level){
                    0{$default_Display_Message = "[INFO]: " + $cString + "but not enough to increase level of the server. Current Values: " + $default_Display_Results;break}
                    1{$default_Display_Message = "[DEG]: " + $cString + "and enough to increase the level of the server to degraded. Current Values: " + $default_Display_Results; break }
                    2{$default_Display_Message = "[POOR]: " + $cString + "and enough to increase the level of the server to poor. Current Values: " + $default_Display_Results; break}
                    3{$default_Display_Message = "[Critical]: " + $cString + "and enough to increase the level of the server to Critical. Current Values: " + $default_Display_Results; break}
                }
            } 
            #There are no spikes 
            else{
                $health_Level = 0
                $default_Display_Message = "[INFO]: " + $default_Server_Object_Counter_String + "This counter is currently below the average threshold (" + $threshold_Avg + ") and didn't have any spikes greater than the warning threshold. Current Values: " + $default_Display_Results
            }
        }

        Update-HealthReportInstanceObject $instanceObject $default_Display_Message $health_Level $default_Display_Results 

    } # end for each counter instance 
}

##########################################
#
# Detecting Issues Functions 
#
##########################################

##########################################
#
# Classes 
#
##########################################
Function Load-Classes {
Add-Type @"

namespace PerformanceHealth
{
    public class TimeProps
    {
        public System.DateTime Time;
        public double Value;    
    }

    public class HealthReport
    {
        public string Status;
        public string LastChangeTime;
        public string Reason;
        public int ProblemInstances;
        public string DisplayInfo;
    }

    public class CounterThresholds
    {
        public double MaxSpike;
        public double WarningSpike;
        public double Average;
    }

    public class InstancesObject
    {
        public string Name;
        public string FullName;
        public TimeProps Current; 
        public System.Array HistoryValues;
        public HealthReport HealthReport; 
    }


    public class CounterSetObject 
    {
        public string Name; 
        public CounterThresholds Threshold;
        public CounterThresholdWeight ThresholdWeight;
        public CounterHealthLevelLimit HealthLevelLimit;
        public HealthReport HealthReport; 
        public System.Array Instances; 
        public string DetectIssueType;
    }

    public class CounterDataObject 
    {
        public string ObjectName;
        public string CounterName;
        public string ServerName;
        public HealthReport HealthReport; 
        public CounterSetObject CounterSet;
    }

    public class ServerPerformanceObject
    {
        public string ServerName;
        public System.Array CounterData;
        public HealthReport HealthReport;
    }

    public class CounterThresholdWeight 
    {
        public int WarningThreshold;
        public int MaxThreshold;
        public int DoubleMaxThreshold;
    }

    public class CounterHealthLevelLimit 
    {
        public int HealthLevelOne;
        public int HealthLevelTwo;
        public int HealthLevelThree;
    }
}
namespace DisplayForm
{
    public class DisplayRowReadyObject 
    {
        public string RowName;
        public System.Array Columns;
    }

    public class DislayColumnReadyObject
    {
        public string ColumnName;
        public System.Array Labels;
    }

    public class DisplayLabelReadyObject
    {
        public string LabelName;
        public string Text;
        public string BackColor;
        public string BorderStyle;
        public string TextAlign;
        public string Font;

    }

    public class DisplayRowObject 
    {
        public string RowName;
        public string EndingYLocation; 
        public System.Array Columns; 
    }

    public class DisplayColumnObject
    {
        public string ColumnName;
        public int StartingXLocation;
        public int StartingYLocation;
        public int EndingXLocation;
        public int EndingYLocation;
        public System.Array Labels;
    }

    public class DisplayLabelInformation 
    {
        public string LabelName;
        public string Text;
        public int StartingXLocation;
        public int StartingYLocation; 
        public int EndingXLocation; 
        public int EndingYLocation;
        public System.Windows.Forms.Label Label;

    }

    public class DisplayServerObject 
    {
        public string ServerName;
        public int StartingYLocation;
        public int EndingYLocation;
        public System.Array Columns;
    }

    public class DisplayLabelObject
    {
        public string Text;
        public int StartingXLocation;
        public int StartingYLocation;
        public int EndingXLocation;
        public int EndingYLocation;
        public System.Array Labels;
    }

}


"@ -ReferencedAssemblies System.Windows.Forms
#Needed to add -ReferencedAssemblies because of the class DisplayLabelInformation with the System.Windows.Forms.Label property
}

##########################################
#
# Script Main 
#
##########################################

Function Main {

    
    Create-LogFileScript
    Load-Classes
    $Script:HealthLevels = Get-HealthReportXML
    Write-VerboseOutput "Setting the Health Level XML for the script" 
    Build-ArrayMasterObjectScript
    #Now to collect actual data 
    $i = 0 
    [int]$mInter = $RefreshRate / $SampleInterval
    while($i++ -lt $LoopMax) 
    {
        Collect-DataCounterDataManager -serverObjects $aMasterObject -counterLists $CounterList -sInterval $SampleInterval -mSamples $mInter 
        Detect-Issue -aObject $aMasterObject
    }

}

Main 