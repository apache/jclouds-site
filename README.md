# Apache jclouds&reg;

This repository supports the GitHub Pages site for jclouds. See and read more at [https://www.jclouds.org](https://www.jclouds.org).

To test the site locally you will need to create the site build image with:

```bash
make image
```

Once you have the build image you can use the following command to build and test the site locally:

```bash
make build
```

To deploy the site and make it live run:

```bash
make publish
```
