extends Node

# This is for event manage
# Event usually happened when:
# 1. one wave finished
# 2. enemy was killed
# 3. player upgrade
# 4. skill point upgrade
signal story_triggered(storyName: String)
signal skill_triggered(skillName: String)	
signal level_triggered(level: int)
