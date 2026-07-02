from abc import ABC, abstractmethod

class IUserRepository(ABC):
    @abstractmethod
    async def save(self, email: str):
        pass

class SqlUserRepository(IUserRepository):
    def __init__(self, db_conn):
        # Store the db connection object in 'self'
        self.db_conn = db_conn

    async def save(self, email: str):
        await self.db_conn.execute(f"INSERT INTO users VALUES ('{email}')")


async def main():
    db = connect_to_sql_server()
    repo = SqlUserRepository(db)
    await repo.save("example@gmail.com")

