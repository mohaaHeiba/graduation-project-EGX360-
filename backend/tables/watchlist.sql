create table public.user_watchlist (
  user_id uuid references public.profiles(id) on delete cascade not null,
  stock_symbol text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  primary key (user_id, stock_symbol)
);