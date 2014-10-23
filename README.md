## Adaptive Thresholding, Segmentation and Experimenting with Robotic Arms






**Introduction**

In computer vision, image segmentation is the process of separating an image into multiple segments. This allows us to better analyze an image by viewing it in an easier representation than its original. One method used to segment an image is thresholding; that is to set all pixels whose intensity values are below a threshold as background values and the other pixels would be above the threshold would be set to foreground values. The simplest form of thresholding uses a global threshold for all pixels, while adaptive thresholding dynamically changes the threshold according to the pixel and its surroundings. Typically thresholding begins with a grayscale image and outputs a binary image to clearly depict the segments in the image. In this lab we developed an adaptive thresholding algorithm and compared it to its simpler counterpart. 

In addition, we developed the inverse kinematics proof to move the robotic arm to a given x, y, z coordinate. The proof involved trignometric identities and a better understanding of the robotic arm's design was acquired.













**1. Adaptive Thresholding**

In this first problem, we were tasked with developing an adaptive thresholding algorithm. First we created a planar image, It
, that would serve as our thresholding plane for the original image. 

![Image](../master/report/images/p1-1.jpg?raw=true)
Above we see distinctively better results in our algorithm as it clearly shows far background objects that are not captured by the simple thresholding algorithm.

![Image](../master/report/images/p1-2.jpg?raw=true)

Above we see our algorithm captures objects and omits small specks as opposed to the simple threshold.

![Image](../master/report/images/p1-3.jpg?raw=true)

Above we see our algorithm captures more branches/leaves of the tree.

![Image](../master/report/images/p1-4.jpg?raw=true)
![Image](../master/report/images/p1-5.jpg?raw=true)
![Image](../master/report/images/p1-6.jpg?raw=true)
It can be concluded that adaptive thresholding does not always perform better than simple global thresholding. Typically, good results are when the image is under varying light conditions and when the background is non-uniform.

To improve our results, we tested a localized approach of the adaptive algorithm, which broke the image into sub images and determined localized planar images; this did not render a drastic improvement in results. It is important to note that, while this approach may lead to increased quality of segmentation; it comes at the cost of time- since we would need to increase the amount of sub images proportionally.











**2. Playing with the Robot**

In this problem we were tasked with using inverse kinematics to move the robotic arm. The idea is that we are given the length of each link (10 inches) and the position of some point in 3D space and we must find the angles of each joint needed to obtain that position. It is important to note that since we are dealing with 3 joints, there are a lot of possible solutions. In fact, for every solution ∅3, there is a unique ∅2 and ∅1. To solve this problem, we must derive the equations for ∅1, ∅2, ∅3:



**Conclusion**

We have demonstrated just a glimpse of the wide range of applications and capabilities of basic computer vision methods. Namely, adaptive thresholding which can be used to reliably segment an image to show objects and features distinctly. We have also explored a more localized approach that improved results proportional to its time complexity. This approach is likely not to be used in a real-time application context. Overall, we have also demonstrated that the simple global thresholding algorithm still holds its own in simple images with uniform backgrounds.

Using trigonometric identities and inverse kinematics principles, we developed a program that moves the robotic arm to a given 3D space coordinate. Although the proof was somewhat trivial, moving from the theoretical values to arm adaptation was not. Since the robotic arm took in five angle values for its; waist, shoulder, elbow, wrist and twist, some additional arithmetic and further understanding of the arm's orientation was needed. All in all, the lab was satisfying at the end however the difficulty.

**User Manual**

All implementations were done using MATLAB 2013.

**1. Adaptive Thresholding**

Open p1.m and run it.

**2. Playing with the Robot**

Run p2.m, providing an X, Y, Z coordinate and an A150 instance.

**References**

"Adaptive Thresholding." Point Operations -. N.p., n.d. Web. 19 Oct. 2014.

"Thresholding (image Processing)." Wikipedia. Wikimedia Foundation, 19 Oct. 2014. Web. 19 Oct. 2014.
