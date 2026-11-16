Day 7 Assignment: Scaling a Photo-Sharing App
1. Introduction

SnapShare is a photo-sharing application where users upload photos and view feeds containing photos from people they follow.

The purpose of this scaling plan is to design an architecture that can handle millions of users, large numbers of photo uploads and high volumes of feed requests.

2. Assumptions

The following information is provided:

Registered users: 10 million.
Daily active users: 10%.
Each active user uploads one photo per day.
Each active user views 50 feed pages per day.
Average original photo size: 2 MB.
Each thumbnail size: 50 KB.
Peak traffic multiplier: 5 times the average traffic.
One day is approximately 100,000 seconds.
Photos and thumbnails are retained for one year.
No photo deletions, compression or additional storage copies are included in the estimates.
3. Daily Active Users

10% of the 10 million registered users are active daily.

Calculation:

10,000,000 × 0.10 = 1,000,000

Therefore, SnapShare has 1 million daily active users.

4. Uploads Per Second

Each active user uploads one photo per day.

Daily uploads:

1,000,000 × 1 = 1,000,000 uploads.

Uploads per second:

1,000,000 ÷ 100,000 = 10 uploads per second.

Average uploads per second: 10.

5. Feed Views Per Second

Each active user views 50 feed pages per day.

Daily feed views:

1,000,000 × 50 = 50,000,000 feed views.

Average feed views per second:

50,000,000 ÷ 100,000 = 500 feed views per second.

Peak feed views per second:

500 × 5 = 2,500 feed views per second.

Therefore:

Average feed views: 500 per second.
Peak feed views: 2,500 per second.
6. Photo Storage Per Year

Each original photo is 2 MB.

Daily original photo storage:

1,000,000 × 2 MB = 2,000,000 MB.

Yearly original photo storage:

2,000,000 × 365 = 730,000,000 MB.

This is approximately 730 TB per year using decimal storage units.

Thumbnail storage:

1,000,000 × 50 KB × 365 = 18,250,000,000 KB.

This is approximately 18.25 TB per year.

Total annual storage:

730 TB + 18.25 TB = 748.25 TB.

Total estimated photo storage per year: 748.25 TB.

7. Read-Heavy or Write-Heavy?

SnapShare is a read-heavy system.

Users view 50 feed pages per day but upload only one photo per day.

This means the application handles significantly more read requests than write requests.

Daily reads: 50 million feed views.

Daily writes: 1 million photo uploads.

The system should therefore be optimized for reading.

Caching, a CDN and database read replicas will help improve performance and reduce the workload on the main database.

8. Why Photos Should Not Be Stored Inside the Database

Photos should not be stored directly inside the main database because they are large files that consume considerable storage space.

Instead, original photos and thumbnails should be stored in object storage, such as Amazon S3.

Object storage is designed to handle large files and can scale as the application grows.

The database should store photo metadata such as the photo ID, user ID, caption, upload date and object storage URL.

A CDN can then deliver photos and thumbnails quickly to users.

9. Architecture Diagram

The following diagram shows the proposed SnapShare architecture.

text
                  USERS / MOBILE APP
                          |
              +-----------+-----------+
              |                       |
             CDN                LOAD BALANCER
              |                       |
       Photos and Files          APP SERVERS
                                      |
                   +------------------+------------------+
                   |                  |                  |
                REDIS              DATABASE          OBJECT STORAGE
                CACHE              PRIMARY          Original Photos
                                      |               and Thumbnails
                                 READ REPLICA
                                     
                                  QUEUE
                                    |
                                  WORKER
                                    |
                            Thumbnail Generation
                                    |
                              OBJECT STORAGE

10. Architecture Components
CDN: Delivers photos, thumbnails and static files from servers close to users.
Load Balancer: Distributes incoming requests across multiple application servers.
App Servers: Handle authentication, photo uploads, feed requests and application logic.
Redis Cache: Stores frequently requested feed data to reduce database queries and improve response times.
Database: Stores structured information such as users, photo metadata, captions and follower relationships.
Read Replica: Handles read queries to reduce the workload on the primary database.
Object Storage: Stores original photos and thumbnails separately from the database.
Queue: Holds background thumbnail-generation jobs for asynchronous processing.
Worker: Processes queued jobs and generates smaller thumbnail images.
11. Step-by-Step Photo Upload Flow
A user selects a photo and uploads it through the SnapShare mobile application.
The load balancer directs the request to an available app server.
The app server authenticates the user and validates the uploaded photo.
The original photo is uploaded to object storage.
The app server saves the photo metadata and storage location in the database.
A thumbnail-generation job is placed in the queue.
A background worker receives the job and creates a smaller thumbnail.
The worker saves the thumbnail in object storage.
The database is updated with the thumbnail location and processing status.
The CDN delivers the photo and thumbnail when users view them in their feeds.
12. Trade-offs
Trade-off 1: Caching vs Data Freshness

Caching improves performance because frequently requested feed information can be retrieved quickly from Redis.

However, cached data may become outdated when users upload new photos or make changes.

The application must invalidate or update cached information when necessary.

Trade-off 2: Object Storage vs Database Storage

Object storage is suitable for storing large photo files and can scale independently.

However, the application needs additional logic to manage file URLs, permissions and photo metadata.

Trade-off 3: Read Replicas vs Consistency

Read replicas improve performance by distributing read queries across multiple database servers.

However, replication delays can cause users to see slightly outdated information after uploading a photo.

Trade-off 4: Background Processing vs Immediate Availability

Using a queue and background workers allows users to upload photos without waiting for thumbnail generation.

However, thumbnails may not be immediately available because background processing takes time.

13. Conclusion

SnapShare requires a scalable architecture because it handles millions of daily users, frequent feed requests and large photo files.

The system is read-heavy, so caching, a CDN and database read replicas are important for improving performance.

Object storage provides a scalable solution for storing photos, while queues and background workers handle thumbnail generation.

This architecture allows SnapShare to handle increasing traffic while maintaining good performance and reliability.