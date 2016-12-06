# Memeticame-API

## Docker Image

[![](https://images.microbadger.com/badges/version/sasalatart/memeticame.svg)](http://microbadger.com/images/sasalatart/memeticame "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/sasalatart/memeticame.svg)](http://microbadger.com/images/sasalatart/memeticame "Get your own image badge on microbadger.com")

## Table Of Contents

- [Setup](#setup)
  - [Development](#development)
  - [Docker](#docker)
- [Usage](#usage)
  - [Accounts And Sessions](#accounts-and-sessions)
  - [Users](#users)
  - [Chats](#chats)
  - [Messages](#messages)
  - [Chat Invitations](#chat-invitations)
  - [Channels](#channels)
  - [Memes](#memes)
  - [Emotions](#emotions)
  - [Push Notifications](#push-notifications)

## Setup

Environment Variables:

 * **SECRET_KEY_BASE**:

  Used for verifying the integrity of signed cookies

 * **MEMETICAME_FCM_KEY**:

  Used for downstream push notifications with FCM. See this [link](https://firebase.google.com/docs/cloud-messaging/)

 * **MEMETICAME_EMOTIONS_PREVIEW_KEY**:

  Used for retrieving emotions from a picture with Microsoft Emotions API. See this [link](https://www.microsoft.com/cognitive-services/)

 * **MEMETICAME_DROPBOX_ACCESS_TOKEN**:

  Your application's Dropbox access token. See this [link](https://www.dropbox.com/developers-v1/core/start/ruby)

 * **MEMETICAME_DROPBOX_USER_ID**:

  Your application's Dropbox user id. See this [link](https://www.dropbox.com/developers-v1/core/start/ruby)

**Note**: Dropbox is used as a file intermediary between this API and Microsoft Cognitive Services, but it was only added because for some reason Microsoft could not download files directly from this API.

### Development

1. Clone and cd into this repository
2. Run `bundle install`
3. Set each of the Environment Variables:
  * Run `export VARIABLE_NAME=value` in the shell for a temporary setup.
  * Write `export VARIABLE_NAME=value` in the shell's configuration file for its persistance (remember to reload the shell after doing so).
4. Start PostgreSQL
5. Run `bundle exec rails db:reset`
6. Run `rails s`

### Docker

```sh
# Set the required environment variables
$ export SECRET_KEY_BASE=anystring
$ export MEMETICAME_FCM_KEY=your_application_fcm_key
$ export MEMETICAME_EMOTIONS_PREVIEW_KEY=your_microsoft_emotions_api_key
$ export MEMETICAME_DROPBOX_ACCESS_TOKEN=your_application_dropbox_access_token
$ export MEMETICAME_DROPBOX_USER_ID=your_application_dropbox_user_id

# Build
$ docker-compose build

# Run
$ docker-compose up -d

# Setup the database and seeds
$ docker-compose run web bundle exec rails db:reset
```

The server's machine should now be redirecting its ports 80 and 443 to the container's port 3000.

To stop:
```sh
$ docker-compose stop
```

---

## Usage

### Accounts And Sessions

#### Signup

- Route: `POST` `/signup`

- Headers:
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  {
    name: 'Sebastián Salata',
    phone_number: '+569 12345678',
    password: 'macoy123',
    password_confirmation: 'macoy123'
  }
  ```

- Success Response:

  - Status: 201
  - Content:

    ```javascript
    { api_key: 'your-memeticame-session-token' }
    ```

- Error Response:

  - Code: 406
  - Content:

    ```javascript
    { message: 'error-message' }
    ```

---

#### Login

- Route: `POST` `/login`

- Headers:
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  {
    phone_number: '+569 12345678',
    password: 'macoy123',
  }
  ```

- Success Response:

  - Status: 201
  - Content:

    ```javascript
    { api_key: 'your-memeticame-session-token' }
    ```

- Error Response:

  - Code: 403
  - Content:

    ```javascript
    { message: 'Invalid credentials' }
    ```

---

#### Logout

- Route: `GET` `/logout`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Content:

    ```javascript
    { message: 'Logged out successfully' }
    ```

- Error Response:

  - Code: 406
  - Content:

    ```javascript
    { message: 'Could not logout' }
    ```

---

### Users

#### List Of My Contacts That Have An Account

- Route: `POST` `/users`

- Example Body:

  ```javascript
  {
    phone_numbers: {
      1: '+569 12345678',
      2: '+569 87654321',
      3: '+569 12121212'
    }
  }
  ```

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
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
      } ...
    ]
    ```

---

#### Show User

- Route: `GET` `/users/:phone_number`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

  ```javascript
  {
    id: 1,
    name: 'Sebastián Salata',
    phone_number: '+569 12345678',
    created_at: '2016-08-16T23:13:05.908Z'
  }
  ```

- Error Response:

  - Code: 404
  - Content:

    ```javascript
    { message: 'User not found' }
    ```

---

### Chats

#### Chats Where I Am A Member

- Route: `GET` `/chats`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
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
              url: 'url-to-the-attachment',
              size: 350
            },
            created_at: '2016-08-16T23:15:25.908Z'
          }
        ],
        created_at: '2016-08-16T23:13:05.908Z'
      }, ...
    ]
    ```

---

#### Show A Chat Where I Am A Member

- Route: `GET` `/chats/:id`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
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
            url: 'url-to-the-attachment',
            size: 350
          },
          created_at: '2016-08-16T23:15:25.908Z'
        }
      ],
      created_at: '2016-08-16T23:13:05.908Z'
    }
    ```

- Error Response:

  - Code: 403
  - Content:

    ```javascript
    { message: 'Not allowed' }
    ```

---

#### Create Chat

- Route: `POST` `/chats`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
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
  - Content:

    ```javascript
    { message: 'error-message' }
    ```

---

#### Leave Chat

- Route: `POST` `/chats/:id/leave`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
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
    { message: 'error-message' }
    ```

---

#### Kick User From Chat

- Route: `POST` `/chats/:id/users/:user_id/kick`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
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
        }, ...
      ], messages: [],
      created_at: '2016-08-16T23:13:05.908Z'
    }
    ```

- Error Response:

  - Code: 400
  - Content:

    ```javascript
    { message: 'error-message' }
    ```

---

### Messages

#### Create Message

- Route: `POST` `/chats/:id/messages`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
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
        url: 'url-to-the-attachment',
        size: 575
      }
      created_at: '2016-08-16T23:13:05.908Z'
    }
    ```

- Error Response:

  - Code: 406
  - Content:

    ```javascript
    { message: 'error-message' }
    ```

---

### Chat Invitations

#### Chat Invitations Sent To Me

- Route: `GET` `/chat_invitations`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
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
      }, ...
    ]
    ```

---

#### Chat Invitations Of A Chat

- Route: `GET` `/chats/:id/invitations`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
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
      }, ...
    ]
    ```

---

### Invite Users To A Chat Group

- Route: `POST` `/chats/:id/invite`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
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
      }, ...
    ]
    ```

- Error Response:

  - Code: 406
  - Content:

    ```javascript
    { message: 'error-message' }
    ```

---

#### Accept Chat Invitation

- Route: `POST` `/chat_invitations/:id/accept`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
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
    { message: 'error-message' }
    ```

---

#### Reject Chat Invitation

- Route: `POST` `/chat_invitations/:id/reject`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
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
    { message: 'error-message' }
    ```

---

### Channels

#### List Of Available Channels

- Route: `GET` `/channels`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    [
      {
        id: 1,
        name: 'PUC Memes From Quickdeli',
        rating: 4.5,
        owner: {
          id: 1,
          name: 'Sebastián Salata',
          phone_number: '+569 12345678',
          created_at: '2016-08-16T23:13:05.908Z'
        },
        categories: [
          {
            id: 1,
            channel_id: 1,
            name: 'FEUC',
            memes: [
              {
                id: 1,
                category_id: 1,
                name: 'Bad Luck Giovanni',
                thumb_url: 'url-to-the-thumb-sized-meme',
                original_url: 'url-to-the-original-sized-meme',
                rating: 4.0,
                owner: {
                  id: 1,
                  name: 'Sebastián Salata',
                  phone_number: '+569 12345678',
                  created_at: '2016-08-16T23:13:05.908Z'
                },
                tags: [
                  {
                    id: 1,
                    text: 'lorem',
                    created_at: '2016-08-16T23:20:05.908Z'
                  }, {
                    id: 2,
                    text: 'ipsum',
                    created_at: '2016-08-16T23:20:05.908Z'
                  }, {
                    id: 3,
                    text: 'dolor',
                    created_at: '2016-08-16T23:20:05.908Z'
                  }
                ],
                created_at: '2016-08-16T23:20:05.908Z'
              } ...
            ],
            created_at: '2016-08-16T23:13:05.908Z'
          } ...
        ],
        created_at: '2016-08-16T23:20:05.908Z'
      } ...
    ]
    ```

---

#### Show Channel

- Route: `GET` `/channels/:id`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      id: 1,
      name: 'PUC Memes From Quickdeli',
      rating: 4.5,
      owner: {
        id: 1,
        name: 'Sebastián Salata',
        phone_number: '+569 12345678',
        created_at: '2016-08-16T23:13:05.908Z'
      },
      categories: [
        {
          id: 1,
          channel_id: 1,
          name: 'FEUC',
          memes: [
            {
              id: 1,
              category_id: 1,
              name: 'Bad Luck Giovanni',
              thumb_url: 'url-to-the-thumb-sized-meme',
              original_url: 'url-to-the-original-sized-meme',
              rating: 4.0,
              owner: {
                id: 1,
                name: 'Sebastián Salata',
                phone_number: '+569 12345678',
                created_at: '2016-08-16T23:13:05.908Z'
              },
              tags: [
                {
                  id: 1,
                  text: 'lorem',
                  created_at: '2016-08-16T23:20:05.908Z'
                }, {
                  id: 2,
                  text: 'ipsum',
                  created_at: '2016-08-16T23:20:05.908Z'
                }, {
                  id: 3,
                  text: 'dolor',
                  created_at: '2016-08-16T23:20:05.908Z'
                }
              ],
              created_at: '2016-08-16T23:20:05.908Z'
            } ...
          ],
          created_at: '2016-08-16T23:13:05.908Z'
        } ...
      ],
      created_at: '2016-08-16T23:20:05.908Z'
    }
    ```

---

#### Create A Channel

- Route: `POST` `/channels`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  {
    name: 'PUC Memes From Quickdeli',
    categories: {
      1: 'FEUC',
      2: 'Gala',
      3: 'Ramos'
    }
  }
  ```

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      id: 1,
      name: 'PUC Memes From Quickdeli',
      rating: 4.5,
      owner: {
        id: 1,
        name: 'Sebastián Salata',
        phone_number: '+569 12345678',
        created_at: '2016-08-16T23:13:05.908Z'
      },
      categories: [
        {
          id: 1,
          channel_id: 1,
          name: 'FEUC',
          memes: [],
          created_at: '2016-08-16T23:13:05.908Z'
        }, {
          id: 2,
          channel_id: 1,
          name: 'Gala',
          memes: [],
          created_at: '2016-08-16T23:13:05.908Z'
        }, {
          id: 3,
          channel_id: 1,
          name: 'Ramos',
          memes: [],
          created_at: '2016-08-16T23:13:05.908Z'
        }
      ],
      created_at: '2016-08-16T23:20:05.908Z'
    }
    ```

- Error Response:

  - Code: 422
  - Content:

    ```javascript
    { message: 'error-message' }
    ```

---

### Memes

#### List Of Plain Memes (With No Text)

- Route: `GET` `/plain_memes`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      plain_memes: {
        [
          {
            thumb: 'url-to-a-plain-meme-in-thumb-size',
            original: 'url-to-a-plain-meme-in-original-size'
          }, {
            thumb: 'url-to-another-plain-meme-in-thumb-size',
            original: 'url-to-another-plain-meme-in-original-size'
          }, {
            thumb: 'url-to-another-plain-meme-in-thumb-size',
            original: 'url-to-another-plain-meme-in-original-size'
          }, ...
        ]
      }
    }
    ```

---

#### Rate A Meme

- Route: `POST` `/memes/:meme_id/ratings`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  { value: 4.0 }
  ```

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      id: 1,
      category_id: 1,
      name: 'Bad Luck Giovanni',
      thumb_url: 'url-to-the-thumb-sized-meme',
      original_url: 'url-to-the-original-sized-meme',
      rating: 4.0,
      owner: {
        id: 1,
        name: 'Sebastián Salata',
        phone_number: '+569 12345678',
        created_at: '2016-08-16T23:13:05.908Z'
      },
      tags: [
        {
          id: 1,
          text: 'lorem',
          created_at: '2016-08-16T23:20:05.908Z'
        }, {
          id: 2,
          text: 'ipsum',
          created_at: '2016-08-16T23:20:05.908Z'
        }, {
          id: 3,
          text: 'dolor',
          created_at: '2016-08-16T23:20:05.908Z'
        }, ...
      ],
      created_at: '2016-08-16T23:20:05.908Z'
    }
    ```

- Error Response:

  - Code: 422
  - Content:

    ```javascript
    { message: 'error-message' }
    ```

---

#### My Rating For A Meme

- Route: `GET` `/memes/:meme_id/my_rating`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    { value: 4.5 }
    ```

---

#### Upload A Meme To A Channel's Category

- Route: `POST` `/categories/:category_id/memes`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  {
    base64: 'base64-representation-of-the-image-file',
    mime_type: 'image/jpeg',
    name: 'Bad Luck Giovanni',
    tags: {
      1: 'lorem',
      2: 'ipsum',
      3: 'dolor'
    }
  }
  ```

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    {
      id: 1,
      category_id: 1,
      name: 'Bad Luck Giovanni',
      thumb_url: 'url-to-the-thumb-sized-meme',
      original_url: 'url-to-the-original-sized-meme',
      rating: 0,
      owner: {
        id: 1,
        name: 'Sebastián Salata',
        phone_number: '+569 12345678',
        created_at: '2016-08-16T23:13:05.908Z'
      },
      tags: [
        {
          id: 1,
          text: 'lorem',
          created_at: '2016-08-16T23:20:05.908Z'
        }, {
          id: 2,
          text: 'ipsum',
          created_at: '2016-08-16T23:20:05.908Z'
        }, {
          id: 3,
          text: 'dolor',
          created_at: '2016-08-16T23:20:05.908Z'
        }, ...
      ],
      created_at: '2016-08-16T23:20:05.908Z'
    }
    ```

- Error Response:

  - Code: 422
  - Content:

    ```javascript
    { message: 'error-message' }
    ```

---

#### Search For Memes

- Route: `POST` `/search_memes`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  {
    name: 'gala',
    tags: {
      1: 'lorem',
      2: 'ipsum'
    }
  }
  ```

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    [
      {
        id: 4,
        category_id: 1,
        name: 'meme from gala 01',
        thumb_url: 'url-to-the-thumb-sized-meme',
        original_url: 'url-to-the-original-sized-meme',
        rating: 3.0,
        owner: {
          id: 1,
          name: 'Sebastián Salata',
          phone_number: '+569 12345678',
          created_at: '2016-08-16T23:13:05.908Z'
        },
        tags: [
          {
            id: 1,
            text: 'lorem',
            created_at: '2016-08-16T23:20:05.908Z'
          }
        ],
        created_at: '2016-08-16T23:20:05.908Z'
      }, {
        id: 1,
        category_id: 1,
        name: 'Bad Luck Giovanni',
        thumb_url: 'url-to-the-thumb-sized-meme',
        original_url: 'url-to-the-original-sized-meme',
        rating: 4.0,
        owner: {
          id: 1,
          name: 'Sebastián Salata',
          phone_number: '+569 12345678',
          created_at: '2016-08-16T23:13:05.908Z'
        },
        tags: [
          {
            id: 1,
            text: 'lorem',
            created_at: '2016-08-16T23:20:05.908Z'
          }, {
            id: 2,
            text: 'ipsum',
            created_at: '2016-08-16T23:20:05.908Z'
          }, {
            id: 3,
            text: 'dolor',
            created_at: '2016-08-16T23:20:05.908Z'
          }, ...
        ],
        created_at: '2016-08-16T23:20:05.908Z'
      } ...
    ]
    ```

- Error Response:

  - Code: 422
  - Content:

    ```javascript
    { message: 'error-message' }
    ```

---

### Emotions

#### Recognize Emotions In Picture

- Route: `POST` `/recognize`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Example Body:

  ```javascript
  {
    base64: 'base64-representation-of-the-image-file',
    mime_type: 'image/jpeg'
  }
  ```

- Success Response:

  - Status: 200
  - Example Content:

    ```javascript
    [
      {
        faceRectangle: {
          left: 68,
          top: 97,
          width: 64,
          height: 97
        },
        scores: {
          anger: 0.00300731952,
          contempt: 5.14648448E-08,
          disgust: 9.180124E-06,
          fear: 0.0001912825,
          happiness: 0.9875571,
          neutral: 0.0009861537,
          sadness: 1.889955E-05,
          surprise: 0.008229999
        }
      }
    ]
    ```

---

### Push Notifications


#### Register to FCM Push Notifications

- Route: `POST` `/fcm_register`

- Headers:
  - Authorization: `Token token=your-memeticame-session-token`
  - Content-Type: `application/json`

- Body:

  ```javascript
  { registration_token: 'your-device-fcm-registration-token' }
  ```

- Success Response:

  - Status: 200
  - Content:

    ```javascript
    { message: 'FCM Token Updated' }
    ```

- Error Response:

  - Code: 400
  - Content:

    ```javascript
    { message: 'Unable to Update FCM Token' }
    ```

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
