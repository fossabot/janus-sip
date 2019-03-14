default_tag=latest
image_name=etherlabsio/janus-sip
build:
	@docker build --no-cache -t ${image_name}:${default_tag} .
	@docker push ${image_name}:${default_tag}

clean:
	@docker system prune -f
