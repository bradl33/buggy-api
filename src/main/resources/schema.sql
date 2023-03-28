-- role enums
CREATE TYPE ROLE_ AS ENUM (
    'PROJECT_MANAGER', 'QA', 'DEVELOPER', 'CLIENT'
    );

-- project status enums
CREATE TYPE PROJECT_STATUS_ AS ENUM (
    'ACTIVE', 'ARCHIVED'
    );

-- bug status enums
CREATE TYPE BUG_STATUS_ AS ENUM (
    'OPEN', 'ASSIGNED', 'IN PROGRESS', 'TESTING', 'VERIFIED', 'CLOSED', 'REOPENED'
    );

-- Create users table
CREATE TABLE IF NOT EXISTS user_ (
                                     id SERIAL PRIMARY KEY,
                                     first_name VARCHAR(25) NOT NULL,
                                     last_name VARCHAR(25) NOT NULL,
                                     email_address VARCHAR(50) UNIQUE NOT NULL,
                                     username VARCHAR(16) UNIQUE NOT NULL,
                                     hashed_password VARCHAR NOT NULL,
                                     title VARCHAR(50) NOT NULL,
                                     role ROLE_ NOT NULL,
                                     created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- create project table
CREATE TABLE IF NOT EXISTS project_ (
                                        id SERIAL PRIMARY KEY,
                                        title VARCHAR(25) NOT NULL,
                                        description TEXT,
                                        status PROJECT_STATUS_ NOT NULL,
                                        start_date TIMESTAMP,
                                        end_date TIMESTAMP,
                                        created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- create bug table
-- keeps a record of details on a bug
CREATE TABLE IF NOT EXISTS bug_ (
                                    id SERIAL PRIMARY KEY,
                                    title VARCHAR(25) NOT NULL,
                                    description TEXT,
                                    priority INT NOT NULL,
                                    status BUG_STATUS_ NOT NULL,
                                    due_date TIMESTAMP,
                                    project_id INT REFERENCES project_(id),
                                    created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- create table bug_note_
-- keeps a record of notes attached to a bug, by which user, and when
CREATE TABLE IF NOT EXISTS bug_note_ (
                                         id SERIAL PRIMARY KEY,
                                         bug_id INT REFERENCES bug_(id),
                                         note_content TEXT NOT NULL,
                                         user_id INT REFERENCES user_(id),
                                         created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ensures a user can only leave one note per bug
-- If need to have multiple notes, user can edit previous note
ALTER TABLE bug_note_ ADD CONSTRAINT unique_bug_user_note UNIQUE (bug_id, user_id);