using Firebase.Database;
using Microsoft.Extensions.Options;
using TISM_FIREBASE.Firebase;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.Configure<FirebaseSettings>(builder.Configuration.GetSection("Firebase"));
builder.Services.AddSingleton<FirebaseClient>(sp =>
{
    var settings = sp.GetRequiredService<IOptions<FirebaseSettings>>().Value;
    return new FirebaseClient(settings.DatabaseUrl, new FirebaseOptions
    {
        AuthTokenAsyncFactory = () => Task.FromResult(settings.AuthSecret)
    });
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
