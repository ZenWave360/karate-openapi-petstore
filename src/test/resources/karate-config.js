function fn() {
    karate.configure('headers', { accept: 'application/json' });

    return {
        baseUrl: 'https://petstore3.swagger.io/api/v3'
    };
}