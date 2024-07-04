# docker build -t atomie/pytorch-tzdata-ssh:2.2.2-cuda11.8-cudnn8-runtime-hdbscan -f 2.2.2-cuda11.8-cudnn8-runtime-hdbscan.dockerfile .

FROM atomie/pytorch-tzdata-ssh:2.2.2-cuda11.8-cudnn8-runtime

# install hdbscan
RUN conda install -y -c conda-forge hdbscan \
    && conda clean -y -a -f

