<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Share Your Experience | JobBoard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@600;700&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'DM Sans', sans-serif; background: #f3f4f6; }
        .star-rating i { cursor: pointer; transition: color 0.2s; }
        .star-rating i.active { color: #facc15; }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-6">

    <div class="max-w-lg w-full bg-white rounded-3xl shadow-xl overflow-hidden">
        <div class="bg-slate-900 p-8 text-center">
            <h2 class="text-2xl font-bold text-white font-sora">How was your <span class="text-yellow-400">Experience?</span></h2>
            <p class="text-slate-400 text-sm mt-2">Your feedback helps us improve JobBoard for everyone.</p>
        </div>

        <form action="reviewController" method="post" class="p-8 space-y-6">
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Your Name</label>
                <input type="text" name="userName" required 
                    class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                    placeholder="e.g. Darshan Patel">
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Rating</label>
                <div class="star-rating flex gap-2 text-2xl text-gray-300">
                    <input type="hidden" name="rating" id="ratingValue" value="5">
                    <i class="fas fa-star active" data-value="1"></i>
                    <i class="fas fa-star active" data-value="2"></i>
                    <i class="fas fa-star active" data-value="3"></i>
                    <i class="fas fa-star active" data-value="4"></i>
                    <i class="fas fa-star active" data-value="5"></i>
                </div>
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Your Review</label>
                <textarea name="userReview" rows="4" required
                    class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                    placeholder="Tell us what you liked or how we can improve..."></textarea>
            </div>

            <button type="submit" 
                class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 rounded-xl shadow-lg shadow-blue-200 transition-all transform active:scale-95">
                Submit Review
            </button>
            
            <p class="text-center text-xs text-gray-400">By submitting, you agree to our Terms of Service.</p>
        </form>
    </div>

    <script>
        // Star Rating Script
        const stars = document.querySelectorAll('.star-rating i');
        const ratingInput = document.getElementById('ratingValue');

        stars.forEach(star => {
            star.addEventListener('click', () => {
                const value = star.getAttribute('data-value');
                ratingInput.value = value;
                
                stars.forEach(s => {
                    if(s.getAttribute('data-value') <= value) {
                        s.classList.add('active', 'text-yellow-400');
                        s.classList.remove('text-gray-300');
                    } else {
                        s.classList.remove('active', 'text-yellow-400');
                        s.classList.add('text-gray-300');
                    }
                });
            });
        });
    </script>
</body>
</html>