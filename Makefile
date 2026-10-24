test: clean
	hugo server --source=exampleSite 
	# --themesDir=../..

build:
	hugo --source=exampleSite 
	# --themesDir=../..

clean:
	# macOS/GDrive junk (Icon?/ .DS_Store), including inside .git/
	./scripts/clean-gdrive-junk.sh

# Clean junk then show status (use when git looks broken on GDrive)
gitclean: clean
	git status -sb


