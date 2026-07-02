# Level 1: Extremely Coupled Architecture - Beginner
"""No repository, no interfaces
Why is not the best way to solve the problem? If later I want to create a test to find out if create_user blocks 
invalid emails, I must have an SQL server database running. Database offline -> Test crashes
"""
async def create_user(user_email: str):
    
    # Direct coupling: We connect directly to SQL server database
    db_connection = await connect_to_sql_server()

    # Hardcoded SQL details inside the business logic
    query = f"INSERT INTO administration.users (email) VALUES ('{user_email}')"
    await db_connection.execute(query)


# Level 2: Using the Repository pattern - Intermediate
"""
The Repository handles interaction with the DB
"""
class SqlUserRepository:
    def __init__(self, db_conn):
        self.db_conn = db_conn

