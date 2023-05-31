package dk.jarry.user;

import java.util.Map;
import java.util.Set;

import org.eclipse.microprofile.jwt.JsonWebToken;
import org.jboss.resteasy.reactive.NoCache;

import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@Path("/api/jwt/users")
public class JwtUsersResource {

    @Inject
    JsonWebToken jwt;

    @GET
    @Path("/me")
    @NoCache
    public User me() {
        return new User(jwt);
    }

    public static class User {

        public Set<String> audience;
        public String issuer;
        public Set<String> claimNames;
        public Set<String> groups;
        public Map realmAccess;
        public Map resourceAccess;
        public String realmAccessType;

        User(JsonWebToken jwt) {
            this.audience =jwt.getAudience();
            this.issuer = jwt.getIssuer();
            this.claimNames = jwt.getClaimNames();
            this.groups = jwt.getGroups();
            this.realmAccess = jwt.getClaim("realm_access");
            this.resourceAccess = jwt.getClaim("resource_access");
            this.realmAccessType =jwt.getClaim("realm_access").getClass().getCanonicalName();
        }

    }

}