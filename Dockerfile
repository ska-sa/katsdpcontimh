ARG KATSDPDOCKERBASE_REGISTRY=quay.io/ska-sa

FROM $KATSDPDOCKERBASE_REGISTRY/docker-base-build as build

USER root
RUN apt-get update && \
    apt-get install -y gnome-todo && \

# IDG
RUN apt-get install -y libblas-dev liblapack-dev libboost-dev libcfitsio-dev libgsl-dev wcslib-dev casacore-dev git
RUN git clone https://gitlab.com/astron-idg/idg.git && cd idg


# EveryBeam
RUN apt-get -y install wget git make cmake g++ doxygen \
    libboost-all-dev libhdf5-dev libfftw3-dev \
    libblas-dev liblapack-dev libgsl-dev libxml2-dev \
    libgtkmm-3.0-dev libpython3-dev python3-distutils && \
    git clone git@git.astron.nl:RD/EveryBeam.git && cd EveryBeam && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX= .. && \
    make install
    

# WSClean
RUN apt-get install -y libfftw4-dev fftw4-dev libblas-dev liblapack-dev libboost-dev libcfitsio-dev libgsl-dev casacore-dev && \
    wget -c https://gitlab.com/aroffringa/wsclean/-/archive/v3.0/wsclean-v3.0.tar.bz2 && \
    bzip2 -d wsclean-v3.0.tar.bz2 && \
    tar -xf wsclean-v3.0.tar && \
    cd wsclean-v3.0 && \
    mkdir build && cd build && \
    cmake .. && \
    make && make install

# Switch to Python 3 environment
USER kat
ENV PATH="$PATH_PYTHON3" VIRTUAL_ENV="$VIRTUAL_ENV_PYTHON3"

# Install dependencies
COPY --chown=kat:kat requirements.txt /tmp/install/requirements.txt
RUN pip install --upgrade pip && \
    install_pinned.py -r /tmp/install/requirements.txt

# Install the current package
COPY --chown=kat:kat . /tmp/install/katsdpcontimh
WORKDIR /tmp/install/katsdpcontimh
RUN python ./setup.py clean
RUN pip install --no-deps .
#RUN pip check

#######################################################################

FROM $KATSDPDOCKERBASE_REGISTRY/docker-base-runtime
LABEL maintainer="sdpdev+katsdpcontimh@ska.ac.za"

COPY --from=build --chown=kat:kat /home/kat/ve3 /home/kat/ve3
ENV PATH="$PATH_PYTHON3" VIRTUAL_ENV="$VIRTUAL_ENV_PYTHON3"
