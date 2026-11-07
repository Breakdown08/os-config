#!/bin/sh
# The bell: how many notifications mako holds and whether do-not-disturb is on.
count=$(makoctl list | grep -c '^Notification')
if makoctl mode | grep -qx do-not-disturb; then
  icon=󰂛 class=dnd
elif [ "$count" -gt 0 ]; then
  icon=󰂚 class=unread
else
  icon=󰂚 class=
fi
[ "$count" -gt 0 ] && text="$icon $count" || text=$icon
printf '{"text":"%s","class":"%s"}\n' "$text" "$class"
