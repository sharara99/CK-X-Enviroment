/**
 * Clipboard Service
 * Handles clipboard-related functionality for exam questions
 */

/**
 * Copy text to remote desktop clipboard via facilitator API
 * @param {string} content - Text content to copy
 * @private
 */
async function copyToRemoteClipboard(content) {
    try {
        // Fire and forget API call
        fetch('/facilitator/api/v1/remote-desktop/clipboard', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ content })
        });
    } catch (error) {
        console.error('Failed to copy to remote clipboard:', error);
        // Don't throw error as this is a non-critical operation
    }
}

/**
 * Show simple copy notification
 * @param {string} content - Content that was copied
 */
function showCopyNotification(content) {
    // Create a simple notification
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #28a745;
        color: white;
        padding: 10px 15px;
        border-radius: 5px;
        z-index: 9999;
        font-size: 14px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    `;
    notification.textContent = `Copied: ${content.length > 30 ? content.substring(0, 30) + '...' : content}`;
    
    document.body.appendChild(notification);
    
    // Remove after 2 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
    }, 2000);
}

/**
 * Setup click-to-copy functionality for all clickable elements
 */
function setupClickToCopy() {
    document.addEventListener('click', function(event) {
        // Find the closest element with data-copy-text (handles nested elements)
        let target = event.target;
        let copyText = null;
        
        // Walk up the DOM tree to find data-copy-text attribute
        while (target && target !== document) {
            if (target.hasAttribute && target.hasAttribute('data-copy-text')) {
                copyText = target.getAttribute('data-copy-text');
                break;
            }
            target = target.parentElement;
        }
        
        // If we found a copyable element, copy it
        if (copyText) {
            event.preventDefault();
            event.stopPropagation();
            
            // Log for debugging
            console.log('Copying text:', copyText);
            
            // Copy to remote desktop clipboard
            copyToRemoteClipboard(copyText);
            
            // Copy to local clipboard
            navigator.clipboard.writeText(copyText).then(() => {
                showCopyNotification(copyText);
            }).catch(err => {
                console.error('Could not copy text to clipboard:', err);
                // Fallback for older browsers
                try {
                    const textArea = document.createElement('textarea');
                    textArea.value = copyText;
                    document.body.appendChild(textArea);
                    textArea.select();
                    document.execCommand('copy');
                    document.body.removeChild(textArea);
                    showCopyNotification(copyText);
                } catch (fallbackErr) {
                    console.error('Fallback copy failed:', fallbackErr);
                }
            });
        }
    });
}

/**
 * Setup click-to-copy functionality for inline code elements (legacy support)
 */
function setupInlineCodeCopy() {
    document.addEventListener('click', function(event) {
        if (event.target && event.target.matches('.inline-code')) {
            const codeText = event.target.textContent;

            // Copy to remote desktop clipboard
            copyToRemoteClipboard(codeText);
            
            // Copy to local clipboard
            navigator.clipboard.writeText(codeText).then(() => {
                showCopyNotification(codeText);
            }).catch(err => {
                console.error('Could not copy text to clipboard:', err);
            });
        }
    });
}

export {
    setupClickToCopy,
    setupInlineCodeCopy
}; 