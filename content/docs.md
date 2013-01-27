---

title:      "Documentation"
markdown:   basic
is_dynamic: true
child_desc: "nanoc documentation"

---

<% content_for :details do %>
    <h3>Documentation Index</h3>
    <ol>
	<li><%= link_to_id '/docs/tutorial/' %></li>
	<li><%= link_to_id '/docs/basics/' %></li>
	<li><%= link_to_id '/docs/extending-nanoc/' %></li>
	<li><%= link_to_id '/docs/guides/' %></li>
	<li><%= link_to_id '/docs/reference/' %></li>
	<li><%= link_to_id '/docs/troubleshooting/' %></li>
	<li><%= link_to_id '/docs/glossary/' %></li>
	<li><a href="<%= api_doc_root %>">API documentation</a></li>
    </ol>
<% end %>

How to use the documentation
----------------------------

The documentation for nanoc is organised in a couple of parts:

1. The [Tutorial](/docs/tutorial/) chapter is meant for first-time users of nanoc, who want to get an impression of what nanoc can do and how it’s done. After reading this part, you should be able to get a basic site up and running.

2. The [Basics](/docs/basics/) chapter describes how to use nanoc in great detail. Everything that nanoc can do, you will find in here.

3. The [Extending nanoc](/docs/extending-nanoc/) chapter shows how nanoc can be extended by writing custom helpers, filters, data sources and more. Medium-sized to large projects will certainly benefit from this chapter.

4. The [Guides](/docs/guides/) show in detail how specific things can be achieved with nanoc. Even if they are not relevant to you, they may be an interesting read in order to get a better idea of what the nanoc way is.

5. The [Reference](/docs/reference/) contains the reference documentation for filters, helpers and commands that nanoc supports out of the box.

6. The [Troubleshooting](/docs/troubleshooting/) section describes some frequent error messages, what causes them and how to solve them.

7. The [Glossary](/docs/glossary/) is a collection of terms that you may stumble upon while using nanoc or reading its documentation. If you don’t understand a term, go here!

8. The [API documentation](<%= api_doc_root %>) contains the documentation of nanoc’s internals. This is quite useful if you want to contribute to nanoc or extend it.

When you’re stuck with a question or a problem the documentation doesn’t solve, considering posting to the <a href="#">discussion group</a> or joining the <a href="irc://irc.freenode.net/#nanoc">nanoc IRC channel</a>. We’ll get it sorted out in no time. Check out the [Community](/community/) page for details.
