
# coding: utf-8

# In[1]:


get_ipython().magic(u'matplotlib')
import numpy as np
import imageio as im
import matplotlib.pyplot as plt


# In[2]:


def rotation_matrix(axis, theta):
    """
    Return the rotation matrix associated with counterclockwise rotation about
    the given axis by theta radians.
    """
    axis = np.asarray(axis)
    axis = axis / np.sqrt(np.dot(axis, axis))
    a = np.cos(theta / 2.0)
    b, c, d = -axis * np.sin(theta / 2.0)
    aa, bb, cc, dd = a * a, b * b, c * c, d * d
    bc, ad, ac, ab, bd, cd = b * c, a * d, a * c, a * b, b * d, c * d
    return np.array([[aa + bb - cc - dd, 2 * (bc + ad), 2 * (bd - ac)],
                     [2 * (bc - ad), aa + cc - bb - dd, 2 * (cd + ab)],
                     [2 * (bd + ac), 2 * (cd - ab), aa + dd - bb - cc]])


# In[3]:


###### Parameters ######
width = 640
height = 480
FOV = 80 * np.pi / 180
#########################

img = im.imread('./cube2.jpg')
frame = img
frame_height = frame.shape[0]
frame_width = frame.shape[1]
frame_channel = frame.shape[2]
cubeFaceHeight = frame_height/3
cubeFaceWidth = frame_width/4


# In[4]:


xx, yy = np.meshgrid(np.arange(-np.rint(width / 2), np.rint(width / 2)), np.arange(np.rint(height / 2), -np.rint(height / 2), -1))
zz = -width / 2 / np.tan(FOV / 2) * np.ones(xx.shape)
screen_points = np.array([xx.ravel(), yy.ravel(), zz.ravel()]).T


# In[5]:


axis = np.random.random_sample(3)
fig = plt.figure(figsize=(12, 10), dpi= 80, facecolor='w', edgecolor='k')
ax = fig.add_subplot(111)
plt.ion()
plt.show()
for theta in np.linspace(0, 2*np.pi, 24):
    rotm = rotation_matrix(axis, theta)
    
    # Apply rotation
    rot_cc = np.dot(screen_points, rotm.T)
    
    # Compute axis along which each pixel primarily lies and normalize
    face_idx = np.argmax(np.abs(rot_cc), axis=1)
    a = np.abs(rot_cc[range(len(face_idx)), face_idx])
    rot_cc[:, 0] /= a
    rot_cc[:, 1] /= a
    rot_cc[:, 2] /= a
    
    xPixel = np.zeros((rot_cc.shape[0]))
    yPixel = np.zeros((rot_cc.shape[0]))
    for ii in range(rot_cc.shape[0]):
        if face_idx[ii] == 0:
            if rot_cc[ii, 0] > 0:
                # Right
                xPixel[ii] = (2 + (rot_cc[ii, 2] + 1) / 2) * cubeFaceWidth
                yPixel[ii] = (1 + (-rot_cc[ii, 1] + 1) / 2) * cubeFaceHeight
            else:
                # Left
                xPixel[ii] = (0 + (-rot_cc[ii, 2] + 1) / 2) * cubeFaceWidth
                yPixel[ii] = (1 + (-rot_cc[ii, 1] + 1) / 2) * cubeFaceHeight
        elif face_idx[ii] == 1:
            if rot_cc[ii, 1] > 0:
                # Top
                xPixel[ii] = (1 + (rot_cc[ii, 0] + 1) / 2) * cubeFaceWidth
                yPixel[ii] = (0 + (-rot_cc[ii, 2] + 1) / 2) * cubeFaceHeight
            else:
                # Bottom
                xPixel[ii] = (1 + (rot_cc[ii, 0] + 1) / 2) * cubeFaceWidth
                yPixel[ii] = (2 + (rot_cc[ii, 2] + 1) / 2) * cubeFaceHeight
        else:
            if rot_cc[ii, 2] > 0:
                # Back
                xPixel[ii] = (3 + (-rot_cc[ii, 0] + 1) / 2) * cubeFaceWidth
                yPixel[ii] = (1 + (-rot_cc[ii, 1] + 1) / 2) * cubeFaceHeight
            else:
                # Front
                xPixel[ii] = (1 + (rot_cc[ii, 0] + 1) / 2) * cubeFaceWidth
                yPixel[ii] = (1 + (-rot_cc[ii, 1] + 1) / 2) * cubeFaceHeight
    
    xPixel = xPixel.astype(int)
    yPixel = yPixel.astype(int)
    
    pix_cor = yPixel * frame_width + xPixel
    flat_img = np.reshape(frame, [-1, frame_channel])
    A = np.take(flat_img, pix_cor, axis=0)

    nfov = np.reshape(np.round(A).astype(np.uint8), [height, width, 3])
    img = ax.imshow(nfov)
    plt.draw()
    plt.pause(0.001)