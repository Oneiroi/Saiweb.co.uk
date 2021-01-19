find . -type f -iname "*.md" -exec sed -i '' -e '/layout: post/d' {} \;
find . -type f -iname "*.md" -exec sed -i '' -e '/comments: true/d' {} \;
find . -type f -iname "*.md" -exec sed -i '' -e 's/^categories:/tags:/' {} \;
find . -type f -iname "*.md" -exec sed -i '' -e 's/<!-- more -->/<!--more-->/' {} \;
