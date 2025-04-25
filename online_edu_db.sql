------------------------------ 1. ÜYELER TABLOSU ------------------------------
CREATE TABLE members (
    pk_member_id BIGSERIAL PRIMARY KEY, 
    -- BIGSERIAL: Uzun vadede milyonlarca üye olabileceği için BIGINT (8 byte) tercih edildi. 
    -- Otomatik artan ID üretir. Manuel ID atamasına gerek kalmaz.
    
    username VARCHAR(50) UNIQUE NOT NULL, 
    -- VARCHAR(50): Kullanıcı adı için 50 karakter yeterli (Twitter 15, Instagram 30 karakter).
    -- UNIQUE: Aynı kullanıcı adıyla tek kayıt olabilmeli.
    -- NOT NULL: Kullanıcı adı zorunlu alan. Boş bırakılamaz.
    
    email VARCHAR(100) UNIQUE NOT NULL, 
    -- VARCHAR(100): E-posta adresleri genelde 100 karakteri geçmez (RFC standartları).
    -- UNIQUE+NOT NULL: Her üye benzersiz ve geçerli bir e-posta ile kayıt olmalı.
    
    password VARCHAR(255) NOT NULL, 
    -- VARCHAR(255): Şifre hash'leri (BCrypt gibi) genelde 60-120 karakter arasındadır. 
    -- 255 karakter güvenli bir üst sınırdır.
    
    registered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    -- TIMESTAMP: Kayıt zamanını saat:dakika:saniye bilgisiyle tutar (DATE yerine).
    -- DEFAULT: Kayıt anını otomatik alır. Kullanıcıdan tarih bilgisi istemeye gerek yok.
    
    first_name VARCHAR(50) NOT NULL, 
    -- Proje dokümanında NOT NULL belirtilmemiş ancak isim boş olmamalı. 
    -- Gerçek dünya senaryosunda bu alan zorunlu olur.
    
    last_name VARCHAR(50) NOT NULL, -- Yukarıdaki ile aynı mantık.
    
    profile_picture_url VARCHAR(255), 
    -- VARCHAR(255): URL'ler için yeterli uzunluk. Örnek: AWS S3 URL'leri ~150 karakter.
    -- NULL izin verilir çünkü kullanıcı profil fotoğrafı yüklemek zorunda değil.
    
    bio TEXT, -- TEXT: Sınırsız uzunlukta metin (VARCHAR(1000) yerine daha esnek).
    
    level INTEGER DEFAULT 1, 
    -- DEFAULT 1: Yeni kayıtlı kullanıcılar otomatik 1. seviyede başlar.
    -- INTEGER: Seviyelerin 2 milyarı geçmesi beklenmediği için yeterli.
    
    is_active BOOLEAN DEFAULT TRUE 
    -- DEFAULT TRUE: Yeni üyeler aktif kabul edilir. 
    -- Hesap askıya alındığında FALSE yapılabilir.
);

------------------------------ 2. KATEGORİLER TABLOSU ------------------------------
CREATE TABLE categories (
    pk_category_id SMALLSERIAL PRIMARY KEY, 
    -- SMALLSERIAL: Kategori sayısı 32,767'den az olacağı varsayımıyla SMALLINT (2 byte) kullanıldı.
    -- Disk tasarrufu ve performans için optimize edildi.
    
    category_name VARCHAR(100) UNIQUE NOT NULL, 
    -- VARCHAR(100): "Yapay Zeka ve Makine Öğrenmesi" gibi uzun isimler için yeterli.
    -- UNIQUE: Aynı isimde iki kategori olamaz (veri tutarlılığı için kritik).
    
    description TEXT -- Kategori detayları için sınırsız metin alanı.
);

------------------------------ 3. EĞİTİMLER TABLOSU ------------------------------
CREATE TABLE courses (
    pk_course_id BIGSERIAL PRIMARY KEY, -- Yüksek sayıda kurs için BIGINT.
    
    title VARCHAR(200) NOT NULL, 
    -- VARCHAR(200): Örnek: "Python ile Sıfırdan İleri Seviye Web Geliştirme: Django, Flask ve FastAPI"
    -- 200 karakter çoğu kurs başlığı için yeterli.
    
    description TEXT, -- Kurs detayları için zengin metin gerekebilir.
    
    start_date DATE NOT NULL, 
    -- DATE: Başlangıç tarihi saat bilgisi gerektirmez (TIMESTAMP gereksiz).
    
    end_date DATE, -- NULL olabilir: Süresiz açık kurslar için.
    
    instructor VARCHAR(100) NOT NULL, 
    -- NOT NULL: Eğitmensiz kurs olmaz. Projede belirtilmemiş ancak mantıklı.
    
    fk_category_id SMALLINT REFERENCES categories(pk_category_id), 
    -- SMALLINT: categories tablosu ile uyumlu.
    -- NULL olabilir: Kategorisiz kurslar için esneklik.
    
    is_published BOOLEAN DEFAULT TRUE, 
    -- DEFAULT TRUE: Yeni eklenen kurs direkt yayınlansın.
    
    language VARCHAR(50) DEFAULT 'Türkçe', 
    -- DEFAULT: Platformun ana dili Türkçe. İsteğe bağlı İngilizce kurslar olabilir.
    
    thumbnail_url VARCHAR(255) -- Kapak görseli URL'si.
);

