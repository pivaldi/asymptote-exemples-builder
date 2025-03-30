# The Asymptote Exemples Builder

This project provides a set of `bash` commands to export the
[Asymptote Examples](https://github.com/pivaldi/asymptote-exemples)
to various format like `html`, `markdown` for
[The Hexo Blog Framework](https://hexo.io/docs/) and pdf (TODO).

## Dependencies

This project is only for `Gnu Linux` users and need these softwares
properly installed :

- [Asymptote](https://asymptote.sourceforge.io/)
- [Gnu Make](https://www.gnu.org/software/make/)
- The Python syntax highlighter [Pygments](https://pygments.org/)
- [xsltproc](http://xmlsoft.org/xslt/xsltproc.html)
- [ImageMagick](https://imagemagick.org/index.php)
- [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
- [pdfinfo](https://www.xpdfreader.com/pdfinfo-man.html) (`apt install poppler-utils` on Debian)
- [FFmpeg](https://www.ffmpeg.org/) (`apt install ffmpeg` on Debian)

## Usage

The first think to do is to launch the command `./configure` and answer to the questions.

Next, you can use the make commands :
- `make html` to generate in `./build/html/` all the `html` files needed to browse the
  Asymptote Example Codes base.  
  The entry point is `./build/html/index.html`, to be opened with your favorite html browser.
- `make md-hexo` to generate the `markdown` files for Hexo with individual posts,
  specific topics pages, specific categories pages and specific tags pages.  
  After-wise, you can synchronize the directories `build/md/hexo/page/` to your
  Hexo `source/asymptote` directory and `build/md/hexo/post/` to your Hexo
  `source/_posts` directory or something like that.
- `make help` gives you some helps for all commands available in the `Makefile`.


# If you appreciate this project

[☕ Buy Me a Coffee](https://buymeacoffee.com/pivaldi).
