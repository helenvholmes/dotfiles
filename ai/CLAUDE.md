# Notes for Claude (all projects)

## Branch names

Name branches for what they contain, in a few lowercase words joined by hyphens:
`route-railway-option`, `fix-inspector-overflow`, `resizable-panels`.

When a session starts on an auto-generated branch (a random name like
`claude/busy-allen-bndz3z`), rename it to a descriptive name as soon as you know
what the work is, and before the first commit is pushed or a pull request is
opened:

    git branch -m claude/<descriptive-name>

Keep the `claude/` prefix. If the old branch was already pushed, push the new name
and delete the old one on the remote.
