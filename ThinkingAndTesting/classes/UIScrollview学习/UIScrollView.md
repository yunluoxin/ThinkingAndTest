**在刚开始时候，viewWillAppear之前**

1.self.automaticallyAdjustsScrollViewInsets = YES
则系统会自动给scrollView的contentInset设置contentInset.top=64，并且contentOffset=-64, （其实是在当前的top的基础上+64，原来如果是20，现在就是top=84,相应的contentOffset=-84）

2.self.automaticallyAdjustsScrollViewInsets = NO时候，则系统不会添加，但是如果自己设置了contentOffset.top,则系统会帮你自动移动到contentOffset=-top位置

3. 在打开自动调节inset时候，把导航栏隐藏，则系统自动叠加的top变成20，说明系统是根据当前是否有状态栏，导航栏，来判断是否应该调整，调整多少！

4. 在scrollView同级view上，，添加一个View，scrollview并不会因此而调整offset或者inset,之前的规律，该怎么调整怎么调整。

5. 若在scrollView之前，已经有同级的view添加到了父view上，则系统不会自动调整scrollView的inset和contentOffset. 但是如果设置了inset，还是会帮你移动offset.


总之，自己刚开始设置了inset,系统肯定会帮你移动offset,如果设置了automaticallyAdjust，则会在你设置的基础上+20或者64，offset也响应的设置！ 在scrollView同级的，在它之前添加到父view上，会阻止automaticallyAdjust.

另外，，如果是automaticallyAdjust的，会把contentIndicatorInset也调节了，但是也是只增加调节的20或者64部分，如果原先就和contentInset不一样，还是不一样！