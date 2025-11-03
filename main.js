// ZipMaster Pro - Main JavaScript File
// LiquidGlass Design Interactive Features

document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

function initializeApp() {
    // Initialize all components
    initializeParticleBackground();
    initializeScrollAnimations();
    initializeInteractiveComponents();
    initializeSliders();
    initializeFAQ();
    initializePerformanceChart();
    
    // Page-specific initializations
    const currentPage = getCurrentPage();
    switch(currentPage) {
        case 'index':
            initializeHomePage();
            break;
        case 'features':
            initializeFeaturesPage();
            break;
        case 'download':
            initializeDownloadPage();
            break;
    }
}

function getCurrentPage() {
    const path = window.location.pathname;
    if (path.includes('features')) return 'features';
    if (path.includes('download')) return 'download';
    return 'index';
}

// Particle Background System
function initializeParticleBackground() {
    const container = document.getElementById('particle-container');
    if (!container) return;
    
    // Create particle system using p5.js
    new p5(function(p) {
        let particles = [];
        
        p.setup = function() {
            const canvas = p.createCanvas(p.windowWidth, p.windowHeight);
            canvas.parent('particle-container');
            
            // Create initial particles
            for (let i = 0; i < 50; i++) {
                particles.push(new Particle(p));
            }
        };
        
        p.draw = function() {
            p.clear();
            
            // Update and draw particles
            particles.forEach(particle => {
                particle.update();
                particle.display();
            });
        };
        
        p.windowResized = function() {
            p.resizeCanvas(p.windowWidth, p.windowHeight);
        };
        
        class Particle {
            constructor(p) {
                this.p = p;
                this.x = p.random(p.width);
                this.y = p.random(p.height);
                this.vx = p.random(-0.5, 0.5);
                this.vy = p.random(-0.5, 0.5);
                this.size = p.random(2, 6);
                this.opacity = p.random(0.3, 0.8);
            }
            
            update() {
                this.x += this.vx;
                this.y += this.vy;
                
                // Wrap around edges
                if (this.x < 0) this.x = this.p.width;
                if (this.x > this.p.width) this.x = 0;
                if (this.y < 0) this.y = this.p.height;
                if (this.y > this.p.height) this.y = 0;
            }
            
            display() {
                this.p.fill(255, 255, 255, this.opacity * 255);
                this.p.noStroke();
                this.p.ellipse(this.x, this.y, this.size);
            }
        }
    });
}

// Scroll Animations
function initializeScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Observe elements for scroll animation
    const animateElements = document.querySelectorAll('.liquid-glass, .demo-card, .feature-card');
    animateElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
}

// Interactive Components
function initializeInteractiveComponents() {
    // File extraction demo
    const selectFileBtn = document.getElementById('select-file-btn');
    if (selectFileBtn) {
        selectFileBtn.addEventListener('click', simulateFileExtraction);
    }
    
    // Format support demo
    const formatItems = document.querySelectorAll('.format-item');
    formatItems.forEach(item => {
        item.addEventListener('click', showFormatDetails);
    });
    
    // Encryption demo
    const encryptBtn = document.getElementById('encrypt-btn');
    if (encryptBtn) {
        encryptBtn.addEventListener('click', simulateEncryption);
    }
    
    // Volume compression demo
    const volumeSlider = document.getElementById('volume-slider');
    if (volumeSlider) {
        volumeSlider.addEventListener('input', updateVolumePreview);
    }
    
    // Compression level buttons
    const compressionButtons = document.querySelectorAll('.compression-level');
    compressionButtons.forEach(btn => {
        btn.addEventListener('click', selectCompressionLevel);
    });
}

// File Extraction Simulation
function simulateFileExtraction() {
    const progressContainer = document.getElementById('extraction-progress');
    const progressBar = document.getElementById('progress-bar');
    const progressText = document.getElementById('progress-text');
    const fileList = document.getElementById('file-list');
    
    if (!progressContainer || !progressBar || !progressText) return;
    
    progressContainer.classList.remove('hidden');
    
    const files = [
        'document.pdf', 'image.jpg', 'video.mp4', 
        'audio.mp3', 'data.csv', 'presentation.pptx'
    ];
    
    let progress = 0;
    const interval = setInterval(() => {
        progress += Math.random() * 15;
        if (progress > 100) progress = 100;
        
        progressBar.style.width = progress + '%';
        progressText.textContent = Math.floor(progress) + '%';
        
        if (progress >= 100) {
            clearInterval(interval);
            showExtractedFiles(files);
        }
    }, 200);
}

