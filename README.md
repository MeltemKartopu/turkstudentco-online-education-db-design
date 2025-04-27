# 🌟 Turk Student Community PostgreSQL Bootcamp Projesi

**Konu:** Online Eğitim Platformu Veritabanı  
**Veritabanı Yönetim Sistemi:** PostgreSQL  

> Bu proje; çevrimiçi eğitim platformu için tasarlanmış bir PostgreSQL veritabanı şemasını, ER diyagramını, örnek veri setlerini ve temel görünümleri (views) içerir.  
> **Amacı:** Veritabanı tasarım prensiplerini gerçek bir senaryo üzerinden uygulamaktır.

## Platformun temel özellikleri şunlardır:

- Üyeler **kayıt** olabilecek.
- Üyeler **eğitimlere** katılabilecek.
- Eğitimleri tamamlayan üyeler **sertifika** kazanabilecek.
- Üyeler, **blog gönderileri** paylaşabilecek.
- Üyeler, yaptıkları aktiviteler sayesinde **profil sayfalarında seviye atlayabileceklerdir**.
---

## 📂 Repo İçeriği

| Yol / Dosya                 | Açıklama                                                                 |
|------------------------------|--------------------------------------------------------------------------|
| `online_edu_db.sql`          | Tüm tablo tanımları, PK–FK–UK kısıtları ve indeksler                     |
| `online_edu_seed_data.sql`   | Örnek veri eklemek için kullanılan INSERT komutları                     |
| `Views/`                     | Platform için hazırlanan view (görünüm) dosyaları (`vw_*.sql`)           |
| `Inserts/`                   | Ek veya genişletilmiş veri ekleme dosyaları                             |
| `ER_diagram.png`             | ER diyagramının pgAdmin üzerinden alınmış statik PNG çıktısı             |

> **Not:** ER diyagramı pgAdmin ERD aracı kullanılarak oluşturulmuş ve proje dizinine eklenmiştir.

---

## 🗄️ Tablolar ve Anahtar Yapısı

| Tablo | Birincil Anahtar | Yabancı Anahtar(lar) | Açıklama |
|:------|:-----------------|:---------------------|:---------|
| **members** | `pk_member_id` | – | Kullanıcı profilleri (`username`, `email` UK) |
| **categories** | `pk_category_id` | – | Eğitim kategorileri |
| **courses** | `pk_course_id` | `fk_category_id → categories.pk_category_id` | Kurs bilgileri ve kategorisi |
| **enrollments** | `pk_enrollment_id` | `fk_member_id → members.pk_member_id`<br>`fk_course_id → courses.pk_course_id` | Kurslara üye katılım kaydı (**çok-çok ilişkisi**) |
| **certificates** | `pk_certificate_id` | `fk_course_id → courses.pk_course_id` | Kurs bazlı sertifika bilgileri |
| **certificate_assignments** | `pk_certificate_assignment_id` | `fk_member_id → members.pk_member_id`<br>`fk_certificate_id → certificates.pk_certificate_id` | Üyelere atanmış sertifikalar |
| **blog_posts** | `pk_blog_post_id` | `fk_author_id → members.pk_member_id` | Kullanıcıların yayınladığı blog yazıları |

---

## 🖼️ ER Diyagramı

![ER Diagramı](./ER_diagram.png)

*(Diyagram, pgAdmin ERD kullanılarak hazırlanmıştır.)*

---

## 🔗 Tablolar Arası İlişki Özeti

| İlişki Türü        | Tablolar | Açıklama |
|:-------------------|:---------|:---------|
| **1 – N (bir-çok)** | `categories` → `courses` | Bir kategori birden fazla kurs içerebilir. |
| **N – N (çok-çok)** | `members` ↔ `courses` (via `enrollments`) | Bir üye birçok kursa katılabilir; bir kursa birçok üye katılabilir. |
| **1 – N (bir-çok)** | `courses` → `certificates` | Bir kurs, birden fazla sertifika verebilir. |
| **N – N (çok-çok)** | `members` ↔ `certificates` (via `certificate_assignments`) | Bir üye birçok sertifika alabilir; aynı sertifika birçok üyeye atanabilir. |
| **1 – N (bir-çok)** | `members` → `blog_posts` | Bir üye birden fazla blog yazısı yayımlayabilir. |

---

## 🎯 Kazanımlar

Bu proje sürecinde:

- İlişkisel veritabanı tasarımı yapma ve ilişki türlerini modelleme
- Birincil Anahtar (Primary Key) ve Yabancı Anahtar (Foreign Key) kullanımı
- 1-N ve N-N ilişkilerde ara tabloların doğru şekilde kurgulanması
- Normalizasyon kurallarını uygulayarak veri tekrarını azaltma
- PostgreSQL üzerinde veri tabanı şeması oluşturma ve yönetme
- İleri düzey veritabanı yapıları: indeksler, kısıtlamalar (constraints) ve otomatik ID yönetimi kullanımı
- Gerçek bir senaryoya dayalı veritabanı tasarımı deneyimi kazanıldı.