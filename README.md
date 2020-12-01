# 2Q

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Mobile application that allows users to queue appointments ahead of time. Ideal for individuals and businesses who wish to conduct appointments more efficiently saving both time and energy.

### App Evaluation
- **Category: Service** 
- **Mobile: iOS**
- **Story: Businesses create queues and users reserve space based on availability**
- **Market: Individuals and Businesses that rely on appointments or queue clients for service.**
- **Habit: This app will be used anytime a reservation or appointment is made**
- **Scope: It will start with a few users and businesses, but as more buisness are added users will increase.**

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User sign up
- [x] Queue page
- [x] User login
- [x] Home - Queue viewer
- [x] Explore page
- [x] Current in line queues
- [x] Create a queue


**Optional Nice-to-have Stories**

- [ ] Profile page
- [ ] Business Login
- [ ] QR code reservation confirmation
- [ ] Recommended Queues
- [ ] Option to rate service

### 2. Screen Archetypes

* Consumer 
    * User sign up
    * Details page
    * User login
    * Home - Queue viewer
    * Explore page
    * Current in line queues
    * Profile page
    * **Optional**
        * QR code reservation confirmation
        * Recommended Queues
        * Option to rate service
* Provider
    * Create a queue
    
   

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home
* Explore
* Create
* My Queues
* Profile

**Flow Navigation** (Screen to Screen)

* Login -> Home
   * Home -> My Live Queues
   * Home -> Followed Queues
* My Queues -> My Live Queues or -> Saved Queues
* Profile -> Account Settings


## Wireframes
<img src="https://i.imgur.com/A6aq11k.png" width=600>

### [BONUS] Digital Wireframes & Mockups
**Home page**

<img src="https://scontent-sjc3-1.xx.fbcdn.net/v/t1.15752-9/122066670_802108780565309_600996336649320390_n.jpg?_nc_cat=109&ccb=2&_nc_sid=ae9488&_nc_ohc=whX2koCL7FYAX_2wP4R&_nc_ht=scontent-sjc3-1.xx&oh=ffbb7af13644c0b9e8baef5957fc6d79&oe=5FB65D4A" width=200>


**Details page of Business**

<img src="https://scontent-sjc3-1.xx.fbcdn.net/v/t1.15752-9/121973393_982919665562031_8504943379036429810_n.jpg?_nc_cat=101&ccb=2&_nc_sid=ae9488&_nc_ohc=-QtRJ8h4WBAAX_HN8WQ&_nc_ht=scontent-sjc3-1.xx&oh=14ffdc9d1cb58c29088fa30cedd58713&oe=5FB8F37E" width=200>

### [BONUS] Interactive Prototype

## Schema 

### Models
#User
| Property      | Type            | Description          |
| ------------- | --------------- | -------------------- |
| username      | Pointer to user | current user         |
| firstName     | String          | users first name     |
| lastName      | String          | users last name      |
| phoneNo       | Number          | users phone no.      |
| email         | String          | users email address  |
| password      | String          | users login password |

#Queue
| Property      | Type          | Description                 |
| ------------- | ------------- | --------------------------- |
| queueNum      | Number        | Position in queue           |
| queueID       | String        | Unique ID for users queue   |
| queueName     | String        | Name of queue               |
| createdAt     | DateTime      | Date when queue was created |
| updatedAt     | DateTime      | Date queue was last updated |
| estWaitTime   | Number        | Wait time (minutes)         |

### Networking
- Home Screen
    - (Read/GET) Query live queues where user is in or hosting
    - (Read/GET) Query live queues that user follows
    - Search Bar
        - (Read/GET) Query matching users or queues 
- Explore Screen
    - (Read/GET) Query queues in specified location
- Create Queue Screen
    - (Create/POST) Create a new Queue object
- My Queues Screen
    - (Read/GET) Query queues user is in or owns
    - (Update/PUT) Update queue status (start/end or leave)
    - (Delete) Delete existing queue
- Profile Screen
    - (Update/PUT) Update user account information 
- Selected Queue Screen
    - (Read/GET) Query logged in user object
    - (Update/PUT) Update Queue information
    - (Update/PUT) Update user(s) position in queue

### Progress
Sprint 1
**Sign Up**

<img src="https://i.imgur.com/BLl37WV.gif" width=200>

**Sign In**

<img src="https://i.imgur.com/ewPnGe3.gif" width=200>

Sprint 2

**Homepage**

<img src="https://i.imgur.com/Xr3AsZ3.gif" width=200>

Sprint 3

**My Queues and Queue Page** 

<img src="https://i.imgur.com/6rvRD2Q.gif" width=200>

Sprint 4

**Explore Page** 

<img src="http://g.recordit.co/6EV4KCQHF9.gif" width=200>

