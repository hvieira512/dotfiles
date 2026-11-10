-- Only for rename, code actions, implementations and type definition;
-- everything shared with intelephense is stripped so nothing doubles.
-- Diagnostics are off in init_options and dropped by the handler as a backstop.
return {
    init_options = {
        ["language_server.diagnostics_on_update"] = false,
        ["language_server.diagnostics_on_save"] = false,
        ["language_server.diagnostics_on_open"] = false,
        ["language_server.diagnostic_outsource"] = false,
        ["language_server_worse_reflection.diagnostics.enable"] = false,
        ["language_server_php_cs_fixer.show_diagnostics"] = false,
        ["php_code_sniffer.show_diagnostics"] = false,
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = function() end,
    },
    on_init = function(client)
        local caps = client.server_capabilities
        for _, cap in ipairs({
            "completionProvider", "hoverProvider", "signatureHelpProvider",
            "definitionProvider", "declarationProvider", "referencesProvider",
            "documentHighlightProvider", "documentSymbolProvider", "workspaceSymbolProvider",
            "documentFormattingProvider", "documentRangeFormattingProvider",
            "inlayHintProvider", "semanticTokensProvider", "diagnosticProvider",
        }) do
            caps[cap] = nil
        end
    end,
}
