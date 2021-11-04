function fn() {
    const port = karate.properties["karate.server.port"] || 3000;
    return {
        baseUrl: 'http://localhost:' + port + '/api/v3'
    };
}