package com.example.nothingbutjazz

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel



class AlgoliaAPIFlutterAdapter(applicationID: ApplicationID, apiKey: APIKey) {

    val client = ClientSearch(applicationID, apiKey)

    fun perform(call: MethodCall, result: MethodChannel.Result): Unit = runBlocking {
        Log.d("AlgoliaAPIAdapter", "method: ${call.method}")
        Log.d("AlgoliaAPIAdapter", "args: ${call.arguments}")
        val args = call.arguments as? List<String>
        if (args == null) {
            result.error("AlgoliaNativeError", "Missing arguments", null)
            return@runBlocking
        }

        when (call.method) {
            "search" -> search(indexName = args[0].toIndexName(), query = Query(args[1]), result = result)
            else -> result.notImplemented()
        }
    }

    suspend fun search(indexName: IndexName, query: Query, result: MethodChannel.Result) {
        val index = client.initIndex(indexName)
        try {
            val search = index.search(query = query)
            result.success(Json.encodeToString(ResponseSearch.serializer(), search))
        } catch (e: Exception) {
            result.error("AlgoliaNativeError", e.localizedMessage, e.cause)
        }
    }
}

class MainActivity : FlutterActivity() {

    val algoliaAPIAdapter = AlgoliaAPIFlutterAdapter(ApplicationID("latency"), APIKey("1f6fd3a6fb973cb08419fe7d288fa4db"))

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.algolia/api").setMethodCallHandler { call, result ->
            algoliaAPIAdapter.perform(call, result)
        }
    }
}