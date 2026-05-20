# Spring Boot

SaaSKit integration for Spring Boot 3.x using `spring-boot-starter-oauth2-client` and `scalekit-sdk-java`.

Reference: [scalekit-inc/scalekit-springboot-auth-example](https://github.com/scalekit-inc/scalekit-springboot-auth-example)

## Dependencies

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>com.scalekit</groupId>
    <artifactId>scalekit-sdk-java</artifactId>
    <version>2.0.4</version>
</dependency>
```

Requires Spring Boot 3.2+ and Java 17+.

## Configuration

`application.yml`:

```yaml
scalekit:
  env-url: ${SCALEKIT_ENV_URL}
  client-id: ${SCALEKIT_CLIENT_ID}
  client-secret: ${SCALEKIT_CLIENT_SECRET}
  redirect-uri: ${SCALEKIT_REDIRECT_URI:http://localhost:8080/login/oauth2/code/scalekit}

spring:
  security:
    oauth2:
      client:
        registration:
          scalekit:
            client-id: ${scalekit.client-id}
            client-secret: ${scalekit.client-secret}
            authorization-grant-type: authorization_code
            redirect-uri: ${scalekit.redirect-uri}
            scope: openid,profile,email,offline_access
        provider:
          scalekit:
            issuer-uri: ${scalekit.env-url}
            authorization-uri: ${scalekit.env-url}/oauth/authorize
            token-uri: ${scalekit.env-url}/oauth/token
            jwk-set-uri: ${scalekit.env-url}/keys
            user-name-attribute: sub

server:
  servlet:
    session:
      cookie:
        same-site: lax
        http-only: true
        secure: true
```

## Scalekit SDK bean

```java
@Configuration
public class ScalekitConfig {
    @Value("${scalekit.env-url}") private String envUrl;
    @Value("${scalekit.client-id}") private String clientId;
    @Value("${scalekit.client-secret}") private String clientSecret;

    @Bean
    public ScalekitClient scalekitClient() {
        return new ScalekitClient(envUrl, clientId, clientSecret);
    }
}
```

## Security filter chain

Spring Security's `oauth2-client` handles the full authorization code flow automatically:

```java
@Bean
public SecurityFilterChain filterChain(HttpSecurity http,
        ClientRegistrationRepository repo) throws Exception {
    http
        .authorizeHttpRequests(authz -> authz
            .requestMatchers("/", "/login", "/error", "/css/**", "/js/**").permitAll()
            .anyRequest().authenticated())
        .oauth2Login(oauth2 -> oauth2
            .loginPage("/login")
            .defaultSuccessUrl("/dashboard"))
        .logout(logout -> logout
            .logoutSuccessHandler(oidcLogoutHandler(repo))
            .invalidateHttpSession(true)
            .clearAuthentication(true));
    return http.build();
}

private LogoutSuccessHandler oidcLogoutHandler(ClientRegistrationRepository repo) {
    var handler = new OidcClientInitiatedLogoutSuccessHandler(repo);
    handler.setPostLogoutRedirectUri("{baseUrl}");
    return handler;
}
```

Always use `OidcClientInitiatedLogoutSuccessHandler` — a plain `logoutSuccessUrl` only clears the local session, leaving the IdP session active.

## Accessing user identity

```java
@GetMapping("/dashboard")
public String dashboard(@AuthenticationPrincipal OidcUser user, Model model) {
    model.addAttribute("name", user.getFullName());
    model.addAttribute("email", user.getEmail());
    model.addAttribute("claims", user.getClaims());
    return "dashboard";
}
```

## Tactics

- **SameSite=Lax** — set in `application.yml`. Without it, the session cookie is dropped on the OAuth redirect from Scalekit.
- **Deep links** — use `.defaultSuccessUrl("/dashboard")` without `true` to respect the saved request URL.
- **CORS** — add `CorsConfigurationSource` bean with `setAllowCredentials(true)` for browser clients.
- **AJAX** — override the authentication entry point to return `401` for `Accept: application/json`.
- **Cache-Control** — add `no-store` header on protected responses.
- **CSRF** — Spring Security disables CSRF for OAuth2 endpoints automatically; the `state` parameter serves as the CSRF token.

## Related docs

- [auth-flows.md](../auth-flows.md) — Framework-agnostic auth flow reference.
