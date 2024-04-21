FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates

# Extras
RUN apk add --no-cache curl

# Timezone (TZ)
RUN apk update && apk add --no-cache tzdata
ENV TZ=US/Eastern
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec

#Set Slinger env variables
ENV SLINGER_CONF=/config
ENV SLINGER_APP=/usr/src/app
ENV PIP_BREAK_SYSTEM_PACKAGES 1

#Add Slinger dependancies
RUN apk add py3-pip
RUN apk add py3-netifaces
RUN pip3 install --upgrade pip
RUN pip3 install flask

# Download the source code, not using to keep size of image down
#RUN apk add --no-cache git
#RUN git clone https://github.com/crhiles/Slinger2.git $SLINGER_APP
COPY . $SLINGER_APP
WORKDIR $SLINGER_APP

# Create working directories for Slinger
RUN mkdir $SLINGER_CONF
RUN chmod a+rwX $SLINGER_CONF

# Configure container volume mappings
VOLUME $SLINGER_CONF

# Set executable permissions
RUN chmod +x entrypoint.sh

#default port in slinger config
EXPOSE 65432

# Entrypoint
ENTRYPOINT ["./entrypoint.sh"]
