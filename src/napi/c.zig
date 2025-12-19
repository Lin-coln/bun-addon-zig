const std = @import("std");

pub const c = @cImport({
    @cDefine("NAPI_VERSION", "10");
    @cInclude("node_api.h");
});

pub fn call_node_api(env: c.napi_env, c_func: anytype, args: anytype) !void {
    var full_args: std.meta.ArgsTuple(@TypeOf(c_func)) = undefined;
    full_args[0] = env;
    inline for (args, 1..) |arg, i| {
        full_args[i] = arg;
    }

    const ret_code = @call(.auto, c_func, full_args);
    if (ret_code == c.napi_ok) {
        return;
    }
    var err_info: [*c]const c.napi_extended_error_info = null;
    if (c.napi_get_last_error_info(env, &err_info) != c.napi_ok) {
        return error.GetLastError;
    }

    const msg = if (err_info) |info|
        if (info.*.error_message == null) "Unknown error occurred" else std.mem.span(info.*.error_message)
    else
        "Unknown error occurred";

    if (err_info) |info_ptr| std.log.debug("Node-API error: {s}, code:{d}", .{ msg, info_ptr.*.error_code });

    var is_pending: bool = undefined;
    if (c.napi_is_exception_pending(env, &is_pending) != c.napi_ok) {
        return error.IsExceptionPending;
    }
    // If an exception is already pending, don't rethrow it
    if (is_pending) {
        return;
    }

    if (c.napi_throw_error(env, null, msg) != c.napi_ok) {
        return error.ThrowError;
    }
}