# frozen_string_literal: true

module Kuby
  module AnyCable
    class Packages < Kuby::Docker::Packages::Package
      def install_on_debian(_dockerfile)
        # nothing specific
      end

      def install_on_alpine(dockerfile)
        dockerfile.run("apk add --no-cache --update libc6-compat")
        dockerfile.run("ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2")

        if lockfile
          protobuf_version = lockfile.specs.detect { |spec| spec.name == "google-protobuf" }&.version
          dockerfile.run("gem install --platform ruby google-protobuf -v '#{protobuf_version}' -N") if protobuf_version

          grpc_version = lockfile.specs.detect { |spec| spec.name == "grpc" }&.version
          dockerfile.run("gem install --platform ruby grpc -v '#{grpc_version}' -N --ignore-dependencies && rm -rf /usr/local/bundle/gems/grpc-#{grpc_version}/src/ruby/ext") if grpc_version
        end
      end

      private

      def lockfile
        return @lockfile if instance_variable_defined?(:@lockfile)

        @lockfile =
          if File.file?("./Gemfile.lock")
            Bundler::LockfileParser.new(Bundler.read_file("./Gemfile.lock"))
          end
      end
    end
  end
end
