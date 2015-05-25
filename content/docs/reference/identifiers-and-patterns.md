---
title:      "Identifiers and patterns"
is_dynamic: true
up_to_date_with_nanoc_4: true
---

In nanoc, every item (page or asset) and every layout has a unique _identifier_: a string derived from the file’s path. A _pattern_ is an expression that is used to select items or layouts based on their identifier.

## Identifiers

Identifiers come in two types: the _full_ type, new in nanoc 4, and the _legacy_ type, used in nanoc 3.

full
: An identifier with the full type is the filename, with the path to the content directory removed. For example, the file <span class="filename">/Users/denis/stoneship/content/about.md</span> will have the full identifier _/about.md_.

legacy
: An identifier with the legacy type is the filename, with the path to the content directory removed, the extension removed, and a slash appended. For example, the file <span class="filename">/Users/denis/stoneship/content/about.md</span> will have the legacy identifier _/about/_. This corresponds closely with paths in clean URLs.

The following methods are useful for full identifiers:

`identifier.with_ext(string)` &rarr; String
: identifier with the extension replaced with the given string

`identifier.without_ext` &rarr; String
: identifier with the extension removed

Here are some examples:

    #!ruby
    identifier = Nanoc::Identifier.new('/about.md')

    identifier.without_ext
    # => "/about"

    identifier.with_ext('html')
    # => "/about.html"

The following methods are useful for legacy identifiers:

{: .legacy}
`identifier.chop` &rarr; String
: identifier with the last character removed

`identifier + string` &rarr; String
: identifier with the given string appended

Here are some examples:

    #!ruby
    identifier = Nanoc::Identifier.new('/about/', type: :legacy)

    identifier.chop
    # => "/about"

    identifier.chop + '.html'
    # => "/about.html"

    identifier + 'index.html'
    # => "/about/index.html"

## Patterns

Patterns are used to find items and layouts based on their identifier. They come in three varieties:

* glob patterns
* regular expression patterns
* legacy patterns

### Glob patterns

Glob patterns are strings that contain wildcard characters. An example of a glob pattern is `/projects/*.md`. Globs are commonplace in Unix-like environments.

Glob patterns are the default in nanoc 4.

For glob patterns, nanoc supports the following wildcards:

`*`
: Matches any file or directory name. Does not cross directory boundaries. For example, `/projects/*.md` matches `/projects/nanoc.md`, but not `/projects/cri.adoc` nor `/projects/nanoc/about.md`.

`**`
: Matches any file or directory name, and crosses directory boundaries. For example, `/projects/**/*.md` matches both `/projects/nanoc.md` and `/projects/nanoc/history.md`.

`?`
: Matches a single character.

`[abc]`
: Matches any single character in the set. For example, `/people/[kt]im.md` matches only `/people/kim.md` and `/people/tim.md`.

`{foo,bar}`
: Matches either string in the comma-separated list. More than two strings are possible. For example, `/c{at,ub,ount}s.txt` matches `/cats.txt`, `/cubs.txt` and `/counts.txt`.

A glob pattern that matches every item is `/**/*`. A glob pattern that matches every item/layout with the extension `md` is `/**/*.md`.

### Regular expression patterns

You can use a regular expression to select items and layouts.

For matching identifiers, the `%r{…}` syntax is (arguably) nicer than the `/…/` syntax. The latter is not a good fit for identifiers (or filenames), because all slashes need to be escaped. The `\A` and `\z` anchors are also useful to make sure the entire identifier is matched.

An example of a regular expression pattern is `%r{\A/projects/(cri|nanoc)\.md\z}`, which matches both `/projects/nanoc.md` and `/projects/cri.md`.

### Legacy patterns

Legacy patterns are strings that contain wildcard characters. The wildcard characters behave differently than the glob wildchard characters.

To enable legacy patterns, set `string_pattern_type` to `"legacy"` in the configuration. For example:

    #!yaml
    string_pattern_type: "legacy"

For legacy patterns, nanoc supports the following wildcards:

`*`
: Matches zero or more characters, including a slash. For example, `/projects/*/` matches `/projects/nanoc/` and `/projects/nanoc/about`, but not `/projects/`.

`+`
: Matches one or more characters, including a slash. For example, `/projects/+` matches `/projects/nanoc/` and `/projects/nanoc/about`, but not `/projects/`.
