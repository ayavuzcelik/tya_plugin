package com.dev.adem.flutter_tya_plugin

import android.app.Application
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.thingclips.smart.android.user.api.ILoginCallback
import com.thingclips.smart.android.user.api.IRegisterCallback
import com.thingclips.smart.android.user.bean.User
import com.thingclips.smart.home.sdk.ThingHomeSdk
import com.thingclips.smart.home.sdk.bean.HomeBean
import com.thingclips.smart.home.sdk.callback.IThingGetHomeListCallback
import com.thingclips.smart.home.sdk.callback.IThingHomeResultCallback
import com.thingclips.smart.sdk.api.IResultCallback
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterTyaPlugin */
class FlutterTyaPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private val TAG = "[FTP-Android]"
    private val NAMESPACE = "flutter_tya_plugin"
    private var logLevel: LogLevel = LogLevel.DEBUG
    private var context: Context? = null
    private var methodChannel: MethodChannel? = null
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        log(LogLevel.DEBUG, "onAttachedToEngine")
        pluginBinding = flutterPluginBinding

        context = flutterPluginBinding.applicationContext
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, NAMESPACE)
        methodChannel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        log(LogLevel.DEBUG, "onMethodCall: ${call.method}")

        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "setLogLevel" -> {
                val idx = call.arguments as Int

                // set global var
                logLevel = LogLevel.values()[idx]

                result.success(true)
            }

            "initSdk" -> {
                val appKey = call.argument<String>("appKey")
                val appSecret = call.argument<String>("appSecret")
                val isDebug = call.argument<Boolean>("isDebug") ?: false
                log(LogLevel.INFO, "Debug mode set to $isDebug")
                try {
                    ThingHomeSdk.init(context as Application, appKey!!, appSecret!!)
                    log(LogLevel.INFO, "ThingHomeSdk initialized with appKey=$appKey")
                    result.success(true)
                } catch (e: Exception) {
                    log(LogLevel.ERROR, "initSdk failed: ${e.message}")
                    result.error("INIT_FAILED", e.message, null)
                }

            }

            "sendBindVerifyCodeWithEmail" -> {
                val countryCode = call.argument<String>("countryCode")
                val email = call.argument<String>("email")
                try {
                    ThingHomeSdk.getUserInstance().sendBindVerifyCodeWithEmail(
                        countryCode!!, email!!,
                        object : IResultCallback {
                            override fun onSuccess() {
                                log(
                                    LogLevel.INFO,
                                    "sendBindVerifyCodeWithEmail success for email=$email code=$countryCode"
                                )
                                result.success(true)
                            }

                            override fun onError(errorCode: String?, errorMsg: String?) {
                                log(
                                    LogLevel.ERROR,
                                    "sendBindVerifyCodeWithEmail failed: [$errorCode] $errorMsg"
                                )
                                result.success(false)
                            }
                        }
                    )

                } catch (e: Exception) {
                    log(LogLevel.ERROR, "sendBindVerifyCodeWithEmail failed: ${e.message}")
                    result.error("SEND_BIND_VERIFY_FAILED", e.message, null)
                }
            }

            "registerAccountWithEmail" -> {
                val countryCode = call.argument<String>("countryCode")
                val email = call.argument<String>("email")
                val password = call.argument<String>("password")
                val code = call.argument<String>("code")
                try {
                    ThingHomeSdk.getUserInstance().registerAccountWithEmail(
                        countryCode, email, password, code,
                        object : IRegisterCallback {
                            override fun onSuccess(user: User?) {
                                log(
                                    LogLevel.INFO,
                                    "registerAccountWithEmail success for email=$email"
                                )
                                result.success(true)
                            }

                            override fun onError(code: String?, error: String?) {
                                log(
                                    LogLevel.ERROR,
                                    "registerAccountWithEmail failed: [$code] $error"
                                )
                                result.success(false)
                            }
                        }
                    )

                } catch (e: Exception) {
                    log(LogLevel.ERROR, "registerAccountWithEmail failed: ${e.message}")
                    result.error("REGISTER_FAILED", e.message, null)
                }
            }

            "loginWithEmail" -> {
                val countryCode = call.argument<String>("countryCode")
                val email = call.argument<String>("email")
                val password = call.argument<String>("password")
                try {
                    ThingHomeSdk.getUserInstance().loginWithEmail(
                        countryCode, email, password,
                        object : ILoginCallback {
                            override fun onSuccess(user: User?) {
                                log(LogLevel.INFO, "loginWithEmail success for email=$email")
                                result.success(true)
                            }

                            override fun onError(code: String?, error: String?) {
                                log(LogLevel.ERROR, "loginWithEmail failed: [$code] $error")
                                result.success(false)
                            }
                        }
                    )

                } catch (e: Exception) {
                    log(LogLevel.ERROR, "loginWithEmail failed: ${e.message}")
                    result.error("LOGIN_FAILED", e.message, null)
                }
            }

            "queryHomeList" -> {
                try {
                    ThingHomeSdk.getHomeManagerInstance()
                        .queryHomeList(object : IThingGetHomeListCallback {
                            override fun onSuccess(homeBeans: MutableList<HomeBean>?) {
                                val homes = arrayListOf<Map<String, Any>>()

                                homeBeans?.forEach {
                                    val item = mapOf<String, Any>(
                                        "homeId" to it.homeId,
                                        "name" to it.name,
                                        "geoName" to it.geoName,
                                        "latitude" to it.lat,
                                        "longitude" to it.lon,
                                        "backgroundUrl" to it.background,
                                        "role" to it.role,
                                        "dealStatus" to it.homeStatus,
                                        "managementStatus" to it.managmentStatus(),
                                        "nickName" to it.inviteName
                                    )
                                    homes.add(item)
                                }

                                log(
                                    LogLevel.INFO,
                                    "queryHomeList success: ${homes.size} homes found"
                                )
                                result.success(homes)
                            }

                            override fun onError(code: String?, error: String?) {
                                log(LogLevel.ERROR, "queryHomeList failed: [$code] $error")
                                result.error(code ?: "UNKNOWN_ERROR", error, null)
                            }
                        })


                } catch (e: Exception) {
                    log(LogLevel.ERROR, "queryHomeList failed: ${e.message}")
                    result.error("QUERY_HOME_LIST_FAILED", e.message, null)
                }
            }

            "createHome" -> {
                val name = call.argument<String>("name")
                val latitude = call.argument<Double>("latitude")
                val longitude = call.argument<Double>("longitude")
                val geoName = call.argument<String>("geoName")
                val rooms = call.argument<List<String>>("rooms")
                try {
                    ThingHomeSdk.getHomeManagerInstance()
                        .createHome(
                            name,
                            longitude!!,
                            latitude!!,
                            geoName,
                            rooms,
                            object : IThingHomeResultCallback {
                                override fun onSuccess(bean: HomeBean?) {
                                    if (bean != null) {
                                        log(
                                            LogLevel.INFO,
                                            "createHome success: homeId=${bean.homeId}, name=$name"
                                        )
                                        result.success(bean.homeId)
                                    } else {
                                        log(
                                            LogLevel.WARNING,
                                            "createHome returned null HomeBean for name=$name"
                                        )
                                        result.error("HOME_NOT_CREATED", "Home not created", null)
                                    }
                                }

                                override fun onError(code: String?, error: String?) {
                                    log(LogLevel.ERROR, "createHome failed: [$code] $error")
                                    result.error(code ?: "UNKNOWN_ERROR", error, null)
                                }
                            })

                } catch (e: Exception) {
                    log(LogLevel.ERROR, "createHome failed: ${e.message}")
                    result.error("CREATE_HOME_FAILED", e.message, null)
                }
            }

            "deleteAllHomes" -> {
                try {
                    val homeManager = ThingHomeSdk.getHomeManagerInstance()
                    homeManager.queryHomeList(object : IThingGetHomeListCallback {
                        override fun onSuccess(homeBeans: MutableList<HomeBean>?) {
                            if (homeBeans.isNullOrEmpty()) {
                                log(LogLevel.INFO, "deleteAllHomes: no homes to delete")
                                result.success(true)
                                return
                            }

                            log(
                                LogLevel.INFO,
                                "deleteAllHomes: ${homeBeans.size} homes found, deleting..."
                            )

                            var deletedCount = 0
                            val totalCount = homeBeans.size

                            homeBeans.forEach { home ->
                                ThingHomeSdk.newHomeInstance(home.homeId)
                                    .dismissHome(object : IResultCallback {
                                        override fun onSuccess() {
                                            log(
                                                LogLevel.INFO,
                                                "deleteAllHomes: homeId=${home.homeId} deleted successfully"
                                            )
                                            deletedCount++
                                            if (deletedCount == totalCount) {
                                                log(
                                                    LogLevel.INFO,
                                                    "deleteAllHomes: all homes processed, success"
                                                )
                                                result.success(true)
                                            }
                                        }

                                        override fun onError(
                                            errorCode: String?,
                                            errorMsg: String?
                                        ) {
                                            log(
                                                LogLevel.ERROR,
                                                "deleteAllHomes: failed to delete homeId=${home.homeId}, [$errorCode] $errorMsg"
                                            )
                                            deletedCount++
                                            if (deletedCount == totalCount) {
                                                log(
                                                    LogLevel.WARNING,
                                                    "deleteAllHomes: all homes processed, some deletions failed"
                                                )
                                                result.success(false)
                                            }
                                        }
                                    })
                            }
                        }

                        override fun onError(errorCode: String?, errorMsg: String?) {
                            log(
                                LogLevel.ERROR,
                                "deleteAllHomes: queryHomeList failed: [$errorCode] $errorMsg"
                            )
                            result.success(false)
                        }
                    })

                } catch (e: Exception) {
                    log(LogLevel.ERROR, "deleteAllHomes failed: ${e.message}")
                    result.error("DELETE_ALL_HOMES_FAILED", e.message, null)
                }
            }

            "getDeviceList" -> {
                val homeId = call.argument<Int>("homeId")
                try {
                    val home = ThingHomeSdk.newHomeInstance(homeId!!.toLong())
log(LogLevel.INFO, "getHomeDetail: Fetching details for homeId=$homeId")

home.getHomeDetail(object : IThingHomeResultCallback {
    override fun onSuccess(bean: HomeBean?) {
        if (bean == null) {
            log(LogLevel.WARNING, "getHomeDetail: HomeBean is null for homeId=$homeId")
            result.success(emptyList<Map<String, Any?>>())
            return
        }

        log(LogLevel.INFO, "getHomeDetail: Home '${bean.name}' (${bean.homeId}) fetched successfully")
        val devices = arrayListOf<Map<String, Any?>>()

        bean.deviceList?.forEach { it ->
            val deviceModel = it.deviceBean

            val device = hashMapOf<String, Any?>(
                "uiName" to it.uiName,
                "devId" to it.devId,
                "name" to it.getName(),
                "iconUrl" to it.getIconUrl(),
                "isOnline" to it.isOnline,
                "isCloudOnline" to it.isCloudOnline,
                "isLocalOnline" to it.isLocalOnline,
                "isShare" to it.getIsShare(),
                "dps" to it.getDps(),
                "dpCodes" to it.getDpCodes(),
                "productId" to it.getProductId(),
                "supportGroup" to it.isSupportGroup,
                "gwType" to it.getGwType(),
                "pv" to it.getPv(),
                "latitude" to it.getLat(),
                "longitude" to it.getLon(),
                "localKey" to it.getLocalKey(),
                "uuid" to it.getUuid(),
                "timezoneId" to deviceModel.timezoneId,
                "nodeId" to deviceModel.nodeId,
                "parentId" to deviceModel.parentId,
                "devKey" to deviceModel.devKey,
                "homeDisplayOrder" to deviceModel.homeDisplayOrder,
                "sharedTime" to deviceModel.sharedTime,
                "accessType" to deviceModel.accessType,
                "schema" to deviceModel.getSchema(),
                "category" to deviceModel.productBean.category,
                "categoryCode" to deviceModel.categoryCode,
                "cadv" to deviceModel.cadv,
                "dpName" to deviceModel.dpName,
                "productVer" to deviceModel.getProductVer(),
                "uiId" to deviceModel.getUi()
            )

            devices.add(device)
            log(LogLevel.INFO, "getHomeDetail: Device loaded: ${it.getName()} (${it.devId})")
        }

        log(LogLevel.INFO, "getHomeDetail: Total ${devices.size} devices found for homeId=$homeId")
        result.success(devices)
    }

    override fun onError(errorCode: String?, errorMsg: String?) {
        log(LogLevel.ERROR, "getHomeDetail: Failed to fetch home detail [$errorCode] $errorMsg")
        result.error(errorCode ?: "UNKNOWN", errorMsg, null)
    }
})

                } catch (e: Exception) {
                    log(LogLevel.ERROR, "getDeviceList failed: ${e.message}")
                    result.error("GET_DEVICE_LIST_FAILED", e.message, null)
                }
            }

            "getActivatorToken" -> {
                try {
                    // TODO: implement
                } catch (e: Exception) {
                    log(LogLevel.ERROR, "getActivatorToken failed: ${e.message}")
                    result.error("GET_ACTIVATOR_TOKEN_FAILED", e.message, null)
                }
            }

            "startCameraActivator" -> {
                try {
                    // TODO: implement
                } catch (e: Exception) {
                    log(LogLevel.ERROR, "startCameraActivator failed: ${e.message}")
                    result.error("START_CAMERA_ACTIVATOR_FAILED", e.message, null)
                }
            }

            "startLive" -> {
                try {
                    // TODO: implement
                } catch (e: Exception) {
                    log(LogLevel.ERROR, "startLive failed: ${e.message}")
                    result.error("START_LIVE_FAILED", e.message, null)
                }
            }

            "stopLive" -> {
                try {
                    // TODO: implement
                } catch (e: Exception) {
                    log(LogLevel.ERROR, "stopLive failed: ${e.message}")
                    result.error("STOP_LIVE_FAILED", e.message, null)
                }
            }

            "startRecord" -> {
                try {
                    // TODO: implement
                } catch (e: Exception) {
                    log(LogLevel.ERROR, "startRecord failed: ${e.message}")
                    result.error("START_RECORD_FAILED", e.message, null)
                }
            }

            "stopRecord" -> {
                try {
                    // TODO: implement
                } catch (e: Exception) {
                    log(LogLevel.ERROR, "stopRecord failed: ${e.message}")
                    result.error("STOP_RECORD_FAILED", e.message, null)
                }
            }

            "takeSnapshot" -> {
                try {
                    // TODO: implement
                } catch (e: Exception) {
                    log(LogLevel.ERROR, "takeSnapshot failed: ${e.message}")
                    result.error("TAKE_SNAPSHOT_FAILED", e.message, null)
                }
            }

            "moveDirection" -> {
                try {
                    // TODO: implement
                } catch (e: Exception) {
                    log(LogLevel.ERROR, "moveDirection failed: ${e.message}")
                    result.error("MOVE_DIRECTION_FAILED", e.message, null)
                }
            }


            else -> {
                result.notImplemented()
            }
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        log(LogLevel.DEBUG, "onDetachedFromEngine")

        invokeMethodUIThread("OnDetachedFromEngine", hashMapOf())

        pluginBinding = null
        context = null

        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    private fun invokeMethodUIThread(method: String, data: HashMap<String, Any>) {
        Handler(Looper.getMainLooper()).post {
            // Could already be torn down at this moment
            if (methodChannel != null) {
                methodChannel?.invokeMethod(method, data)
            } else {
                log(
                    LogLevel.WARNING,
                    "invokeMethodUIThread: tried to call method on closed channel: $method"
                )
            }
        }
    }

    private fun log(level: LogLevel, message: String?) {
        if (level.ordinal > logLevel.ordinal) {
            return
        }
        val logMessage = "[FBP] ${message ?: "null"}"

        when (level) {
            LogLevel.DEBUG -> Log.d(TAG, "[FBP] $logMessage")
            LogLevel.WARNING -> Log.w(TAG, "[FBP] $logMessage")
            LogLevel.ERROR -> Log.e(TAG, "[FBP] $logMessage")
            else -> Log.d(TAG, "[FBP] $logMessage")
        }
    }

    enum class LogLevel {
        NONE,    // 0
        ERROR,   // 1
        WARNING, // 2
        INFO,    // 3
        DEBUG,   // 4
        VERBOSE  // 5
    }
}
