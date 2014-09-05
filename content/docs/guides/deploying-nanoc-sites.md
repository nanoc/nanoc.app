---
title:    "Deploying nanoc sites"
---

Deploying
---------

There are quite a few ways to deploy a site to a web host. The most traditional way of uploading a site involves using FTP to transfer the files (perhaps using an “update” or “synchronise” option). If your web host provides access via SSH, you can use SCP or SFTP to deploy a site.

With rsync
----------

If your web host supports rsync, then deploying a site can be fully automated, and the transfer itself can be quite fast, too. rsync is unfortunately a bit cumbersome, providing a great deal of options (check <kbd>man rsync</kbd> in case of doubt), but fortunately nanoc provides a “deploy” command that can make this quite a bit easier: a simple <kbd>nanoc deploy</kbd> will deploy your site.

To use the deploy command, open the <span class="filename">nanoc.yaml</span> (on older sites: <span class="filename">config.yaml</span>) file and add a `deploy` hash. Inside, add a hash with a key that describes the destination (for example, `public` or `staging`). Inside this hash, set `dst` to the destination, in the format used by rsync and scp, to where the files should be uploaded, and set `kind` to `rsync`. Here’s what it will look like:

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

CAUTION: This will remove all files and directories that do not correspond to nanoc items in the destination. Make sure that the destination does not contain anything that you still need.

With GitHub Pages or Bitbucket
------------------------------

[GitHub](https://github.com/) and [Bitbucket](https://bitbucket.org/) are two repository hosting services that support publishing web sites. This section explains how to use their functionality for publishing a website in combination with nanoc.

### GitHub Pages setup

The publishing of a website based on a Git repo to GitHub Pages is [described in Github's help pages](https://help.github.com/articles/creating-project-pages-manually).

Clone the current repo into the <span class="filename">output/</span> directory, create an orphaned branch dedicated to GitHub Pages named `gh-pages`, and check out the new branch:

<pre><span class="prompt">%</span> <kbd>git clone . output</kbd>
<span class="prompt">%</span> <kbd>cd output</kbd>
<span class="prompt">output@master%</span> <kbd>git branch --orphan gh-pages</kbd>
<span class="prompt">output@master%</span> <kbd>git checkout gh-pages</kbd>
<span class="prompt">output@gh-pages%</span> <kbd>cd ..</kbd></pre>

Change the remote for this repo, replacing <var>repo-url</var> with the URL to the repository:

<pre><span class="prompt">output@gh-pages%</span> <kbd>git remote rm origin</kbd>
<span class="prompt">output@gh-pages%</span> <kbd>git remote add origin</kbd> <var>repo-url</var></pre>

Add the <span class="filename">output/</span> directory to your <span class="filename">.gitignore</span>. Make sure that the base repository doesn’t contain <span class="filename">output/</span>.

### Bitbucket setup

The publishing of a website based on a Git repo to Bitbucket is [described in Bitbucket's help pages](https://confluence.atlassian.com/display/BITBUCKET/Publishing+a+Website+on+Bitbucket).

Bitbucket supports publishing a website at <var>username</var>.bitbucket.org, where <var>username</var> is your Bitbucket account name. The contents of the web site will be read from a repository named <var>username</var>.bitbucket.org.

First of all, create the Bitbucket repository <var>username</var>.bitbucket.org. For example, _ddfreyne.bitbucket.org_.

Create a new Git repository inside the <span class="filename">output/</span> directory, replacing <var>repo-url</var> with the URL to the repository (e.g. `git@bitbucket.org:ddfreyne/ddfreyne.bitbucket.org.git`):

<pre><span class="prompt">%</span> <kbd>git init output/</kbd>
<span class="prompt">%</span> <kbd>cd output/</kbd>
<span class="prompt">output%</span> <kbd>git remote add origin</kbd> <var>repo-url</var></pre>

Add the <span class="filename">output/</span> directory to your <span class="filename">.gitignore</span>. Make sure that the base repository doesn’t contain <span class="filename">output/</span>.

### Publish

To publish your nanoc site, first compile site:

<pre><span class="prompt">%</span> <kbd>nanoc</kbd></pre>

Enter the <span class="filename">output/</span> directory, add and commit everything, and push:

<pre><span class="prompt">%</span> <kbd>cd output</kbd>
<span class="prompt">output%</span> <kbd>git add .</kbd>
<span class="prompt">output%</span> <kbd>git commit -m 'Update compiled output'</kbd>
<span class="prompt">output%</span> <kbd>git push</kbd></pre>

After a few seconds, the updated site will appear at <span class="uri">http://<var>username</var>.github.io/<var>repo-name</var></span> for GitHub, or <span class="uri">http://<var>username</var>.bitbucket.org</span> for Bitbucket.

For GitHub, we recommend removing the _gh-pages_ branch from the base repository, since it is quite likely to be out of sync with the _gh-pages_ branch in the repository in the <span class="filename">output/</span> directory.

With Fog gem for Amazon S3, Google Cloud, etc.
----------------------------------------------

You can deploy to any Fog provider directly from Nanoc. You find available providers
and their configuration variables in Fog [documentation](http://fog.io).

### Setup

You need `fog` gem installed, preferably using bundler. Change your configuration
for deployment in `config.yaml` to (for Amazon S3):

  #!yaml
  deploy:
    path_style:            true
    kind:                  fog
    provider:              aws
    region:                YOUR-REGION (eg. eu-west-1)
    bucket:                YOUR-BUCKETNAME
    aws_access_key_id:     YOUR-KEY-ID
    aws_secret_access_key: YOUR-SECRET

### Publish

To publish your nanoc site you use normal deploy command:

<pre><span class="prompt">%</span> <kbd>nanoc deploy</kbd></pre>

You should see this when done:

<pre>
Loading site data… done
Connecting
Getting bucket
Uploading local files
Removing remote files
Done!
</pre>
