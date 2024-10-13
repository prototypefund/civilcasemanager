defmodule CaseManagerWeb.LiveUtilsTest do
  use ExUnit.Case, async: true
  import CaseManagerWeb.LiveUtils

  describe "to_slug/1" do
    test "converts a string to a slug" do
      assert to_slug("Hello World") == "hello-world"
    end

    test "removes special characters" do
      assert to_slug("Hello! World@") == "hello-world"
    end

    test "replaces multiple spaces and hyphens with a single hyphen" do
      assert to_slug("Hello   World---Test") == "hello-world-test"
    end

    test "trims leading and trailing hyphens" do
      assert to_slug("-Hello World-") == "hello-world"
    end

    test "handles empty string" do
      assert to_slug("") == ""
    end

    test "handles string with only special characters" do
      assert to_slug("!@#$%^&*()") == ""
    end

    test "preserves numbers" do
      assert to_slug("Hello 123 World") == "hello-123-world"
    end

    test "handles mixed case" do
      assert to_slug("HeLLo WoRLd") == "hello-world"
    end
  end
end