function showExtractedFiles(files) {
    const fileList = document.getElementById('file-list');
    if (!fileList) return;
    
    fileList.innerHTML = '';
    files.forEach((file, index) => {
        setTimeout(() => {
            const fileItem = document.createElement('div');
            fileItem.className = 'flex items-center space-x-2 p-2 bg-white/10 rounded text-white text-sm';
            fileItem.innerHTML = `
                <span class="text-green-400">✓</span>
                <span>${file}</span>
            `;
            fileList.appendChild(fileItem);
            
            anime({
                targets: fileItem,
                opacity: [0, 1],
                translateX: [-20, 0],
                duration: 300,
                easing: 'easeOutQuad'
            });
        }, index * 100);
    });
}

// Format Details
function showFormatDetails(event) {
    const format = event.currentTarget.dataset.format;
    const detailsContainer = document.getElementById('format-details');
    const description = document.getElementById('format-description');
    
    if (!detailsContainer || !description) return;
    
    const formatInfo = {
        zip: {
            name: 'ZIP格式',
            description: '最流行的压缩格式，兼容性好，支持加密和分卷压缩。适用于日常文件压缩和分享。'
        },
        '7z': {
            name: '7Z格式', 
            description: '高压缩比格式，使用LZMA/LZMA2压缩算法。适合需要最大化压缩效果的场景。'
        },
        rar: {
            name: 'RAR格式',
            description: '功能强大的专有格式，支持固实压缩、恢复记录等高级功能。广泛用于分卷压缩。'
        }
    };
    
    const info = formatInfo[format];
    if (info) {
        description.textContent = info.description;
        detailsContainer.classList.remove('hidden');
        
        anime({
            targets: detailsContainer,
            opacity: [0, 1],
            translateY: [-10, 0],
            duration: 300,
            easing: 'easeOutQuad'
        });
    }
}

// Encryption Simulation
function simulateEncryption() {
    const password = document.getElementById('password-input').value;
    const strength = document.getElementById('encryption-strength').value;
    const statusContainer = document.getElementById('encryption-status');
    
    if (!password) {
        alert('请输入加密密码');
        return;
    }
    
    if (!statusContainer) return;
    
    statusContainer.classList.remove('hidden');
    
    setTimeout(() => {
        statusContainer.innerHTML = `
            <div class="text-center">
                <div class="text-green-400 text-xl mb-2">✓</div>
                <div class="text-white text-sm">加密完成 (${strength}位AES)</div>
            </div>
        `;
    }, 2000);
}

// Volume Compression
function updateVolumePreview() {
    const slider = document.getElementById('volume-slider');
    const sizeDisplay = document.getElementById('volume-size');
    const countDisplay = document.getElementById('volume-count');
    
    if (!slider || !sizeDisplay || !countDisplay) return;
    
    const size = slider.value;
    sizeDisplay.textContent = size;
    
    // Simulate volume count calculation
    const totalSize = 1000; // MB
    const count = Math.ceil(totalSize / size);
    countDisplay.textContent = count;
}

function selectCompressionLevel(event) {
    const buttons = document.querySelectorAll('.compression-level');
    buttons.forEach(btn => {
        btn.classList.remove('bg-pink-500', 'text-white');
        btn.classList.add('bg-white/10', 'hover:bg-white/20', 'text-white');
    });
    
    event.target.classList.remove('bg-white/10', 'hover:bg-white/20', 'text-white');
    event.target.classList.add('bg-pink-500', 'text-white');
}

// Sliders Initialization
function initializeSliders() {
    // Initialize Splide sliders
    const reviewsSlider = document.getElementById('reviews-slider');
    if (reviewsSlider) {
        new Splide(reviewsSlider, {
            type: 'loop',
            perPage: 3,
            perMove: 1,
            gap: '1rem',
            autoplay: true,
            interval: 4000,
            breakpoints: {
                1024: { perPage: 2 },
                768: { perPage: 1 }
            }
        }).mount();
    }
}

// FAQ Functionality
function initializeFAQ() {
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
        item.addEventListener('click', toggleFAQ);
    });
}

