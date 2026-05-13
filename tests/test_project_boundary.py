from pathlib import Path


def test_gitignore_contains_project_boundary_patterns():
    gitignore = Path(".gitignore")
    patterns = set(gitignore.read_text(encoding="utf-8").splitlines())

    assert "__pycache__/" in patterns
    assert ("server.log" in patterns) or ("*.log" in patterns)
    assert "temp_uploads/" in patterns
    assert "output/" in patterns
    assert "*.zip" in patterns
    assert "*.7z" in patterns
