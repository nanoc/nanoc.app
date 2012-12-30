---
title:    "Development"
markdown: basic
has_toc:  true
---

Reporting bugs
--------------

If you find a bug in nanoc, you should report it! But before you do, make sure you have the latest version of nanoc (and dependencies) installed, and see if you can still reproduce the bug there. If you can, report it!

When reporting a bug, please make sure you include as many details as you can about the bug. Some information that you should include:

* The nanoc version (`nanoc --version`), including the Ruby version
* The `crash.log` file, if the bug you’re reporting is a crash

Submitting feature requests
---------------------------

If you have an idea for a feature that you believe is missing in nanoc, describe it on the [wishlist](https://github.com/ddfreyne/nanoc/wiki/Wishlist). I recommend also starting a discussion on the [discussion forums](https://groups.google.com/forum/?fromgroups#!forum/nanoc) to get feedback.

### nanoc Enhancement Proposals (NEPs)

When a feature from the wishlist is deemed interesting enough, it will be converted to a _nanoc Enhancement Proposal_ (NEP). Take a look at the [list of NEPs](/development/neps/). The NEPs are stored in the [NEPs repository](https://github.com/ddfreyne/neps) and the nanoc web site will regularly be updated to include updates made to the NEPs repository.

Getting the source code
-----------------------

The nanoc source code is available in the [nanoc repository on GitHub](https://github.com/ddfreyne/nanoc). There are a few branches you should be aware of:

* The `master` branch contains new developments that are scheduled to be released in the next feature release (x.Y.0 release).

* The `release-*` branches, e.g. `release-3.4.x`, are branched off the master branch when the feature set is frozen. Bug fixes are applied on this branch and will be part of the next bugfix release (x.y.Z release).

Contributing code
-----------------

There are two kind of pull requests:

* If your pull request is a **bug fix**, submit it on the latest release branch. At the moment of writing, this is `release-3.4.x`. This ensures that the bug fix comes in the next patch release.

* If your pull request is a new **feature** or extends an existing feature,  submit it on the `master` branch.

In both cases, make sure that your changes have **test cases** that cover the bug fix or the new/changed functionality. If necessary, update the **YARD documentation**.

Do not touch the README and NEWS files, and do not change the version number.

Also note that **backwards compatibility** must be retained. This means that you cannot simply modify a feature to work in a different way. What you can do, is add an option to make it work in a different way, but do double-check with me ([@ddfreyne](https://github.com/ddfreyne)) first.
