# GUT Test Stub
# This is a minimal stub to prevent load errors.
# For full testing functionality, install the GUT addon:
# https://github.com/bitwes/Gut
#
# Install via AssetLib in Godot or download from GitHub.

class_name GutTest
extends Node

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

func assert_has(obj, method_name: String, text := "") -> void:
	if not obj.has_method(method_name):
		push_error("FAIL: %s - Object does not have method '%s'" % [text, method_name])
	else:
		print("PASS: %s" % text)

func autoqfree(node: Node) -> Node:
	# Queue the node for freeing when the test is done
	return node

func before_each() -> void:
	pass

func after_each() -> void:
	pass

func before_all() -> void:
	pass

func after_all() -> void:
	pass
