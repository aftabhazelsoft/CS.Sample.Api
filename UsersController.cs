﻿using Microsoft.AspNetCore.Mvc;

namespace CS.Sample.Api
{
    [ApiController]
    [Route("api/[Controller]")]
    public class UsersController : Controller
    {
        private readonly SampleDbContext _dbContext;

        public UsersController(SampleDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        [HttpGet]
        public IActionResult Get() => Ok(_dbContext.SystemUsers.OrderByDescending(x => x.Id).ToList());

        [HttpPost]
        public IActionResult Post([FromBody] SystemUser user)
        {
            _dbContext.SystemUsers.Add(user);
            _dbContext.SaveChanges();
            return Created("/", user);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var entity = _dbContext.SystemUsers.FirstOrDefault(x => x.Id == id);
            if (entity != null)
            {
                _dbContext.Remove(entity);
            }
            return Ok($"Requested record with {id}: Deleted!");
        }
    }
}
