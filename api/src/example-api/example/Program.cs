using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// 1) Services
builder.Services.AddControllers();            // discover controller actions
builder.Services.AddEndpointsApiExplorer();   // discover minimal APIs (ok to keep)
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "API", Version = "v1" });

    // Optional: include XML comments (see .csproj snippet below)
    var xml = $"{System.Reflection.Assembly.GetExecutingAssembly().GetName().Name}.xml";
    var xmlPath = System.IO.Path.Combine(AppContext.BaseDirectory, xml);
    if (System.IO.File.Exists(xmlPath))
        c.IncludeXmlComments(xmlPath, includeControllerXmlComments: true);
});

var app = builder.Build();

// 2) Middleware + UI (enable in prod too)
app.UseSwagger();
app.UseSwaggerUI(o =>
{
    o.SwaggerEndpoint("/swagger/v1/swagger.json", "API v1");
    o.RoutePrefix = "swagger"; // UI at /swagger
});

// Optional typical middleware
app.UseHttpsRedirection();
app.UseAuthorization();

// 3) Map controllers (this is what exposes *all* controller routes)
app.MapControllers();

// Optional health
app.MapGet("/health", () => Results.Ok("OK"));

app.Run();
