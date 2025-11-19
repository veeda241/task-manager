import enum
from datetime import datetime
from typing import Optional
from pydantic import BaseModel
class TaskStatus(str, enum.Enum):
    to_do = "To Do"
    in_progress = "In Progress"
    done = "Done"
class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    status: TaskStatus = TaskStatus.to_do
    due_date: Optional[datetime] = None
class TaskCreate(TaskBase):
    pass
class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    status: Optional[TaskStatus] = None
    due_date: Optional[datetime] = None
class Task(TaskBase):
    id: int
    owner_id: int
    created_at: datetime
    class Config:
        from_attributes = True
class UserBase(BaseModel):
    username: str
    email: str
class UserCreate(UserBase):
    password: str
class User(UserBase):
    id: int
    created_at: datetime
    class Config:
        from_attributes = True
class Token(BaseModel):
    access_token: str
    token_type: str