const std = @import("std");
const database = @import("database.zig");

const Contact = struct {
    name: []const u8,
    phone: []const u8,
};

pub fn addContact(db: database.Database) anyerror!void {
    var contact: Contact = undefined;

    std.debug.print("Enter contact name: ", .{});
    contact.name = try std.debug.readLineAlloc(std.heap.page_allocator);

    std.debug.print("Enter contact phone number: ", .{});
    contact.phone = try std.debug.readLineAlloc(std.heap.page_allocator);

    try db.insertContact(contact);
    std.debug.print("Contact added successfully.\n", .{});
}

pub fn listContacts(db: database.Database) anyerror!void {
    const contacts = try db.getContacts();

    for (contacts) |contact| {
        std.debug.print("Name: {s}, Phone: {s}\n", .{ contact.name, contact.phone });
    }
}

pub fn deleteContact(db: database.Database) anyerror!void {
    std.debug.print("Enter the name of the contact to delete: ", .{});
    var name = try std.debug.readLineAlloc(std.heap.page_allocator);

    try db.deleteContact(name);
    std.debug.print("Contact deleted successfully.\n", .{});
}
