const c = @import("c.zig").node_api;

pub fn throw(env: c.napi_env, comptime message: [:0]const u8) error{Exception} {
  return switch (c.napi_throw_error(env, null, message)) {
    c.napi_ok, c.napi_pending_exception => error.Exception,
    else => unreachable,
  };
}