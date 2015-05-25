---
title:    "Glossary"
up_to_date_with_nanoc_4: true
---

<dl class="glossary">
	<dt id="glossary-asset">asset</dt>
	<dd><span class="see">see <a href="#glossary-item">item</a></span></dd>

	<dt id="glossary-attribute">attribute</dt>
	<dd>A key-value pair that contains extra <a href="#glossary-metadata">metadata</a> about an <a href="#glossary-item">item</a> or a <a href="#glossary-layout">layout</a>.</dd>

	<dt id="glossary-compilation">compilation</dt>
	<dd>The act of <a href="#glossary-filter">filtering</a> and <a href="#glossary-layout">laying out</a> all <a href="#glossary-item">items</a> in a <a href="#glossary-site">site</a>, according to <a href="#glossary-routing-rule">routing rules</a>, <a href="#glossary-compilation-rule">compilation rules</a> and <a href="#glossary-layout-rule">layout rules</a>.</dd>

	<dt id="glossary-compilation-rule">compilation rule</dt>
	<dd>A <a href="#glossary-rule">rule</a> that defines how an <a href="#glossary-item">item</a> should be <a href="#glossary-filter">filtered</a> and/or <a href="#glossary-layout">laid out</a>.</dd>

	<dt id="glossary-content-file">content file</dt>
	<dd>A file containing the actual content of an <a href="#glossary-item">item</a> or a <a href="#glossary-layout">layout</a>. Usually, there will also be a <a href="#glossary-meta-file">meta-file</a> containing <a href="#glossary-metadata">metadata</a> about that item or layout, although some <a href="#glossary-data-source">data sources</a> (e.g. <code>filesystem</code>) merge the content file and the meta-file into a single file.</dd>

	<dt id="glossary-data-source">data source</dt>
	<dd>An object that reads data from a given location and turns this data into <a href="#glossary-item">items</a> and/or <a href="#glossary-layout">layouts</a>. By default, data can be read from the filesystem, but data sources for databases and online web services are also possible.</dd>

	<dt id="glossary-filter">filter</dt>
	<dd>An object that transforms content from one format into another format. There are filters that evaluate embedded Ruby code (<code>erb</code>, <code>haml</code>), filters that transform from text to HTML (<code>bluecloth</code>, <code>redcloth</code>), filters that “clean” HTML (<code>rubypants</code>), and more.</dd>

	<dt id="glossary-helper">helper</dt>
	<dd>A module that, when included, offers additional functionality such as easy linking to pages, building XML sitemaps or Atom web feeds.</dd>

	<dt id="glossary-identifier">identifier</dt>
	<dd>A string that is used to uniquely identify an <a href="#glossary-item">item</a> or a <a href="#glossary-layout">layout</a>. It is used to construct <a href="#glossary-path">paths</a> of item <a href="#glossary-representation">representations</a>. <span class="see">See</see> <a href="/docs/reference/identifiers-and-patterns/">identifiers and patterns</a>.</dd>

	<dt id="glossary-item">item</dt>
	<dd>The main piece of unprocessed content in a <a href="#glossary-site">site</a>. This can be a HTML page, a CSS file, a script file, etc. An item can have multiple <a href="#glossary-representation">representations</a>. It is sometimes referred to as a <a href="#glossary-page">page</a> or an <a href="#glossary-asset">asset</a>.</dd>

	<dt id="glossary-layout">layout</dt>
	<dd>An object consisting of content and <a href="#glossary-metadata">metadata</a> that embeds content from <a href="#glossary-item">items</a> or layouts. For example, it can be used to add headers, footers and sidebars to pages.</dd>

	<dt id="glossary-layout-rule">layout rule</dt>
	<dd>A <a href="#glossary-rule">rule</a> that specifies what <a href="#glossary-filter">filter</a> should be used when processing a <a href="#glossary-layout">layout</a>.</dd>

	<dt id="glossary-metadata">metadata</dt>
	<dd>A collection of <a href="#glossary-attribute">attributes</a>, usually stored in a <a href="#glossary-meta-file">meta-file</a>, for an <a href="#glossary-item">item</a> or a <a href="#glossary-layout">layout</a>.</dd>

	<dt id="glossary-meta-file">meta-file</dt>
	<dd>A file containing <a href="#glossary-metadata">metadata</a> about an <a href="#glossary-item">item</a> or a <a href="#glossary-layout">layout</a>. It is usually paired with a <a href="#glossary-content-file">content file</a>. Some <a href="#glossary-data-source">data sources</a> put the metadata and the content in a single file.</dd>

	<dt id="glossary-output-directory">output directory</dt>
	<dd>The directory to which compiled <a href="#glossary-representation">item representations</a> are written.</dd>

	<dt id="glossary-path">path</dt>
	<dd>A string containing the path, relative to the <a href="#glossary-output-directory">output directory</a>, to a compiled <a href="#glossary-representation">item representation</a>.</dd>

	<dt id="glossary-page">page</dt>
	<dd><span class="see">see <a href="#glossary-item">item</a></span></dd>

	<dt id="glossary-partial">partial</dt>
	<dd>A <a href="#glossary-layout">layout</a> that is not used for embedding content, but rather used for being embedded in layouts or <a href="#glossary-item">items</a> using the <code>Rendering</code> helper.</dd>

	<dt id="glossary-rep">rep</dt>
	<dd><span class="see">see <a href="#glossary-representation">representation</a></span></dd>

	<dt id="glossary-representation">representation</dt>
	<dd>A "version" of an <a href="#glossary-item">item</a>. For example, an item can have a HTML, an XHTML, a JSON and a YAML representation. A single representation corresponds to one output file (or zero, if the representation does not have a <a href="#glossary-path">path</a>).</dd>

	<dt id="glossary-routing-rule">routing rule</dt>
	<dd>A <a href="#glossary-rule">rule</a> that defines what <a href="#glossary-path">path</a> a <a href="#glossary-representation">representation</a> should get.</dd>

	<dt id="glossary-rule">rule</dt>
	<dd>A bit of code that defines how an <a href="#glossary-item">item</a> should be processed (routed using a <a href="#glossary-routing-rule">routing rule</a> and compiled using a <a href="#glossary-compilation-rule">compilation rule</a>), or which <a href="#glossary-filter">filter</a> should be used for processing a given <a href="#glossary-layout">layout</a> in a <a href="#glossary-layout-rule">layout rule</a>.</dd>

	<dt id="glossary-site">site</dt>
	<dd>A directory containing <a href="#glossary-item">items</a>, <a href='#glossary-layout'>layouts</a>, <a href="#glossary-rule">rules</a> and custom code. It can also refer to the compiled site, which can be found in the uncompiled site’s <a href="#glossary-output-directory">output directory</a>.</dd>
</dl>
