/**
 * ====================================================================
 * Chandigarh University - MCA AIP Mini Project
 * JavaScript Form Validation & Interactive Client Scripts
 * ====================================================================
 */

document.addEventListener('DOMContentLoaded', () => {
    initFormValidation();
    initLiveSearch();
    initAlertDismiss();
});

/**
 * Validates Registration Form fields on submission and on blur.
 */
function validateRegistrationForm() {
    const nameInput = document.getElementById('fullName');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const rollNoInput = document.getElementById('rollNo');
    const phoneInput = document.getElementById('phone');

    let isValid = true;

    // Validate Full Name
    if (!nameInput || nameInput.value.trim().length < 3) {
        showError('nameError', 'Full Name must be at least 3 characters long.');
        isValid = false;
    } else {
        hideError('nameError');
    }

    // Validate Email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailInput || !emailRegex.test(emailInput.value.trim())) {
        showError('emailError', 'Please enter a valid university or personal email address.');
        isValid = false;
    } else {
        hideError('emailError');
    }

    // Validate Roll Number
    if (!rollNoInput || rollNoInput.value.trim().length < 4) {
        showError('rollNoError', 'Please enter a valid University Roll Number (e.g. 23MCA1001).');
        isValid = false;
    } else {
        hideError('rollNoError');
    }

    // Validate Password
    if (!passwordInput || passwordInput.value.length < 6) {
        showError('passwordError', 'Password must contain at least 6 characters.');
        isValid = false;
    } else {
        hideError('passwordError');
    }

    // Validate Password Match
    if (!confirmPasswordInput || passwordInput.value !== confirmPasswordInput.value) {
        showError('confirmPasswordError', 'Passwords do not match.');
        isValid = false;
    } else {
        hideError('confirmPasswordError');
    }

    // Validate Phone (optional but if provided, must be 10 digits)
    if (phoneInput && phoneInput.value.trim() !== '') {
        const phoneRegex = /^[0-9]{10}$/;
        if (!phoneRegex.test(phoneInput.value.trim())) {
            showError('phoneError', 'Phone number must be exactly 10 digits.');
            isValid = false;
        } else {
            hideError('phoneError');
        }
    }

    return isValid;
}

/**
 * Validates Login Form fields.
 */
function validateLoginForm() {
    const emailInput = document.getElementById('loginEmail');
    const passwordInput = document.getElementById('loginPassword');

    let isValid = true;
    if (!emailInput || emailInput.value.trim() === '') {
        showError('loginEmailError', 'Email is required.');
        isValid = false;
    } else {
        hideError('loginEmailError');
    }

    if (!passwordInput || passwordInput.value.trim() === '') {
        showError('loginPasswordError', 'Password is required.');
        isValid = false;
    } else {
        hideError('loginPasswordError');
    }

    return isValid;
}

/**
 * Validates Event Creation/Edit Form.
 */
function validateEventForm() {
    const title = document.getElementById('eventTitle');
    const venue = document.getElementById('eventVenue');
    const dateInput = document.getElementById('eventDate');
    const capacityInput = document.getElementById('eventCapacity');

    let isValid = true;

    if (!title || title.value.trim().length < 3) {
        showError('eventTitleError', 'Event title must be at least 3 characters.');
        isValid = false;
    } else {
        hideError('eventTitleError');
    }

    if (!venue || venue.value.trim() === '') {
        showError('eventVenueError', 'Venue location cannot be empty.');
        isValid = false;
    } else {
        hideError('eventVenueError');
    }

    if (!dateInput || dateInput.value === '') {
        showError('eventDateError', 'Event date is required.');
        isValid = false;
    } else {
        // Check if date is in the past
        const selectedDate = new Date(dateInput.value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        if (selectedDate < today) {
            showError('eventDateError', 'Event date cannot be in the past.');
            isValid = false;
        } else {
            hideError('eventDateError');
        }
    }

    if (!capacityInput || parseInt(capacityInput.value) < 1) {
        showError('eventCapacityError', 'Event capacity must be at least 1 seat.');
        isValid = false;
    } else {
        hideError('eventCapacityError');
    }

    return isValid;
}

function showError(elementId, message) {
    const errElem = document.getElementById(elementId);
    if (errElem) {
        errElem.textContent = message;
        errElem.style.display = 'block';
    }
}

function hideError(elementId) {
    const errElem = document.getElementById(elementId);
    if (errElem) {
        errElem.style.display = 'none';
    }
}

/**
 * Confirm before deleting or cancelling items.
 */
function confirmAction(message) {
    return confirm(message || 'Are you sure you want to proceed with this action?');
}

/**
 * Live search filter on event cards in browser.
 */
function initLiveSearch() {
    const searchInput = document.getElementById('liveEventSearch');
    if (!searchInput) return;

    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase().trim();
        const cards = document.querySelectorAll('.event-card');

        cards.forEach(card => {
            const title = card.querySelector('.event-title')?.textContent.toLowerCase() || '';
            const desc = card.querySelector('.event-desc')?.textContent.toLowerCase() || '';
            const venue = card.querySelector('.meta-venue')?.textContent.toLowerCase() || '';

            if (title.includes(query) || desc.includes(query) || venue.includes(query)) {
                card.style.display = 'flex';
            } else {
                card.style.display = 'none';
            }
        });
    });
}

function initFormValidation() {
    const regForm = document.getElementById('registrationForm');
    if (regForm) {
        regForm.addEventListener('submit', (e) => {
            if (!validateRegistrationForm()) {
                e.preventDefault();
            }
        });
    }

    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            if (!validateLoginForm()) {
                e.preventDefault();
            }
        });
    }

    const eventForm = document.getElementById('eventForm');
    if (eventForm) {
        eventForm.addEventListener('submit', (e) => {
            if (!validateEventForm()) {
                e.preventDefault();
            }
        });
    }
}

function initAlertDismiss() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });
}
