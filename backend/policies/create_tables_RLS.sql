create policy "Public profiles viewable" on profiles for select using (true);
create policy "Users update own" on profiles for update using (auth.uid() = id);

create policy "Public posts viewable" on posts for select using (true);
create policy "Users insert own posts" on posts for insert with check (auth.uid() = user_id);
create policy "Users delete own posts" on posts for delete using (auth.uid() = user_id);

create policy "Public comments viewable" on comments for select using (true);
create policy "Users insert own comments" on comments for insert with check (auth.uid() = user_id);
create policy "Users delete own comments" on comments for delete using (auth.uid() = user_id);

create policy "Public votes viewable" on post_votes for select using (true);
create policy "Users vote posts" on post_votes for insert with check (auth.uid() = user_id);
create policy "Users unvote posts" on post_votes for delete using (auth.uid() = user_id);

create policy "Public comment votes viewable" on comment_votes for select using (true);
create policy "Users vote comments" on comment_votes for insert with check (auth.uid() = user_id);
create policy "Users unvote comments" on comment_votes for delete using (auth.uid() = user_id);

create policy "Public follows viewable" on follows for select using (true);
create policy "Users follow" on follows for insert with check (auth.uid() = follower_id);
create policy "Users unfollow" on follows for delete using (auth.uid() = follower_id);

create policy "Users view own bookmarks" on bookmarks for select using (auth.uid() = user_id);
create policy "Users bookmark posts" on bookmarks for insert with check (auth.uid() = user_id);
create policy "Users remove bookmark" on bookmarks for delete using (auth.uid() = user_id);

create policy "Users view own watchlist" on user_watchlist for select using (auth.uid() = user_id);
create policy "Users add to watchlist" on user_watchlist for insert with check (auth.uid() = user_id);
create policy "Users remove from watchlist" on user_watchlist for delete using (auth.uid() = user_id);