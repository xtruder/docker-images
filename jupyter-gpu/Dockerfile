ARG UBUNTU_VERSION=20.04
ARG CUDA_VERSION=11.3.1
ARG CUDA=11.3
ARG CUDNN_VERSION=8

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-ubuntu${UBUNTU_VERSION}
LABEL maintainer "Jaka Hudoklin <jaka@x-truder.net>"

SHELL ["/bin/bash", "-c"]
ENV LANG C.UTF-8

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        sudo \
        ssh \
        unzip \
        build-essential \
        git \
        vim && \
    rm -rf /var/lib/apt/lists/*

# For CUDA profiling
ENV LD_LIBRARY_PATH /usr/local/cuda-${CUDA}/targets/x86_64-linux/lib:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
    echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf && \
    ldconfig

# create non-root user and group and add it sudoers
ARG USERNAME=code
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# install micromamba
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
RUN mkdir -p /opt/micromamba && chown $USERNAME:$USERNAME /opt/micromamba 
ENV MAMBA_ROOT_PREFIX=/opt/micromamba

# set user and working directory
USER $USERNAME
WORKDIR /home/${USERNAME}

# install micromamba .bashrc hook
RUN micromamba shell init -s bash -p /opt/micromamba

# Create the micromamba environment
ADD environment.yml /opt/micromamba/environment.yml
RUN micromamba create -f /opt/micromamba/environment.yml
ENV PATH=/opt/micromamba/envs/jupyter/bin:$PATH

# enable jupyter server extensions
RUN jupyter server extension enable --py --sys-prefix jupyterlab jupyterlab_github

# install jupyter-lab extensions
RUN jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager \
        plotlywidget \
        jupyter-leaflet \
        @mamba-org/gator-lab

# copy jupyter server configuration
COPY jupyter_server_config.py /etc/jupyter/

# run jupyter-hub in singleuser mode by default
CMD ["jupyterhub-singleuser", "--ip=0.0.0.0"]

# Install pytorch
#RUN source activate ${CONDA_ENV_NAME} && \
#    conda install --yes pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch

# Install tensorflow
#ARG TF_VERSION=2.11.0
#RUN source activate ${CONDA_ENV_NAME} && \
#    python -m pip install --no-cache-dir tensorflow-gpu==${TF_VERSION} tensorboard==${TF_VERSION}
