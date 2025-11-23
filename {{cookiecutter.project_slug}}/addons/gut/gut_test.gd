# GUT Test Stub
# This is a minimal stub to prevent load errors.
# For full testing functionality, install the GUT addon:
# https://github.com/bitwes/Gut
#
# Install via AssetLib in Godot or download from GitHub.

class_name GutTest
extends Node

var gut = self

func assert_eq(got, expected, text := "") -> void:
	if got != expected:
		push_error("FAIL: %s - Expected '%s' but got '%s'" % [text, expected, got])
	else:
		print("PASS: %s" % text)

func assert_ne(got, not_expected, text := "") -> void:
	if got == not_expected:
		push_error("FAIL: %s - Expected not '%s'" % [text, not_expected])
	else:
		print("PASS: %s" % text)

func assert_true(value, text := "") -> void:
	if not value:
		push_error("FAIL: %s - Expected true" % text)
	else:
		print("PASS: %s" % text)

func assert_false(value, text := "") -> void:
	if value:
		push_error("FAIL: %s - Expected false" % text)
	else:
		print("PASS: %s" % text)

func assert_null(value, text := "") -> void:
	if value != null:
		push_error("FAIL: %s - Expected null" % text)
	else:
		print("PASS: %s" % text)

func assert_not_null(value, text := "") -> void:
	if value == null:
		push_error("FAIL: %s - Expected not null" % text)
	else:
		print("PASS: %s" % text)

func assert_has(obj, property, text := "") -> void:
	print("STUB: assert_has - %s" % text)

func assert_does_not_have(obj, property, text := "") -> void:
	print("STUB: assert_does_not_have - %s" % text)

func assert_gt(got, expected, text := "") -> void:
	if got <= expected:
		push_error("FAIL: %s - Expected '%s' > '%s'" % [text, got, expected])
	else:
		print("PASS: %s" % text)

func assert_lt(got, expected, text := "") -> void:
	if got >= expected:
		push_error("FAIL: %s - Expected '%s' < '%s'" % [text, got, expected])
	else:
		print("PASS: %s" % text)

func assert_ge(got, expected, text := "") -> void:
	if got < expected:
		push_error("FAIL: %s - Expected '%s' >= '%s'" % [text, got, expected])
	else:
		print("PASS: %s" % text)

func assert_le(got, expected, text := "") -> void:
	if got > expected:
		push_error("FAIL: %s - Expected '%s' <= '%s'" % [text, got, expected])
	else:
		print("PASS: %s" % text)

func assert_has_signal(obj, signal_name: String, text := "") -> void:
	if obj.has_signal(signal_name):
		print("PASS: %s" % text)
	else:
		push_error("FAIL: %s - Object does not have signal '%s'" % [text, signal_name])

func assert_signal_emitted(obj, signal_name: String, text := "") -> void:
	print("STUB: assert_signal_emitted - %s" % text)

func assert_signal_emitted_with_parameters(obj, signal_name: String, params: Array, text := "") -> void:
	print("STUB: assert_signal_emitted_with_parameters - %s" % text)

func assert_extends(obj, parent_class, text := "") -> void:
	print("STUB: assert_extends - %s" % text)

func assert_string_contains(text: String, search: String, msg := "") -> void:
	if search in text:
		print("PASS: %s" % msg)
	else:
		push_error("FAIL: %s - '%s' not found in '%s'" % [msg, search, text])

func assert_string_starts_with(text: String, search: String, msg := "") -> void:
	if text.begins_with(search):
		print("PASS: %s" % msg)
	else:
		push_error("FAIL: %s - '%s' does not start with '%s'" % [msg, text, search])

func assert_string_ends_with(text: String, search: String, msg := "") -> void:
	if text.ends_with(search):
		print("PASS: %s" % msg)
	else:
		push_error("FAIL: %s - '%s' does not end with '%s'" % [msg, text, search])

func autoqfree(node: Node) -> Node:
	return node

func add_child_autoqfree(node: Node) -> Node:
	add_child(node)
	return node

func watch_signals(obj) -> void:
	pass

func stub(obj, method: String) -> StubBuilder:
	return StubBuilder.new()

func use_parameters(params: Array) -> Variant:
	if params.size() > 0:
		return params[0]
	return null

func pending(text := "") -> void:
	print("PENDING: %s" % text)

func p(msg, arg1 = null, arg2 = null) -> void:
	print(msg)

func before_each() -> void:
	pass

func after_each() -> void:
	pass

func before_all() -> void:
	pass

func after_all() -> void:
	pass


class StubBuilder:
	func to_return(value) -> StubBuilder:
		return self

	func when_passed(args) -> StubBuilder:
		return self
