package cn.ppps.forwarder.core

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import androidx.viewbinding.ViewBinding
import com.hjq.language.MultiLanguages
import cn.ppps.forwarder.utils.EVENT_TOAST_ERROR
import cn.ppps.forwarder.utils.EVENT_TOAST_INFO
import cn.ppps.forwarder.utils.EVENT_TOAST_SUCCESS
import cn.ppps.forwarder.utils.EVENT_TOAST_WARNING
import cn.ppps.forwarder.utils.XToastUtils
import com.jeremyliao.liveeventbus.LiveEventBus
import com.xuexiang.xpage.base.XPageActivity
import com.xuexiang.xpage.base.XPageFragment
import com.xuexiang.xpage.core.CoreSwitchBean
import com.xuexiang.xrouter.facade.service.SerializationService
import com.xuexiang.xrouter.launcher.XRouter
import com.xuexiang.xui.widget.slideback.SlideBack
import com.xuexiang.xutil.resource.ResUtils.isRtl

/**
 * Base container activity
 *
 * @author XUE
 * @since 2019/3/22 11:21
 */
@Suppress("MemberVisibilityCanBePrivate", "UNCHECKED_CAST", "DEPRECATION", "EmptyMethod")
open class BaseActivity<Binding : ViewBinding?> : XPageActivity() {
    /**
     * Get the binding
     *
     * @return Binding
     */
    /**
     * ViewBinding
     */
    var binding: Binding? = null
        protected set

    override fun attachBaseContext(newBase: Context) {
        //Inject fonts
        //super.attachBaseContext(ViewPumpContextWrapper.wrap(newBase))
        // Attach the app locale
        //super.attachBaseContext(ViewPumpContextWrapper.wrap(MultiLanguages.attach(newBase)))
        super.attachBaseContext(MultiLanguages.attach(newBase))
    }

    override fun getCustomRootView(): View? {
        binding = viewBindingInflate(layoutInflater)
        return if (binding != null) binding!!.root else null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        initStatusBarStyle()
        super.onCreate(savedInstanceState)
        registerSlideBack()

        //Toast notifications for various events
        LiveEventBus.get(EVENT_TOAST_ERROR, String::class.java).observe(this) { msg: String ->
            XToastUtils.error(msg, 15000)
        }
        LiveEventBus.get(EVENT_TOAST_SUCCESS, String::class.java).observe(this) { msg: String ->
            XToastUtils.success(msg)
        }
        LiveEventBus.get(EVENT_TOAST_INFO, String::class.java).observe(this) { msg: String ->
            XToastUtils.info(msg)
        }
        LiveEventBus.get(EVENT_TOAST_WARNING, String::class.java).observe(this) { msg: String ->
            XToastUtils.warning(msg, 10000)
        }
    }

    /**
     * Create the ViewBinding
     *
     * @param inflater  inflater
     * @return ViewBinding
     */
    protected open fun viewBindingInflate(inflater: LayoutInflater?): Binding? {
        return null
    }

    /**
     * Initialize the status bar style
     */
    protected open fun initStatusBarStyle() {}

    /**
     * Open a fragment
     *
     * @param clazz          Page class
     * @param addToBackStack Whether to add to the back stack
     * @return Opened fragment instance
     */
    fun <T : XPageFragment?> openPage(clazz: Class<T>?, addToBackStack: Boolean): T {
        val page = CoreSwitchBean(clazz)
            .setAddToBackStack(addToBackStack)
        return openPage(page) as T
    }

    /**
     * Open a fragment
     *
     * @return Opened fragment instance
     */
    fun <T : XPageFragment?> openNewPage(clazz: Class<T>?): T {
        val page = CoreSwitchBean(clazz)
            .setNewActivity(true)
        return openPage(page) as T
    }

    /**
     * Switch fragments
     *
     * @param clazz Page class
     * @return Opened fragment instance
     */
    fun <T : XPageFragment?> switchPage(clazz: Class<T>?): T {
        return openPage(clazz, false)
    }

    /**
     * Serialize an object
     *
     * @param object
     * @return
     */
    fun serializeObject(`object`: Any?): String {
        return XRouter.getInstance().navigation(SerializationService::class.java)
            .object2Json(`object`)
    }

    override fun onRelease() {
        unregisterSlideBack()
        super.onRelease()
    }

    /**
     * Register the swipe callback
     */
    protected fun registerSlideBack() {
        if (isSupportSlideBack) {
            SlideBack.with(this)
                .haveScroll(true)
                .edgeMode(if (isRtl()) SlideBack.EDGE_RIGHT else SlideBack.EDGE_LEFT)
                .callBack { popPage() }
                .register()
        }
    }

    /**
     * Unregister the swipe callback
     */
    protected fun unregisterSlideBack() {
        if (isSupportSlideBack) {
            SlideBack.unregister(this)
        }
    }

    /**
     * @return Whether swipe-back navigation is supported
     */
    protected open val isSupportSlideBack: Boolean
        get() {
            val page: CoreSwitchBean? = intent.getParcelableExtra(CoreSwitchBean.KEY_SWITCH_BEAN)
            return page == null || page.bundle == null || page.bundle.getBoolean(
                KEY_SUPPORT_SLIDE_BACK,
                true
            )
        }

    companion object {
        /**
         * Whether swipe-back navigation is supported
         */
        const val KEY_SUPPORT_SLIDE_BACK = "key_support_slide_back"
    }
}