FROM researchit/shiny-server:openshift
LABEL maintainer="Levi Baber <baber@iastate.edu>"


ENV \
    # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    # Path to be used in other layers to place s2i scripts into
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    APP_ROOT=/opt/app-root \
    # The $HOME is not set by default, but some applications needs this variable
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH

USER 0
#system dependencies for R packages
RUN yum -y install libxml2-devel libcurl-devel openssl-devel v8-devel

#R dependencies for TissueEnrich 
RUN Rscript -e "install.packages(c('DT', 'tidyverse', 'shinythemes', 'plotly', 'shinyjs', 'rsconnect', 'shinycssloaders', 'V8', 'sqldf'), repos='https://cran.rstudio.com/')" 
RUN sed -i -e 's/run_as 1001;/run_as undefined;/g' /etc/shiny-server/shiny-server.conf; 

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

USER 1001
