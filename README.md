# 🚀 Library Application 🚀

---

### Setup & Run

1. **Install:**
   ```bash
   git clone git@github.com:fabiomgg/library.git && cd library
   bundle install

2. **Set devise jwt_secret_key:**
   EDITOR=YOUR_PREFERED_EDITOR rails credentials:edit
   ```yml
   devise:
    jwt_secret_key: xxxxxxxxx


3. **Set datase:**
   ```bash
   rails db:create db:migrate db:seed

4. **Run:**
   ```bash
   rails s

5. **Access:**
   ```bash
   http://localhost:3000

### Default Users

- **Member 1**
  - Email: `member1@email.com`
  - Password: `password_member1`

- **Member 2**
  - Email: `member2@email.com`
  - Password: `password_member2`

- **Librarian**
  - Email: `librarian@email.com`
  - Password: `password_librarian`

### API Usage Sample

**Authentication** `
curl -X POST http://localhost:3000/api/v1/users/sign_in -H "Content-Type: application/json" -d '{"email":"librarian@email.com","password":"password_librarian"}'`

**Books list** `
curl -X GET http://localhost:3000/api/v1/books -H "Authorization: Bearer __JWT_TOKEN__"`

**Book create** `curl -X POST http://localhost:3000/api/v1/books -H "Content-Type: application/json" -H "Authorization: Bearer __JWT_TOKEN__" -d '{
  "book": {
    "title": "The Great Gatsby",
    "author": "F. Scott Fitzgerald",
    "genre": "Classic",
    "total_copies": 5
  }
}'`
