---
title:    "Deploying nanoc sites"
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

<div class="admonition caution">This will remove all files and directories that do not correspond to nanoc items in the destination. Make sure that the destination does not contain anything that you still need.</div>

With GitHub pages
-----------------

The Github pages deploy process is nicely [described in Github's help pages](https://help.github.com/articles/creating-project-pages-manually).

### Setup

Create a orphaned branch dedicated to GitHub pages:

<pre><span class="prompt">%</span> <kbd>rm -rf output</kbd>
<span class="prompt">%</span> <kbd>git branch --orphan gh-pages</kbd></pre>

Clone the current repo into the output directory and <kbd>git checkout</kbd> the new branch:

<pre><span class="prompt">%</span> <kbd>git clone . output</kbd>
<span class="prompt">%</span> <kbd>cd output</kbd>
<span class="prompt">%</span> <kbd>git checkout gh-pages</kbd></pre>

Nuke the current content:

<pre><span class="prompt">%</span> <kbd>rm -rf *</kbd>
<span class="prompt">%</span> <kbd>git add .</kbd>
<span class="prompt">%</span> <kbd>git commit -am 'Nuke the output directory and gh-pages branch'</kbd></pre>

Change the remote for this repo, replacing <var>repo-url</var> with the URL to the repository:

<pre><span class="prompt">%</span> <kbd>git remote rm origin</kbd>
<span class="prompt">%</span> <kbd>git remote add origin</kbd> <var>repo-url</var></pre>

Add the `output` folder to your `.gitignore`. (Adding it to the repo does not help.)

Every new user need to set up this branch manually.

Now you have an orphaned branch dedicated to GitHub pages publishing. This branch now dwells in the output folder of your nanoc repository.

### Publish

To publish your nanoc site you start with running nanoc as normal:

<pre><span class="prompt">%</span> <kbd>nanoc</kbd></pre>

Jump into output, commit the result and push the publishing branch:

<pre><span class="prompt">%</span> <kbd>cd output</kbd>
<span class="prompt">%</span> <kbd>git add .</kbd>
<span class="prompt">%</span> <kbd>git commit -am 'Content created'</kbd>
<span class="prompt">%</span> <kbd>git push origin gh-pages</kbd></pre>

Wait a couple of minutes and your content will appear at <code>http://<var>your-GitHub-username</var>.github.com/<var>your-GitHub-repository-name</var></code>.

The above five lines can be put into a shell script for easy publishing. (Or you could create a deployer for this setup. Any takers?)

With this approach, nanoc is happy, because the output folder is where it is supposed to be, and GitHub pages is happy as well, because there is a nice and tidy branch called `gh-pages` with static publishable content.

A weird side effect is that the `gh-pages` branch in the output directory is likely to be out of sync with the gh-pages branch in your base repo. You can either remove the branch from the base repo, or just make sure to `pull` after a succesful publish.
