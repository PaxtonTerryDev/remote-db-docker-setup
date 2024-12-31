class Database:
    def __init__(self, sid=None, pwd=None):
        self.sid = sid
        self.pwd = pwd

    def __repr__(self):
        return f"Database(sid={self.sid}, pwd={self.pwd})"


class Target(Database):
    def __init__(self, sid=None, pwd=None):
        super().__init__(sid, pwd)

    def __repr__(self):
        return f"Target(sid={self.sid}, pwd={self.pwd})"


class Schema:
    def __init__(self, name=None, pwd=None):
        self.name = name
        self.pwd = pwd

    def __repr__(self):
        return f"Schema(name={self.name}, pwd={self.pwd})"


class Source(Database):
    def __init__(self, sid=None, pwd=None, schemas=None):
        super().__init__(sid, pwd)
        self.schemas = [Schema(**schema) for schema in schemas] if schemas else []

    def __repr__(self):
        return f"Source(sid={self.sid}, pwd={self.pwd}, schemas={self.schemas})"


class Config:
    def __init__(self, target=None, source=None):
        self.target = Target(**target) if target else None
        self.source = Source(**source) if source else None

    def __repr__(self):
        return f"Config(target={self.target}, source={self.source})"