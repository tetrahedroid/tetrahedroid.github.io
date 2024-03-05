test: clean
	hugo server --source=exampleSite 
	# --themesDir=../..

build:
	hugo --source=exampleSite 
	# --themesDir=../..

clean:
	find . -name Icon\* | xargs rm


