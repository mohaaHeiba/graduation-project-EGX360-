create or replace view comments_full_view as
select 
  c.id, c.post_id, c.parent_id, c.content, c.created_at, c.user_id,
  pr.name as user_name, pr.avatar_url as user_avatar,
  (select count(*) from public.comment_votes cv where cv.comment_id = c.id and cv.vote_type = 1) as likes_count,
  (select count(*) from public.comment_votes cv where cv.comment_id = c.id and cv.vote_type = -1) as dislikes_count
from public.comments c
left join public.profiles pr on c.user_id = pr.id
order by c.created_at asc;