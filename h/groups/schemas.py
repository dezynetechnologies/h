# -*- coding: utf-8 -*-

import colander

from h import i18n
from h.accounts.schemas import CSRFSchema
from h.groups.models import GROUP_NAME_MIN_LENGTH
from h.groups.models import GROUP_NAME_MAX_LENGTH


_ = i18n.TranslationString


class GroupSchema(CSRFSchema):

    """The schema for the create-a-new-group form."""

    name = colander.SchemaNode(
        colander.String(),
        title=_("Group name"),
        hint=_("a human-readable name for your group"),
        validator=colander.Length(
            min=GROUP_NAME_MIN_LENGTH,
            max=GROUP_NAME_MAX_LENGTH))
