.DELETE_ON_ERROR:
.SECONDARY:

all: linkage-map-slides.html

clean:
	rm -f linkage-map-slides.html

# Deploy the slides to GitHub Pages.
deploy: linkage-map-slides.html
	git checkout -B gh-pages
	cp $< index.html
	git add index.html
	git commit -m 'Add index.html'
	git push --force
	git checkout master

# Install dependencies.
install-deps:
	brew install pandoc

# Create the HTML slides.
%.html: %.md reveal.js/js/reveal.js
	pandoc -st revealjs -V theme:sky -o $@ $<

# Create the self-contained HTML slides.
%-self-contained.html: %.md reveal.js/js/reveal.js
	pandoc -st revealjs -V theme:sky --self-contained -o $@ $<

# Download reveal.js
revealjs-3.7.0.tar.gz:
	curl -L -o $@ https://github.com/hakimel/reveal.js/archive/3.7.0.tar.gz

# Extract reveal.js
reveal.js-3.7.0/js/reveal.js: revealjs-3.7.0.tar.gz
	tar xf $<
	touch $@

# Patch reveal.js
reveal.js/js/reveal.js: reveal.js-3.7.0/js/reveal.js
	cp -a reveal.js-3.7.0 reveal.js
	sed -i .orig \
		-e 's/text-transform: uppercase;//' \
		-e 's/font-size: 40px;/font-size: 34px;/' \
		-e 's/border: 4px solid #333;/border: 2px solid #333;/' \
		reveal.js/css/theme/sky.css
	touch $@
