FROM researchit/shiny-server:openshift
LABEL maintainer="Levi Baber <baber@iastate.edu>"


USER 0
#system dependencies for R packages
RUN yum -y install libxml2-devel libcurl-devel openssl-devel v8-devel

#R dependencies for TissueEnrich 
RUN Rscript -e "install.packages(c('DT', 'tidyverse', 'shinythemes', 'plotly', 'shinyjs', 'rsconnect', 'shinycssloaders', 'V8', 'sqldf'), repos='https://cran.rstudio.com/')" 

USER 1001
