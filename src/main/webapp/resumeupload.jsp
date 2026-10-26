<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%
  UserModel u = (UserModel) session.getAttribute("Model");
  if (u == null) {
    response.sendRedirect("login.jsp");
    return;
  }
  String initial = u.getFirstname() != null && !u.getFirstname().isEmpty()
      ? String.valueOf(u.getFirstname().charAt(0)).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>JobBoard — Upload Resume</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            sora: ['Sora', 'sans-serif'],
            dm:   ['DM Sans', 'sans-serif'],
          },
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'DM Sans', sans-serif; }
    .font-sora, h1, h2, h3 { font-family: 'Sora', sans-serif; }
    html { scroll-behavior: smooth; }

    .navbar-blur {
      background: rgba(15,23,42,0.92);
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
    }

    .hero-mesh {
      background: linear-gradient(135deg, #060b14 0%, #0f172a 40%, #1e3a5f 70%, #1a56db 100%);
      position: relative;
      overflow: hidden;
    }
    .hero-mesh::before {
      content: '';
      position: absolute;
      inset: 0;
      background-image:
        radial-gradient(ellipse 60% 50% at 80% 40%, rgba(26,86,219,0.25) 0%, transparent 70%),
        radial-gradient(ellipse 40% 40% at 20% 70%, rgba(245,158,11,0.10) 0%, transparent 60%);
    }
    .hero-mesh::after {
      content: '';
      position: absolute;
      inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px);
      background-size: 28px 28px;
    }

    .dropdown-menu {
      display: none;
      position: absolute;
      top: 110%; right: 0;
      min-width: 200px;
      background: #fff;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      box-shadow: 0 12px 40px rgba(0,0,0,0.14);
      padding: 8px 0;
      z-index: 100;
    }
    .dropdown-parent:hover .dropdown-menu { display: block; }
    .dropdown-menu a {
      display: flex; align-items: center; gap: 8px;
      padding: 10px 18px; font-size: 13px;
      color: #475569; text-decoration: none;
      transition: background 0.15s, color 0.15s;
    }
    .dropdown-menu a:hover { background: #f8fafc; color: #1a56db; }
    .logout-link { color: #ef4444 !important; }
    .logout-link:hover { background: #fef2f2 !important; }
    .dropdown-divider { border-top: 1px solid #e2e8f0; margin: 6px 0; }

    #mobileMenu { display: none; }
    #mobileMenu.open { display: flex; }

    /* Drag & Drop Zone */
    .drop-zone {
      border: 2px dashed #cbd5e1;
      border-radius: 16px;
      padding: 48px 24px;
      text-align: center;
      cursor: pointer;
      transition: all 0.25s;
      background: #f8fafc;
      position: relative;
    }
    .drop-zone:hover, .drop-zone.dragover {
      border-color: #1a56db;
      background: #eff6ff;
    }
    .drop-zone input[type="file"] {
      position: absolute;
      inset: 0;
      opacity: 0;
      cursor: pointer;
      width: 100%;
      height: 100%;
    }

    /* Progress bar */
    .progress-bar-fill {
      height: 100%;
      background: linear-gradient(90deg, #1a56db, #3b82f6);
      border-radius: 99px;
      transition: width 0.4s ease;
      width: 0%;
    }

    /* File type badges */
    .file-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 500;
    }
  </style>
</head>
<body class="bg-gray-50 antialiased">

<!-- NAVBAR -->
<header class="navbar-blur sticky top-0 z-50 border-b border-white/10">
  <div class="max-w-7xl mx-auto px-5 py-3 flex items-center justify-between gap-6">
    <a href="user-home.jsp" class="font-sora font-bold text-xl text-white tracking-tight flex-shrink-0">
      Job<span class="text-yellow-400">Board</span>
    </a>
    <nav class="hidden xl:flex items-center gap-1">
      <a href="user-home.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-home mr-1.5 text-xs"></i>Home
      </a>
      <a href="user-home.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-briefcase mr-1.5 text-xs"></i>Browse Jobs
      </a>
      <a href="Application-track.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-file-alt mr-1.5 text-xs"></i>Applications
      </a>
      <a href="resumeupload.jsp" class="text-white bg-white/15 text-sm font-medium px-3 py-2 rounded-lg">
        <i class="fas fa-file-upload mr-1.5 text-xs"></i>Resume
      </a>
      <div class="dropdown-parent relative ml-2">
        <button class="flex items-center gap-2 bg-white/10 border border-white/20 rounded-full pl-1.5 pr-3 py-1.5 text-sm text-white font-medium hover:bg-white/20 transition-all">
          <span class="w-7 h-7 rounded-full bg-blue-600 text-white font-bold text-xs flex items-center justify-center"><%= initial %></span>
          <%= u.getFirstname() %>
          <i class="fas fa-chevron-down text-[10px] text-white/60"></i>
        </button>
        <div class="dropdown-menu">
          <a href="newProfile.jsp"><i class="fas fa-user fa-xs text-blue-600"></i> My Profile</a>
          <a href="Application-track.jsp"><i class="fas fa-file-alt fa-xs text-blue-600"></i> Applications</a>
          <a href="resumeupload.jsp"><i class="fas fa-file-upload fa-xs text-blue-600"></i> Resume</a>
          <a href="Setting.jsp"><i class="fas fa-cog fa-xs text-gray-400"></i> Settings</a>
          <div class="dropdown-divider"></div>
          <a href="logout" class="logout-link"><i class="fas fa-sign-out-alt fa-xs"></i> Logout</a>
        </div>
      </div>
    </nav>
    <div class="hidden xl:flex items-center gap-2">
      <a href="logout" class="border border-white/30 text-white text-sm font-medium px-4 py-2 rounded-lg hover:bg-white/10 transition-all">
        <i class="fas fa-sign-out-alt mr-1.5 text-xs"></i>Logout
      </a>
    </div>
    <button id="hamburger" class="xl:hidden text-white text-xl p-1"><i class="fas fa-bars"></i></button>
  </div>
  <div id="mobileMenu" class="xl:hidden border-t border-white/10 px-5 pb-4 pt-2 flex-col gap-1">
    <a href="userhome.jsp"        class="text-white/90 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-home w-4"></i> Home</a>
    <a href="Application-track.jsp" class="text-white/70 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-file-alt w-4"></i> Applications</a>
    <a href="resumeupload.jsp"    class="text-white text-sm py-2.5 px-3 rounded-lg bg-white/15 flex items-center gap-2"><i class="fas fa-file-upload w-4"></i> Resume</a>
    <hr class="border-white/10 my-1">
    <a href="logout" class="text-red-400 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-sign-out-alt w-4"></i> Logout</a>
  </div>
</header>

<!-- HERO -->
<section class="hero-mesh py-12 relative">
  <div class="max-w-7xl mx-auto px-5 relative z-10">
    <div class="flex items-center gap-2 text-white/50 text-xs mb-4">
      <a href="userhome.jsp" class="hover:text-white transition-colors">Home</a>
      <i class="fas fa-chevron-right text-[10px]"></i>
      <span class="text-white/80">Upload Resume</span>
    </div>
    <div class="inline-flex items-center gap-2 bg-white/10 border border-white/20 rounded-full px-4 py-1.5 text-xs text-white/80 mb-4">
      <span class="w-1.5 h-1.5 rounded-full bg-yellow-400 inline-block"></span>
      Career Profile
    </div>
    <h1 class="font-sora text-3xl md:text-4xl font-bold text-white tracking-tight mb-2">
      Upload Your <span class="text-yellow-400">Resume</span>
    </h1>
    <p class="text-white/60 text-sm">Let top companies discover you. Upload your latest resume to stand out.</p>
  </div>
</section>

<!-- MAIN CONTENT -->
<section class="py-12 bg-gray-50">
  <div class="max-w-2xl mx-auto px-5">

    <!-- Tips Banner -->
    <div class="bg-blue-50 border border-blue-100 rounded-2xl p-4 flex items-start gap-3 mb-6">
      <div class="w-8 h-8 rounded-lg bg-blue-100 flex items-center justify-center flex-shrink-0">
        <i class="fas fa-lightbulb text-blue-600 text-sm"></i>
      </div>
      <div>
        <p class="text-sm font-semibold text-blue-800 mb-0.5">Pro Tip</p>
        <p class="text-xs text-blue-600 leading-relaxed">
          Resumes with clear headings, quantified achievements, and relevant keywords get <strong>3x more callbacks</strong>. Keep it to 1-2 pages.
        </p>
      </div>
    </div>

    <!-- Upload Card -->
    <div class="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 md:p-8 mb-5">

      <div class="flex items-center gap-3 mb-6 pb-4 border-b border-gray-100">
        <div class="w-9 h-9 rounded-xl bg-blue-50 flex items-center justify-center">
          <i class="fas fa-file-upload text-blue-600 text-sm"></i>
        </div>
        <div>
          <h2 class="font-sora font-bold text-lg text-gray-900">Resume Upload</h2>
          <p class="text-xs text-gray-400">PDF, DOC, DOCX — Max 2MB</p>
        </div>
      </div>

      <form id="uploadForm">

        <!-- Drag & Drop Zone -->
        <div class="drop-zone mb-5" id="dropZone">
          <input type="file" id="resume" name="resume" accept=".pdf,.doc,.docx" required>
          <div id="dropContent">
            <div class="w-16 h-16 rounded-2xl bg-blue-50 flex items-center justify-center mx-auto mb-4">
              <i class="fas fa-cloud-upload-alt text-blue-500 text-2xl"></i>
            </div>
            <p class="font-sora font-semibold text-gray-700 text-base mb-1">Drag & drop your resume here</p>
            <p class="text-sm text-gray-400 mb-4">or click to browse files</p>
            <div class="flex items-center justify-center gap-2 flex-wrap">
              <span class="file-badge bg-red-50 text-red-600"><i class="fas fa-file-pdf text-xs"></i> PDF</span>
              <span class="file-badge bg-blue-50 text-blue-600"><i class="fas fa-file-word text-xs"></i> DOC</span>
              <span class="file-badge bg-blue-50 text-blue-600"><i class="fas fa-file-word text-xs"></i> DOCX</span>
            </div>
          </div>
          <!-- File selected state (hidden by default) -->
          <div id="fileSelected" class="hidden">
            <div class="w-14 h-14 rounded-2xl bg-green-50 flex items-center justify-center mx-auto mb-3">
              <i class="fas fa-file-check text-green-500 text-xl"></i>
            </div>
            <p class="font-sora font-semibold text-gray-800 text-sm" id="fileName">file.pdf</p>
            <p class="text-xs text-gray-400 mt-1" id="fileSize">0 KB</p>
            <span class="inline-block mt-2 text-xs text-green-600 bg-green-50 border border-green-200 rounded-full px-3 py-1">
              <i class="fas fa-check mr-1"></i>Ready to upload
            </span>
          </div>
        </div>

        <!-- Progress Bar (hidden by default) -->
        <div id="progressContainer" class="hidden mb-5">
          <div class="flex items-center justify-between mb-1.5">
            <span class="text-xs font-medium text-gray-600">Uploading...</span>
            <span class="text-xs text-gray-400" id="progressText">0%</span>
          </div>
          <div class="h-2 bg-gray-100 rounded-full overflow-hidden">
            <div class="progress-bar-fill" id="progressBar"></div>
          </div>
        </div>

        <!-- Status Message -->
        <div id="statusMessage" class="hidden mb-5"></div>

        <!-- Submit Button -->
        <button type="submit" id="submitBtn"
          class="w-full bg-blue-600 hover:bg-blue-700 disabled:opacity-60 disabled:cursor-not-allowed text-white font-sora font-semibold text-sm px-6 py-3.5 rounded-xl transition-all hover:-translate-y-0.5 shadow-md shadow-blue-600/20 flex items-center justify-center gap-2">
          <i class="fas fa-paper-plane text-sm"></i>
          Submit Resume
        </button>
      </form>
    </div>

    <!-- What Happens Next -->
    <div class="bg-white rounded-2xl border border-gray-100 shadow-sm p-6">
      <h3 class="font-sora font-bold text-base text-gray-900 mb-4">What happens next?</h3>
      <div class="space-y-4">
        <div class="flex items-start gap-3">
          <div class="w-7 h-7 rounded-full bg-blue-600 text-white text-xs font-bold flex items-center justify-center flex-shrink-0 mt-0.5">1</div>
          <div>
            <p class="text-sm font-semibold text-gray-800">Resume is reviewed</p>
            <p class="text-xs text-gray-400 mt-0.5">Our system indexes your skills and experience for better job matching.</p>
          </div>
        </div>
        <div class="flex items-start gap-3">
          <div class="w-7 h-7 rounded-full bg-blue-600 text-white text-xs font-bold flex items-center justify-center flex-shrink-0 mt-0.5">2</div>
          <div>
            <p class="text-sm font-semibold text-gray-800">Employers can find you</p>
            <p class="text-xs text-gray-400 mt-0.5">Top companies searching for your skill set can discover your profile.</p>
          </div>
        </div>
        <div class="flex items-start gap-3">
          <div class="w-7 h-7 rounded-full bg-yellow-400 text-white text-xs font-bold flex items-center justify-center flex-shrink-0 mt-0.5">3</div>
          <div>
            <p class="text-sm font-semibold text-gray-800">Get interview calls</p>
            <p class="text-xs text-gray-400 mt-0.5">Sit back and wait for employers to reach out directly to you!</p>
          </div>
        </div>
      </div>
    </div>

  </div>
</section>

<!-- FOOTER -->
<footer style="background:#0f172a;" class="pt-14 pb-6">
  <div class="max-w-7xl mx-auto px-5">
    <div class="grid grid-cols-2 md:grid-cols-4 gap-8 mb-10">
      <div class="col-span-2 md:col-span-1">
        <p class="font-sora font-bold text-xl text-white mb-2">Job<span class="text-yellow-400">Board</span></p>
        <p class="text-xs text-white/40 leading-relaxed max-w-[200px]">The easiest way to connect talent with top companies across India.</p>
        <div class="flex gap-2 mt-4">
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 transition-all text-xs"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 transition-all text-xs"><i class="fab fa-twitter"></i></a>
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 transition-all text-xs"><i class="fab fa-instagram"></i></a>
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 transition-all text-xs"><i class="fab fa-linkedin-in"></i></a>
        </div>
      </div>
      <div>
        <p class="text-xs font-semibold text-white uppercase tracking-widest mb-4">For Job Seekers</p>
        <ul class="space-y-2.5">
          <li><a href="userhome.jsp"         class="text-xs text-white/40 hover:text-white transition-colors">Browse Jobs</a></li>
          <li><a href="newProfile.jsp"        class="text-xs text-white/40 hover:text-white transition-colors">My Profile</a></li>
          <li><a href="Application-track.jsp" class="text-xs text-white/40 hover:text-white transition-colors">Applications</a></li>
          <li><a href="resumeupload.jsp"      class="text-xs text-white/40 hover:text-white transition-colors">Upload Resume</a></li>
        </ul>
      </div>
      <div>
        <p class="text-xs font-semibold text-white uppercase tracking-widest mb-4">Company</p>
        <ul class="space-y-2.5">
          <li><a href="about.jsp"   class="text-xs text-white/40 hover:text-white transition-colors">About Us</a></li>
          <li><a href="contact.jsp" class="text-xs text-white/40 hover:text-white transition-colors">Contact</a></li>
          <li><a href="#"           class="text-xs text-white/40 hover:text-white transition-colors">Blog</a></li>
        </ul>
      </div>
      <div>
        <p class="text-xs font-semibold text-white uppercase tracking-widest mb-4">Support</p>
        <ul class="space-y-2.5">
          <li><a href="#" class="text-xs text-white/40 hover:text-white transition-colors">FAQ</a></li>
          <li><a href="#" class="text-xs text-white/40 hover:text-white transition-colors">Privacy Policy</a></li>
          <li><a href="#" class="text-xs text-white/40 hover:text-white transition-colors">Terms of Service</a></li>
        </ul>
      </div>
    </div>
    <hr class="border-white/10 mb-6">
    <p class="text-center text-xs text-white/30">&copy; <span id="yr"></span> JobBoard. All rights reserved.</p>
  </div>
</footer>

<script>
  document.getElementById('yr').textContent = new Date().getFullYear();

  // Mobile menu
  document.getElementById('hamburger').addEventListener('click', function(){
    document.getElementById('mobileMenu').classList.toggle('open');
  });

  // Drag & Drop highlight
  const dropZone = document.getElementById('dropZone');
  dropZone.addEventListener('dragover',  e => { e.preventDefault(); dropZone.classList.add('dragover'); });
  dropZone.addEventListener('dragleave', () => dropZone.classList.remove('dragover'));
  dropZone.addEventListener('drop',      e => { e.preventDefault(); dropZone.classList.remove('dragover'); });

  // File selected — show file info
  document.getElementById('resume').addEventListener('change', function(){
    const file = this.files[0];
    if (!file) return;
    document.getElementById('dropContent').classList.add('hidden');
    document.getElementById('fileSelected').classList.remove('hidden');
    document.getElementById('fileName').textContent = file.name;
    document.getElementById('fileSize').textContent = (file.size / 1024).toFixed(1) + ' KB';
  });

  // Form submit
  document.getElementById('uploadForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const status      = document.getElementById('statusMessage');
    const submitBtn   = document.getElementById('submitBtn');
    const progressBox = document.getElementById('progressContainer');
    const progressBar = document.getElementById('progressBar');
    const progressTxt = document.getElementById('progressText');
    const formData    = new FormData(this);

    submitBtn.disabled = true;
    status.classList.add('hidden');
    progressBox.classList.remove('hidden');

    // Simulate progress
    let pct = 0;
    const interval = setInterval(() => {
      pct = Math.min(pct + Math.random() * 18, 90);
      progressBar.style.width = pct + '%';
      progressTxt.textContent = Math.floor(pct) + '%';
    }, 200);

    fetch('UploadServlet', { method: 'POST', body: formData })
      .then(response => {
        if (!response.ok) throw new Error('Upload failed. Please try again.');
        return response.text();
      })
      .then(() => {
        clearInterval(interval);
        progressBar.style.width = '100%';
        progressTxt.textContent = '100%';
        setTimeout(() => {
          progressBox.classList.add('hidden');
          status.classList.remove('hidden');
          status.innerHTML = `
            <div class="flex items-center gap-3 bg-green-50 border border-green-200 rounded-xl p-4">
              <div class="w-9 h-9 rounded-full bg-green-100 flex items-center justify-center flex-shrink-0">
                <i class="fas fa-check text-green-600"></i>
              </div>
              <div>
                <p class="text-sm font-semibold text-green-800">Resume uploaded successfully!</p>
                <p class="text-xs text-green-600 mt-0.5">Employers can now discover your profile.</p>
              </div>
            </div>`;
          document.getElementById('uploadForm').reset();
          document.getElementById('dropContent').classList.remove('hidden');
          document.getElementById('fileSelected').classList.add('hidden');
        }, 400);
      })
      .catch(error => {
        clearInterval(interval);
        progressBox.classList.add('hidden');
        status.classList.remove('hidden');
        status.innerHTML = `
          <div class="flex items-center gap-3 bg-red-50 border border-red-200 rounded-xl p-4">
            <div class="w-9 h-9 rounded-full bg-red-100 flex items-center justify-center flex-shrink-0">
              <i class="fas fa-times text-red-600"></i>
            </div>
            <div>
              <p class="text-sm font-semibold text-red-800">Upload failed</p>
              <p class="text-xs text-red-600 mt-0.5">${error.message}</p>
            </div>
          </div>`;
      })
      .finally(() => { submitBtn.disabled = false; });
  });
</script>
</body>
</html>