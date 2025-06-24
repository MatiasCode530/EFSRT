package com.centroinformacion.config;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
        .csrf().disable()  // Deshabilita la protección CSRF
            .authorizeRequests()
                // Permite acceso sin autenticación a las rutas especificadas
                .requestMatchers(new AntPathRequestMatcher("/intranetLogin", "POST")).permitAll()  // Página de login
                .requestMatchers(new AntPathRequestMatcher("/**")).permitAll()  // Permite acceso a cualquier otra URL
                .anyRequest().authenticated()  // Requiere autenticación para otras solicitudes
            .and()
            .formLogin()
                .loginPage("/intranetLogin")  // URL personalizada para la página de inicio de sesión
                .loginProcessingUrl("/intranetLogin")  // URL para procesar el formulario de inicio de sesión
                .defaultSuccessUrl("/intranetHome", true)  // Redirige a la página /home después de un inicio de sesión exitoso
                .failureUrl("/intranetLogin?error=true")  // Redirige si el inicio de sesión falla
                .permitAll()
            .and()
            .logout()
                .logoutUrl("/logout")  // URL de logout
                .logoutSuccessUrl("/")  // Redirige después del logout
                .permitAll();

        return http.build();
    }
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
