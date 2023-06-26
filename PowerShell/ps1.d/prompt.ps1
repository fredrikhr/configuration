function prompt {
    "PS $($ExecutionContext.SessionState.Path.CurrentLocation)",
    "$('>' * ($nestedPromptLevel + 1)) " `
        -join [System.Environment]::NewLine
}
