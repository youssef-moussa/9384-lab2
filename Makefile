DIR = watched
MAL_DIR = quarantine
INTERVAL = 5
antivirus: prebuild
	./antivirusd.sh $(DIR) $(MAL_DIR) $(INTERVAL)

restore: prebuild
	./restore.sh $(DIR) $(MAL_DIR)

prebuild:
	mkdir -p $(MAL_DIR)
