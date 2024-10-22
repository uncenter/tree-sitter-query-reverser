# tree-sitter-query-reverser

Convert Neovim/Zed-style Tree-sitter queries to Helix-style Tree-sitter queries ([where query precedence is flipped](https://github.com/helix-editor/helix/issues/9436)) by parsing the nodes of the Scheme-like document using [tree-sitter-query](https://github.com/tree-sitter-grammars/tree-sitter-query) and reversing them.

Simply run `tsqr <path-to-query-file>`. Comments are not preserved.

## License

[MIT](LICENSE)
