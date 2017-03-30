#http://stackoverflow.com/questions/22081991/rmarkdown-pandoc-pdflatex-not-found
 pandoc -s -o b.pdf \
	--toc --toc-depth=2 \
	0.perface.md \
	1.startup.md \
	controller/1.intro.md \
	controller/AlertController.md \
	controller/NavigationController.md \
	controller/PageViewController.md\
	controller/TabBarController.md \
	view/1.intro.md \
	view/ActivityIndicatorView.md \
	view/CollectionView.md \
	view/ImageView.md \
	view/PickerView.md \
	view/ProgressView.md \
	view/ScrollView.md \
	view/SearchBar.md \
	view/TableView.md \
	view/textview.md \
	view/webview.md \
	layout/1.intro.md \
	layout/stackview.md \
	todoapp/1.intro.md \
	storage/1.intro.md \
	storage/sqlite.md \
	storage/coredata.md 
	
