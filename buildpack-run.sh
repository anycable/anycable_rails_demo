# Download Litestream
wget https://github.com/benbjohnson/litestream/releases/download/v0.3.9/litestream-v0.3.9-linux-amd64-static.tar.gz

# Extract the archive
tar -xzf litestream-v0.3.9-linux-amd64-static.tar.gz

# Make the binary executable
chmod +x litestream

# Verify
./litestream version
