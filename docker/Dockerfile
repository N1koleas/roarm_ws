FROM ros:humble

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_WS=/opt/roarm_ws
ENV ROARM_MODEL=roarm_m3

# Install core ROS packages + build tools
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    python3-pip \
    ros-humble-desktop \
    ros-humble-moveit \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-generate-parameter-library \
    ros-humble-py-binding-tools \
    ros-humble-control-msgs \
    ros-humble-realtime-tools \
    ros-humble-xacro \
    ros-humble-joint-state-publisher-gui \
    python3-colcon-common-extensions \
    python3-rosdep \
    && pip3 install --no-cache-dir \
        pyserial \
        requests \
        pytest \
        flake8 \
        roarm-sdk==0.1.0 \
        simplejson \
    && rm -rf /var/lib/apt/lists/*

# Init rosdep
RUN rosdep init || true
RUN rosdep update

# Create workspace
RUN mkdir -p $ROS_WS/src
WORKDIR $ROS_WS

# Copy source code
COPY ../src/ $ROS_WS/src/

# Build base message package
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
    colcon build --packages-select roarm_msgs --symlink-install"

# Build intermediate packages that depend on roarm_msgs
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
    source install/setup.bash && \
    colcon build --packages-select moveit_servo rviz_marker_tools --symlink-install"

RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
    source install/setup.bash && \
    colcon build --packages-select moveit_task_constructor_msgs moveit_task_constructor_core moveit_task_constructor_capabilities moveit_task_constructor_visualization --symlink-install"

# Build roarm MoveIt packages
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
    source install/setup.bash && \
    colcon build --packages-select roarm_moveit_cmd roarm_moveit_ikfast_plugins roarm_moveit_mtc_demo roarm_moveit_servo --symlink-install"

# Build remaining meta packages
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
    source install/setup.bash && \
    colcon build --packages-select roarm_description roarm_driver roarm_moveit --symlink-install"

# Auto-source in container shell
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
RUN echo "source $ROS_WS/install/setup.bash" >> /root/.bashrc

# Copy run.sh into the container for easy model switching
COPY docker/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD ["bash", "-c", "source /opt/ros/humble/setup.bash && source /opt/roarm_ws/install/setup.bash && ros2 run roarm_driver roarm_driver --ros-args --remap serial_port:=/dev/ttyUSB0"]