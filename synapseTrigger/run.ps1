# Input bindings are passed in via param block.
param($Timer)

Import-Module Az.Synapse -SkipEditionCheck

$workspaceName = $ENV:WorkspaceName
$pipelineName = $ENV:PipelineName
$begin = (Get-Date).AddDays(-90)
$end = (Get-Date) 


$result = Get-AzSynapsePipelineRun -WorkspaceName $workspaceName -RunStartedAfter $begin -RunStartedBefore $end -PipelineName $pipelineName

$total = $result | Where {$_.Status -eq 'InProgress'}

if ($total.count -eq 0)
{
  write-host "No running streaming pipeline.....starting new pipeline....."
  Invoke-AzSynapsePipeline -WorkspaceName $workspaceName -PipelineName $pipelineName
  write-host "Pipeline Started"
  
} else{
    write-host "Streaming is Running..."
}
