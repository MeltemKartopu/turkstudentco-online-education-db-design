CREATE VIEW vw_blog_with_authors AS
SELECT 
    b.pk_blog_post_id,
    b.title,
    b.content,
    b.published_at,
    b.last_edited_at,
    b.likes,
    b.comments_count,
    m.pk_member_id AS author_id,
    m.username AS author_username,
    m.first_name,
    m.last_name
FROM blog_posts b
JOIN members m ON b.fk_author_id = m.pk_member_id;
-- Yazar bilgisiyle birlikte blog gönderilerini listelemek için.
-- Bu görünüm, blog gönderilerinin yazar bilgileriyle birlikte hızlıca erişilmesini sağlar.
-- Özellikle blog gönderilerini listeleme ve detay sayfalarında kullanılabilir.