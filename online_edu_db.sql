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
    -- VARCHAR(255): Şifreler genelde 60-100 karakter uzunluğunda olduğu için seçildi.
    -- NOT NULL: Şifre zorunlu alan. Boş bırakılamaz.
    -- 255 karakter güvenli bir üst sınırdır.
    
    registered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    -- TIMESTAMP: Kayıt zamanını saat:dakika:saniye bilgisiyle tutuğu için DATE yerine seçildi.
    -- NOT NULL: Kayıt tarihi zorunlu.
    -- DEFAULT: Kayıt anını otomatik alır. 
    
    first_name VARCHAR(50) NOT NULL, 
    -- Proje dokümanında NOT NULL belirtilmemiş ancak isim boş olmaması gerektiği için zorunlu yapıldı.
    -- VARCHAR(50): 50 karakter çoğu isim için yeterli.
    -- NOT NULL: Kullanıcı adı boş olamaz.
    
    last_name VARCHAR(50) NOT NULL, -- Yukarıdaki ile aynı mantık.
    
    profile_picture_url VARCHAR(255), 
    -- VARCHAR(255): URL'ler için yeterli uzunluk. Örnek: AWS S3 URL'leri ~150 karakter.
    -- NULL izin verilir çünkü kullanıcı profil fotoğrafı yüklemek zorunda değil.
    
    bio TEXT, -- TEXT: Sınırsız uzunlukta metin kullanımı için kullanıldı.
    
    level INTEGER DEFAULT 1, 
    -- DEFAULT 1: Yeni kayıtlı kullanıcılar otomatik 1. seviyede başlar.
    -- INTEGER: Seviyelerin 2 milyarı geçmesi beklenmediği için yeterli.
    
    is_active BOOLEAN DEFAULT TRUE 
    -- DEFAULT TRUE: Yeni üyeler aktif kabul edilir. 
    -- boolean: 1 bitlik alan (TRUE/FALSE) için kullanıldı.
    -- Hesap askıya alındığında FALSE yapılabilir.
);

------------------------------ 2. KATEGORİLER TABLOSU ------------------------------
CREATE TABLE categories (
    pk_category_id SMALLSERIAL PRIMARY KEY, 
    -- SMALLSERIAL: Küçük veri setleri için yeterli olduğu için 2 byte kullanıldı.
    -- Otomatik artan ID üretir. Manuel ID atamasına gerek kalmadığı için SERIAL yerine SMALLSERIAL seçildi.
    
    category_name VARCHAR(100) UNIQUE NOT NULL, 
    -- VARCHAR(100): "Yapay Zeka ve Makine Öğrenmesi" gibi uzun isimler için yeterli olduğu için 100 karakter seçildi.
    -- NOT NULL: Kategori ismi boş olamaz.
    -- UNIQUE: Aynı isimde iki kategori olamaz (veri tutarlılığı için kritik).
    
    description TEXT -- Kategori detayları için sınırsız metin alanı sağladığı için TEXT kullanıldı.
    -- NULL olabilir: Kategorinin açıklaması zorunlu değil.
);

------------------------------ 3. EĞİTİMLER TABLOSU ------------------------------
CREATE TABLE courses (
    pk_course_id BIGSERIAL PRIMARY KEY, -- BiGSERIAL: Uzun vadede milyonlarca kurs olabileceği için BIGINT (8 byte) tercih edildi.
    -- Otomatik artan ID üretir. Manuel ID atamasına gerek kalmaz.  
    
    title VARCHAR(200) NOT NULL, 
    -- VARCHAR(200): Kurs başlıkları genelde 100-150 karakteri geçmez.

    description TEXT, -- Kurs açıklamaları için sınırsız metin alanı sağladığı için TEXT kullanıldı.
    
    start_date DATE NOT NULL, 
    -- DATE: Saat bilgisi gerekmediği için DATE yeterli olduğundan kullanıldı.
    -- NOT NULL: Kurs başlangıç tarihi zorunlu. Boş bırakılamaz.
    
    end_date DATE, -- NULL: Kursun bitiş tarihi zorunlu değil. Bazı kurslar sürekli açık olabilir.
    
    instructor VARCHAR(100) NOT NULL, 
    -- NOT NULL: Eğitmensiz kurs olmaz.
    -- VARCHAR(100): Eğitmen isimleri genelde 50-100 karakteri geçmediği için 100 karakter kullanıldı.
    
    fk_category_id SMALLINT REFERENCES categories(pk_category_id), 
    -- SMALLINT: Karegori ID'leri için yeterli. 2 byte kullanıldı.
    -- FOREIGN KEY: courses tablosu categories tablosuna bağlı.
    -- NULL olabilir: Kategorisiz kurslar için esneklik.
    
    is_published BOOLEAN DEFAULT TRUE, 
    -- DEFAULT TRUE: Yeni kurslar otomatik olarak yayınlanması için ayarlandı.
    -- BOOLEAN: 1 bitlik alan (TRUE/FALSE) için kullanıldı.
    -- Default ne işe yarar: Yeni kurslar otomatik olarak yayınlanır. Eğitmen kursu iptal ederse FALSE yapılabilir.
    
    language VARCHAR(50) DEFAULT 'Türkçe', 
    -- DEFAULT: Platformun ana dili Türkçe. İsteğe bağlı İngilizce kurslar olabilir.
    -- VARCHAR(50): Kurs dilleri genelde 50 karakteri geçmediği için kullanıldı.
    
    thumbnail_url VARCHAR(255) -- Kapak görseli URL'si.
    -- VARCHAR(255), URL'ler için yeterli uzunluk olduğu için kullanıldı.
    -- NULL olabilir: Kapak görseli zorunlu değil. Eğitmen ekleyebilir.
);

