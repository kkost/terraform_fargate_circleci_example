import pytest
import pytest_flask

from app.main import create_app


@pytest.fixture
def app():
    app = create_app()
    return app


def test_response_code(client, app):
    response = client.get('/')
    assert response.status_code == 200
