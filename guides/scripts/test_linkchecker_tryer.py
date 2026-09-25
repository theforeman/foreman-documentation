#!/usr/bin/env python3

import importlib.machinery
import importlib.util
import unittest
from contextlib import redirect_stdout
from io import StringIO
from pathlib import Path
from unittest.mock import patch

SCRIPT = Path(__file__).with_name("linkchecker-tryer")
LOADER = importlib.machinery.SourceFileLoader("linkchecker_tryer", str(SCRIPT))
SPEC = importlib.util.spec_from_loader(LOADER.name, LOADER)
LINKCHECKER_TRYER = importlib.util.module_from_spec(SPEC)
LOADER.exec_module(LINKCHECKER_TRYER)


class TransientFailureTest(unittest.TestCase):
    def test_read_timeout_is_transient(self):
        message = "Result     Error: ReadTimeout: request timed out"

        self.assertTrue(LINKCHECKER_TRYER.is_transient_failure(message))

    def test_connection_reset_is_transient(self):
        message = "Result     Error: ConnectionError: RemoteDisconnected"

        self.assertTrue(LINKCHECKER_TRYER.is_transient_failure(message))

    def test_too_many_requests_is_transient(self):
        message = "Result     Error: 429 Too Many Requests"

        self.assertTrue(LINKCHECKER_TRYER.is_transient_failure(message))

    def test_not_found_is_not_transient(self):
        message = "Result     Error: 404 Not Found"

        self.assertFalse(LINKCHECKER_TRYER.is_transient_failure(message))


class MainOutputTest(unittest.TestCase):
    def test_no_broken_links_message(self):
        output = StringIO()

        with patch.object(LINKCHECKER_TRYER.fileinput, "input", return_value=[]), redirect_stdout(output):
            LINKCHECKER_TRYER.main()

        self.assertIn("No broken links", output.getvalue())


if __name__ == "__main__":
    unittest.main()
