------------------------------ [INSERT SIRASI] ------------------------------
-- 1. Kategoriler (Parent)
-- 2. Üyeler (Parent)
-- 3. Kurslar (Child: categories'e bağlı)
-- 4. Blog Gönderileri (Child: members'a bağlı)
-- 5. Katılımlar (Child: members ve courses'a bağlı)
-- 6. Sertifikalar (Child: courses'a bağlı)
-- 7. Sertifika Atamaları (Child: members ve certificates'a bağlı)

------------------------------ [1. KATEGORİLER] ------------------------------
INSERT INTO categories (category_name, description) 
VALUES
('Programlama', 'Yazılım geliştirme ve programlama dilleri'),
('Veri Bilimi', 'Veri analizi ve makine öğrenmesi'),
('Kişisel Gelişim', 'Kariyer ve kişisel gelişim kursları');

------------------------------ [2. ÜYELER] ------------------------------
INSERT INTO members (username, email, password, first_name, last_name, bio, level) 
VALUES
('ahmet_yilmaz', 'ahmet@kodluyoruz.com', '$2a$12$xyz123...', 'Ahmet', 'Yılmaz', 'FullStack Developer', 2),
('zeynep_ai', 'zeynep@deeplearning.tr', '$2a$12$abc456...', 'Zeynep', 'Demir', 'AI Researcher', 3),
('mehmet_career', 'mehmet@kariyer.com', '$2a$12$def789...', 'Mehmet', 'Kaya', NULL, 1);

------------------------------ [3. KURSLAR] ------------------------------
-- Kategori ID'lerini manuel girmek yerine subquery ile alma
INSERT INTO courses (title, description, start_date, instructor, fk_category_id, language) 
VALUES
(
  'Python 360°', 
  'Sıfırdan uzman seviyeye Python', 
  '2024-09-01', 
  'Elif Yıldız', 
  (SELECT pk_category_id FROM categories WHERE category_name = 'Programlama'), 
  'Türkçe'
),
(
  'Veri Bilimi Bootcamp', 
  'Pandas, NumPy ve Makine Öğrenmesi', 
  '2024-10-15', 
  'Dr. Can Aksoy', 
  (SELECT pk_category_id FROM categories WHERE category_name = 'Veri Bilimi'), 
  'Türkçe'
);

------------------------------ [4. BLOG GÖNDERİLERİ] ------------------------------
INSERT INTO blog_posts (title, content, fk_author_id) 
VALUES
(
  'Python ile Web Scraping', 
  'BeautifulSoup kütüphanesi detaylı rehber...', 
  (SELECT pk_member_id FROM members WHERE username = 'ahmet_yilmaz')
),
(
  'Derin Öğrenme Trendleri 2024', 
  'LLM''ler ve Multi-Modal AI sistemleri...', 
  (SELECT pk_member_id FROM members WHERE username = 'zeynep_ai')
);

------------------------------ [5. KATILIMLAR] ------------------------------
INSERT INTO enrollments (fk_member_id, fk_course_id, progress_percent) 
VALUES
(
  (SELECT pk_member_id FROM members WHERE username = 'ahmet_yilmaz'),
  (SELECT pk_course_id FROM courses WHERE title = 'Python 360°'),
  35
),
(
  (SELECT pk_member_id FROM members WHERE username = 'zeynep_ai'),
  (SELECT pk_course_id FROM courses WHERE title = 'Veri Bilimi Bootcamp'),
  82
);

------------------------------ [6. SERTİFİKALAR] ------------------------------
INSERT INTO certificates (certificate_code, fk_course_id, pdf_url) 
VALUES
(
  'CERF-PYTHON-2024-12345', 
  (SELECT pk_course_id FROM courses WHERE title = 'Python 360°'), 
  'https://cdn.example.com/certs/ahmet_python.pdf'
),
(
  'CERF-DATASCI-2024-67890', 
  (SELECT pk_course_id FROM courses WHERE title = 'Veri Bilimi Bootcamp'), 
  'https://cdn.example.com/certs/zeynep_ds.pdf'
);

------------------------------ [7. SERTİFİKA ATAMALARI] ------------------------------
INSERT INTO certificate_assignments (fk_member_id, fk_certificate_id) 
VALUES
(
  (SELECT pk_member_id FROM members WHERE username = 'ahmet_yilmaz'),
  (SELECT pk_certificate_id FROM certificates WHERE certificate_code = 'CERF-PYTHON-2024-12345')
),
(
  (SELECT pk_member_id FROM members WHERE username = 'zeynep_ai'),
  (SELECT pk_certificate_id FROM certificates WHERE certificate_code = 'CERF-DATASCI-2024-67890')
);