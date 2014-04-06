---
title: "The Compilation Process"
---

nanoc’s compilation process is not straightforward because many different subsystems are invoked at different points in the process. The purpose of this page is to give insight in the various stages that the compiler goes through. It is mostly intended as reference material for developers who are interested in learning about nanoc’s internals.

Note that **this page is a work in progress** and is by no means complete and may even be factually inaccurate. Use at your own risk!

At the highest level, there are four phases the compiler runs through:

1. Loading the site data
2. Preprocessing the site data
3. Building the item representations
4. Compiling the item representations

Loading the site data
---------------------

In order to load items and layouts, the site’s data sources are consulted. The data sources that should be used is determined by the configuration file. For each data source, its items and layouts are requested.

The code in the lib/ directory as well as the content of the Rules file is also loaded. The data sources are not responsible for loading this data.

Preprocessing the site data
---------------------------

Once the site’s data is loaded, several preprocessing steps are performed:

1. Setting up child-parent links
2. Running the preprocessor block
3. Updating the child-parent links
4. Freezing all site data

Setting up child-parent links means adding points from parent items to their children and vice versa. For example, the `Nanoc3::Item` corresponding to “/foo/” will gain pointers to its children, e.g. “/foo/a/” and “/foo/xyzzy/”, while “/foo/a/” and “/foo/xyzzy/” will both have a parent pointer to the “/foo/” item.

The preprocessor block, defined using the `#preprocess` call in the `Rules` file, will be run, allowing items to be modified, added and deleted. Since the item hierarchy potentially changes, the child-parent links are updated after this step.

The last step involves freezing all site data. No modification of site data is allowed after this point. Attempting to modify any source data, including item content or attributes, will result in an error. Preventing modifications is necessary in order to guarantee a correct answer from the outdatedness heuristics (see below).

### Building the item representations

At this point, each item gets one or more representations. The names of the representations are inferred from the compilation rules: for each item, all matching compilation rules are collected, and for each rule the rep names are collected. For each of these rep names, an item representation is generated.

Secondly, for each item representation, the matching routing rule is found and executed in order to determine this representation’s output path.

### Compiling the item representations

Once all the necessary information has been obtained, the actual compilation can begin. In order to determine which item should be compiled, the following algorithm is used:

	procedure compile_reps(reps):
	  outdated_reps ← select from reps where outdated = true
	  graph ← empty graph with vertices for outdated reps

	  repeat:
	    if graph has no roots, stop
	    rep ← random root from graph
	    compile rep
	    when successful:
	      remove vertex for rep from graph
	    when failure due to an unmet dependency:
	      rep2 ← representation that rep depends on
	      add vertex for rep2 to graph
	      add edge from rep to rep2 to graph

	  if graph is not empty:
	    throw recursive compilation error

To detect which items representations are outdated, a fairly complicated outdatedness checking algorithm is used, described in a separate section below.

Unmet dependencies occur when one rep includes the content of another rep, but the content of the latter is not yet available because the latter is not (yet) compiled. In this case, a directed edge is created in order to ensure that the item will not be recompiled until its dependency has been compiled.

The compilation process stops when the graph has no roots anymore. If the graph still has vertices at this point, the compilation has failed because items mutually include each other.

To compile a single representation, the following algorithm is used:

	procedure compile_rep(rep)
	  if rep is not outdated and cached content is available:
	    compiled content ← cached compiled content
	  else:
	    rule ← compilation rule for rep
	    apply rule to rep
	    cache compiled content

	  set rep to compiled

Outdatedness checking
---------------------

nanoc takes an “always-correct” approach when it comes to deciding whether an item is outdated or not. The outdatedness checking algorithm will always return “yes” if the item needs to be recompiled one way or another. However, it may also return “yes” in cases where the item does not need to be recompiled. The latter can and will happen because nanoc’s heuristics for determining outdatedness are, and always will be, imperfect. The advantage of this “always-correct” approach is that when compiling a site, all items are guaranteed to be up-to-date.

The following checks are used in determining item outdatedness:

* Output file availability check
* Code check
* Checksum check
* Rule memory check
* Dependency check

### Output file availability check

If the rep will be written to a file that does not (yet) exist, the rep will have to be recompiled.

### Code check

If any of the code in the lib/ directory changes, all reps will have to be recompiled. This is sad but true, because there is no way to determine what impact a change in this directory has.

### Checksum check

For each item, a checksum is created from both its uncompiled content as well as its attributes. More specifically, the SHA1 hash of the item’s content is combined with the SHA1 hash of the YAML dump of the item’s attributes. If these checksums differ during the next compilation process, the item is marked as outdated.

### Rule memory check

Another check compares the rules and their actions used during the compilation process. Before running the actual item rep through its corresponding compilation rule, a stub object is passed through the compilation rule. This stub object records all actions (calls to #filter, #layout and #snapshot). When the actions differ between compilation processes, the rep needs to be recompiled.

### Dependency check

When an item rep depends on an item rep that is outdated, the former will need to be recompiled as well. This is recursive: for example, a rep that depends on a rep that depends on a rep that is outdated will also be considered outdated.

### Cache

nanoc remembers the compiled content of compiled reps. This way, if an outdated rep depends on a non-outdated rep, the latter will not have to be recompiled needlessly; the compiled content will be taken from the cache.