function toggleFAQ(event) {
    const item = event.currentTarget;
    const answer = item.querySelector('.faq-answer');
    const icon = item.querySelector('span');
    
    if (answer.classList.contains('active')) {
        answer.classList.remove('active');
        icon.textContent = '+';
    } else {
        // Close other FAQs
        document.querySelectorAll('.faq-answer').forEach(a => {
            a.classList.remove('active');
        });
        document.querySelectorAll('.faq-item span').forEach(i => {
            i.textContent = '+';
        });
        
        // Open current FAQ
        answer.classList.add('active');
        icon.textContent = '−';
    }
}

// Performance Chart
function initializePerformanceChart() {
    const chartContainer = document.getElementById('performance-chart');
    if (!chartContainer) return;
    
    const chart = echarts.init(chartContainer);
    
    const option = {
        backgroundColor: 'transparent',
        textStyle: {
            color: '#ffffff'
        },
        tooltip: {
            trigger: 'axis',
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            borderColor: 'rgba(255, 255, 255, 0.2)',
            textStyle: {
                color: '#ffffff'
            }
        },
        legend: {
            data: ['解压速度', '压缩速度', '内存效率'],
            textStyle: {
                color: '#ffffff'
            }
        },
        xAxis: {
            type: 'category',
            data: ['ZipMaster Pro', 'WinZip', '7-Zip', 'RAR', '原生工具'],
            axisLine: {
                lineStyle: {
                    color: 'rgba(255, 255, 255, 0.3)'
                }
            },
            axisLabel: {
                color: '#ffffff'
            }
        },
        yAxis: {
            type: 'value',
            axisLine: {
                lineStyle: {
                    color: 'rgba(255, 255, 255, 0.3)'
                }
            },
            axisLabel: {
                color: '#ffffff'
            },
            splitLine: {
                lineStyle: {
                    color: 'rgba(255, 255, 255, 0.1)'
                }
            }
        },
        series: [
            {
                name: '解压速度',
                type: 'bar',
                data: [95, 78, 82, 85, 65],
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#f093fb' },
                        { offset: 1, color: '#f5576c' }
                    ])
                }
            },
            {
                name: '压缩速度',
                type: 'bar',
                data: [92, 75, 88, 80, 60],
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#667eea' },
                        { offset: 1, color: '#764ba2' }
                    ])
                }
            },
            {
                name: '内存效率',
                type: 'bar',
                data: [98, 70, 75, 78, 85],
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#4facfe' },
                        { offset: 1, color: '#00f2fe' }
                    ])
                }
            }
        ]
    };
    
    chart.setOption(option);
    
    // Resize chart on window resize
    window.addEventListener('resize', () => {
        chart.resize();
    });
}

// Page-specific initializations
function initializeHomePage() {
    // Initialize volume slider
    const volumeSlider = document.getElementById('volume-slider');
    if (volumeSlider) {
        volumeSlider.addEventListener('input', updateVolumePreview);
        updateVolumePreview(); // Initial update
    }
    
    // Initialize preview button
    const previewBtn = document.getElementById('preview-btn');
    if (previewBtn) {
        previewBtn.addEventListener('click', showVolumePreview);
    }
}

function showVolumePreview() {
    const slider = document.getElementById('volume-slider');
    const countDisplay = document.getElementById('volume-count');
    
    if (!slider || !countDisplay) return;
    
    const size = parseInt(slider.value);
    const totalSize = 1000; // MB
    const count = Math.ceil(totalSize / size);
    
    // Animate the count
    anime({
        targets: countDisplay,
        innerHTML: [0, count],
        duration: 1000,
        round: 1,
        easing: 'easeOutQuad'
    });
}

function initializeFeaturesPage() {
    // Initialize volume compression demo
    const fileSizeSlider = document.getElementById('file-size-slider');
    const volumeSizeSlider = document.getElementById('volume-size-slider');
    const calculateBtn = document.getElementById('calculate-btn');
    
    if (fileSizeSlider) {
        fileSizeSlider.addEventListener('input', updateFileSizeDisplay);
        updateFileSizeDisplay();
    }
    
    if (volumeSizeSlider) {
        volumeSizeSlider.addEventListener('input', updateVolumeSizeDisplay);
        updateVolumeSizeDisplay();
    }
    
    if (calculateBtn) {
        calculateBtn.addEventListener('click', calculateVolumeCompression);
    }
    
    // Initialize compression buttons
    const compressionBtns = document.querySelectorAll('.compression-btn');
    compressionBtns.forEach(btn => {
        btn.addEventListener('click', selectCompressionBtn);
    });
}

