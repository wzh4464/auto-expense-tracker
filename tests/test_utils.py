from src.utils import welcome


def test_welcome() -> None:
    assert welcome() == "Welcome to auto-expense-tracker!"
