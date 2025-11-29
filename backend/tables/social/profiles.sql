create table if not exists public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  email varchar(255) unique not null,
  name varchar(255),
  avatar_url varchar(255),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);