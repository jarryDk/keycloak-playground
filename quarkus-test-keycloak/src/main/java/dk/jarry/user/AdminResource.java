package dk.jarry.user;

import org.eclipse.microprofile.jwt.JsonWebToken;

import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/api/admin")
@Authenticated
public class AdminResource {

    @Inject
    JsonWebToken jwt;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String admin() {
        return "granted";
    }

    @GET
    @Path("/foo")
    @Produces(MediaType.TEXT_PLAIN)
    public String foo() {
        return "Access for subject " + jwt.toString() + " is granted";
    }

}
