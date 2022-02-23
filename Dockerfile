FROM alpine:3.15.0
LABEL maintainer="Hugo Blom <hugo.blom1@gmail.com>"

# Dependencies
RUN apk --no-cache add curl=7.80.0-r0 vlc=3.0.16-r3	ffmpeg=4.4.1-r2 tzdata=2021e-r0	bash=5.1.16-r0

# Remove APK cache
RUN rm -rf /var/cache/apk/*

# Add xteve binary
ADD https://github.com/xteve-project/xTeVe-Downloads/blob/master/xteve_linux_amd64.tar.gz?raw=true /tmp/xteve_linux_amd64.tar.gz

# Unzip the Binary
RUN mkdir -p /xteve
RUN tar -xvf /tmp/xteve_linux_amd64.tar.gz --directory /xteve

# Clean up the .zip
RUN rm /tmp/xteve_linux_amd64.tar.gz

# Add user for VLC and ffmpeg
RUN addgroup --gid 65000 -S xteve && adduser --uid 65000 -S xteve -G xteve

# Set executable permissions
RUN chmod +x /xteve/xteve
RUN chown xteve:xteve /xteve/xteve

# Set user contexts
USER xteve

#Create folder structure for backups and tmp files
RUN mkdir /home/xteve/.xteve/
RUN mkdir /home/xteve/.xteve/backup/
RUN mkdir /tmp/xteve

#Set Permission on folders
RUN chown xteve:xteve /home/xteve/.xteve/
RUN chown xteve:xteve /home/xteve/.xteve/backup/
RUN chown xteve:xteve /tmp/xteve

# Volumes
VOLUME /home/xteve/.xteve

# Expose Ports for Access
EXPOSE 34400

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --retries=3 --timeout=10s \
  CMD curl -f http://localhost:34400/ || exit 1

# Entrypoint should be the base command
ENTRYPOINT ["/xteve/xteve"]

# Command should be the basic working
CMD ["-port=34400"]
