---
title: How I use Pandoc to create programming eBooks
date: '2021-01-21'
excerpt: >-
  Here is the story of how I built my eBooks, especially the last one. After
  some trial and errors, in the end, I used the same recipe as the two previous
  ones, and it involves a fantastic tool: Pandoc.
cover: /assets/posts/how-i-use-pandoc-to-create-my-programming-ebooks/cover.jpg
lang: en
tags:
  - dev
---

In the past four years, I wrote three eBooks about programming. It’s like an addiction.

I would be terrible at talking about writing techniques, so I won’t. But the content is not everything when you write an eBook. You have to care about creating **beautiful files to release**: PDF, ePub, Kindle…

Here is the story of how I built my eBooks, especially [the last one](https://gum.co/use-hooks). After some trial and errors, in the end, I used the same recipe as the two previous ones, and it involves a fantastic tool: **Pandoc**.

_Note: since I wrote this post, I converted all by book content to an interactive course, solving some of the questions I asked myself in the conclusion. Check out the course at [useEffect.dev](https://useeffect.dev/?ref=PandocPost)._

## Give me a beautiful PDF…

I wanted my last eBook to be a practical guide, not an academic manual. So I imagined a very **custom design**, with a **dark theme** and many colors (it is not designed to be printed).

Since it was about coding, I also wanted to include some source code examples with **syntax highlighting**.

Bust most of all, I wanted an efficient workflow.

## … with an efficient workflow (please)

I intended to release a first version of the book ASAP, then iterate thanks to readers’ feedback and new ideas I had. For this reason, I wanted to focus on the content and on the appearance **independently**.

![The workflow I didn’t want vs. the one I wanted.](/assets/posts/how-i-use-pandoc-to-create-my-programming-ebooks/workflow.png)

I didn’t want to spend time on the presentation each time I updated the content. I’m a web developer; it wouldn’t occur to me to edit my CSS each time I update the HTML content. Same here.

## My first try with mainstream tools

I thought: why not just use **MS Word** or its Apple version, **Pages**? Well, I tried. It didn’t go well.

You can customize pretty much everything you want. Every color, font family, font size… But it gets trickier when you want to include source code.

Since I wanted to have syntax highlighting, the _less bad_ solution I found was to copy and paste from VS Code. At first, it looked (kind of) okay, but as soon as I wanted to modify it, it went terribly: the formatting was lost, spaces were inserted where I didn’t want them…

Definitely, these tools are not made to write content with embedded source code.

I also tried **Illustrator** and its open-source alternative, [**Scribus**](https://www.scribus.net/).

It was worse.

I admire people able to use these applications. They seem to require a lot of training and practice. Unfortunately, I intended to release my book in the next two years, so I didn’t have time to learn them. 😉

> I’m used to writing content using **Markdown**. Or in **Slack**. Or in **Notion** (for this blog post). Today, we have such perfect tools for writing. I didn’t want to struggle each time I update some examples.

So, in the end, I relied on the tool I used for my previous books: **Pandoc**.

## The never-disappointing Pandoc

[Pandoc](https://pandoc.org/) is a command-line tool whose main feature is converting some text (usually Markdown) to another format: HTML, ePub, PDF, etc.

I used it for my other books, and it’s perfect for “academic” work (thesis, research articles). But I wasn’t sure that creating something a bit more original, with shiny colors and such, was possible.

<center>
<blockquote class="twitter-tweet" data-conversation="none" data-dnt="true"><p lang="en" dir="ltr">I spent around 5 hours to write the content, and lost the same amount of time looking for a publishing software or Saas to generate beautiful PDF for developer-oriented content, with source code. The winner ended being the good old Pandoc 😅</p>&mdash; Sébastien Castiel (@scastiel) <a href="https://twitter.com/scastiel/status/1338477555272331265?ref_src=twsrc%5Etfw">December 14, 2020</a></blockquote>
</center>

To write the content, I could now write using Markdown, with the basic formatting options I needed: titles, italic, source code… And the source code was highlighted!

By the way, syntax highlighting is themeable, and I really wanted to use [Dracula](https://draculatheme.com/), which I already used for my VSCode. So I created [a custom theme](https://gist.github.com/scastiel/4c409156ad4bc6a6dbbfe2abbd163671#file-dracula-theme) for it. 🙂

![](/assets/posts/how-i-use-pandoc-to-create-my-programming-ebooks/source-code.png)

The only thing I find problematic with Pandoc is [its documentation](https://pandoc.org/MANUAL.html). It contains a lot of information, but it’s on one page.

One page!

So you scroll, then scroll, and scroll again. And when you want to find something, you do Cmd/Ctrl+F, type “color”, oh cool, there is something. Then you realize you’re in the section concerning the generation of some obscure and unknown document format…

Anyway, you can usually find what you’re looking for. I’d just prefer if it used something more modern, such as Gitbook or Docusaurus, to maintain the documentation and make it easier to navigate.

![An overview of how I used Pandoc to generate PDF, ePub, and mobi files.](/assets/posts/how-i-use-pandoc-to-create-my-programming-ebooks/pandoc.png)

Pandoc is very good at generating HTML or an ePub file. You can give it some CSS to customize anything you want. It would be a dream if you were able to do the same to generate a customized PDF.

Unfortunately, it is slightly more complicated…

## The tricky LaTeX customization

To generate PDFs, Pandoc uses _pdflatex_, which relies on **[LaTeX](https://www.latex-project.org/)**. The LaTeX language is used to write documents with a powerful but unusual syntax. These documents are then converted to PDF, Postscript, etc.

So, a little like Pandoc. But with a weird syntax instead of beautiful Markdown.

Long story short, if you want to customize the PDF rendered by Pandoc with _pdflatex_, you don’t have a choice: you need to provide some LaTeX code, a bit like CSS.

And I didn’t want to spend several months learning LaTeX—it’s truly fantastic, you can do anything you want with it. So I did what every good developer hates doing: search on Google and copy-paste pieces of code.

Here is, for example, how I managed to have the book title in the page footer: (sorry if you are a LaTeX guru, it probably will hurt your eyes)

```latex
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\lfoot{
  \begin{tikzpicture}[overlay,baseline={(0,0)}]
  \node[rectangle, outer sep=0pt, text=white, anchor=west ]
    (pageno)
    {A React Developer’s Guide to Hooks, © Sebastien Castiel};
  \draw[fill=comment, draw=comment]
    ([xshift=-\oddsidemargin-1in]pageno.north west)
      rectangle
    ([yshift=1.5pt]pageno.south east);
  \end{tikzpicture}
}
```

Well, to be fair, it would have been much more straightforward if I just wanted the book title. But I wanted it in an indigo rectangle starting from the far left of the page.

![The page footer is not that easy to obtain using LaTeX customization…](/assets/posts/how-i-use-pandoc-to-create-my-programming-ebooks/footer.png)

Still, most of the time, I was able to get what I wanted. It just took more time than I wanted to spend on it.

_You can find here [the complete LaTeX header file](https://gist.github.com/scastiel/4c409156ad4bc6a6dbbfe2abbd163671#file-header-tex) I used for my book. I cleaned it a little and added some comments._

Although I didn’t interact with them, I’m sure the LaTeX community is fantastic because you can find many resources on the Internet: answers on forums, tutorials, manuals, etc.

## Polishing the workflow with a Makefile

I think the last time I used the [GNU make](https://www.gnu.org/software/make/manual/make.html) utility was like ten years ago. I had this idea that it was only used by C or C++ projects.

If you never heard of **GNU make**, it’s a utility program to run specific commands to generate files. It’s mostly used to compile and build programs, but you can use it for any command.

My first intuition was to write a shell script to generate my book in several formats. Quickly, I realized a **Makefile** would make more sense:

- I had _content_ files and _resource_ files (images, the LaTeX header, for example)
- I needed to generate intermediate files, such as the cover as a PDF from a PNG
- Some formats (ePub) were used to create other formats (Kindle)

Using a Makefile, I regenerated only the needed parts, based on which files were updated since the latest build. I could run `make pdf`, `make epub`, `make mobi`, or just `make` to generate all formats.

Here is the portion of my Makefile used to generate the _ePub_ and _mobi_ (Kindle) files:

```makefile
BOOK_TITLE = A\ React\ Developer’s\ Guide\ to\ Hooks\ -\ Sebastien\ Castiel

epub: dist/${BOOK_TITLE}.epub
  @echo '✅  ePub'

kindle: dist/${BOOK_TITLE}.mobi
  @echo ‘✅  Kindle’

dist/${BOOK_TITLE}.epub: dist content/*.md images/* resources/dracula.theme resources/metadata.xml resources/epub.css
  @pandoc content/foreword.md content/ch*.md content/resources.md \
  --output=dist/${BOOK_TITLE}.epub \
  --highlight-style resources/dracula.theme \
  --standalone \
  --epub-metadata=resources/metadata.xml \
  -c resources/epub.css \
  --epub-cover-image=cover.png \
  --toc --toc-depth=1 \
  --metadata title="A React Developer’s Guide to Hooks"

dist/${BOOK_TITLE}.mobi: dist/${BOOK_TITLE}.epub
  @kindlegen dist/${BOOK_TITLE}.epub -o ${BOOK_TITLE}.mobi >/dev/null 2>&1
```

Okay, maybe slightly overkill for my needs, but I felt so powerful! 💪🏻

_You can find [here the complete Makefile](https://gist.github.com/scastiel/4c409156ad4bc6a6dbbfe2abbd163671#file-makefile) for my book._

## What about the cover or the examples?

I embedded the examples’ source code in a small **React** application to run them locally. The user can start it by running `yarn start` and navigate easily through them.

Now, I feel a bit silly not to have thought of using [Storybook](https://storybook.js.org/), which could have been a perfect solution.

![The mini-app to run examples.](/assets/posts/how-i-use-pandoc-to-create-my-programming-ebooks/examples.png)

I created the cover using Apple Pages, sufficient for what I wanted to do. I should ~~probably~~ definitely hire someone to create a more professional one.

![Designing the cover in Pages.](/assets/posts/how-i-use-pandoc-to-create-my-programming-ebooks/pages.png)

I often design graphics using **[Inkscape](https://inkscape.org/)** (for example, the banner for the [Gumroad page](https://gum.co/use-hooks)), even if at the end I manipulate and generate bitmap images. I know it’s not its first purpose, but I find it easier to use than Gimp or commercial alternatives.

If you know a better choice, please please please tell me!

## What I have to do better

From the beginning, I really wanted a custom presentation with a dark theme.

Now, I realize this wish took me a lot of extra time. And I would have preferred spending that time on the content. Plus, I don’t know if the readers actually like this theme or not…

Also, it may have been better to focus first on the **web support**. [Docusaurus](https://v2.docusaurus.io/) could do an excellent job: readers could navigate the sections, search for keywords, etc.

The PDF or ePub version would be secondary content: available, but maybe with a generic appearance. So what?

> In the end, if the user finds the content useful, shouldn’t it be all that matters?

I will probably consider this change soon. Plus, I’d like to create a **course** (without video) from the book’s content…

Regarding the workflow with Pandoc, I’m quite satisfied with it. Writing using Markdown is lovely to focus on the content without caring how it will render. And since Markdown is text, it’s easy to keep track of the history using Git. 🙂

<center>
<blockquote class="twitter-tweet" data-conversation="none" data-dnt="true"><p lang="en" dir="ltr">It takes some time to set it up, especially to get the rendering you have in mind. But once it’s done, the workflow is perfect: write in Markdown, focusing on the content, run your build command, and done!</p>&mdash; Sébastien Castiel (@scastiel) <a href="https://twitter.com/scastiel/status/1338477556614516736?ref_src=twsrc%5Etfw">December 14, 2020</a></blockquote>
</center>

As I wanted, I spent time working on the appearance, time focusing on the content, but both independently. I can’t imagine what it would have been if I used MS Word.

A nightmare, for sure. 😅

## What about you?

Did you publish eBooks? Which tools did you use? What was your workflow?

I can’t wait to hear about it!

[Mention me on Twitter](https://twitter.com/scastiel) to share your thoughts!

<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
