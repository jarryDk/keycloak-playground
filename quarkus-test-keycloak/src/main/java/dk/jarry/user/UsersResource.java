package dk.jarry.user;

import java.util.Set;

import org.eclipse.microprofile.jwt.Claim;
import org.eclipse.microprofile.jwt.Claims;
import org.jboss.resteasy.reactive.NoCache;

import io.quarkus.security.identity.SecurityIdentity;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@Path("/api/si/users")
//@RolesAllowed("write:todo")
public class UsersResource {

    @Inject
    SecurityIdentity identity;

    @Inject @Claim(standard = Claims.aud)
    Set<String> audience;

    @GET
    @Path("/me")
    @NoCache
    public User me() {
        return new User(identity, audience);
    }

    public static class User {

        private final String userName;
        private Set<String> roles;
        private Set<String> audience;

        User(SecurityIdentity identity) {
            this.userName = identity.getPrincipal().getName();
            this.roles = identity.getRoles();
        }

        User(SecurityIdentity identity, Set<String> audience) {
            this.userName = identity.getPrincipal().getName();
            this.roles = identity.getRoles();
            this.audience = audience;
        }

        public String getUserName() {
            return userName;
        }

        public Set<String> getRoles() {
            return roles;
        }

        public Set<String> getAudience() {
            return audience;
        }

    }

}