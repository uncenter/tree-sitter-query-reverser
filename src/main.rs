use clap::Parser;
use std::{fs, path::PathBuf};
use tree_sitter_query_reverser::reverse;

#[derive(clap::Parser)]
#[command(version, about)]
struct Cli {
    path: PathBuf,

    #[clap(long, short)]
    output: Option<PathBuf>,
}

fn main() -> miette::Result<()> {
    let args = Cli::parse();

    let source_code = fs::read_to_string(&args.path).map_err(|e| FilesystemError::Read {
        source: e,
        path: args.path.display().to_string(),
    })?;
    let reversed_code = reverse(source_code);

    if let Some(outpath) = args.output {
        fs::write(&outpath, reversed_code).map_err(|e| FilesystemError::Write {
            source: e,
            path: outpath.display().to_string(),
        })?;
    } else {
        println!("{}", reversed_code);
    }

    Ok(())
}

#[cfg(test)]
mod test {
    use pretty_assertions::assert_eq;
    use std::{env, fs, path::Path};

    use crate::reverse;

    fn assert_sample(name: &str) {
        let stubs = Path::new(&env::current_dir().unwrap())
            .join("test")
            .join("stubs");
        let input = stubs.join(format!("{name}-input.scm"));
        let output = stubs.join(format!("{name}-output.scm"));

        assert_eq!(
            fs::read_to_string(output).unwrap(),
            reverse(fs::read_to_string(input).unwrap())
        )
    }

    #[test]
    fn gleam_sample() {
        assert_sample("gleam")
    }

    #[test]
    fn swift_sample() {
        assert_sample("swift")
    }
}

#[derive(thiserror::Error, miette::Diagnostic, Debug)]
pub enum FilesystemError {
    #[error("Failed to read file '{}'.", .path)]
    Read {
        #[source]
        source: std::io::Error,
        path: String,
    },
    #[error("Failed to write file '{}'.", .path)]
    Write {
        #[source]
        source: std::io::Error,
        path: String,
    },
}
