const napi = @import("napi/index.zig");

comptime {
    napi.registerModule(init);
}

fn init(ctx: napi.Ctx, exports: napi.Obj) !napi.Obj {
    try exports.set("foo", try ctx.boolean(true));
    return exports;
}
