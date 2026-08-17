<!DOCTYPE html>
<html>

<head>
    <title>Vimal Agency</title>
    <link rel='stylesheet' type='text/css' href='main.css'>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <!-- font links -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Merriweather&display=swap" rel="stylesheet">

</head>

<body>
    <%@ include file="header.jsp" %>

        <div id="carouselExampleControls" class="carousel slide c1" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="Product/hero section/01.png" class="d-block w-100 hero-img" alt="...">
                </div>
                <div class="carousel-item">
                    <img src="Product/hero section/2.png" class="d-block w-100 hero-img" alt="...">
                </div>
                <div class="carousel-item">
                    <img src="Product/hero section/03.png" class="d-block w-100 hero-img" alt="...">
                </div>
                <div class="carousel-item">
                    <img src="Product/hero section/4.png" class="d-block w-100 hero-img" alt="...">
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleControls"
                data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls"
                data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <!-- video section -->

        <div class="container px-4">
            <div class="row gx-5">
                <div class="col">
                    <div class="p-4 div-video">
                        <iframe width="560" height="315" class="video-main"
                            src="https://www.youtube.com/embed/l8bW2eOCzYY?rel=0&controls=1"
                            title="YouTube video" frameborder="0" allow="encrypted-media" allowfullscreen>
                        </iframe>
                        <p style="font-size: xx-large;">Gippi | Har Bite Mein Zindagi Ka Maza, With Masala N...</p>
                    </div>
                </div>
                <div class="col">
                    <div class="p-4 div-video">
                        <iframe width="560" height="315" class="video-main"
                            src="https://www.youtube.com/embed/oDJMuZGJ4DQ?rel=0&modestbranding=1&controls=1&showinfo=0"
                            title="YouTube video" frameborder="0" allow="encrypted-media" allowfullscreen>
                        </iframe>
                    </div>
                </div>
            </div>
        </div>







</body>

</html>