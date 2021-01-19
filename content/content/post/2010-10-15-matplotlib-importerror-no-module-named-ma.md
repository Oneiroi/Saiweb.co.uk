---
date: "2010-10-15T15:07:12Z"
tags:
- mac
- python
title: 'matplotlib ImportError: No module named ma'
wordpress_id: 968
wordpress_url: https://blog.oneiroi.co.uk/mac/matplotlib-importerror-no-module-named-ma
---
ImportError: No module named ma

Fix is to edit the following files:

{{< highlight bash >}}sudo vi /Library/Python/2.6/site-packages/matplotlib-0.91.1-py2.6-macosx-10.6-universal.egg/matplotlib/numerix/ma/__init__.py
sudo vi /Library/Python/2.6/site-packages/matplotlib-0.91.1-py2.6-macosx-10.6-universal.egg/matplotlib/numerix/npyma/__init__.py{{< / highlight >}}

On my installed on lines 16 and 7 respectively replace


{{< highlight python >}}
from numpy.core.ma import *
{{< / highlight >}}

with

{{< highlight python >}}
from numpy.ma import *
{{< / highlight >}}

and done.
