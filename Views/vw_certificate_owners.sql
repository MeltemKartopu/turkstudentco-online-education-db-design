CREATE VIEW vw_certificate_owners AS
SELECT 
    m.pk_member_id,
    m.username,
    c.certificate_code,
    c.issued_date,
    crs.title AS course_title,
    ca.assigned_date,
    c.pdf_url
FROM certificate_assignments ca
JOIN members m ON ca.fk_member_id = m.pk_member_id
JOIN certificates c ON ca.fk_certificate_id = c.pk_certificate_id
JOIN courses crs ON c.fk_course_id = crs.pk_course_id;
-- Sertifika sahiplerini ve ilgili bilgileri listelemek için.
-- Bu görünüm, sertifika atamalarını ve sahiplerini hızlıca görüntülemek için kullanılır.
-- Create View şu işe yarar:
-- 1. Sertifika sahiplerinin bilgilerini hızlıca görüntülemek. 
-- 2. Sertifika kodu, veriliş tarihi ve kurs bilgilerini bir arada sunmak.
-- 3. Sertifika PDF URL'sini kolay erişim için sağlamak.
-- 4. Sertifika atama tarihini görmek için kullanılır.
--