---
title:    "Deploying nanoc sites"
has_toc:  true
markdown: basic
---

Deploying
---------

There are quite a few ways to deploy a site to a web host. The most traditional way of uploading a site involves using FTP to transfer the files (perhaps using an “update” or “synchronise” option). If your web host provides access via SSH, you can use SCP or SFTP to deploy a site.

With rsync
----------

If your web host supports rsync, then deploying a site can be fully automated, and the transfer itself can be quite fast, too. rsync is unfortunately a bit cumbersome, providing a great deal of options (check <kbd>man rsync</kbd> in case of doubt), but fortunately nanoc provides a “deploy” command that can make this quite a bit easier: a simple <kbd>nanoc deploy</kbd> will deploy your site.

To use the deploy command, open the `nanoc.yaml` (on older sites: `config.yaml`) file and add a `deploy` hash. Inside, add a hash with a key that describes the destination (for example, `public` or `staging`). Inside this hash, set `dst` to the destination, in the format used by rsync and scp, to where the files should be uploaded, and set `kind` to `rsync`. Here’s what it will look like:

	#!yaml
	deploy:
	  public:
	    kind: rsync
	    dst:  "stoneship.org:/var/www/sites/example.com/public"
	  staging:
	    kind: rsync
	    dst:  "stoneship.org:/var/www/sites/example.com/public/staging"

By default, the rsync deployer will upload all files in the output directory to the given location. None of the existing files in the target location will be deleted; however, be aware that files with the same name will be overwritten. To run the deploy command, pass it a `--target` option, like this:

<pre title="Deploying"><span class="prompt">%</span> <kbd>nanoc deploy --target staging</kbd></pre>

This will deploy using the “staging” configuration. Replace “staging” with “public” if you want to deploy to the location marked with “public”.

If you want to check whether the executed `rsync` command is really correct, you can perform a dry run by passing `--dry-run`. The rsync command will be printed, but not executed. For example:

<pre title="Performing a dry run"><span class="prompt">%</span> <kbd>nanoc deploy --target public --dry-run</kbd></pre>

### Deleting stray files

nanoc will, by default, only update files that have changes, and not remove any files from the remote destination. If you _do_ want to let <kbd>nanoc deploy</kbd> remove any files on the destination that are not part of the nanoc site, you can modify the options used for rsync to include `--delete-after`, like this:

<pre title="Custom rsync options in the deployment configuration"><code class="language-yaml">options: [ '-aP', '--delete-after' ]</code></pre>

Use this with caution!

With git
--------

There’s no git deploy guide yet. If you want to write one, fork the nanoc site on GitHub, fill in this section and send a pull request!
