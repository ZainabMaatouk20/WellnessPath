import matplotlib.pyplot as plt
from matplotlib.patches import PathPatch
from matplotlib.path import Path

# Create figure
fig, ax = plt.subplots(figsize=(6, 6), dpi=100)

# Draw a path (curve)
verts = [
    (0.1, 0.1),  # Start
    (0.4, 0.6),  # Control point 1
    (0.8, 0.3),  # Control point 2
    (1.0, 0.9)   # End
]
codes = [Path.MOVETO, Path.CURVE3, Path.CURVE3, Path.LINETO]
path = Path(verts, codes)
patch = PathPatch(path, facecolor='none', edgecolor='#4CAF50', lw=3)
ax.add_patch(patch)

# Add circles
circle1 = plt.Circle((0.1, 0.1), 0.05, color='#FF9800', fill=True)
circle2 = plt.Circle((1.0, 0.9), 0.07, color='#4CAF50', fill=True)
ax.add_artist(circle1)
ax.add_artist(circle2)

# Add text
ax.text(0.5, -0.1, 'WellnessPath', fontsize=20, color='#4CAF50', ha='center', family='Roboto', fontweight='bold')

# Styling
ax.set_xlim(-0.1, 1.1)
ax.set_ylim(-0.1, 1.1)
ax.axis('off')  # Hide axes

# Save the logo
plt.savefig('wellnesspath_logo.png', transparent=True)
plt.show()
