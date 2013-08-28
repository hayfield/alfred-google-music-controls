workflow:
	./builder
	ditto	-ck	--rsrc	--sequesterRsrc	'buildDir'	"Google Music Controls.alfredworkflow"

raw:
	ditto	-ck	--rsrc	--sequesterRsrc	'./src/workflow/'	"Google Music Controls.alfredworkflow"
