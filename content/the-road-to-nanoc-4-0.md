---
title:      "The road to nanoc 4.0"
is_dynamic: true
---

<% content_for :details do %>
    <h3>The road to nanoc 4.0</h3>
    <p>Have feedback? Do let us know on the <a href="http://groups.google.com/group/nanoc">nanoc mailing list</a>!</p>
<% end %>

_Ghent, April 1st, 2013_

**Update**: April fools’ day. :)

Dear nanoc users,

Almost six years ago, the first nanoc release saw the light of day. It started out as a glorified Ruby script, but has since then evolved into a reliable application that has served many people well for years. I am proud of what I have achieved with nanoc, in no small part thanks to the many contributions I have received from the community. Many thanks to all of you!

In the past few months, I have received a significant amount of feedback for nanoc. This has been quite an enlightening experience to get to know the proper needs that you and other nanoc users have. Unfortunately, I reached a saddening conclusion: nanoc is not ready for Web 3.0. The reason became crystal clear pretty quickly: Ruby is not web scale.

I have been quite intrigued by [Hakyll](http://jaspervdj.be/hakyll/) lately. Like nanoc, Hakyll is a static site generator, but unlike nanoc, it is written in [Haskell](http://haskell.org/). It is written by [Jasper](http://jaspervdj.be/), who used to be a good friend before he started working on his own static site generator. That aside, Hakyll demonstrates that Haskell is a superior language that, unlike Ruby, _is_ web scale.

Because of this, I have decided that nanoc 4.0 will be rewritten in Haskell. This has not been an easy decision. After many discussions with key people in the nanoc community, the concensus was quite clear: Haskell is the road to the future.

At [FOSDEM 2013](https://fosdem.org/2013/), I gave a talk on static site generation, called [Static Site Generation For The Masses](https://fosdem.org/2013/schedule/event/static_site_generation_for_the_masses/). The goal of this presentation was to show people the power of SSGs and show that SSGs can be an excellent tool in many cases and for many people. I now believe, however, that I was misguided: the goal that I want to achieve is _not_ to build a static site generator to be used by the masses, but only _by the elite_. Haskell fits in nicely there.

So, how should you prepare for nanoc 4.0? First of all, you must decide for yourself whether you are smart enough to learn Haskell. If not, I recommend going back to [WordPress](http://wordpress.org/) or [Drupal](http://drupal.org/). If you are up to the task of learning Haskell, I recommend the book [Learn You A Haskell](http://learnyouahaskell.com/). This book is written by a six-year-old who mistakenly believes he can actually draw, but apart from that fact, the book is pretty good. Haskell is fairly easy to learn. If you are having a difficult time, please do not use nanoc. Oh, and remember that a monad is just a monoid in the category of endofunctors.

The next major version of nanoc has been in development for quite a while. We have opted for secrecy in order to prevent industrial espionage. Because of this, nanoc 4.0 will also not be open-source. Rest assured, though, that development is making significant progress and there will be a release in the next three months.

It is a very exciting time for all of us. Static site generation is being taken seriously by the general public, and nanoc is taking steps to distinguish itself from the rest of static site generators. Still, we are not quite there yet, but the future is bright, and we will get to our destination before anyone else.

See you in the future!

Denis Defreyne

