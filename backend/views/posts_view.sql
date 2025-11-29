create or replace view posts_view as
select 
  p.id, p.user_id, p.content, p.image_url, p.created_at, p.sentiment, p.cashtags,
  pr.name as user_name, pr.avatar_url as user_avatar,
  (select count(*) from public.post_votes v where v.post_id = p.id and v.vote_type = 1) as likes_count,
  (select count(*) from public.post_votes v where v.post_id = p.id and v.vote_type = -1) as dislikes_count,
  (select count(*) from public.comments c where c.post_id = p.id) as comments_count
from public.posts p
left join public.profiles pr on p.user_id = pr.id;