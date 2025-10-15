const std = @import("std");

pub const PluginConfig = struct {
    description: Description,
    features: PluginFeatures,
    root_source_file: []const u8,

    // in-place modification of certain properties

    pub fn withName(self: PluginConfig, name: [:0]const u8) PluginConfig {
        var new = self;
        new.description.name = name;
        return new;
    }

    pub fn withID(self: PluginConfig, id: [:0]const u8) PluginConfig {
        var new = self;
        new.description.id = id;
        return new;
    }

    pub fn withSource(self: PluginConfig, src: []const u8) PluginConfig {
        var new = self;
        new.root_source_file = src;
        return new;
    }
};

pub const Description = struct {
    /// plugin name
    name: [:0]const u8,
    /// unique id for plugin, i.e. com.Company.Plugin
    id: [:0]const u8,
    /// company name
    company: [:0]const u8,
    /// version string
    version: [:0]const u8,
    /// copyright string
    copyright: [:0]const u8,
    /// url of your website, not that you need one. It's nice to have!
    url: [:0]const u8,
    /// contact url
    contact: [:0]const u8,
    /// link to user manual
    manual: [:0]const u8,
    /// short description of plugin
    description: [:0]const u8,
    // NOTE: Removed features from this struct until bugs w/ Zig build options are fixed
    // format-agnostic list of plugin features
    // features: []const PluginFeatures,
};

pub const PluginFeatures = packed struct(u32) {
    mono: bool = false,
    stereo: bool = true,
    surround: bool = false,
    ambisonic: bool = false,
    effect: bool = true,
    distortion: bool = false,
    dynamics: bool = false,
    eq: bool = false,
    reverb: bool = false,
    pitch_shift: bool = false,
    mastering: bool = false,
    analyzer: bool = false,
    restoration: bool = false,
    instrument: bool = false,
    synth: bool = false,
    sampler: bool = false,
    drum: bool = false,
    gui: bool = true,
    _: u14 = 0,

    pub fn toInt(self: PluginFeatures) u32 {
        return @bitCast(self);
    }
};

pub const Format = enum {
    CLAP,
    VST2,
    VST3,
};
