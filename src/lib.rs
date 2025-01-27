use std::collections::VecDeque;

#[derive(Default, Debug, Clone)]
struct Chunk {
    leading_comments: Vec<String>,
    inner_nodes: Vec<String>,
    trailing_whitespace: String,
}

impl ToString for Chunk {
    fn to_string(&self) -> String {
        self.leading_comments
            .iter()
            .chain(self.inner_nodes.iter().rev())
            .cloned()
            .collect::<Vec<_>>()
            .join("\n")
            + &self.trailing_whitespace
    }
}

pub fn reverse(source: String) -> String {
    let mut parser = tree_sitter::Parser::new();
    parser
        .set_language(&tree_sitter_query::LANGUAGE.into())
        .expect("Error loading Query grammar");

    let tree = parser.parse(&source, None).unwrap();
    let root_node = tree.root_node();
    let mut cursor = root_node.walk();
    let mut children = root_node.children(&mut cursor);

    let mut chunks: VecDeque<Chunk> = VecDeque::new();

    let mut last_range_end: Option<usize> = None;
    let mut current_chunk = Chunk::default();
    let mut current_chunk_comment_end = false;

    loop {
        match children.next() {
            Some(node) => {
                let range = node.byte_range();
                let raw = source[range.start..range.end].to_owned();

                if let Some(last_range_end) = last_range_end {
                    if range.start != last_range_end + 1 {
                        current_chunk.trailing_whitespace =
                            source[last_range_end..range.start].to_owned();
                        chunks.push_back(current_chunk);
                        current_chunk = Chunk::default();
                        current_chunk_comment_end = false;
                    }
                }

                if node.kind() == "comment" && current_chunk_comment_end == false {
                    current_chunk.leading_comments.push(raw);
                } else {
                    current_chunk.inner_nodes.push(raw);
                    current_chunk_comment_end = true;
                }

                last_range_end = Some(range.end);
            }
            None => {
                chunks.push_back(current_chunk);
                break;
            }
        }
    }

    // Often query files start with a comment at the top that should stay at the top.
    // This gets the first chunk, checks if it only has comments and doesn't have any nodes.
    // If so, the comment is moved back to the top.
    let top_comment = if let Some(first) = chunks.front() {
        if first.inner_nodes.is_empty() && !first.leading_comments.is_empty() {
            chunks.pop_front()
        } else {
            None
        }
    } else {
        None
    };

    // Switch the trailing whitespace of the first and last nodes (excluding the temporarily removed top comment if present).
    let len = chunks.len();
    if len >= 2 {
        let first_suffix = chunks[0].trailing_whitespace.clone();
        chunks[0].trailing_whitespace = chunks[len - 1].trailing_whitespace.clone();
        chunks[len - 1].trailing_whitespace = first_suffix;
    }

    // Reverse order of chunks (as is the main goal of this program!).
    chunks.make_contiguous().reverse();

    // Re-add the top comment saved from before.
    if let Some(top_comment) = top_comment {
        chunks.push_front(top_comment);
    }

    chunks
        .iter()
        .map(Chunk::to_string)
        .collect::<Vec<_>>()
        .join("")
}
