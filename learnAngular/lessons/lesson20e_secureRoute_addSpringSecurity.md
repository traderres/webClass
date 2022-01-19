Lesson 20e:  Secure Routes / Add Spring Security to the Back End
----------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1T3m8JsRDL4sM7tE9TXXPbjdIsWbEkorADHtkAY9eeDA/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson20e/secure-route/add-security
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  To protect back-end REST endpoints, the back-end needs to know what roles are granted to a user<br>
Solution:   Setup Spring-Security on the back-end and place roles in the UserInfo object<br>



<br>
<br>
<h3>What happens when a user connects to the webapp?</h3>

1. The user attempts to connect to the Spring Boot Web App  
1. Spring Security intercepts the REST call and verifies that the user is authenticated.  
   If the user is not authenticated, then attempt to authenticate the user  
   NOTE: This means verifying that the username is found in some system -- e.g., Active Directory, LDAP, some list of users  
1. If the user is valid, then get the list of roles granted to this user:  
   NOTE: The authentication service provides this: Active Directory or LDAP would have this info  
   https://lh5.googleusercontent.com/2XP3wBKjPFqd3WHp8B1N9NJG1yJ5HxBAY6O2x4s2s3PUK6r4gIP0j_lPLVd5EldfZPtB4cyPXct2lsucoC7eyGrUWWx_2J1NP6yiESBlOdJm05IcfKtiUX1Fuk4I6L8XmZcPfbcG
1. Get or Generate the Userid  
   If the user is not in the Users table, then add a Users record (and get the userId)  
   If the user is is in the Users table, then update the Users record with the latest login date (and get the userid)  
1. Create a UserInfo object that holds the user's name, userid, list of granted roles  
   NOTE: This object is available in all REST calls  
1. Return a sessionId field or cookie to the front-end  
    &lt;sessionId> -> UserInfo object on backend  
  
    NOTE: THe front-end will return the sessionId with future requests



<br>
<br>
<h5>Spring Security works with PKI authentication using https  (prod profile)</h5>

- The userid (hard-coded in the PKI certificate)  holds the user's name  (so there is no username/password)
- The back-end queries some external service to find out what roles are granted to the userid


<br>
<br>
<h5>Spring Security can be Simulated using http (dev profile)</h5>

- The back-end hard-codes the username
- The back-end hard-codes the list of granted roles
- The back-end hard-codes the userid


<br>
<br>
<h3>Your Web Application has 3 Security Modes (based on application.yaml)</h3>

1. Local http Mode<br>
   Running in local http mode (using http but get roles from hard-coded principal)  
   ```
   # Use hard-coded security principal  
   use.hardcoded.authenticated.principal: true  
  
   # Do not use SSL  
   server.ssl.enabled: false   
   ```
   <br>

1. Local https Mode<br>
   Running in local https mode (using https but get roles from hard-coded principal)  
   ```
    # Use hard-coded security principal  
    use.hardcoded.authenticated.principal: true  
    
    # We are running "prod mode" locally, get the CN info from the PKI cert  
    # On the BDP, we run "prod mode" to get CN info from the header  
    ssl.security.mode: **pki**  
     

     server:  
        port: 8443  
        ssl:  
        key-store: backend/src/main/dev_resources/myKeystore.jks  
        key-store-password: changeit  
        key-store-type: JKS  
        client-auth: need  
        trust-store: backend/src/main/dev_resources/myTruststore.jks  
        trust-store-password: changeit  
        trust-store-type: JKS  
        enabled: true  
    ```
   <br>
   
 1. BDP Mode<br>
    Running in https mode and getting roles from headers<br>
    ```
    # Use hard-coded security principal
    use.hardcoded.authenticated.principal: false
    
     # We are running "prod mode" locally, get the CN info from the PKI cert
     # On the BDP, we run "prod mode" to get CN info from the header
     ssl.security.mode: header
    
     server:
           port: 8443
                ssl:
                    key-store: backend/src/main/dev_resources/myKeystore.jks
                    key-store-password: changeit
                    key-store-type: JKS
                    client-auth: need
                    trust-store: backend/src/main/dev_resources/myTruststore.jks
                    trust-store-password: changeit
                    trust-store-type: JKS
                    enabled: true
                    
            # Secure the cookies
            server.servlet.session.cookie.secure: true
            server.servlet.session.cookie.http-only: true
    ```
    <br>
    <br>
    
   
   
   
   

