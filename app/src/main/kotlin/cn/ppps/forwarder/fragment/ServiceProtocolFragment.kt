package cn.ppps.forwarder.fragment

import android.view.LayoutInflater
import android.view.ViewGroup
import cn.ppps.forwarder.R
import cn.ppps.forwarder.core.BaseFragment
import cn.ppps.forwarder.databinding.FragmentServiceProtocolBinding
import com.xuexiang.xpage.annotation.Page
import com.xuexiang.xrouter.annotation.AutoWired
import com.xuexiang.xrouter.launcher.XRouter
import com.xuexiang.xui.widget.actionbar.TitleBar
import com.xuexiang.xutil.resource.ResourceUtils

/**
 * Service agreement (loaded locally)
 *
 * @author xuexiang
 * @since 2021/5/18 1:35 AM
 */
@Suppress("REDUNDANT_MODIFIER_IN_GETTER")
@Page
class ServiceProtocolFragment : BaseFragment<FragmentServiceProtocolBinding?>() {
    @JvmField
    @AutoWired(name = KEY_PROTOCOL_TITLE)
    var title: String? = null

    @JvmField
    @AutoWired(name = KEY_IS_IMMERSIVE)
    var isImmersive = false

    override fun initArgs() {
        XRouter.getInstance().inject(this)
    }

    override fun viewBindingInflate(
        inflater: LayoutInflater,
        container: ViewGroup,
    ): FragmentServiceProtocolBinding {
        return FragmentServiceProtocolBinding.inflate(inflater, container, false)
    }

    override fun initTitle(): TitleBar? {
        return super.initTitle()!!.setTitle(title).setImmersive(isImmersive)
    }

    /**
     * Initialize widgets
     */
    override fun initViews() {
        if (title == getString(R.string.title_user_protocol)) {
            binding!!.tvProtocolText.text = accountProtocol
        } else {
            binding!!.tvProtocolText.text = privacyProtocol
        }
    }

    private val accountProtocol: String
        get() = ResourceUtils.readStringFromAssert(getString(R.string.account_protocol_asset))

    private val privacyProtocol: String
        get() = ResourceUtils.readStringFromAssert(getString(R.string.privacy_protocol_asset))

    companion object {
        const val KEY_PROTOCOL_TITLE = "key_protocol_title"
        const val KEY_IS_IMMERSIVE = "key_is_immersive"

    }
}