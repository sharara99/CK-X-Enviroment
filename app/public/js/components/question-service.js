/**
 * Question Service
 * Handles question display and navigation
 */

// Process question content to improve formatting and highlighting
function processQuestionContent(content) {
    // First, preserve existing HTML formatting
    let processedContent = content;
    
    // Add click-to-copy functionality for URLs (simple approach)
    processedContent = processedContent.replace(
        /(https?:\/\/[^\s<>"{}|\\^`[\]]+)/g,
        '<span class="clickable-url" data-copy-text="$1" title="Click to copy URL">$1</span>'
    );
    
    // ===== QUESTION 15 SPECIFIC HIGHLIGHTING - MUST BE FIRST =====
    // Highlight specific values for NetworkPolicy question
    processedContent = processedContent.replace(
        /(backend-allow-frontend)/g,
        '<span class="highlight-yellow" style="background-color: #fff3cd; padding: 2px 4px; border-radius: 3px; font-weight: bold;" data-copy-text="backend-allow-frontend" title="Click to copy">backend-allow-frontend</span>'
    );
    
    processedContent = processedContent.replace(
        /(app=backend-api)/g,
        '<span class="highlight-yellow" style="background-color: #fff3cd; padding: 2px 4px; border-radius: 3px; font-weight: bold;" data-copy-text="app=backend-api" title="Click to copy">app=backend-api</span>'
    );
    
    processedContent = processedContent.replace(
        /(name=frontend)/g,
        '<span class="highlight-yellow" style="background-color: #fff3cd; padding: 2px 4px; border-radius: 3px; font-weight: bold;" data-copy-text="name=frontend" title="Click to copy">name=frontend</span>'
    );
    
    processedContent = processedContent.replace(
        /(backend-allow-all|backend-deny-all)/g,
        '<span class="highlight-red" style="background-color: #f8d7da; padding: 2px 4px; border-radius: 3px; text-decoration: line-through; font-weight: bold;" data-copy-text="$1" title="Do NOT use">$1</span>'
    );
    
    // Highlight standalone "backend" and "frontend" when they appear as values
    processedContent = processedContent.replace(
        /([\s\(])(backend)([\s\)])/g,
        function(match, before, value, after) {
            // Only highlight if not already inside a span
            if (match.includes('<span')) return match;
            return before + '<span class="highlight-blue" style="background-color: #d1ecf1; padding: 2px 4px; border-radius: 3px; font-weight: bold;" data-copy-text="backend" title="Click to copy">backend</span>' + after;
        }
    );
    
    processedContent = processedContent.replace(
        /([\s\(])(frontend)([\s\)])/g,
        function(match, before, value, after) {
            // Only highlight if not already inside a span
            if (match.includes('<span')) return match;
            return before + '<span class="highlight-blue" style="background-color: #d1ecf1; padding: 2px 4px; border-radius: 3px; font-weight: bold;" data-copy-text="frontend" title="Click to copy">frontend</span>' + after;
        }
    );
    // ===== END QUESTION 15 HIGHLIGHTING =====
    
    // Add click-to-copy functionality for kubectl commands
    processedContent = processedContent.replace(
        /(kubectl\s+[^\n\r<]+)/g,
        '<span class="clickable-command" data-copy-text="$1" title="Click to copy kubectl command">$1</span>'
    );
    
    // Add click-to-copy functionality for specific naming patterns
    // Ingress name: value
    processedContent = processedContent.replace(
        /(Ingress name|ingress name):\s*([a-zA-Z0-9-_]+)/g,
        function(match, label, value) {
            return label + ': <span class="clickable-ingress" data-copy-text="' + value + '" title="Click to copy ingress name">' + value + '</span>';
        }
    );
    
    // Namespace: value
    processedContent = processedContent.replace(
        /(Namespace|namespace):\s*([a-zA-Z0-9-_]+)/g,
        function(match, label, value) {
            return label + ': <span class="clickable-namespace" data-copy-text="' + value + '" title="Click to copy namespace">' + value + '</span>';
        }
    );
    
    // Host: value
    processedContent = processedContent.replace(
        /(Host|host):\s*([a-zA-Z0-9.-]+)/g,
        '$1: <span class="clickable-host" data-copy-text="$2" title="Click to copy host">$2</span>'
    );
    
    // Path: value
    processedContent = processedContent.replace(
        /(Path|path):\s*([a-zA-Z0-9/_-]+)/g,
        '$1: <span class="clickable-path" data-copy-text="$2" title="Click to copy path">$2</span>'
    );
    
    // Service: value
    processedContent = processedContent.replace(
        /(Service|service):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-service" data-copy-text="$2" title="Click to copy service name">$2</span>'
    );
    
    // Port: value
    processedContent = processedContent.replace(
        /(Port|port):\s*([0-9]+)/g,
        '$1: <span class="clickable-port" data-copy-text="$2" title="Click to copy port">$2</span>'
    );
    
    // Pod name: value
    processedContent = processedContent.replace(
        /(Pod name|pod name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-pod" data-copy-text="$2" title="Click to copy pod name">$2</span>'
    );
    
    // Deployment name: value
    processedContent = processedContent.replace(
        /(Deployment name|deployment name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-deployment" data-copy-text="$2" title="Click to copy deployment name">$2</span>'
    );
    
    // ConfigMap name: value
    processedContent = processedContent.replace(
        /(ConfigMap name|configmap name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-configmap" data-copy-text="$2" title="Click to copy configmap name">$2</span>'
    );
    
    // Secret name: value
    processedContent = processedContent.replace(
        /(Secret name|secret name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-secret" data-copy-text="$2" title="Click to copy secret name">$2</span>'
    );
    
    // Additional patterns for specific resource names
    // PriorityClass name: value
    processedContent = processedContent.replace(
        /(PriorityClass name|priorityclass name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-priorityclass" data-copy-text="$2" title="Click to copy priorityclass name">$2</span>'
    );
    
    // StorageClass name: value
    processedContent = processedContent.replace(
        /(StorageClass name|storageclass name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-storageclass" data-copy-text="$2" title="Click to copy storageclass name">$2</span>'
    );
    
    // Gateway name: value
    processedContent = processedContent.replace(
        /(Gateway name|gateway name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-gateway" data-copy-text="$2" title="Click to copy gateway name">$2</span>'
    );
    
    // HTTPRoute name: value
    processedContent = processedContent.replace(
        /(HTTPRoute name|httproute name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-httproute" data-copy-text="$2" title="Click to copy httproute name">$2</span>'
    );
    
    // PVC name: value
    processedContent = processedContent.replace(
        /(PVC name|pvc name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-pvc" data-copy-text="$2" title="Click to copy PVC name">$2</span>'
    );
    
    // HPA name: value
    processedContent = processedContent.replace(
        /(HPA name|hpa name):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-hpa" data-copy-text="$2" title="Click to copy HPA name">$2</span>'
    );
    
    // Target: value (for HPA)
    processedContent = processedContent.replace(
        /(Target|target):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-target" data-copy-text="$2" title="Click to copy target">$2</span>'
    );
    
    // Min replicas: value
    processedContent = processedContent.replace(
        /(Min replicas|min replicas):\s*([0-9]+)/g,
        '$1: <span class="clickable-minreplicas" data-copy-text="$2" title="Click to copy min replicas">$2</span>'
    );
    
    // Max replicas: value
    processedContent = processedContent.replace(
        /(Max replicas|max replicas):\s*([0-9]+)/g,
        '$1: <span class="clickable-maxreplicas" data-copy-text="$2" title="Click to copy max replicas">$2</span>'
    );
    
    // CPU target: value
    processedContent = processedContent.replace(
        /(CPU target|cpu target):\s*([0-9]+%)/g,
        '$1: <span class="clickable-cputarget" data-copy-text="$2" title="Click to copy CPU target">$2</span>'
    );
    
    // Storage size: value
    processedContent = processedContent.replace(
        /([0-9]+Mi|[0-9]+Gi|[0-9]+M|[0-9]+G)\s+storage/g,
        '<span class="clickable-storage" data-copy-text="$1" title="Click to copy storage size">$1</span> storage'
    );
    
    // Version numbers: value
    processedContent = processedContent.replace(
        /(v[0-9]+\.[0-9]+\.[0-9]+)/g,
        '<span class="clickable-version" data-copy-text="$1" title="Click to copy version">$1</span>'
    );
    
    // File paths: value
    processedContent = processedContent.replace(
        /(\/[a-zA-Z0-9-_\/\.]+\.(yaml|yml|log|conf|json))/g,
        '<span class="clickable-filepath" data-copy-text="$1" title="Click to copy file path">$1</span>'
    );
    
    // Container images: value
    processedContent = processedContent.replace(
        /([a-zA-Z0-9-_\/]+:[a-zA-Z0-9-_\.]+)/g,
        '<span class="clickable-image" data-copy-text="$1" title="Click to copy container image">$1</span>'
    );
    
    // NodePort values: value
    processedContent = processedContent.replace(
        /(NodePort|nodeport):\s*([0-9]+)/g,
        '$1: <span class="clickable-nodeport" data-copy-text="$2" title="Click to copy NodePort">$2</span>'
    );
    
    // Provisioner: value
    processedContent = processedContent.replace(
        /(Provisioner|provisioner):\s*([a-zA-Z0-9-_\.\/]+)/g,
        '$1: <span class="clickable-provisioner" data-copy-text="$2" title="Click to copy provisioner">$2</span>'
    );
    
    // GatewayClass: value
    processedContent = processedContent.replace(
        /(GatewayClass|gatewayclass):\s*([a-zA-Z0-9-_]+)/g,
        '$1: <span class="clickable-gatewayclass" data-copy-text="$2" title="Click to copy GatewayClass">$2</span>'
    );
    
    // Specific patterns for common naming scenarios (optimized)
    // "named X" patterns - only for specific resources
    processedContent = processedContent.replace(
        /(named|Named)\s+(high-priority|low-latency|apache-server|web-gateway|web-route|web-tls|nginx-config|mariadb|busybox-logger|synergy-deployment|front-end-svc)/g,
        '$1 <span class="clickable-named" data-copy-text="$2" title="Click to copy name">$2</span>'
    );
    
    // Specific resource names with their types
    processedContent = processedContent.replace(
        /\b(synergy-deployment|front-end|WordPress|MariaDB|nginx-static|apache-server)\s+(deployment|Deployment)\b/g,
        '<span class="clickable-deployment-name" data-copy-text="$1" title="Click to copy deployment name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(relative-fawn|mariadb|nginx-static|autoscale|echo-sound|tigera-operator|argocd|priority|sp-culator|cert-manager)\s+(namespace|Namespace)\b/g,
        '<span class="clickable-namespace-name" data-copy-text="$1" title="Click to copy namespace name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(nginx-config)\s+(ConfigMap|configmap)\b/g,
        '<span class="clickable-configmap-name" data-copy-text="$1" title="Click to copy ConfigMap name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(mariadb)\s+(PVC|pvc)\b/g,
        '<span class="clickable-pvc-name" data-copy-text="$1" title="Click to copy PVC name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(web-gateway)\s+(Gateway|gateway)\b/g,
        '<span class="clickable-gateway-name" data-copy-text="$1" title="Click to copy Gateway name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(web-route)\s+(HTTPRoute|httproute)\b/g,
        '<span class="clickable-httproute-name" data-copy-text="$1" title="Click to copy HTTPRoute name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(web-tls)\s+(secret|Secret)\b/g,
        '<span class="clickable-secret-name" data-copy-text="$1" title="Click to copy secret name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(web)\s+(Ingress|ingress)\b/g,
        '<span class="clickable-ingress-name" data-copy-text="$1" title="Click to copy Ingress name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(high-priority)\s+(PriorityClass|priorityclass)\b/g,
        '<span class="clickable-priorityclass-name" data-copy-text="$1" title="Click to copy PriorityClass name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(low-latency)\s+(StorageClass|storageclass)\b/g,
        '<span class="clickable-storageclass-name" data-copy-text="$1" title="Click to copy StorageClass name">$1</span> $2'
    );
    
    processedContent = processedContent.replace(
        /\b(apache-server)\s+(HPA|hpa)\b/g,
        '<span class="clickable-hpa-name" data-copy-text="$1" title="Click to copy HPA name">$1</span> $2'
    );
    
    // Specific replicas patterns
    processedContent = processedContent.replace(
        /\b(3)\s+(replicas|Replicas)\b/g,
        '<span class="clickable-replicas" data-copy-text="$1" title="Click to copy replicas">$1</span> $2'
    );
    
    // Specific percentage patterns
    processedContent = processedContent.replace(
        /\b(10%|90%)\s+(for|For)\s+(node|WordPress)/g,
        '<span class="clickable-percentage" data-copy-text="$1" title="Click to copy percentage">$1</span> $2 <span class="clickable-resource" data-copy-text="$3" title="Click to copy resource name">$3</span>'
    );
    
    // Specific node patterns
    processedContent = processedContent.replace(
        /\b(node01|master|worker)\b/g,
        '<span class="clickable-node" data-copy-text="$1" title="Click to copy node name">$1</span>'
    );
    
    // Specific volume patterns
    processedContent = processedContent.replace(
        /\b(shared-logs)\s+(volume|Volume)\b/g,
        '<span class="clickable-volume" data-copy-text="$1" title="Click to copy volume name">$1</span> $2'
    );
    
    // Specific container patterns
    processedContent = processedContent.replace(
        /\b(busybox-logger|init)\s+(container|Container)\b/g,
        '<span class="clickable-container" data-copy-text="$1" title="Click to copy container name">$1</span> $2'
    );
    
    // Specific listener patterns
    processedContent = processedContent.replace(
        /\b(HTTPS)\s+(listener|Listener)\b/g,
        '<span class="clickable-listener" data-copy-text="$1" title="Click to copy listener name">$1</span> $2'
    );
    
    // Specific endpoint patterns
    processedContent = processedContent.replace(
        /\b(HTTPS)\s+(endpoint|Endpoint)\b/g,
        '<span class="clickable-endpoint" data-copy-text="$1" title="Click to copy endpoint name">$1</span> $2'
    );
    
    // Specific failure patterns
    processedContent = processedContent.replace(
        /\b(TLSv1\.2)\s+(failure|Failure)\b/g,
        '<span class="clickable-failure" data-copy-text="$1" title="Click to copy failure type">$1</span> $2'
    );
    
    // Additional specific patterns you identified
    // "busybox-logger deployment" pattern
    processedContent = processedContent.replace(
        /\b(busybox-logger)\s+(deployment|Deployment)\b/g,
        '<span class="clickable-deployment-specific" data-copy-text="$1" title="Click to copy deployment name">$1</span> $2'
    );
    
    // "namespace sp-culator" pattern
    processedContent = processedContent.replace(
        /\b(namespace|Namespace)\s+(sp-culator)\b/g,
        '$1 <span class="clickable-namespace-specific" data-copy-text="$2" title="Click to copy namespace">$2</span>'
    );
    
    // "front-end pods" pattern
    processedContent = processedContent.replace(
        /\b(front-end)\s+(pods|Pods)\b/g,
        '<span class="clickable-pods-specific" data-copy-text="$1" title="Click to copy pod name">$1</span> $2'
    );
    
    // "NodePort to 30080" pattern
    processedContent = processedContent.replace(
        /\b(NodePort|nodeport)\s+(to|To)\s+(30080)\b/g,
        '$1 $2 <span class="clickable-nodeport-specific" data-copy-text="$3" title="Click to copy NodePort">$3</span>'
    );
    
    // "Name: low-latency" pattern
    processedContent = processedContent.replace(
        /\b(Name|name):\s+(low-latency)\b/g,
        '$1: <span class="clickable-name-specific" data-copy-text="$2" title="Click to copy name">$2</span>'
    );
    
    // "Volume binding mode: WaitForFirstConsumer" pattern
    processedContent = processedContent.replace(
        /\b(Volume binding mode|volume binding mode):\s+(WaitForFirstConsumer)\b/g,
        '$1: <span class="clickable-binding-mode" data-copy-text="$2" title="Click to copy binding mode">$2</span>'
    );
    
    // "Edit synergy-deployment" pattern
    processedContent = processedContent.replace(
        /\b(Edit|edit)\s+(synergy-deployment)\b/g,
        '$1 <span class="clickable-edit-target" data-copy-text="$2" title="Click to copy deployment name">$2</span>'
    );
    
    // "relative-fawn" standalone pattern
    processedContent = processedContent.replace(
        /\b(relative-fawn)\b/g,
        '<span class="clickable-namespace-standalone" data-copy-text="$1" title="Click to copy namespace">$1</span>'
    );
    
    // "/var/lib/mysql" path pattern
    processedContent = processedContent.replace(
        /\b(\/var\/lib\/mysql)\b/g,
        '<span class="clickable-mount-path" data-copy-text="$1" title="Click to copy mount path">$1</span>'
    );
    
    // "name web-gateway" pattern
    processedContent = processedContent.replace(
        /\b(name|Name)\s+(web-gateway)\b/g,
        '$1 <span class="clickable-gateway-name-specific" data-copy-text="$2" title="Click to copy gateway name">$2</span>'
    );
    
    // "namespace autoscale" pattern
    processedContent = processedContent.replace(
        /\b(namespace|Namespace)\s+(autoscale)\b/g,
        '$1 <span class="clickable-namespace-autoscale" data-copy-text="$2" title="Click to copy namespace">$2</span>'
    );
    
    // Add highlighting to text in single quotes that isn't already styled
    processedContent = processedContent.replace(
        /`([^`]+)`/g, 
        function(match, text) {
            // Skip if already inside an HTML tag or existing styled element
            if (match.match(/<.*>/) || 
                match.includes('class="code"') || 
                match.includes('class="highlight"') ||
                match.includes('class="clickable-')) {
                return match;
            }
            return `<span class="inline-code clickable-code" data-copy-text="${text}" title="Click to copy">${text}</span>`;
        }
    );
    
    // Style inline code with backticks if not already styled
    processedContent = processedContent.replace(
        /`([^`]+)`/g, 
        '<code class="bg-light px-1 rounded clickable-code" data-copy-text="$1" title="Click to copy">$1</code>'
    );
    
    // Style bold text
    processedContent = processedContent.replace(
        /\*\*([^*]+)\*\*/g, 
        '<strong>$1</strong>'
    );
    
    // Style italic text
    processedContent = processedContent.replace(
        /\*([^*]+)\*/g, 
        '<em>$1</em>'
    );
    
    // Convert literal newline characters to HTML line breaks
    processedContent = processedContent.replace(/\n/g, '<br>');
    
    // Ensure paragraphs have proper spacing and line breaks
    processedContent = processedContent.replace(
        /<\/p><p>/g, 
        '</p>\n<p>'
    );
    
    // Add more spacing between list items
    processedContent = processedContent.replace(
        /<\/li><li>/g, 
        '</li>\n<li>'
    );
    
    return processedContent;
}

// Generate question content HTML
function generateQuestionContent(question) {
    try {
        // Get original data
        const originalData = question.originalData || {};
        const machineHostname = originalData.machineHostname || 'N/A';
        const namespace = originalData.namespace || 'N/A';
        const concepts = originalData.concepts || [];
        const conceptsString = concepts.join(', ');
        
        // Format question content with improved styling
        const formattedQuestionContent = processQuestionContent(question.content);
        
        // Create formatted content with minimal layout
        return `
            <div class="d-flex flex-column" style="height: 100%;">
                <div class="question-header">
                    
                    <div class="mb-3">
                        <strong>Solve this question on instance:</strong> <span class="inline-code">ssh ${machineHostname}</span></span>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Namespace:</strong> <span class="text-primary">${namespace}</span>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Concepts:</strong> <span class="text-primary">${conceptsString}</span>
                    </div>
                    
                    <hr class="my-3">
                </div>
                
                <div class="question-body">
                    ${formattedQuestionContent}
                </div>
                
                <div class="action-buttons-container mt-auto">
                    <div class="d-flex justify-content-between py-2">
                        <button class="btn ${question.flagged ? 'btn-warning' : 'btn-outline-warning'}" id="flagQuestionBtn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-flag${question.flagged ? '-fill' : ''} me-2" viewBox="0 0 16 16">
                                <path d="M14.778.085A.5.5 0 0 1 15 .5V8a.5.5 0 0 1-.314.464L14.5 8l.186.464-.003.001-.006.003-.023.009a12.435 12.435 0 0 1-.397.15c-.264.095-.631.223-1.047.35-.816.252-1.879.523-2.71.523-.847 0-1.548-.28-2.158-.525l-.028-.01C7.68 8.71 7.14 8.5 6.5 8.5c-.7 0-1.638.23-2.437.477A19.626 19.626 0 0 0 3 9.342V15.5a.5.5 0 0 1-1 0V.5a.5.5 0 0 1 1 0v.282c.226-.079.496-.17.79-.26C4.606.272 5.67 0 6.5 0c.84 0 1.524.277 2.121.519l.043.018C9.286.788 9.828 1 10.5 1c.7 0 1.638-.23 2.437-.477a19.587 19.587 0 0 0 1.349-.476l.019-.007.004-.002h.001"/>
                            </svg>
                            ${question.flagged ? 'Flagged' : 'Flag for review'}
                        </button>
                        <button class="btn btn-success" id="nextQuestionBtn">
                            Satisfied with answer
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-right ms-2" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z"/>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
        `;
    } catch (error) {
        console.error('Error generating question content:', error);
        return '<div class="alert alert-danger">Error displaying question content. Please try refreshing the page.</div>';
    }
}

// Transform API response to question objects
function transformQuestionsFromApi(data) {
    if (data.questions && Array.isArray(data.questions)) {
        // Transform the questions to match our expected format
        return data.questions.map(q => ({
            id: q.id,
            content: q.question || '', // Map 'question' field to 'content'
            title: `Question ${q.id}`,  // Create a title from the ID
            originalData: q, // Keep original data for reference if needed
            flagged: false // Add flagged status property
        }));
    }
    return [];
}

// Update question dropdown
function updateQuestionDropdown(questionsArray, dropdownMenu, currentId, onQuestionSelect) {
    // Clear existing dropdown items
    dropdownMenu.innerHTML = '';
    
    // Add items for each question
    questionsArray.forEach((question) => {
        const li = document.createElement('li');
        const a = document.createElement('a');
        a.className = 'dropdown-item';
        a.href = '#';
        a.dataset.question = question.id;
        a.textContent = `Question ${question.id}`;
        
        // Add flag icon if question is flagged
        if (question.flagged) {
            const flagIcon = document.createElement('span');
            flagIcon.className = 'flag-icon ms-2';
            flagIcon.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="bi bi-flag-fill text-warning" viewBox="0 0 16 16"><path d="M14.778.085A.5.5 0 0 1 15 .5V8a.5.5 0 0 1-.314.464L14.5 8l.186.464-.003.001-.006.003-.023.009a12.435 12.435 0 0 1-.397.15c-.264.095-.631.223-1.047.35-.816.252-1.879.523-2.71.523-.847 0-1.548-.28-2.158-.525l-.028-.01C7.68 8.71 7.14 8.5 6.5 8.5c-.7 0-1.638.23-2.437.477A19.626 19.626 0 0 0 3 9.342V15.5a.5.5 0 0 1-1 0V.5a.5.5 0 0 1 1 0v.282c.226-.079.496-.17.79-.26C4.606.272 5.67 0 6.5 0c.84 0 1.524.277 2.121.519l.043.018C9.286.788 9.828 1 10.5 1c.7 0 1.638-.23 2.437-.477a19.587 19.587 0 0 0 1.349-.476l.019-.007.004-.002h.001"/></svg>';
            a.appendChild(flagIcon);
        }
        
        // Add click event
        a.addEventListener('click', function(e) {
            e.preventDefault();
            const clickedQuestionId = this.dataset.question;
            if (onQuestionSelect) {
                onQuestionSelect(clickedQuestionId);
            }
        });
        
        li.appendChild(a);
        dropdownMenu.appendChild(li);
    });
}

export {
    processQuestionContent,
    generateQuestionContent,
    transformQuestionsFromApi,
    updateQuestionDropdown
}; 