```

Part 1:  Create the Certificates to run in SSL mode locally
-----------------------------------------------------------
    1. Create a Certificate Authority

       Windows:  
       https://github.com/traderres/webClass/blob/master/learnSSL/howToUseYourCertAuthority_InitialSetup.txt
        
       Unix:
       https://github.com/traderres/webClass/blob/master/learnSSL/howToUseYourCertAuthority_InitialSetup_centos7.txt



    2. Use the Certificate Authority to create your own server certificate  (holds mywebsite.somewhere.com)

       Windows:
       https://github.com/traderres/webClass/blob/master/learnSSL/howToUseYourCertAuthority_MakeServerCert.txt
        
       Unix:
       https://github.com/traderres/webClass/blob/master/learnSSL/howToUseYourCertAuthority_MakeServerCert_centos7.txt



    3. Use your Certificate Authority to create a PKI client certificate  (holds "John Smith")

       Windows:
       https://github.com/traderres/webClass/blob/master/learnSSL/howToUseYourCertAuthority_MakeClientCert.txt
        
       Unix:
       https://github.com/traderres/webClass/blob/master/learnSSL/howToUseYourCertAuthority_MakeClientCert_centos7.txt
        


    4. Install your client.p12, myKeystore.jks and myTrustStore.jks into the project
        a. Create this directory:  backend/src/main/dev_resources

        b. Copy the client.p12, myKeystore.jks and myTrustStore.jks to your new dev_resources directory




Part 2:  Add Spring Security to the Back End
--------------------------------------------
    1. Add the Spring Security dependencies to your backend's pom.xml file
        a. Edit the backend/pom.xml

        b. Add these dependencies

            <dependency>
                <groupId>org.springframework.security</groupId>
                <artifactId>spring-security-web</artifactId>
                <version>5.2.1.RELEASE</version>
            </dependency>
            
            <dependency>
                <groupId>org.springframework.security</groupId>
                <artifactId>spring-security-config</artifactId>
                <version>5.2.1.RELEASE</version>
            </dependency>


        c. Right-click on the pom.xml -> Maven -> Reload Project



    2. Add this package: security
        a. Right-click on backend/src/main/java/com/lessons -> New Package
           Package Name:  security



    3. Add this java class: UserInfo
        a. Right-click on security -> New Java Class
           Class Name:  UserInfo

        b. Copy this code to your newly-created class:
            
            package com.lessons.security;
            
            import org.apache.commons.lang3.StringUtils;
            import org.springframework.security.core.GrantedAuthority;
            import org.springframework.security.core.userdetails.UserDetails;
            import java.io.Serializable;
            import java.util.Collection;
            import java.util.Comparator;
            import java.util.List;
            import java.util.stream.Collectors;
            
            
            public class UserInfo implements UserDetails, Serializable{
            
                private String username;         		// The part of the Cn=.... from PKI client cert)
                private String usernameDN;                    // The entire DN string	(from the PKI client cert)
                private List<GrantedAuthority> grantedAuthorities;	// List of roles found in the database)
                private Integer id;                               	// Holds the user's ID in the database
            
                public String getPassword() {
                    // Must implement this method in order to implement the UserDetails interface
                    // NOTE:  There is no password as we are using PKI authentication
                    return null;
                }
            
                public String getUsername() {
                    return this.username;
                }
            
                public boolean isAccountNonExpired() {
                    // Must implement this method in order to implement the UserDetails interface
                    return true;
                }
            
                public boolean isAccountNonLocked() {
                    // Must implement this method in order to implement the UserDetails interface
                    return true;
                }
            
                public boolean isCredentialsNonExpired() {
                    // Must implement this method in order to implement the UserDetails interface
                    return true;
                }
            
                public boolean isEnabled() {
                    // Must implement this method in order to implement the UserDetails interface
                    return true;
                }
            
            
                /**
                * @return an array of GrantedAuthority objects for this user
                */
                public Collection<? extends GrantedAuthority> getAuthorities() {
                    // Must implement this method in order to implement the UserDetails interface
                    return this.grantedAuthorities;
                }
            
                /**
                * @return an array of Strings (for this user)
                */
                public List<String> getRoles() {
                    return grantedAuthorities.stream().map(auth -> auth.toString()).collect(Collectors.toList());
                }
            
                public String getUsernameDN() {
                    return this.usernameDN;
                }
            
                public List<GrantedAuthority> getGrantedAuthorities() {
                    return grantedAuthorities;
                }
            
                public void setGrantedAuthorities(List<GrantedAuthority> grantedAuthorities) {
                    this.grantedAuthorities = grantedAuthorities;
                }
            
                private static class GrantedAuthorityComparator implements Comparator<GrantedAuthority> {
                    public int compare(GrantedAuthority object1, GrantedAuthority object2) {
                        return object1.getAuthority().compareTo(object2.getAuthority());
                    }
                }
            
                public Integer getId() {
                    return id;
                }
            
                public String toString() {
                    return ("Roles=" + StringUtils.join(this.grantedAuthorities, ",") +
                            " UID=" + this.username +
                            " DN=" + this.usernameDN);
                }
            
                public UserInfo withId(Integer id) {
                    this.id = id;
                    return this;
                }
            
                public UserInfo withUsernameUID(String usernameUID) {
                    this.username = usernameUID;
                    return this;
                }
            
                public UserInfo withUsernameDn(String usernameDN) {
                    this.usernameDN = usernameDN;
                    return this;
                }
            
                public UserInfo withGrantedAuthorities(List<GrantedAuthority> grantedAuthorities) {
                    this.grantedAuthorities = grantedAuthorities;
                    return this;
                }
            
            }



    4. Add this java class:  SubjectX509PrincipalExtractor
        a. Right-click on security -> New Java Class
           Class Name:  SubjectX509PrincipalExtractor

        b. Copy this code to your newly-created class:
            
            package com.lessons.security;
            
            import org.springframework.security.web.authentication.preauth.x509.X509PrincipalExtractor;
            import org.springframework.stereotype.Component;
            import java.security.cert.X509Certificate;
            
            
            /**
             * Extractor for the principal from the certificate.
             */
            @Component("com.lessons.security.SubjectX509PrincipalExtractor")
            public class SubjectX509PrincipalExtractor implements X509PrincipalExtractor
            {
            
                public Object extractPrincipal(X509Certificate clientCertificate)
                {
                    // Get the Distinguished Name (DN) from the cert
                    return clientCertificate.getSubjectX500Principal().getName();
                }
            }



    5. Add this java class:  UserService
        a. Right-click on backend/src/main/java/com/lessons/services -> New Java Class
           Class Name:  UserService

        b. Copy this to your newly-create class:
            
            package com.lessons.services;
            
            import com.lessons.security.UserInfo;
            import org.springframework.jdbc.core.JdbcTemplate;
            import org.springframework.security.core.Authentication;
            import org.springframework.security.core.context.SecurityContext;
            import org.springframework.security.core.context.SecurityContextHolder;
            import org.springframework.stereotype.Service;
            import javax.annotation.Resource;
            import javax.sql.DataSource;
            
            @Service("com.lessons.services.UserService")
            public class UserService {
            
                @Resource
                private DataSource dataSource;
            
                /**
                * @return the UserInfo object from Spring-Security
                */
                public UserInfo getUserInfo() {
                    // Get the UserInfo object from Spring Security
                    SecurityContext securityContext = SecurityContextHolder.getContext();
            
                    if (securityContext == null) {
                        throw new RuntimeException("Error in getUserInfoFromSecurity():  SecurityContext is null.  This should never happen.");
                    }
            
                    Authentication auth = securityContext.getAuthentication();
                    if (auth == null) {
                        throw new RuntimeException("Error in getUserInfoFromSecurity():  Authentication is null.  This should never happen.");
                    }
            
                    UserInfo userInfo = (UserInfo) auth.getPrincipal();
                    if (userInfo == null) {
                        throw new RuntimeException("Error in getUserInfoFromSecurity():  UserInfo is null.  This should never happen.");
                    }
            
                    return userInfo;
                }
            
            
                /**
                * @return The name of the logged-in user
                */
                public String getLoggedInUserName() {
                    UserInfo userinfo = getUserInfo();
            
                    return userinfo.getUsername();
                }
            
                /**
                * @return The ID of the logged-in user
                */
                public Integer getLoggedInUserId() {
                    UserInfo userinfo = getUserInfo();
            
                    return userinfo.getId();
                }
            
            
                public Integer getOrAddUserRecordsToSystem(String aUsername) {
                    JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                    Integer userid = 25;
            
            //    	// Query the database to see if the id exists
            //    	String sql = "select id from users where username=?";
            //    	SqlRowSet rs = jt.queryForRowSet(sql, aUsername);
            //
            //    	if (rs.next()) {
            //        	// This record already exists in the system -- so return it
            //         	userid = rs.getInt("id");
            //    	}
            //    	else {
            //        	// This record does not exist -- so add it
            //        	sql = "insert into users(id, version, full_name, username, password, email, phone_number, is_locked, is_registered)\n" +
            //              	"values(nextval('seq_table_ids'), 1, 'John Smith', ?, 'secret', null, null, false, true) returning id";
            //
            //        	userid = jt.queryForObject(sql, Integer.class, aUsername);
            //    	}
            //
                    return userid;
                }
            
            
            }




    6. Add this java class:  MyAuthenticationManager
        a. Right-click on backend/src/main/java/com/lessons/security -> New Java Class
           Class Name:  MyAuthenticationManager

        b. Copy this to your new class
            
            package com.lessons.security;
            
            import com.lessons.services.UserService;
            import org.apache.commons.lang3.StringUtils;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.beans.factory.annotation.Value;
            import org.springframework.security.authentication.AuthenticationManager;
            import org.springframework.security.core.Authentication;
            import org.springframework.security.core.AuthenticationException;
            import org.springframework.security.core.GrantedAuthority;
            import org.springframework.security.core.authority.SimpleGrantedAuthority;
            import org.springframework.security.core.context.SecurityContextHolder;
            import org.springframework.security.core.userdetails.UserDetails;
            import org.springframework.security.core.userdetails.UsernameNotFoundException;
            import org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationToken;
            import org.springframework.stereotype.Component;
            import javax.annotation.Resource;
            import javax.servlet.http.HttpServletRequest;
            import java.util.ArrayList;
            import java.util.List;
            import java.util.regex.Matcher;
            import java.util.regex.Pattern;
            
            @Component("com.lessons.security.MyAuthenticationManager")
            public class MyAuthenticationManager implements AuthenticationManager {
                private static final Logger logger = LoggerFactory.getLogger(MyAuthenticationManager.class);
            
                private static final Pattern patExtractCN = Pattern.compile("cn=(.*?)(?:,|/|\\z)", Pattern.CASE_INSENSITIVE);
                private static final Pattern patMatchRole = Pattern.compile("ROLE:(.*?)(?:;|\\z)",
            Pattern.CASE_INSENSITIVE);
            
                @Resource
                private UserService userService;
            
                @Resource
                private HttpServletRequest httpServletRequest;
            
                @Value("${use.hardcoded.authenticated.principal}")
                private boolean useHardcodedAuthenticatedPrincipal;
            
                @Override
                public Authentication authenticate(Authentication authentication) throws AuthenticationException {
                    logger.debug("authenticate() started.   authentication={}", authentication);
            
                    if (SecurityContextHolder.getContext().getAuthentication() != null) {
                        // Users is already authenticated, so do nothing
                        return  SecurityContextHolder.getContext().getAuthentication();
                    }
            
                    UserDetails userDetails;
            
                    if (! useHardcodedAuthenticatedPrincipal) {
                        // We are in production mode and we are getting information from headers
                        // -- So get the roles from a real source -- e.g., ActiveDirectory, Database, or BDP headers
                        userDetails = loadUserDetailsFromRealSource(authentication);
                    }
                    else {
                        // Get the hard-coded bogus user details
                        userDetails = loadUserDetailsForDevelopment(authentication);
                    }
            
                    // Return an AuthenticationToken object
                    PreAuthenticatedAuthenticationToken preapproved = new PreAuthenticatedAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                    preapproved.setAuthenticated(true);
                    logger.debug("authenticate() finished.  preapproved={}", preapproved.toString());
                    return preapproved;
                }
            
                private UserDetails loadUserDetailsFromRealSource(Authentication authentication) {
                    logger.debug("loadUserDetailsFromRealSource() started authentication={}", authentication);
                    String userDN;
                    PreAuthenticatedAuthenticationToken token;
            
                    if (authentication.getPrincipal() instanceof String) {
                        userDN = authentication.getPrincipal().toString();
                    } else if (authentication.getPrincipal() instanceof UserInfo) {
                        return (UserDetails) authentication.getPrincipal();
                    } else {
                        token = ( PreAuthenticatedAuthenticationToken ) authentication.getPrincipal();
                        userDN = token.getName();
                    }
            
                    logger.debug("userDN={}", userDN);
            
                    // Get the user's UID from the CN=<...>
                    try {
                        String userUID = getCnValueFromLongDnString(userDN);
            
                        // Get the list of roles from the header
                        List<GrantedAuthority> grantedRoleAuthorities = getAuthoritiesFromHeaderValue();
            
                        if (grantedRoleAuthorities.size() > 0) {
                            // This user has at least one role found in my authorization service
                            // NOTE:  All granted authorities must start with the "ROLE_" prefix
                            grantedRoleAuthorities.add(new SimpleGrantedAuthority("ROLE_USER_FOUND_IN_VALID_LIST_OF_USERS"));
                        }
                        else {
                            // This user has no roles so throw a runtime exception
                            throw new RuntimeException("No roles were found for this user: " + userUID);
                        }
            
                        logger.info("{} successfully logged-in.", userUID);
            
                        // User is about to login
                        // -- This would be the place to add/update a database record indicating that the user logged-in
                        Integer userId = this.userService.getOrAddUserRecordsToSystem(userUID);
            
                        logger.debug("loadUserDetailsFromRealSource() about to return new UserInfo object");
            
                        // We *MUST* set the database ID in the UserInfo object here
                        return new UserInfo()
                                .withId(userId)
                                .withUsernameDn(userDN)
                                .withUsernameUID(userUID)
                                .withGrantedAuthorities(grantedRoleAuthorities);
                    } catch (Exception e) {
                        throw new UsernameNotFoundException("Exception raised in loadUserDetailsFromRealSource():  This user will definitely not login", e);
                    }
                }
            
                /**
                * header(X-BDP-User) holds -AUTH:FOUO;AUTH:U;AUTH:USA;GROUP:BDPUSERS;NAME:bdptest_u_fouo;ROLE:ANALYTIC_RUNNER;ROLE:BDP_ADMIN;ROLE:CITE_USER;ROLE:DATA_ADMIN;ROLE:KIBANA_ADMIN;ROLE:LOGS;ROLE:METRICS;ROLE:OWF_ADMIN;ROLE:OWF_USER;ROLE:UNITY_ADMIN<---
                * Pull every ROLE:role name entry out of the header and insert it into a list of GrantedAuthority objects
                * @return List of GrantedAuthority objects
                */
                private List<GrantedAuthority> getAuthoritiesFromHeaderValue() {
                    List<GrantedAuthority> grantedRoles = new ArrayList<>();
            
                    // header(X-BDP-User) holds -AUTH:FOUO;AUTH:U;AUTH:USA;GROUP:BDPUSERS;NAME:bdptest_u_fouo;ROLE:ANALYTIC_RUNNER;ROLE:BDP_ADMIN;ROLE:CITE_USER;ROLE:DATA_ADMIN;ROLE:KIBANA_ADMIN;ROLE:LOGS;ROLE:METRICS;ROLE:OWF_ADMIN;ROLE:OWF_USER;ROLE:UNITY_ADMIN<---
                    String xbdpUserHeaderValue = httpServletRequest.getHeader("X-BDP-User");
                    logger.debug("In getAuthoritiesFromHeaderValue():  header-->{}<--", xbdpUserHeaderValue);
                    if (StringUtils.isEmpty(xbdpUserHeaderValue)) {
                        // The header is empty -- so return an empty list
                        logger.warn("Warning in getAuthoritiesFromHeaderValue():  The X-BDP-User header had nothing in it.  This should never happen.");
                        return grantedRoles;
                    }
            
                    // Pull every string that starts with ROLE: and add it to the list
                    Matcher matcher = patMatchRole.matcher(xbdpUserHeaderValue);
                    while (matcher.find()) {
                        String roleName = matcher.group(1);
                        logger.debug("Found a role:  roleName={}", roleName);
                        String roleNameWithPrefix = "ROLE_" + roleName;
                        grantedRoles.add(new SimpleGrantedAuthority(roleNameWithPrefix));
                    }
            
                    logger.debug("getAuthoritiesFromHeaderValue() returns -->{}<--", StringUtils.join(grantedRoles, ","));
                    return grantedRoles;
                }
            
                public UserDetails loadUserDetailsForDevelopment(Authentication authentication) {
                    String userUID = "my_test_user";
                    String userDN = "3.2.12.144549.1.9.1=#161760312e646576,CN=my_test_user,OU=Hosts,O=ZZTop.Org,C=ZZ";
            
                    if ((authentication != null) && (authentication.getPrincipal() != null)) {
                        userDN = authentication.getPrincipal().toString();
                        userUID = getCnValueFromLongDnString(userDN);
                        if (userUID == null) {
                            userUID = "my_test_user";
                        }
                    }
            
                    // Create a list of granted authorities
                    List<GrantedAuthority> grantedAuthorities = new ArrayList<>();
                    grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_READER"));
                    grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_USER_FOUND_IN_VALID_LIST_OF_USERS"));
            
                    // User is about to login
                    // -- This would be the place to add/update a database record indicating that the user logged-in
                    Integer userId = 25;
            
                    // Create a bogus UserInfo object
                    // NOTE:  I am hard-coding the user's userid=25
                    UserInfo anonymousUserInfo = new UserInfo()
                            .withId(userId)
                            .withUsernameUID(userUID)
                            .withUsernameDn(userDN)
                            .withGrantedAuthorities(grantedAuthorities);
                    return anonymousUserInfo;
                }
            
                private static String getCnValueFromLongDnString(String userDN) {
                    logger.debug("getCnValueFromLongDnString()  userDN={}", userDN);
                    String cnValue = null;
                    // Use the regular expression pattern to getByUserId the value part of "CN=value"
                    Matcher matcher = patExtractCN.matcher(userDN);
                    if (matcher.find()) {
                        cnValue = matcher.group(1);
                    }
            
                    logger.debug("getCnValueFromLongDnString() returns -->{}<--", cnValue);
                    return cnValue;
                }
            
            }


    7. Add this java class:  MyRequestHeaderAuthFilter
        a. Right-click on security -> New Java Class
           Class Name:  MyRequestHeaderAuthFilter

        b. Copy this to your new class
            
            package com.lessons.security;
            
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.beans.factory.annotation.Value;
            import org.springframework.security.web.authentication.preauth.RequestHeaderAuthenticationFilter;
            import org.springframework.stereotype.Component;
            import javax.annotation.PostConstruct;
            import javax.annotation.Resource;
            import javax.servlet.http.HttpServletRequest;
            
            
            @Component("com.lessons.security.RequestHeaderAuthFilter")
            public class MyRequestHeaderAuthFilter extends RequestHeaderAuthenticationFilter
            {
                private static final Logger logger = LoggerFactory.getLogger(MyRequestHeaderAuthFilter.class);
            
                @Resource
                private MyAuthenticationManager myAuthenticationManager;
            
                @Value("${use.hardcoded.authenticated.principal}")
                private boolean useHardcodedAuthenticatedPrincipal;
            
                @PostConstruct
                public void init() {
                    this.setAuthenticationManager(myAuthenticationManager);
                }
            
            
                /**
                * This is called when a request is made to get the pre-authenticated principal
                * @param request holds the request object
                * @return the userDN found in the certificate
                */
                @Override
                protected Object getPreAuthenticatedPrincipal(HttpServletRequest request)
                {
                    logger.debug("getPreAuthenticatedPrincipal() called");
            
                    // Get the principal from the header
                    String userDnFromHeader = (String) request.getHeader("SSL_CLIENT_S_DN");
                    logger.debug("userDnFromHeader from header -->{}<---", userDnFromHeader);
            
                    if (userDnFromHeader == null) {
            
                        if (useHardcodedAuthenticatedPrincipal) {
                            // No header was found, but I am in dev mode or "local prod" mode.  So, set a hard-coded user name
                            logger.debug("No header was found, so husing hard-dcoded header 'Bogus_user'");
                            userDnFromHeader = "Bogus_user";
                        }
                    }
            
                    // If this method returns null, then the user will see a 403 Forbidden Message
                    logger.debug("getPreAuthenticatedPrincipal() returns -->{}<--", userDnFromHeader);
                    return userDnFromHeader;
                }
            
            }
            


    8. Add this java class:  SpringSecurityConfig
        a. Right-click on security -> New Java Class
           Class Name:  SpringSecurityConfig

        b. Copy this to your new class
            
            package com.lessons.security;
            
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.beans.factory.annotation.Autowired;
            import org.springframework.beans.factory.annotation.Value;
            import org.springframework.context.annotation.Bean;
            import org.springframework.context.annotation.Configuration;
            import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
            import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
            import org.springframework.security.config.annotation.web.builders.HttpSecurity;
            import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
            import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
            import org.springframework.security.config.http.SessionCreationPolicy;
            import org.springframework.security.web.authentication.preauth.x509.X509AuthenticationFilter;
            import javax.annotation.PostConstruct;
            import javax.annotation.Resource;
            
            
            @Configuration
            @EnableWebSecurity
            @EnableGlobalMethodSecurity(prePostEnabled = true)     	// Needed for @PreAuthorize to work
            public class SpringSecurityConfig extends WebSecurityConfigurerAdapter {
            
                private static final Logger logger = LoggerFactory.getLogger(SpringSecurityConfig.class);
            
            
                /**
                * The authorization mode being
                * Possible values:  pki	(if user is sending PKI certificate directly to the spring boot webapp)
                *               	header (if a proxy is sending the PKI certificate info as headers to the spring boot webapp)
                *               	null   (if not using ssl)
                */
                @Value("${ssl.security.mode:}")
                private String sslSecurityMode;
            
                @Value("${server.ssl.enabled}")
                private boolean sslEnabled;
            
                @Resource
                private MyAuthenticationManager myAuthenticationManager;
            
                @Resource
                private MyRequestHeaderAuthFilter requestHeaderAuthFilter;
            
                @Resource
                private SubjectX509PrincipalExtractor subjectX509PrincipalExtractor;
            
                /**
                * Global configuration to set the authorization listener.
                * @param authenticationManagerBuilder holds the authenticationManagerBuilder
                * @throws Exception if something bad happens
                */
                @Autowired
                public void configureGlobal(AuthenticationManagerBuilder authenticationManagerBuilder) throws Exception
                {
                    logger.debug("configureGlobal() started");
                    super.configure(authenticationManagerBuilder);
            
                    logger.debug("configureGlobal() finished");
                }
            
                @PostConstruct
                public void init() {
                    if (sslEnabled) {
                        // Running in SSL mode so verify that sslSecurityMode is set to a valid value
            
                        if (sslSecurityMode == null) {
                            throw new RuntimeException("Critical Error in SpringSecurityConfig:  server.ssl.enabled=TRUE but ssl.security.mode is not set.  The ssl.security.mode should be either 'header' or 'pki'");
                        }
                        else if (!(sslSecurityMode.equalsIgnoreCase("header")) && (!(sslSecurityMode.equalsIgnoreCase("pki")))) {
                            throw new RuntimeException("Critical Error in SpringSecurityConfig:  server.ssl.enabled=TRUE but ssl.security.mode holds an invalid value.  The ssl.security.mode should be either 'header' or 'pki'");
                        }
                    }
                }
            
            
                /**
                * Configure Spring Security
                *
                * If ssl is enabled AND ssl.security.mode=='pki'
                *	then use the x509 filter to getByUserId the DN from the x509 certificate
                *
                * If ssl is enabled AND ssl.security.mode is anything else
                *	then use the requestHeaderAuthFilter to pull roles from the header
                * 	 
                * @param aHttpSecurity an HttpSecurity object with Spring Security Configuration
                * @throws Exception
                */
                @Override
                public void configure(HttpSecurity aHttpSecurity) throws Exception {
                    logger.debug("configure() started.");
            
                    if (sslEnabled) {
                        // Running in https mode
                        javax.servlet.Filter filter;
            
                        if (sslSecurityMode.equalsIgnoreCase("pki")) {
                            // Running in "prod" mode with sslSecurityMode="pki" so, get the CN information from the user's x509 pki cert
                            logger.debug("In configure()  filter will be the x509 filter");
                            filter = x509Filter();
                        }
                        else {
                            // Running in "prod" mode with sslSecurityMode="header" so, get the CN information from a header
                            logger.debug("In configure()  filter will be MyRequestHeaderAuthFilter");
                            filter = requestHeaderAuthFilter;
                        }
            
                        aHttpSecurity.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.ALWAYS)
                                .and()
                                .authorizeRequests()	// Filters out any URLs that are ignored.  This should be before any authorization filters
                                .antMatchers("/resources/**", "/app1/resources/**", "/error").permitAll()
                                .antMatchers("/**").access("hasRole('ROLE_USER_FOUND_IN_VALID_LIST_OF_USERS')")   // All users must have the grantedAuthority called ROLE_UserFoundInLdap to view all pages
                                .and()
                                .requiresChannel().antMatchers("/**").requiresSecure()	// Redirect http to https
                                .and()
                                .addFilter(filter)                             	// Pull the DN from the user's X509 certificate or header
                                .headers().frameOptions().disable()           	// By default X-Frame-Options is set to denied. Disable frameoptions to let this webapp work in OWF
                                .and()
                                .anonymous().disable();
                    }
                    else {
                        // Running in http mode
                        aHttpSecurity.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.ALWAYS)
                                .and()
                                .authorizeRequests() 	// Filters out any URLs that are ignored.  This should be before any authorization filters
                                .antMatchers("/resources/**", "/app1/resources/**", "/app1/error", "/error").permitAll()
                                .antMatchers("/**").access("hasRole('ROLE_USER_FOUND_IN_VALID_LIST_OF_USERS')")   // All users must have the grantedAuthority called ROLE_USER_FOUND_IN_VALID_LIST_OF_USERS to view all pages
                                .anyRequest().authenticated()
                                .and()
                                .requiresChannel().antMatchers("/**").requiresInsecure()
                                .and()
                                .addFilter(requestHeaderAuthFilter)
                                .headers().frameOptions().disable()                   	// By default X-Frame-Options is set to denied.
                                .and()
                                .anonymous().disable();
                    }
            
                    // Disable CSRF Checks (because the BDP cannot handle it)
                    aHttpSecurity.csrf().disable();
                }
            
            
            
                /**
                * Configures the X509AuthenticationFilter for extracting information from the Cert
                * @return X509AuthenticationFilter object
                */
                @Bean
                public X509AuthenticationFilter x509Filter() {
                    // Setup a filter that extracts the principal from the cert
                    X509AuthenticationFilter x509Filter = new X509AuthenticationFilter();
                    x509Filter.setContinueFilterChainOnUnsuccessfulAuthentication(false);
                    x509Filter.setAuthenticationManager(myAuthenticationManager);
                    x509Filter.setPrincipalExtractor(subjectX509PrincipalExtractor);
                    return x509Filter;
                }
            }
            


    9. Update the application.yaml so it has separate dev and prod profiles.
        a. Edit backend/src/main/resources/application.yaml

        b. Replace its contents with this:
            
            ##########################################################
            # application.yaml   (used for development purposes)
            #
            # NOTE:  Make sure there are no leading spaces on any of these lines
            ##########################################################
            name: app1
            server.servlet.context-path: /app1
            
            
            # Set the Active profile to be dev
            spring.profiles.active: dev
            
            # Disable cors check because we are running in local dev mode
            # NOTE:  order is important.  Make sure disable.cors comes *AFTER* you set the profile
            disable.cors: true
            
            # Tell Spring to disable DataSource Auto Configuration (so you can run a springboot app without a datasource
            spring.autoconfigure:
              exclude:
              - org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
              - org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration
                - org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration
            
            
            ###########################################################
            # ElasticSearch Settings
            ##########################################################
            es:
              url: http://localhost:9201
              ssl_enabled: false
            
            
            ##########################################################
            # File Upload Settings
            ##########################################################
            spring.servlet.multipart.enabled: true
            
            # Set the maximum file upload size for one file	(-1 is unlimited)
            spring.servlet.multipart.max-file-size: 300MB
            
            # Set the maximum request size
            # If a user uploads 5 files of 1 MB, then the entire request size is 5 MB   (-1 is unlimited)
            spring.servlet.multipart.max-request-size: 400MB
            
            
            # Tell Spring to not run flyway automatically
            # NOTE:  In the DataSourceConfig, java code is used to run a flyway migrate
            spring.flyway.enabled: false
            
            
            
            ---
            #################################################################################################
            #     	D E V   	P R O F I L E
            #
            #################################################################################################
            spring.profiles: dev
            
            ##########################################################
            # Database Settings
            ##########################################################
            app.datasource:
              driver-class-name: org.postgresql.Driver
              url: jdbc:postgresql://localhost:5432/app1_db
              username: app1_user
              password: secret
              schema: app1_db
              maxPoolSize: 10
            
            
            ################################################
            # SSL Settings     
            ################################################
            server.port: 8080
            server.ssl.enabled: false    # SSL is disabled so use plain-text http
            
            # Use hard-coded security principal
            use.hardcoded.authenticated.principal: true
            
            
            
            ---
            #################################################################################################
            #   	P R O D   	P R O F I L E
            #
            #################################################################################################
            spring.profiles: prod
            
            # So, we're running in HTTPS mode but using a hard-coded principal for security
            use.hardcoded.authenticated.principal: true
            ssl.security.mode: pki
            
            
            ##########################################################
            # Database Settings
            ##########################################################
            app.datasource:
              driver-class-name: org.postgresql.Driver
              url: jdbc:postgresql://localhost:5432/app1_db
              username: app1_user
              password: secret
              schema: app1_db
              maxPoolSize: 10
            
            
            ################################################
            # SSL Settings
            ################################################
            server:
                port: 8443
                ssl:
                        key-store: backend/src/main/dev_resources/myKeystore.jks
                        key-store-password: changeit
                        key-store-type: JKS
                        client-auth: need
                        trust-store: backend/src/main/dev_resources/myTruststore.jks
                        trust-store-password: changeit
                        trust-store-type: JKS
                        enabled: true        # SSL is enabled so use https
            
            
            # Secure the cookies
            server.servlet.session.cookie.secure: true
            server.servlet.session.cookie.http-only: true
            




    10. Run the Backend in prod mode
        a. Create a "Backend (prod)" entry that runs the backend in prod mode
            i.   Pull Run / Edit Configurations
            ii.  On the right-side, open-up the "Spring Boot" section or "Application" section
            iii. Single-click on Backend  (on the left side)
            iv.  Press Control-D  (to duplicate the entry)
            v.   Single-click on the new entry
            vi.  Change the name to be Backend (prod)
            vii. Change the VM options to this:
                    -Dspring.profiles.active=prod

            When completed, it should look like this:
```
![](https://lh5.googleusercontent.com/E7b8YqChDeFVQZkmj6pYlvrHtmtQe8GrEuc7gJBpeupByw7r4tVGFvLE8jcFcCMajMuzae900DPkgaEEyB-f8x5wfZiIhM5WP05n4h1irlZ_JLGU57CuDHT0tGvM6jyFwR-i7spM)
```




        b. Select Backend (prod) and run the debugger

        c. Verify that the console shows it is running https on port 8443:

            06/02/2021 20:44:07 INFO  org.xnio XNIO version 3.3.8.Final
            06/02/2021 20:44:07 INFO  org.xnio.nio XNIO NIO Implementation Version 3.3.8.Final
            06/02/2021 20:44:07 INFO org.springframework.boot.web.embedded.undertow.UndertowServletWebServer Undertow started on port(s) 8443 (https) with context path '/app1'
            06/02/2021 20:44:07 INFO  com.lessons.Application Started Application in 1.594 seconds (JVM running for 2.028)
            06/02/2021 20:44:07 DEBUG com.lessons.Application WebApp is Up.


    11. Use your "John Smith" PKI client certificate to hit the backend date/time REST endpoint
        a. Startup the browser that has your "John Smith" PKI certificate imported
        b. Connect to https://localhost:8443/app1/api/time
           -- If it works, you should see the date/time

    12. Stop the Backend (prod) debugger


    13. Run the entire web app in prod mode from command line
        a. Compile the webapp
           unix> cd ~/intellijProjects/angularApp1
           unix> mvn clean package -Pprod

        b. Run the webapp in prod mode
           unix> java -Dspring.profiles.active=prod -jar ./backend/target/backend-1.0-SNAPSHOT-exec.jar

        c. Startup the web browser (that has your "John Smith" pki certificate)

        d. Connect to the webapp at https://localhost:8443/app1
           -- You should be connecting to your webapp using PKI authentication

        e. Press Control-C to kill the web app



    14. Verify the web app still runs in local dev mode (using http)
        a. Pull Build -> Rebuild Project
        b. Run the Debugger on "Full WebApp"
        c. Verify that the webapp still runs on http://localhost:4200/



```
