FROM debian:testing-slim

RUN apt-get update
RUN apt-get install -y git vim curl sudo procps net-tools jq


##############
# Set up user
##############
ARG USERNAME=code
ARG USER_HOME=/home/$USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
WORKDIR /home/$USERNAME


#######################
# Install other tools
#######################
# SCM Breeze
RUN git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
RUN ~/.scm_breeze/install.sh


#######################
# Provide vim setup files under /home/code/install, leave it to the user to install
#######################
RUN mkdir ${USER_HOME}/install
COPY scripts/.vimrc ${USER_HOME}/install/.vimrc
COPY scripts/setup_vim.sh ${USER_HOME}/install/setup_vim.sh
COPY scripts/coc-settings.json ${USER_HOME}/install/coc-settings.json

# Command to run when container starts, overrideable
CMD ["/bin/bash"]
