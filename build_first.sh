#!/bin/bash
set -e  # exit on any error

WORKSPACE_DIR=$(pwd)

# source existing setup if available
if [ -f "$WORKSPACE_DIR/install/setup.bash" ]; then
    source "$WORKSPACE_DIR/install/setup.bash"
fi

# build base package first
colcon build --packages-select roarm_msgs --symlink-install

grep -qxF "source ~/roarm_ws/install/setup.bash" ~/.bashrc || echo "source ~/roarm_ws/install/setup.bash" >> ~/.bashrc
source "$WORKSPACE_DIR/install/setup.bash"

# build packages that depend on it
colcon build --packages-select moveit_servo rviz_marker_tools --symlink-install
colcon build --packages-select moveit_task_constructor_msgs moveit_task_constructor_core moveit_task_constructor_capabilities moveit_task_constructor_visualization --symlink-install
source "$WORKSPACE_DIR/install/setup.bash"

# build roarm MoveIt packages
colcon build --packages-select roarm_moveit_cmd roarm_moveit_ikfast_plugins roarm_moveit_mtc_demo roarm_moveit_servo --symlink-install
source "$WORKSPACE_DIR/install/setup.bash"

# build remaining meta packages
colcon build --packages-select roarm_description roarm_driver roarm_moveit --symlink-install

# final source so your terminal is ready
source "$WORKSPACE_DIR/install/setup.bash"

echo "Workspace built successfully!"