------------------------------ 4. KATILIMLAR TABLOSU ------------------------------
CREATE TABLE enrollments (
    pk_enrollment_id BIGSERIAL PRIMARY KEY, 
    -- BIGSERIAL: Potansiyel milyarlarca katılım kaydı için.
    -- Otomatik artan ID üretir. Manuel ID atamasına gerek kalmaz.
    -- NOT NULL: Katılım ID'si zorunlu. Boş bırakılamaz.
    
    fk_member_id BIGINT NOT NULL REFERENCES members(pk_member_id), 
    -- BIGINT bigserials yerine kullanıldı çünkü enrollments tablosu members tablosuna bağlı, otomatik artan ID olması gerekmiyor..
    -- FOREIGN KEY: enrollments tablosu members tablosuna bağlı.
    -- NOT NULL: Anonim katılım olmamalı.
    
    fk_course_id BIGINT NOT NULL REFERENCES courses(pk_course_id), 
    -- BIGINT: courses tablosu ile uyumlu bigserials yerine kullanılma sebebi; otomatik artan ID olması gerekmiyor.
    -- FOREIGN KEY: enrollments tablosu courses tablosuna bağlı.    
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    -- TIMESTAMP: Katılımın tam zamanı kaydedilir.
    -- DEFAULT: Katılım tarihi otomatik alınır. Elle girilmesine gerek yok.
    
    completion_status VARCHAR(20) DEFAULT 'devam ediyor' CHECK (
        completion_status IN ('tamamlandı', 'devam ediyor', 'iptal edildi')
    ), 
    -- CHECK: Sadece geçerli durumlar girilebilir. Geçersiz değerler engelleneceği için kullanıldı.
    -- DEFAULT: Yeni kayıtlar otomatik "devam ediyor" olarak işaretlenir.
    
    progress_percent INTEGER DEFAULT 0 CHECK (
        progress_percent BETWEEN 0 AND 100
    ) 
    -- CHECK: Yüzde 0-100 dışında değer girilmesi engellenir.
    -- DEFAULT 0: Yeni kayıtlarda ilerleme sıfırdan başlar.
    -- INTEGER: 0-100 arası değerler olacağı için yeterli. 
);

------------------------------ 5. SERTİFİKALAR TABLOSU ------------------------------
CREATE TABLE certificates (
    pk_certificate_id BIGSERIAL PRIMARY KEY, 
    certificate_code VARCHAR(100) UNIQUE NOT NULL, 
    -- UNIQUE: Her sertifika kodu eşsiz olmalı (sahte sertifika üretimini önlemek için).
    -- Örnek kod: "UDEMY-PYTHON-ABC123" gibi formatlı değerler.
    -- NOT NULL: Sertifika kodu zorunlu. Boş bırakılamaz.
    -- VARCHAR(100): Sertifika kodları genelde 50-100 karakteri geçmez.
    -- BIGSERIAL: Uzun vadede milyonlarca sertifika olabileceği için BIGINT (8 byte) tercih edildi.
    -- Otomatik artan ID üretir. Manuel ID atamasına gerek kalmaz.

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
    -- NOT NULL: Başlık zorunlu. Boş bırakılamaz.
    
    
    
    content TEXT NOT NULL, 
    -- TEXT: Blog içeriği için sınırsız alan (10 bin karakter sınırı koymak mantıksız olurdu).
    -- NOT NULL: İçerik zorunlu. Boş bırakılamaz.
    
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    -- DEFAULT: Yayınlanma zamanı otomatik kaydedilir.
    -- TIMESTAMP: Gün, saat, dakika ve saniye bilgisi kaydedilir.
    -- NULL olabilir: Gönderi henüz yayınlanmadıysa bu alan boş kalabilir.
    
    fk_author_id BIGINT NOT NULL REFERENCES members(pk_member_id), 
    -- NOT NULL: Anonim gönderi olamaz. Her blogun bir yazarı olmalı.
    -- FOREIGN KEY: blog_posts tablosu members tablosuna bağlı.
    -- Neden BIGINT: blog_posts tablosu members tablosuna bağlı, otomatik artan ID olması gerekmiyor.
    
    likes INTEGER DEFAULT 0 CHECK (likes >= 0), 
    -- CHECK: Negatif beğeni olmaz. Trolleri engellemek için.
    -- DEFAULT 0: Yeni gönderilerde beğeni sayısı sıfırdan başlar.
    
    comments_count INTEGER DEFAULT 0 CHECK (comments_count >= 0), 
    -- CHECK: Negatif yorum sayısı mantıksız olacağı için eklendi.
    -- DEFAULT 0: Yeni gönderilerde yorum sayısı sıfırdan başlar.
    
    last_edited_at TIMESTAMP 
    -- NULL olabilir: Gönderi hiç düzenlenmediyse bu alan boş kalır.
    -- Düzenleme yapıldığında CURRENT_TIMESTAMP otomatik güncellenebilir trigger eklenebilir.
);

------------------------------ İNDEKSLER ------------------------------
-- Tüm tabloyu taramadan, doğrudan indeks üzerinden arama yapabilmek için indeksler oluşturuldu.
CREATE INDEX idx_courses_category ON courses(fk_category_id);
-- Kursları kategoriye göre filtrelerken hız kazandırır.

CREATE INDEX idx_enrollments_member ON enrollments(fk_member_id);
-- Kullanıcının katıldığı kursları hızlıca getirmek için.Profil sayfası için kullanılır.
CREATE INDEX idx_certificates_course ON certificates(fk_course_id);
-- Bir kursa ait sertifikaları hızla listelemek için kurs detay sayfasında kullanılabilir.