function updateFileSizeDisplay() {
    const slider = document.getElementById('file-size-slider');
    const display = document.getElementById('file-size-display');
    if (slider && display) {
        display.textContent = slider.value + 'MB';
    }
}

function updateVolumeSizeDisplay() {
    const slider = document.getElementById('volume-size-slider');
    const display = document.getElementById('volume-size-display');
    if (slider && display) {
        display.textContent = slider.value + 'MB';
    }
}

function calculateVolumeCompression() {
    const fileSize = parseInt(document.getElementById('file-size-slider').value);
    const volumeSize = parseInt(document.getElementById('volume-size-slider').value);
    const resultsContainer = document.getElementById('volume-results');
    const placeholder = document.getElementById('volume-placeholder');
    
    if (!resultsContainer || !placeholder) return;
    
    // Hide placeholder and show results
    placeholder.classList.add('hidden');
    resultsContainer.classList.remove('hidden');
    
    // Calculate results
    const totalParts = Math.ceil(fileSize / volumeSize);
    const compressionRatio = 0.7; // 70% compression
    const compressedSize = Math.floor(fileSize * compressionRatio);
    const estimatedTime = Math.floor(fileSize / 500); // Rough estimate
    
    // Animate results
    anime({
        targets: '#total-parts',
        innerHTML: [0, totalParts],
        duration: 1000,
        round: 1,
        easing: 'easeOutQuad'
    });
    
    anime({
        targets: '#compressed-size',
        innerHTML: [0, compressedSize],
        duration: 1000,
        round: 1,
        easing: 'easeOutQuad'
    });
    
    document.getElementById('estimated-time').textContent = estimatedTime + '分钟';
    
    // Generate volume preview
    generateVolumePreview(totalParts);
    
    // Animate compression progress
    anime({
        targets: '#compression-bar',
        width: '100%',
        duration: 2000,
        easing: 'easeOutQuad'
    });
    
    anime({
        targets: '#compression-progress',
        innerHTML: [0, 100],
        duration: 2000,
        round: 1,
        easing: 'easeOutQuad',
        update: function(anim) {
            document.getElementById('compression-progress').textContent = Math.floor(anim.progress) + '%';
        }
    });
}

function generateVolumePreview(count) {
    const container = document.getElementById('volume-preview');
    if (!container) return;
    
    container.innerHTML = '';
    
    for (let i = 0; i < Math.min(count, 20); i++) {
        const part = document.createElement('div');
        part.className = 'volume-part';
        part.textContent = `part${i + 1}.7z`;
        container.appendChild(part);
        
        anime({
            targets: part,
            opacity: [0, 1],
            scale: [0.8, 1],
            duration: 300,
            delay: i * 50,
            easing: 'easeOutQuad'
        });
    }
    
    if (count > 20) {
        const more = document.createElement('div');
        more.className = 'volume-part';
        more.textContent = `+${count - 20}`;
        container.appendChild(more);
    }
}

function selectCompressionBtn(event) {
    const buttons = document.querySelectorAll('.compression-btn');
    buttons.forEach(btn => {
        btn.classList.remove('bg-pink-500', 'text-white');
        btn.classList.add('bg-white/10', 'hover:bg-white/20', 'text-white');
    });
    
    event.target.classList.remove('bg-white/10', 'hover:bg-white/20', 'text-white');
    event.target.classList.add('bg-pink-500', 'text-white');
}

function initializeDownloadPage() {
    // Initialize download buttons
    const downloadBtns = document.querySelectorAll('.download-btn');
    downloadBtns.forEach(btn => {
        btn.addEventListener('click', handleDownload);
    });
}

function handleDownload(event) {
    const button = event.target;
    const originalText = button.textContent;
    
    // Show loading state
    button.textContent = '准备下载...';
    button.disabled = true;
    
    // Simulate download process
    setTimeout(() => {
        button.textContent = '跳转中...';
        
        setTimeout(() => {
            // Show success message
            alert('即将跳转到App Store下载页面');
            
            // Reset button
            button.textContent = originalText;
            button.disabled = false;
        }, 1000);
    }, 1500);
}

// Utility Functions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Error Handling
window.addEventListener('error', function(event) {
    console.error('JavaScript Error:', event.error);
});

// Performance Monitoring
if ('performance' in window) {
    window.addEventListener('load', function() {
        setTimeout(() => {
            const perfData = performance.getEntriesByType('navigation')[0];
            console.log('Page Load Time:', perfData.loadEventEnd - perfData.loadEventStart, 'ms');
        }, 0);
    });
}