var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI(o =>
{
    o.SwaggerEndpoint("/swagger/v1/swagger.json", "API v1");
    o.RoutePrefix = "swagger"; // ui at /swagger
});

app.MapGet("/healthz", () => Results.Ok("OK"));

app.Run();
