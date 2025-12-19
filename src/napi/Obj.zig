const std = @import("std");
const c = @import("c.zig").c;
const call_node_api = @import("c.zig").call_node_api;
const utils = @import("utils.zig");
const Ctx = @import("Ctx.zig");

c_val: c.napi_value,
ctx: Ctx,
const Obj = @This();

pub fn new(ctx: Ctx) !Obj {
  var res: c.napi_value = undefined;
  try call_node_api(
    ctx.c_env,
    c.napi_create_object,
    .{&res},
  );
  return .{ .c_val = res, .ctx = ctx };
}

pub fn set(self: Obj, name: [:0]const u8, val: anytype) !void {
  comptime {
    if (!utils.typeHasCVal(@TypeOf(val))) {
      @compileError("obj.set val must be struct has field `c_val`");
    }
  }

  try call_node_api(
    self.ctx.c_env,
    c.napi_set_named_property,
    .{ self.c_val, name.ptr, val.c_val },
  );
}
