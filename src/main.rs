use clap::Parser;
use color_eyre::Result;
use std::{fs, path::PathBuf};

#[derive(clap::Parser)]
#[command(version, about)]
struct Cli {
    path: PathBuf,

    #[clap(long, short)]
    output: Option<PathBuf>,
}

fn main() -> Result<()> {
    let args = Cli::parse();

    let mut parser = tree_sitter::Parser::new();
    parser
        .set_language(&tree_sitter_query::LANGUAGE.into())
        .expect("Error loading Query grammar");

    let source_code = fs::read_to_string(args.path)?;

    let tree = parser.parse(&source_code, None).unwrap();
    let root_node = tree.root_node();
    let mut cursor = root_node.walk();

    let mut nodes = root_node
        .children(&mut cursor)
        .into_iter()
        .filter_map(|n| {
            if n.kind() == "comment" {
                None
            } else {
                let range = n.byte_range();

                Some(&source_code[range.start..range.end])
            }
        })
        .collect::<Vec<_>>();

    nodes.reverse();

    let reversed_code = nodes.join("\n");

    if let Some(outpath) = args.output {
        fs::write(outpath, reversed_code)?;
    } else {
        println!("{}", reversed_code);
    }

    Ok(())
}
