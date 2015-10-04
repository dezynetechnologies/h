# -*- coding: utf-8 -*-

"""
Configure and expose the application database session.

This module is responsible for setting up the database session and engine, and
making that accessible to other parts of the application.

Models should inherit from `h.db.Base` in order to have their metadata bound at
application startup (and if `h.db.should_create_all` is set, their tables will
be automatically created).

Access to the database session can either be through the `h.db.Session` session
factory, or through the request property `request.db` which is provided by this
module.
"""

from pyramid.settings import asbool
from sqlalchemy import engine_from_config
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import scoped_session, sessionmaker
import transaction

from zope.sqlalchemy import ZopeTransactionExtension

from h.api import db as api_db

__all__ = (
    'Base',
    'Session',
    'bind_engine',
    'make_engine',
)

# Create a thread-local session factory (which can also be used directly as a
# session):
#
#   http://docs.sqlalchemy.org/en/latest/orm/contextual.html#using-thread-local-scope-with-web-applications
#
# Using ZopeTransactionExtension from zope.sqlalchemy ensures that sessions are
# correctly scoped to the current processing request, and that sessions are
# automatically committed (or aborted) when the request terminates. This
# integration with pyramid is provided by `pyramid_tm`:
#
#   http://docs.pylonsproject.org/projects/pyramid-tm/en/latest/#transaction-usage
#
Session = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))


# Provide a very simple base class with a dynamic query property.
class _Base(object):
    query = Session.query_property()

Base = declarative_base(cls=_Base)


def bind_engine(engine,
                session=Session,
                base=Base,
                should_create=False,
                should_drop=False):
    """Bind the ``session`` and ``base`` to the ``engine``."""
    session.configure(bind=engine)
    base.metadata.bind = engine
    if should_drop:
        transaction.commit()
        base.metadata.drop_all(engine)
    if should_create:
        base.metadata.create_all(engine)
    api_db.bind_engine(engine, should_create=should_create,
                       should_drop=should_drop)


def make_engine(settings):
    """Construct a sqlalchemy engine from the passed ``settings``."""
    return engine_from_config(settings, 'sqlalchemy.')


def includeme(config):
    settings = config.registry.settings
    should_create = asbool(settings.get('h.db.should_create_all', False))
    should_drop = asbool(settings.get('h.db.should_drop_all', False))
    engine = make_engine(settings)

    # Add a property to all requests for easy access to the session. This means
    # that view functions need only refer to `request.db` in order to retrieve
    # the current database session.
    config.add_request_method(lambda req: Session(), name='db', reify=True)

    # Register a deferred action to bind the engine when the configuration is
    # committed. Deferring the action means that this module can be included
    # before model modules without ill effect.
    config.action(None, bind_engine, (engine,), {
        'should_create': should_create,
        'should_drop': should_drop
    })

    api_db.use_session(Session)
