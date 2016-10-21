# Memeticame-API

## Docker Image

[![](https://images.microbadger.com/badges/version/sasalatart/memeticame.svg)](http://microbadger.com/images/sasalatart/memeticame "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/sasalatart/memeticame.svg)](http://microbadger.com/images/sasalatart/memeticame "Get your own image badge on microbadger.com")

## About

*Proyecto semestral del ramo IIC3380 - Taller de Aplicaciones en Plataformas Móviles*

## Setup

Environment Variables:

 * **SECRET_KEY_BASE**: *used for verifying the integrity of signed cookies*
 * **MEMETICAME_FCM_KEY**: *your application's FCM Key*

##### Development

1. Clone and cd into this repository
2. Run `bundle install`
3. Set each of the Environment Variables:
  * Run `export VARIABLE_NAME=value` in the shell for a temporary setup.
  * Write `export VARIABLE_NAME=value` in the shell's configuration file for its persistance (remember to reload the shell after doing so).
4. Start PostgreSQL
5. Run `bundle exec rails db:reset`
6. Run `rails s`

##### Docker

```sh
# Set the required environment variables
$ export SECRET_KEY_BASE=anystring
$ export MEMETICAME_FCM_KEY=your_application_fcm_key

# Build
$ docker-compose build

# Run
$ docker-compose up -d

# Setup the database
$ docker-compose run web bundle exec rails db:reset
```

The server's machine should now be redirecting its ports 80 and 443 to the container's port 3000.

To stop:
```sh
$ docker-compose stop
```

## Usage

#### Signup

- Route: `POST` `/signup`

- Headers:
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  {
    name: new_user_name,
    phone_number: new_user_phone_number,
    password: new_user_password,
    password_confirmation: new_user_password_confirmation
  }
  ```

- Success Response:

  - Status: 201
  - Example Content:

    ```javascript
    { api_key: your_memeticame_session_token }
    ```

- Error Response:

  - Code: 406
  - Example Content:

    ```javascript
    { message: error_message }
    ```

---

#### Login

- Route: `POST` `/login`

- Headers:
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  {
    phone_number: user_phone_number,
    password: user_password,
  }
  ```

- Success Response:

  - Status: 201
  - Example Content:

    ```javascript
    { api_key: your_memeticame_session_token }
    ```

- Error Response:

  - Code: 403
  - Example Content:

    ```javascript
    { message: 'Invalid credentials' }
    ```

---

#### Logout

- Route: `GET` `/logout`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    { message: 'Logged out successfully' }
    ```

- Error Response:

  - Code: 406
  - Example Content:

    ```javascript
    { message: 'Could not logout' }
    ```

---

#### Register to FCM Push Notifications

- Route: `POST` `/fcm_register`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Body:

  ```javascript
  { registration_token: your_device_fcm_registration_token }
  ```

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    { message: 'FCM Token Updated' }
    ```

- Error Response:

  - Code: 400
  - Example Content:

    ```javascript
    { message: 'Unable to Update FCM Token' }
    ```

---

#### User Index

- Route: `POST` `/users`

- Example Body:

  ```javascript
  {
    phone_numbers: {
      1: '+569 12345678',
      2: '+569 87654321',
      3: '+569 12121212',
      4: '+569 33333333',
      5: '+569 45454545'
    }
  }
  ```

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      [
        {
          id: 1,
          name: 'Sebastián Salata',
          phone_number: '+569 12345678',
          created_at: '2016-08-16T23:13:05.908Z'
        }, {
          id: 2,
          name: 'Patricio López',
          phone_number: '+569 87654321',
          created_at: '2016-09-16T23:13:15.908Z'
        }, {
          id: 3,
          name: 'Adrián Soto',
          phone_number: '+569 12121212',
          created_at: '2016-09-16T23:25:15.908Z'
        }
      ]
    }
  ```

---

#### Chats Where A Specific User Is A Member

- Route: `GET` `/chats`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      [
        {
          id: 1,
          title: 'Chat with Napoleon',
          group: false,
          admin: {
            id: 1,
            name: 'Sebastián Salata',
            phone_number: '+569 12345678',
            created_at: '2016-08-16T23:13:05.908Z'
          }, users: [
            {
              id: 1,
              name: 'Sebastián Salata',
              phone_number: '+569 12345678',
              created_at: '2016-08-16T23:13:05.908Z'
            }, {
              id: 2,
              name: 'Patricio López',
              phone_number: '+569 87654321',
              created_at: '2016-09-16T23:13:15.908Z'
            }
          ], messages: [
            {
              id: 1,
              sender_phone: '+569 12345678',
              content: 'Lorem ipsum',
              chat_id: 1,
              attachment_link: null,
              created_at: '2016-08-16T23:13:05.908Z'
            }, {
              id: 2,
              sender_phone: '+569 87654321',
              content: 'dolor sit amet',
              chat_id: 1,
              attachment_link: {
                name: '20160915_203714.mp4',
                mime_type: 'video/mp4',
                url: 'https://memeticame.salatart.com/system/messages/attachments/000/000/049/original/20160915_203714.mp4?1474212725',
                size: 350
              },
              created_at: '2016-08-16T23:15:25.908Z'
            }
          ],
          created_at: '2016-08-16T23:13:05.908Z'
        }, {
          id: 2,
          title: 'Asado familiar',
          group: true,
          admin: {
            id: 1,
            name: 'Sebastián Salata',
            phone_number: '+569 12345678',
            created_at: '2016-08-16T23:13:05.908Z'
          }, users: {
            [
              {
                id: 1,
                name: 'Sebastián Salata',
                phone_number: '+569 12345678',
                created_at: '2016-08-16T23:13:05.908Z'
              }, {
                id: 2,
                name: 'Patricio López',
                phone_number: '+569 87654321',
                created_at: '2016-09-16T23:13:15.908Z'
              }, {
                id: 3,
                name: 'Adrián Soto',
                phone_number: '+569 12121212',
                created_at: '2016-09-16T23:25:15.908Z'
              }
            ]
          }, messages: [
            {
              id: 3,
              sender_phone: '+569 12345678',
              content: 'Lorem ipsum',
              chat_id: 2,
              attachment_link: null,
              created_at: '2016-08-16T23:13:05.908Z'
            }
          ],
          created_at: '2016-08-16T23:45:05.908Z'
        }
      ]
    }
    ```

---

#### Create Chat

- Route: `POST` `/chats`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Example Body (Not Group):

  ```javascript
  {
    admin: '+569 12345678',
    group: false,
    title: 'Chat with Napoleon',
    users: [
      "+569 87654321"
    ]
  }
  ```

- Example Body (Group):

  ```javascript
  {
    admin: '+569 12345678',
    group: true,
    title: 'Asado familiar',
    users: [
      "+569 12345678",
      "+569 87654321",
      "+569 12121212"
    ], messages: []
  }
  ```

- Success Response (Not Group):

  - Status: 201
  - Example Content:

    ```javascript
    {
      id: 1,
      title: 'Chat with Napoleon',
      group: false,
      admin: {
        id: 1,
        name: 'Sebastián Salata',
        phone_number: '+569 12345678',
        created_at: '2016-08-16T23:13:05.908Z'
      }, users: [
        {
          id: 1,
          name: 'Sebastián Salata',
          phone_number: '+569 12345678',
          created_at: '2016-08-16T23:13:05.908Z'
        }, {
          id: 2,
          name: 'Patricio López',
          phone_number: '+569 87654321',
          created_at: '2016-09-16T23:13:15.908Z'
        }
      ], messages: [],
      created_at: '2016-08-16T23:13:05.908Z'
    }
    ```

- Success Response (Group):

  - Status: 201
  - Example Content:

    ```javascript
    {
      id: 2,
      title: 'Asado familiar',
      group: true,
      admin: {
        id: 1,
        name: 'Sebastián Salata',
        phone_number: '+569 12345678',
        created_at: '2016-08-16T23:13:05.908Z'
      }, users: [
        {
          id: 1,
          name: 'Sebastián Salata',
          phone_number: '+569 12345678',
          created_at: '2016-08-16T23:13:05.908Z'
        }, {
          id: 2,
          name: 'Patricio López',
          phone_number: '+569 87654321',
          created_at: '2016-09-16T23:13:15.908Z'
        }, {
          id: 3,
          name: 'Adrián Soto',
          phone_number: '+569 12121212',
          created_at: '2016-09-16T23:25:15.908Z'
        }
      ], messages: [],
      created_at: '2016-08-16T23:45:05.908Z'
    }
    ```

- Error Response:

  - Code: 406
  - Example Content:

    ```javascript
    { message: error_message }
    ```

---

#### Create Message

- Route: `POST` `/chats/:id/messages`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`-

- Example Body (Without Attachment):

  ```javascript
  { content: 'Hello, how are you?' }
  ```

- Example Body (With Attachment):

  ```javascript
  {
    content: 'Hello, this is an image',
    attachment: {
      base64: 'base64-representation-of-the-image-file',
      mime_type: 'image/jpeg',
      name: '20160915_203725.jpeg'
    }
  }
  ```

- Success Response (Without Attachment):

  - Status: 201
  - Example Content:

    ```javascript
    {
      id: 1,
      sender_phone: '+569 12345678',
      content: 'Hello, how are you?',
      chat_id: 1,
      attachment_link: null,
      created_at: '2016-08-16T23:13:05.908Z'
    }
    ```

- Success Response (With Attachment):

  - Status: 201
  - Example Content:

    ```javascript
    {
      id: 2,
      sender_phone: '+569 12345678',
      content: 'Hello, this is an image',
      chat_id: 1,
      attachment_link: {
        name: '20160915_203725.jpeg',
        mime_type: 'image/jpeg',
        url: 'https://memeticame.salatart.com/system/messages/attachments/000/000/049/original/20160915_203725.jpeg?1474212725',
        size: 575
      }
      created_at: '2016-08-16T23:13:05.908Z'
    }
    ```

- Error Response:

  - Code: 406
  - Content:

    ```javascript
    { message: error_message }
    ```

---

#### Leave Chat

- Route: `POST` `/chats/:id/leave`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      id: 1,
      title: 'Chat with Napoleon',
      group: false,
      admin: {
        id: 1,
        name: 'Sebastián Salata',
        phone_number: '+569 12345678',
        created_at: '2016-08-16T23:13:05.908Z'
      }, users: [
        {
          id: 1,
          name: 'Sebastián Salata',
          phone_number: '+569 12345678',
          created_at: '2016-08-16T23:13:05.908Z'
        }
      ], messages: [],
      created_at: '2016-08-16T23:13:05.908Z'
    }
    ```

- Error Response:

  - Code: 400
  - Content:

    ```javascript
    { message: error_message }
    ```

---

#### Kick User From Chat

- Route: `POST` `/chats/:id/leave`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      id: 1,
      title: 'Chat with Napoleon',
      group: false,
      admin: {
        id: 1,
        name: 'Sebastián Salata',
        phone_number: '+569 12345678',
        created_at: '2016-08-16T23:13:05.908Z'
      }, users: [
        {
          id: 1,
          name: 'Sebastián Salata',
          phone_number: '+569 12345678',
          created_at: '2016-08-16T23:13:05.908Z'
        }
      ], messages: [],
      created_at: '2016-08-16T23:13:05.908Z'
    }
    ```

- Error Response:

  - Code: 400
  - Content:

    ```javascript
    { message: error_message }
    ```

---

#### Chat Invitations Belonging To A User

- Route: `GET` `/chat_invitations`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      [
        {
          id: 1,
          chat_id: 3,
          chat_title: 'This is a group',
          user: {
            id: 2,
            name: 'Patricio López',
            phone_number: '+569 87654321',
            created_at: '2016-09-16T23:13:15.908Z'
          },
          created_at: '2016-08-16T23:13:05.908Z'
        }, {
          id: 3,
          chat_id: 4,
          chat_title: 'This is another group',
          user: {
            id: 2,
            name: 'Patricio López',
            phone_number: '+569 87654321',
            created_at: '2016-09-16T23:13:15.908Z'
          },
          created_at: '2016-09-16T23:13:15.908Z'
        }
      ]
    }
    ```

