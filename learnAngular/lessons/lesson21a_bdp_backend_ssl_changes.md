Lesson 21a:  BDP / Adjust Backend ElasticSearchService  to use SSL (if needed)
------------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1MbxOKOU0hx-sWAduFQ7xgFsPPrzInyCOT59cEt6Y2uw/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson21a/bdp/add-ssl-to-elasticsearch
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  The BDP's ElasticSearch requires a PKI authenticated certificate to talk to it<br>
Solution:   Adjust the backend ElasticSearchService to use either http or https to talk to ElasticSearch




<br>
<br>

```

Procedure
---------
    1. Verify that the MyAuthenticationManager is storing the accessMap in the UserInfo object (when running in prod mode)

        a. Edit MyAuthenticationManager.java

        b. Examine the loadUserDetailsFromRealSource() method 
            
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
                        grantedRoleAuthorities.add(new
            SimpleGrantedAuthority("ROLE_USER_FOUND_IN_VALID_LIST_OF_USERS"));
                    }
                    else {
                            // This user has no roles so throw a runtime exception
                            throw new RuntimeException("No roles were found for this user: " + userUID);
                    }
            
                    logger.info("{} successfully logged-in.", userUID);
            
                    // User is about to login
                    // -- This would be the place to add/update a database record indicating that the user logged-in
                    Integer userId = this.userService.getOrAddUserRecordsToSystem(userUID);
            
            
                    // Get the user's granted access map
                    // NOTE:  This holds all authorized routes and UI controls (based on the user's granted roles)
                    Map<String, Boolean> accessMap = userService.generateAccessMap(grantedRoleAuthorities);
                 
                    logger.debug("loadUserDetailsFromRealSource() about to return new UserInfo object");
            
                    // We *MUST* set the database ID in the UserInfo object here
                    return new UserInfo()
                            .withId(userId)
                            .withUsernameDn(userDN)
                            .withUsernameUID(userUID)
                            .withAccessMap(accessMap)
                            .withGrantedAuthorities(grantedRoleAuthorities);
            
                } catch (Exception e) {
                    throw new UsernameNotFoundException("Exception raised in loadUserDetailsFromRealSource():  This user will definitely not login", e);
                }
            }
            


    2. Add this class:  SSLCustomTrustManager
        a. Edit backend/src/main/java/com/lessons/security -> New Java Class
           Class Name:  SSLCustomTrustManager

        b. Copy this to your newly-created class
            
            package com.lessons.security;
            
            import javax.net.ssl.TrustManager;
            import javax.net.ssl.TrustManagerFactory;
            import javax.net.ssl.X509TrustManager;
            import java.security.KeyStore;
            import java.security.KeyStoreException;
            import java.security.NoSuchAlgorithmException;
            import java.security.Principal;
            import java.security.cert.*;
            import java.util.Arrays;
            import java.util.List;
            
            /**
             * A custom X509TrustManager implementation that trusts a specified server certificate in addition
             * to those that are in the system TrustStore.
             * Also handles an out-of-order certificate chain, as is often produced by Apache's mod_ssl
             */
            public class SSLCustomTrustManager implements X509TrustManager
            {
            
                private final X509TrustManager originalX509TrustManager;
                private final KeyStore trustStore;
            
                /**
                * @param trustStore A KeyStore containing the server certificate that should be trusted
                * @throws NoSuchAlgorithmException
                * @throws KeyStoreException
                */
                public SSLCustomTrustManager(KeyStore trustStore) throws NoSuchAlgorithmException, KeyStoreException
                {
                    this.trustStore = trustStore;
            
                    TrustManagerFactory originalTrustManagerFactory = TrustManagerFactory.getInstance("X509");
                    originalTrustManagerFactory.init((KeyStore) null);
            
                    TrustManager[] originalTrustManagers = originalTrustManagerFactory.getTrustManagers();
                    originalX509TrustManager = (X509TrustManager) originalTrustManagers[0];
                }
            
                /**
                * No-op. Never invoked by client, only used in server-side implementations
                * @return
                */
                public X509Certificate[] getAcceptedIssuers() {
                    return new X509Certificate[0];
                }
            
                /**
                * No-op. Never invoked by client, only used in server-side implementations
                * @return
                */
                public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException
                {
                }
            
            
                /**
                * Given the partial or complete certificate chain provided by the peer,
                * build a certificate path to a trusted root and return if it can be validated and is trusted
                * for client SSL authentication based on the authentication type. The authentication type is
                * determined by the actual certificate used. For instance, if RSAPublicKey is used, the authType should be "RSA".
                * Checking is case-sensitive.
                * Defers to the default trust manager first, checks the cert supplied in the ctor if that fails.
                * @param chain the server's certificate chain
                * @param authType the authentication type based on the client certificate
                * @throws CertificateException
                */
                public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                    try {
                        originalX509TrustManager.checkServerTrusted(chain, authType);
                    } catch(CertificateException originalException) {
                        try {
                            X509Certificate[] reorderedChain = reorderCertificateChain(chain);
                            CertPathValidator validator = CertPathValidator.getInstance("PKIX");
                            CertificateFactory factory = CertificateFactory.getInstance("X509");
                            CertPath certPath = factory.generateCertPath(Arrays.asList(reorderedChain));
                            PKIXParameters params = new PKIXParameters(trustStore);
                            params.setRevocationEnabled(false);
                            validator.validate(certPath, params);
                        } catch(Exception ex) {
                            throw originalException;
                        }
                    }
            
                }
            
                /**
                * Puts the certificate chain in the proper order, to deal with out-of-order
                * certificate chains as are sometimes produced by Apache's mod_ssl
                * @param chain the certificate chain, possibly with bad ordering
                * @return the re-ordered certificate chain
                */
                private X509Certificate[] reorderCertificateChain(X509Certificate[] chain) {
            
                    X509Certificate[] reorderedChain = new X509Certificate[chain.length];
                    List<X509Certificate> certificates = Arrays.asList(chain);
            
                    int position = chain.length - 1;
                    X509Certificate rootCert = findRootCert(certificates);
                    reorderedChain[position] = rootCert;
            
                    X509Certificate cert = rootCert;
                    while((cert = findSignedCert(cert, certificates)) != null && position > 0) {
                        reorderedChain[--position] = cert;
                    }
            
                    return reorderedChain;
                }
            
                /**
                * A helper method for certificate re-ordering.
                * Finds the root certificate in a possibly out-of-order certificate chain.
                * @param certificates the certificate change, possibly out-of-order
                * @return the root certificate, if any, that was found in the list of certificates
                */
                private X509Certificate findRootCert(List<X509Certificate> certificates) {
                    X509Certificate rootCert = null;
            
                    for(X509Certificate cert : certificates) {
                        X509Certificate signer = findSigner(cert, certificates);
                        if(signer == null || signer.equals(cert)) { // no signer present, or self-signed
                            rootCert = cert;
                            break;
                        }
                    }
            
                    return rootCert;
                }
            
                /**
                * A helper method for certificate re-ordering.
                * Finds the first certificate in the list of certificates that is signed by the signingCert.
                */
                private X509Certificate findSignedCert(X509Certificate signingCert, 
            List<X509Certificate> certificates) {
                    X509Certificate signed = null;
            
                    for(X509Certificate cert : certificates) {
                        Principal signingCertSubjectDN = signingCert.getSubjectDN();
                        Principal certIssuerDN = cert.getIssuerDN();
                        if(certIssuerDN.equals(signingCertSubjectDN) && !cert.equals(signingCert)) {
                            signed = cert;
                            break;
                        }
                    }
            
                    return signed;
                }
            
                /**
                * A helper method for certificate re-ordering.
                * Finds the certificate in the list of certificates that signed the signedCert.
                */
                private X509Certificate findSigner(X509Certificate signedCert, List<X509Certificate> certificates) {
                    X509Certificate signer = null;
            
                    for(X509Certificate cert : certificates) {
                        Principal certSubjectDN = cert.getSubjectDN();
                        Principal issuerDN = signedCert.getIssuerDN();
                        if(certSubjectDN.equals(issuerDN)) {
                            signer = cert;
                            break;
                        }
                    }
            
                    return signer;
                }
            }


    3. Add this class:  SSLContextFactory
        a. Edit backend/src/main/java/com/lessons/security -> New Java Class
           Class Name:  SSLContextFactory

        b. Copy this to your newly-created class
            
            package com.lessons.security;
            
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import javax.net.ssl.KeyManager;
            import javax.net.ssl.KeyManagerFactory;
            import javax.net.ssl.SSLContext;
            import javax.net.ssl.TrustManager;
            import javax.xml.bind.DatatypeConverter;
            import java.io.*;
            import java.security.KeyStore;
            import java.security.cert.CertificateFactory;
            import java.security.cert.X509Certificate;
            
            /**
             * Builds an SSLContext with custom KeyStore and TrustStore, to work with a client cert signed by a truststore.jks file
             */
            public enum SSLContextFactory
            {
                INSTANCE;
            
                private static final Logger logger = LoggerFactory.getLogger(SSLContextFactory.class);
            
                /**
                * Utility class private constructor
                */
                private SSLContextFactory() {
                }
            
            
                /***********************************************************************************
                * makeContext()
                * Creates an SSLContext using the passed-in clientp12 File and truststoreJks File objects
                *
                * @return An initialized SSLContext
                * @throws Exception
                ***********************************************************************************/
                public static SSLContext makeContext(File clientCertificateP12File, String clientCertificatePassword,
                                                    File trustJksFile, String trustPassword) throws Exception
                {
                    logger.debug("makeContext() started.  aClientCertP12File={}   aTrustJksFile={}",
                            clientCertificateP12File.toString(), trustJksFile.toString());
            
                    // Generate a keystore from the client p12 file
                    final KeyStore keyStore = loadPKCS12KeyStore(clientCertificateP12File, clientCertificatePassword);
                    KeyManagerFactory kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
                    kmf.init(keyStore, clientCertificatePassword.toCharArray());
                    KeyManager[] keyManagers = kmf.getKeyManagers();
            
                    // Generate a truststore from the passed-in aTrustJksFile object
                    final KeyStore trustStore = loadJksKeyStore(trustJksFile, trustPassword);
            
                    TrustManager[] trustManagers = {new SSLCustomTrustManager(trustStore) };
                    SSLContext sslContext = SSLContext.getInstance("TLS");
                    sslContext.init(keyManagers, trustManagers, null);
            
                    logger.debug("makeContext() finished.");
                    return sslContext;
                }
            
            
                /***********************************************************************************
                * loadPEMTrustStore()
                * Produces a KeyStore from a String containing a PEM certificate (typically, the server's CA certificate)
                ***********************************************************************************/
                private static KeyStore loadPEMTrustStore(String certificateString) throws Exception
                {
                    byte[] certificateBytes = loadPemCertificate(new ByteArrayInputStream(certificateString.getBytes()));
                    ByteArrayInputStream derInputStream = new ByteArrayInputStream(certificateBytes);
                    CertificateFactory certificateFactory = CertificateFactory.getInstance("X.509");
                    X509Certificate certificate = (X509Certificate)
            certificateFactory.generateCertificate(derInputStream);
                    String alias = certificate.getSubjectX500Principal().getName();
            
                    KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
                    trustStore.load(null);
                    trustStore.setCertificateEntry(alias, certificate);
            
                    return trustStore;
                }
            
            
                /***********************************************************************************
                * Produces a KeyStore from a PKCS12 (.p12) certificate file, typically the client certificate
                * @param certificateP12File A File object referring to the client p12 certificate
                * @param clientCertPassword Password for the certificate
                * @return A KeyStore containing the certificate from the certificateFile
                ***********************************************************************************/
                private static KeyStore loadPKCS12KeyStore(File certificateP12File, String clientCertPassword) throws Exception {
                    try (FileInputStream fileInputStream = new FileInputStream(certificateP12File)) {
                        KeyStore keyStore = KeyStore.getInstance("PKCS12");
                        keyStore.load(fileInputStream, clientCertPassword.toCharArray());
                        return keyStore;
                    }
                }
            
                /***********************************************************************************
                * loadJksKeyStore()
                * @param jksCertificateFile
                * @param trustPassword
                * @return
                ***********************************************************************************/
                private static KeyStore loadJksKeyStore(File jksCertificateFile, String trustPassword) throws Exception {
                    try (FileInputStream fileInputStream = new FileInputStream(jksCertificateFile)) {
                        KeyStore keyStore =  KeyStore.getInstance("JKS");
                        keyStore.load(fileInputStream, trustPassword.toCharArray());
                        return keyStore;
                    }
                }
            
            
                /***********************************************************************************
                * loadPemCertificate()
                * Reads and decodes a base-64 encoded DER certificate (a .pem certificate), typically the server's CA cert.
                * @param certificateStream an InputStream from which to read the cert
                * @return a byte[] containing the decoded certificate
                ***********************************************************************************/
                private static byte[] loadPemCertificate(InputStream certificateStream) throws IOException
                {
                    byte[] certificateBytes;
                    BufferedReader bufferedReader = null;
            
                    try {
                        StringBuilder builder = new StringBuilder();
                        bufferedReader = new BufferedReader(new InputStreamReader(certificateStream));
            
                        String line = bufferedReader.readLine();
                        while(line != null) {
                            if(!line.startsWith("--")){
                                builder.append(line);
                            }
                            line = bufferedReader.readLine();
                        }
            
                        String pem = builder.toString();
                        certificateBytes = DatatypeConverter.parseBase64Binary(pem);
            
                    }
                    finally
                    {
                        if(bufferedReader != null)
                        {
                            bufferedReader.close();
                        }
                    }
            
                    return certificateBytes;
                }
            }


    4. Adjust the ElasticSearchResourcesConfig so that the ElasticSearchService can initialize talking to ElasticSearch using http or https
        a. Edit ElasticSearchResourcesConfig.java

        b. Replace its contents with this:
            
            package com.lessons.config;
            
            import com.lessons.security.SSLContextFactory;
            import com.ning.http.client.AsyncHttpClient;
            import org.apache.commons.lang3.StringUtils;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.beans.factory.annotation.Value;
            import org.springframework.context.annotation.Bean;
            import org.springframework.context.annotation.Configuration;
            import javax.net.ssl.SSLContext;
            import java.io.File;
            
            
            @Configuration
            public class ElasticSearchResourcesConfig {
            
                private static final Logger logger = LoggerFactory.getLogger(ElasticSearchResourcesConfig.class);
            
                @Value("${es.url:}")
                private String elasticSearchUrl;
            
                @Value("${es.ssl_enabled:false}")
                private boolean sslEnabled;
            
            
                // -------------- Optional SSL Parameters ------------------------
                @Value("${es.client-p12:}")
                private String clientP12FilePath;
            
                @Value("${es.client-p12-password:}")
                private String clientP12Password;
            
                @Value("${es.trust-store:}")
                private String trustStoreFilePath;
            
                @Value("${es.trust-store-password:}")
                private String trustStorePassword;
            
                @Value("${es.trust-store-type:}")
                private String turstStoreType;
            
            
                @Bean
                public ElasticSearchResources elasticSearchResources() throws Exception {
            
                    // Set the AsyncHttpClient settings
                    com.ning.http.client.AsyncHttpClientConfig.Builder configBuilder = new com.ning.http.client.AsyncHttpClientConfig.Builder();
                    configBuilder.setReadTimeout(-1);
                    configBuilder.setAcceptAnyCertificate(true);
                    configBuilder.setFollowRedirect(true);
            
                    logger.debug("In elasticSearchResources()  this.sslEnabled={}", this.sslEnabled);
                    if (sslEnabled) {
                        // initialize the sslContext and store it in the configBuilder object
                        SSLContext sslContext = generateSslContext();
                        configBuilder.setSSLContext(sslContext);
                    }
            
                    // Create a new AsyncHttpClient object
                    com.ning.http.client.AsyncHttpClientConfig config = configBuilder.build();
                    AsyncHttpClient asyncHttpClient = new AsyncHttpClient(config);
            
            
                    // Store the AsyncHttpClient and elasticSearch url in the ElasticSearchResources object
                    // NOTE:  THe elastic search url is injected from the application.yaml
                    //    	The AsyncHttpClient is constructed with java code
                    ElasticSearchResources elasticSearchResources = new
            ElasticSearchResources(this.elasticSearchUrl, asyncHttpClient);
            
                    // Return a spring bean that holds the AsyncHttpClient and elasticsearch url
                    return elasticSearchResources;
                }
            
            
                /**
                * Helper method to generate the SSL Context
                * @return a SSLContext object
                */
                private SSLContext generateSslContext() throws Exception {
            
                    if (StringUtils.isEmpty(this.clientP12Password)) {
                        throw new RuntimeException("Critical Error Creating SSL Context:  The client p12 password is empty.  Check this property 'es.client-p12-password' in the application.yaml");
                    }
                    else if (StringUtils.isEmpty(this.trustStorePassword)) {
                        throw new RuntimeException("Critical Error Creating SSL Context:  The truststore jks password is empty.  Check this property 'es.trust-store-password' in the application.yaml");
                    }
                    else if ((StringUtils.isEmpty(this.turstStoreType)) || (! this.turstStoreType.equalsIgnoreCase("JKS"))) {
                        throw new RuntimeException("Critical Error Creating SSL Context:  The truststore type must be JKS.   Check this property 'es.trust-store-type'");
                    }
            
                    File clientP12File = new File(this.clientP12FilePath);
                    if (! clientP12File.exists()) {
                        throw new RuntimeException("Critical Error:  This client p12 file was not found: " + this.clientP12FilePath + "  Check this property 'es.client-p12' in the application.yaml");
                    }
            
                    File trustStoreJkdFile = new File(this.trustStoreFilePath);
                    if (! trustStoreJkdFile.exists()) {
                        throw new RuntimeException("Critical Error:  This truststore JKS file was not found: " + this.trustStoreFilePath + "  Check this property 'es.trust-store' in the application.yaml");
                    }
            
                    logger.debug("Generating SSL Context from client p12 {} and truststore {}", this.clientP12FilePath, this.trustStoreFilePath);
                    SSLContext sslContext = SSLContextFactory.makeContext(clientP12File, this.clientP12Password, trustStoreJkdFile, this.trustStorePassword);
                    return sslContext;
                }
            
            }

    5. Make sure your web app still runs in local dev mode
        a. Pull Build -> Rebuild Project
        b. Activate the Debugger on "Full Web App"
        c. Verify that the web app comes up on localhost:4200

            NOTE:  The backend is configured to talk to ElasticSearch.  
	        If there are problems, then the backend will not startup.


        d. Stop the debugger


```
