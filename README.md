# Apache jclouds&reg;

DO NOT MERGE

This repository supports the GitHub Pages site for jclouds. See and read more at [http://www.jclouds.org](http://www.jclouds.org).

To test the site locally:

    jekyll _1.5.1_ serve --safe

To deploy the site:

* Ensure you have [jekyll](http://jekyllrb.com/docs/installation/) 1.5.1 installed: `gem install jekyll -v 1.5.1` (it will require an old Ruby such as 2.2.5)
* If necessary, clone this repository
* Run `sh ./deploy-site.sh [$uid] [$pwd]` from the repository root. Here, `$uid` is your ASF account ID and `$pwd` your ASF password. If you do not supply your account ID or password, you will be prompted for them

