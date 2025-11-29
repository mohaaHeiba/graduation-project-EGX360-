create table public.post_votes (
  user_id uuid references public.profiles(id) on delete cascade not null,
  post_id bigint references public.posts(id) on delete cascade not null,
  vote_type int not null check (vote_type in (1, -1)),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  primary key (user_id, post_id)
);