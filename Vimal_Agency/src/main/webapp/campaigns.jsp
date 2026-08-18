<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campaigns | Vimal Agency</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel='stylesheet' type='text/css' href='main.css'>

    <style>
        .hero-img {
            max-height: 450px;
            object-fit: cover;
        }

        .video-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            border: 1px solid #e2e8f0;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .video-wrapper {
            position: relative;
            width: 100%;
            aspect-ratio: 16 / 9;
            border-radius: 12px;
            overflow: hidden;
            background: #000;
        }

        .video-wrapper iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: 0;
        }

        .video-title {
            font-size: clamp(16px, 3vw, 20px);
            font-weight: 700;
            color: #1e293b;
            margin-top: 15px;
            margin-bottom: 0;
        }
    </style>
</head>

<body>
    <%@ include file="header.jsp" %>

    <div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="Product/hero section/01.png" class="d-block w-100 hero-img" alt="Banner 1">
            </div>
            <div class="carousel-item">
                <img src="Product/hero section/2.png" class="d-block w-100 hero-img" alt="Banner 2">
            </div>
            <div class="carousel-item">
                <img src="Product/hero section/03.png" class="d-block w-100 hero-img" alt="Banner 3">
            </div>
            <div class="carousel-item">
                <img src="Product/hero section/4.png" class="d-block w-100 hero-img" alt="Banner 4">
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="prev" aria-label="Previous">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="next" aria-label="Next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>

    <!-- Video Campaigns Section -->
    <div class="container py-5">
        <div class="text-center mb-5">
            <h1 class="fw-800" style="font-size: clamp(1.8rem, 4vw, 2.5rem);">Featured Campaigns</h1>
            <p class="text-muted">Watch the latest taste adventures and commercials from Balaji Wafers.</p>
        </div>

        <div class="row g-4">
            <div class="col-lg-6 col-12">
                <div class="video-card">
                    <div class="video-wrapper">
                        <iframe src="https://www.youtube.com/embed/l8bW2eOCzYY?rel=0&controls=1"
                            title="Gippi Masala Noodles Commercial" allow="encrypted-media" allowfullscreen>
                        </iframe>
                    </div>
                    <p class="video-title">Gippi | Har Bite Mein Zindagi Ka Maza</p>
                </div>
            </div>
            <div class="col-lg-6 col-12">
                <div class="video-card">
                    <div class="video-wrapper">
                        <iframe src="https://www.youtube.com/embed/oDJMuZGJ4DQ?rel=0&modestbranding=1&controls=1"
                            title="Balaji Wafers Commercial" allow="encrypted-media" allowfullscreen>
                        </iframe>
                    </div>
                    <p class="video-title">Balaji Wafers | Crunch and Flavor Forever</p>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
