function prompt {
    [string]::Join([System.Environment]::NewLine, 
        "PS $($ExecutionContext.SessionState.Path.CurrentLocation)",
        "$('>' * ($nestedPromptLevel + 1)) "
    )
}