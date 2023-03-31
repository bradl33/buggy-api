BEGIN;
    DO
    '
    DECLARE
    BEGIN
        -- create role_enum enum type if does not exist
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = ''role_enum'') THEN
            CREATE TYPE role_enum AS ENUM (
                ''PROJECT_MANAGER'', ''QA'', ''DEVELOPER'', ''CLIENT''
                );
        END IF;

        --create project_status_enum enum type if does not exist
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = ''project_status_enum'') THEN
            CREATE TYPE project_status_enum AS ENUM (
                ''DEVELOPMENT'', ''PRODUCTION'', ''MAINTENANCE'', ''ARCHIVED''
                );
        END IF;

        --create bug_status_enum enum type if does not exist
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = ''bug_status_enum'') THEN
            CREATE TYPE bug_status_enum AS ENUM (
                ''NEW'', ''OPEN'', ''ASSIGNED'', ''IN PROGRESS'', ''TESTING'', ''VERIFIED'', ''CLOSED'', ''REOPENED''
                );
        END IF;

        -- create sequences
        CREATE SEQUENCE IF NOT EXISTS user_id_seq;
        CREATE SEQUENCE IF NOT EXISTS project_id_seq;
        CREATE SEQUENCE IF NOT EXISTS bug_id_seq;
        CREATE SEQUENCE IF NOT EXISTS bug_note_id_seq;


        -- create users table if does not exist
        CREATE TABLE IF NOT EXISTS user_ (
             id BIGINT DEFAULT nextval(''user_id_seq'') PRIMARY KEY,
             first_name VARCHAR(25) NOT NULL,
             last_name VARCHAR(25) NOT NULL,
             email_address VARCHAR(50) UNIQUE NOT NULL,
             username VARCHAR(16) UNIQUE NOT NULL,
             hashed_password VARCHAR NOT NULL,
             title VARCHAR(50),
             role role_enum,
             created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
             updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );

        -- create project table if does not exist
        CREATE TABLE IF NOT EXISTS project_ (
            id BIGINT DEFAULT nextval(''project_id_seq'') PRIMARY KEY,
            title VARCHAR(25) NOT NULL,
            description TEXT,
            status project_status_enum NOT NULL,
            start_date TIMESTAMP,
            end_date TIMESTAMP,
            created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );

        -- create bug table if does not exist
        -- keeps a record of details on a bug
        CREATE TABLE IF NOT EXISTS bug_ (
            id BIGINT DEFAULT nextval(''bug_id_seq'') PRIMARY KEY,
            title VARCHAR(25) NOT NULL,
            description TEXT,
            priority INT NOT NULL,
            status bug_status_enum NOT NULL,
            due_date TIMESTAMP,
            project_id BIGINT REFERENCES project_(id) NOT NULL,
            created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );

        -- create table bug_note_ if does not exist
        -- keeps a record of notes attached to a bug, by which user, and when
        CREATE TABLE IF NOT EXISTS bug_note_ (
            id BIGINT DEFAULT nextval(''bug_note_id_seq'') PRIMARY KEY,
            bug_id BIGINT REFERENCES bug_(id) NOT NULL,
            note_content TEXT NOT NULL,
            user_id BIGINT REFERENCES user_(id) NOT NULL,
            created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            -- user can leave multiple notes on a bug, but created at different time
            -- useful when, say, user gets reassigned bug
             CONSTRAINT unique_bug_user_note UNIQUE (bug_id, user_id, created_on)
        );
    END;
    ' LANGUAGE plpgsql;
COMMIT;