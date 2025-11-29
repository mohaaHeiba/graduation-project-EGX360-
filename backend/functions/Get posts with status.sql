create or replace function get_posts_with_status(viewer_id uuid, target_user_id uuid)
returns table (
  id bigint, user_id uuid, content text, image_url text, sentiment text, cashtags text[],
  created_at timestamptz, user_name text, user_avatar text,
  likes_count bigint, dislikes_count bigint, comments_count bigint,
  is_liked boolean, is_bookmarked boolean
) 
language plpgsql as $$
begin
  return query
  select 
    p.id, p.user_id, p.content, p.image_url, p.sentiment::text, p.cashtags, p.created_at,
    pr.name::text, pr.avatar_url::text,
    (select count(*) from public.post_votes v where v.post_id = p.id and v.vote_type = 1),
    (select count(*) from public.post_votes v where v.post_id = p.id and v.vote_type = -1),
    (select count(*) from public.comments c where c.post_id = p.id),
    exists(select 1 from public.post_votes v where v.post_id = p.id and v.user_id = viewer_id and v.vote_type = 1),
    exists(select 1 from public.bookmarks b where b.post_id = p.id and b.user_id = viewer_id)
  from public.posts p
  left join public.profiles pr on p.user_id = pr.id
  where p.user_id = target_user_id
  order by p.created_at desc;
end;
$$;