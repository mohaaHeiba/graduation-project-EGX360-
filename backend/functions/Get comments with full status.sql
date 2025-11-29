create or replace function get_comments_with_status(viewer_id uuid, target_post_id bigint)
returns table (
  id bigint, post_id bigint, parent_id bigint, content text, created_at timestamptz,
  user_id uuid, user_name text, user_avatar text,
  likes_count bigint, dislikes_count bigint,
  user_vote_type int, parent_username text
) 
language plpgsql as $$
begin
  return query
  select 
    c.id, c.post_id, c.parent_id, c.content, c.created_at, c.user_id,
    pr.name::text, pr.avatar_url::text,
    (select count(*) from public.comment_votes cv where cv.comment_id = c.id and cv.vote_type = 1),
    (select count(*) from public.comment_votes cv where cv.comment_id = c.id and cv.vote_type = -1),
    (select vote_type from public.comment_votes cv where cv.comment_id = c.id and cv.user_id = viewer_id),
    (select p2.name::text from public.comments c2 join public.profiles p2 on c2.user_id = p2.id where c2.id = c.parent_id)
  from public.comments c
  left join public.profiles pr on c.user_id = pr.id
  where c.post_id = target_post_id
  order by c.created_at asc;
end;
$$;