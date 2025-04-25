CREATE VIEW vw_member_courses AS
SELECT 
    m.pk_member_id,
    m.username,
    m.email,
    c.pk_course_id,
    c.title AS course_title,
    e.enrolled_at,
    e.completion_status,
    e.progress_percent
FROM members m
JOIN enrollments e ON m.pk_member_id = e.fk_member_id
JOIN courses c ON e.fk_course_id = c.pk_course_id;
--Bu görünüm, üyelerin kurs kayıtlarını ve ilgili bilgileri listelemek için kullanılır.
--Özellikle kullanıcıların hangi kurslara kayıtlı olduğunu ve ilerleme durumlarını görüntülemek için yararlıdır.
