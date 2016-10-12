generate:
	bundle exec rake generate

cloudfiles:
	cd public && \
	swift -A https://auth.api.rackspacecloud.com/v1.0 -U $CF_USER -K $CF_API_KEY upload -c $CF_CONTAINER ./