---

#### Chat Invitations Belonging To A Chat

- Route: `GET` `/chats/:id/invitations`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      [
        {
          id: 1,
          chat_id: 3,
          chat_title: 'This is a group',
          user: {
            id: 2,
            name: 'Patricio López',
            phone_number: '+569 87654321',
            created_at: '2016-09-16T23:13:15.908Z'
          },
          created_at: '2016-08-16T23:13:05.908Z'
        }, {
          id: 4,
          chat_id: 3,
          chat_title: 'This is a group',
          user: {
            id: 3,
            name: 'Adrián Soto',
            phone_number: '+569 12121212',
            created_at: '2016-09-16T23:25:15.908Z'
          },
          created_at: '2016-09-16T23:13:15.908Z'
        }
      ]
    }
    ```

---

### Invite Users To A Chat Group

- Route: `POST` `/chats/:id/invite`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  {
    users: {
      1: '+569 12345678',
      2: '+569 87654321'
    }
  }
  ```

- Success Response:

  - Status: 201
  - Example Content:

    ```javascript
    {
      [
        {
          id: 1,
          chat_id: 3,
          chat_title: 'This is a group',
          user: {
            id: 1,
            name: 'Sebastián Salata',
            phone_number: '+569 12345678',
            created_at: '2016-09-16T23:13:15.908Z'
          },
          created_at: '2016-08-16T23:13:05.908Z'
        }, {
          id: 1,
          chat_id: 3,
          chat_title: 'This is a group',
          user: {
            id: 2,
            name: 'Patricio López',
            phone_number: '+569 87654321',
            created_at: '2016-09-16T23:13:15.908Z'
          },
          created_at: '2016-08-16T23:13:05.908Z'
        }
      ]
    }
    ```

