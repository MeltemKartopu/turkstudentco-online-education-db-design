CREATE VIEW vw_course_details AS
SELECT 
    c.pk_course_id,
    c.title,
    c.description,
    c.start_date,
    c.end_date,
    c.instructor,
    cat.category_name,
    cat.description AS category_description,
    c.is_published,
    c.language
FROM courses c
LEFT JOIN categories cat ON c.fk_category_id = cat.pk_category_id;
-- Bu görünüm, kurs detaylarını ve ilgili kategori bilgilerini bir arada sunar.
-- Özellikle kurs detay sayfalarında kullanılabilir.