------------------------------ 4. KATILIMLAR TABLOSU ------------------------------
CREATE TABLE enrollments (
    pk_enrollment_id BIGSERIAL PRIMARY KEY, 
    -- BIGSERIAL: Potansiyel milyarlarca katılım kaydı için.
    
    fk_member_id BIGINT NOT NULL REFERENCES members(pk_member_id), 
    -- BIGINT: members tablosu ile uyumlu.
    -- NOT NULL: Anonim katılım olmamalı.
    
    fk_course_id BIGINT NOT NULL REFERENCES courses(pk_course_id), 
    -- BIGINT: courses tablosu ile uyumlu.
    
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    -- TIMESTAMP: Katılımın tam zamanı (saat 10:00 vs 14:00 farklı kayıtlar için).
    
    completion_status VARCHAR(20) DEFAULT 'devam ediyor' CHECK (
        completion_status IN ('tamamlandı', 'devam ediyor', 'iptal edildi')
    ), 
    -- CHECK: Sadece geçerli durumlar girilebilir. Geçersiz değerler engellenir.
    -- DEFAULT: Yeni kayıtlar otomatik "devam ediyor" olarak işaretlenir.
    
    progress_percent INTEGER DEFAULT 0 CHECK (
        progress_percent BETWEEN 0 AND 100
    ) 
    -- CHECK: Yüzde 0-100 dışında değer girilmesi engellenir (örneğin 120% hatalı olur).
    -- DEFAULT 0: Yeni kayıtlarda ilerleme sıfırdan başlar.
);

------------------------------ 5. SERTİFİKALAR TABLOSU ------------------------------
CREATE TABLE certificates (
    pk_certificate_id BIGSERIAL PRIMARY KEY, 
    certificate_code VARCHAR(100) UNIQUE NOT NULL, 
    -- UNIQUE: Her sertifika kodu eşsiz olmalı (sahte sertifika üretimini önlemek için).
    -- Örnek kod: "UDEMY-PYTHON-ABC123" gibi formatlı değerler.
    
    issued_date DATE NOT NULL DEFAULT CURRENT_DATE, 
    -- DATE: Sertifikanın veriliş günü (saat bilgisi gerekmez).
    
    fk_course_id BIGINT NOT NULL REFERENCES courses(pk_course_id), 
    -- NOT NULL: Her sertifika bir kursa ait olmalı.
    -- Kurs silinirse sertifika da silinmeli (ON DELETE CASCADE eklenebilir).
    
    pdf_url VARCHAR(255) NOT NULL 
    -- NOT NULL: Sertifika PDF'i mutlaka bir URL'de barındırılmalı.
);

------------------------------ 6. SERTİFİKA ATAMALARI TABLOSU ------------------------------
CREATE TABLE certificate_assignments (
    pk_certificate_assignment_id BIGSERIAL PRIMARY KEY, 
    fk_member_id BIGINT NOT NULL REFERENCES members(pk_member_id), 
    -- NOT NULL: Anonim kullanıcıya sertifika atanamaz.
    
    fk_certificate_id BIGINT NOT NULL REFERENCES certificates(pk_certificate_id), 
    -- NOT NULL: Geçersiz sertifika ataması yapılamaz.
    
    assigned_date DATE DEFAULT CURRENT_DATE 
    -- DEFAULT: Atama tarihi otomatik alınır (elle girilmesine gerek yok).
);

------------------------------ 7. BLOG GÖNDERİLERİ TABLOSU ------------------------------
CREATE TABLE blog_posts (
    pk_blog_post_id BIGSERIAL PRIMARY KEY, 
    title VARCHAR(255) NOT NULL, 
    -- VARCHAR(255): Uzun blog başlıkları için (ör: "Yapay Zeka ve Etik: Geleceğimizi Nasıl Şekillendiriyor?").
    
    content TEXT NOT NULL, 
    -- TEXT: Blog içeriği için sınırsız alan (10 bin karakter sınırı koymak mantıksız olurdu).
    
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    -- DEFAULT: Yayınlanma zamanı otomatik kaydedilir.
    
    fk_author_id BIGINT NOT NULL REFERENCES members(pk_member_id), 
    -- NOT NULL: Anonim gönderi olamaz. Her blogun bir yazarı olmalı.
    
    likes INTEGER DEFAULT 0 CHECK (likes >= 0), 
    -- CHECK: Negatif beğeni olmaz. Trolleri engellemek için.
    
    comments_count INTEGER DEFAULT 0 CHECK (comments_count >= 0), 
    -- CHECK: Negatif yorum sayısı mantıksız.
    
    last_edited_at TIMESTAMP 
    -- NULL olabilir: Gönderi hiç düzenlenmediyse bu alan boş kalır.
    -- Düzenleme yapıldığında CURRENT_TIMESTAMP otomatik güncellenebilir (trigger gerekli).
);

------------------------------ İNDEKSLER ------------------------------
-- Arama performansını artırmak için
CREATE INDEX idx_courses_category ON courses(fk_category_id);
-- Kursları kategoriye göre filtrelerken hız kazandırır (ör: "Tüm Python kurslarını listele").

CREATE INDEX idx_enrollments_member ON enrollments(fk_member_id);
-- Kullanıcının katıldığı kursları hızlıca getirmek için (Profil sayfası için kritik).

CREATE INDEX idx_certificates_course ON certificates(fk_course_id);
-- Bir kursa ait sertifikaları hızla listelemek için (Kurs detay sayfasında kullanılır).    