- Error Response:

  - Code: 406
  - Example Content:

    ```javascript
    { message: error_message }
    ```

---

#### Accept Chat Invitation

- Route: `POST` `/chat_invitations/:id/accept`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      id: 1,
      chat_id: 3,
      chat_title: 'This is a group',
      user: {
        id: 2,
        name: 'Patricio López',
        phone_number: '+569 87654321',
        created_at: '2016-09-16T23:13:15.908Z'
      },
      created_at: '2016-08-16T23:13:05.908Z'
    }
    ```

- Error Response:

  - Code: 400
  - Content:

    ```javascript
    { message: error_message }
    ```

---

#### Reject Chat Invitation

- Route: `POST` `/chat_invitations/:id/reject`

- Headers:
  - Authorization: `Token token=your_memeticame_session_token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      id: 2,
      chat_id: 4,
      chat_title: 'This is another group',
      user: {
        id: 2,
        name: 'Patricio López',
        phone_number: '+569 87654321',
        created_at: '2016-09-16T23:13:15.908Z'
      },
      created_at: '2016-09-16T23:13:15.908Z'
    }
    ```

- Error Response:

  - Code: 400
  - Content:

    ```javascript
    { message: error_message }
    ```

## FCM Push Notifications

#### When A User Signs Up

- collapse_key: 'user_created'
- data:
  ```javascript
  { user: a_serialized_user }
  ```

#### When A Message Is Created

- collapse_key: 'message_created'
- data:
  ```javascript
  { message: a_serialized_message }
  ```

#### When A Chat Is Created

- collapse_key: 'chat_created'
- data:
  ```javascript
  { chat: a_serialized_chat }
  ```

#### When A User Is Kicked From A Chat, Or Leaves It

- collapse_key: 'user_kicked'
- data:
  ```javascript
  {
    user: a_serialized_user,
    chat: a_serialized_chat
  }
  ```

#### When Users Are Invited To A Chat

- collapse_key: 'users_invited'
- data:
  ```javascript
  { chat_invitations: array_of_serialized_chat_invitations }
  ```

#### When A Chat Invitation Is Accepted

- collapse_key: 'chat_invitation_accepted'
- data:
  ```javascript
  { chat_invitation: a_serialized_chat_invitation }
  ```

#### When A Chat Invitation Is Rejected

- collapse_key: 'chat_invitation_rejected'
- data:
  ```javascript
  { chat_invitation: a_serialized_chat_invitation }
  ```
