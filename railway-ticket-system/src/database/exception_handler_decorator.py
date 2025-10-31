import logging
import time

from pymysql.err import Error

logger = logging.getLogger(__name__)
logger.setLevel(logging.ERROR)


def db_exception_handler(f):
    def wrapper(*args, **kwargs):
        try:
            result = f(*args, *kwargs)
        except Error as e:
            result = None
            logger.error(f"Error in function `{f.__name__}`. {e}")
            time.sleep(0.1)
        return result

    return wrapper
