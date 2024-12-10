CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- CREATE TABLE USER
CREATE TABLE users (
	user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	user_name varchar(25) UNIQUE NOT NULL, 
	user_password varchar(250) NOT NULL,
	user_email varchar(50) NOT NULL
);

--CREATE TABLE TASK
CREATE TABLE task (
	task_id UUID  PRIMARY KEY DEFAULT gen_random_uuid(),
	task_description text,
	task_title varchar (25),
	task_date timestamp DEFAULT CURRENT_TIMESTAMP,
	task_completed boolean DEFAULT FALSE,
	user_id UUID REFERENCES users(user_id)
);

--THIS FUNCTION CREATE A USER IN TABLE USERS
CREATE OR REPLACE FUNCTION create_user(
	_user_name varchar,
	_user_password varchar,
	_user_email varchar
)
RETURNS VOID AS $$
BEGIN
	INSERT INTO users(user_name, user_password,user_email)
	VALUES(_user_name, _user_password, _user_email);
END;
$$ LANGUAGE PLPGSQL;

--THIS FUNCTION CATCH THE DATA OF A USER OF TABLE USERS
CREATE OR REPLACE FUNCTION list_user(
	_user_name varchar
)
RETURNS TABLE (_user_id UUID, _user_password varchar) AS $$
BEGIN
	RETURN QUERY
	SELECT user_id, user_password FROM users WHERE user_name = _user_name;
END;
$$LANGUAGE PLPGSQL;


--THIS FUNCTION ADD A TASK TO TABLE TASK
CREATE OR REPLACE FUNCTION add_task(
	_task_description text,
	_task_title varchar,
	_user_id UUID
) 
RETURNS VOID AS $$
BEGIN
	INSERT INTO task(task_description, task_title, user_id) 
	VALUES(_task_description, _task_title, _user_id);
END;
$$ LANGUAGE PLPGSQL;

-- THIS FUNCTION DELETE A TASK FROM TABLE TASK
CREATE OR REPLACE FUNCTION delete_task(_task_id UUID)
RETURNS VOID AS $$ 
BEGIN
	DELETE FROM task
	WHERE _task_id = _task_id;
END;
$$ LANGUAGE PLPGSQL;

--THIS FUNCTION UPDATE TASK TO TABLE TASK
CREATE OR REPLACE FUNCTION update_task(
	_task_id UUID,
	_task_description text,
	_task_title varchar,
	_task_completed boolean
)
RETURNS VOID AS $$
BEGIN
	UPDATE task 
	SET task_description = _task_description,
		task_title = _task_title,
		task_completed = _task_completed
	WHERE task_id=_task_id;
END;
$$ lANGUAGE PLPGSQL;



