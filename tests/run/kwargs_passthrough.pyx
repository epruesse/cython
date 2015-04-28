cimport cython


@cython.test_fail_if_path_exists('//KeywordArgsNode')
def wrap_passthrough(f):
    """
    >>> def f(a=1): return a
    >>> wrapped = wrap_passthrough(f)
    >>> wrapped(1)
    CALLED
    1
    >>> wrapped(a=2)
    CALLED
    2
    """
    def wrapper(*args, **kwargs):
        print("CALLED")
        return f(*args, **kwargs)
    return wrapper


@cython.test_fail_if_path_exists('//KeywordArgsNode')
def unused(*args, **kwargs):
    """
    >>> unused()
    ()
    >>> unused(1, 2)
    (1, 2)
    """
    return args


@cython.test_fail_if_path_exists('//KeywordArgsNode')
def used_in_closure(**kwargs):
    """
    >>> used_in_closure()
    >>> d = {}
    >>> used_in_closure(**d)
    >>> d  # must not be modified
    {}
    """
    def func():
        kwargs['test'] = 1
    return func()


@cython.test_fail_if_path_exists('//KeywordArgsNode')
def modify_in_closure(**kwargs):
    """
    >>> func = modify_in_closure()
    >>> func()

    >>> d = {}
    >>> func = modify_in_closure(**d)
    >>> func()
    >>> d  # must not be modified
    {}
    """
    def func():
        kwargs['test'] = 1
    return func


@cython.test_assert_path_exists('//KeywordArgsNode')
def wrap_passthrough_more(f):
    """
    >>> def f(a=1, test=2):
    ...     return a, test
    >>> wrapped = wrap_passthrough_more(f)
    >>> wrapped(1)
    CALLED
    (1, 1)
    >>> wrapped(a=2)
    CALLED
    (2, 1)
    """
    def wrapper(*args, **kwargs):
        print("CALLED")
        return f(*args, test=1, **kwargs)
    return wrapper


@cython.test_fail_if_path_exists('//KeywordArgsNode')
def wrap_passthrough2(f):
    """
    >>> def f(a=1): return a
    >>> wrapped = wrap_passthrough2(f)
    >>> wrapped(1)
    CALLED
    1
    >>> wrapped(a=2)
    CALLED
    2
    """
    def wrapper(*args, **kwargs):
        print("CALLED")
        f(*args, **kwargs)
        return f(*args, **kwargs)
    return wrapper


@cython.test_fail_if_path_exists('//KeywordArgsNode')
def wrap_modify(f):
    """
    >>> def f(a=1, test=2):
    ...     return a, test

    >>> wrapped = wrap_modify(f)
    >>> wrapped(1)
    CALLED
    (1, 1)
    >>> wrapped(a=2)
    CALLED
    (2, 1)
    >>> wrapped(a=2, test=3)
    CALLED
    (2, 1)
    """
    def wrapper(*args, **kwargs):
        print("CALLED")
        kwargs['test'] = 1
        return f(*args, **kwargs)
    return wrapper


@cython.test_fail_if_path_exists('//KeywordArgsNode')
def wrap_modify_mix(f):
    """
    >>> def f(a=1, test=2):
    ...     return a, test

    >>> wrapped = wrap_modify_mix(f)
    >>> wrapped(1)
    CALLED
    (1, 1)
    >>> wrapped(a=2)
    CALLED
    (2, 1)
    >>> wrapped(a=2, test=3)
    CALLED
    (2, 1)
    """
    def wrapper(*args, **kwargs):
        print("CALLED")
        f(*args, **kwargs)
        kwargs['test'] = 1
        return f(*args, **kwargs)
    return wrapper


@cython.test_assert_path_exists('//KeywordArgsNode')
def wrap_modify_func(f):
    """
    >>> def f(a=1, test=2):
    ...     return a, test

    >>> wrapped = wrap_modify_func(f)
    >>> wrapped(1)
    CALLED
    (1, 1)
    >>> wrapped(a=2)
    CALLED
    (2, 1)
    >>> wrapped(a=2, test=3)
    CALLED
    (2, 1)
    """
    def modify(kw):
        kw['test'] = 1
        return kw

    def wrapper(*args, **kwargs):
        print("CALLED")
        return f(*args, **modify(kwargs))
    return wrapper


@cython.test_assert_path_exists('//KeywordArgsNode')
def wrap_modify_func_mix(f):
    """
    >>> def f(a=1, test=2):
    ...     return a, test

    >>> wrapped = wrap_modify_func_mix(f)
    >>> wrapped(1)
    CALLED
    (1, 1)
    >>> wrapped(a=2)
    CALLED
    (2, 1)
    >>> wrapped(a=2, test=3)
    CALLED
    (2, 1)
    """
    def modify(kw):
        kw['test'] = 1
        return kw

    def wrapper(*args, **kwargs):
        print("CALLED")
        f(*args, **kwargs)
        return f(*args, **modify(kwargs))
    return wrapper


@cython.test_fail_if_path_exists('//KeywordArgsNode')
def wrap_reassign(f):
    """
    >>> def f(a=1, test=2):
    ...     return a, test

    >>> wrapped = wrap_reassign(f)
    >>> wrapped(1)
    CALLED
    (1, 1)
    >>> wrapped(a=2)
    CALLED
    (1, 1)
    >>> wrapped(a=2, test=3)
    CALLED
    (1, 1)
    """
    def wrapper(*args, **kwargs):
        print("CALLED")
        kwargs = {'test': 1}
        return f(*args, **kwargs)
    return wrapper


@cython.test_fail_if_path_exists('//KeywordArgsNode')
def kwargs_metaclass(**kwargs):
    """
    >>> K = kwargs_metaclass()
    >>> K = kwargs_metaclass(metaclass=type)
    """
    class K(**kwargs):
        pass
    return K