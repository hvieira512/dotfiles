-- hitcare pages use $db, $dbLIC and $i18n as globals from require'd files,
-- which intelephense can't follow. "local" (a string, not a boolean) silences
-- that at file scope and keeps it inside functions.
return {
    settings = {
        intelephense = {
            diagnostics = { undefinedVariables = "local" },
        },
    },
}
