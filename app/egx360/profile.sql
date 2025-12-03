create table profiles (
    id uuid primary key default gen_random_uuid(),
    name varchar(255) not null,
    email varchar(255) unique not null,
    avatar_url varchar(255),
    last_active_at timestamp,
    created_at timestamp default now(),
    updated_at timestamp default now()
);
