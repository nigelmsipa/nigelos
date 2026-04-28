#!/bin/bash

# Get current volume
vol=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

# Create visual bar
bar_length=10
filled=$(( vol * bar_length / 100 ))
empty=$(( bar_length - filled ))

# Create bar characters
bar=""
for ((i=0; i<filled; i++)); do
    bar+="█"
done
for ((i=0; i<empty; i++)); do
    bar+="░"
done

# Output with icon
if [ "$muted" = "true" ]; then
    echo " $bar $vol%"
else
    echo " $bar $vol%"
fi
