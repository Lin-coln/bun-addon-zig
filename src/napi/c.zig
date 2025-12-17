pub const node_api = @cImport({
    // @cDefine("NAPI_VERSION", "10");
    @cInclude("node_api.h");
});
