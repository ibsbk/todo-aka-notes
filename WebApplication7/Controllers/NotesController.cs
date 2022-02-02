using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApplication7.Models;

namespace WebApplication7.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotesController : ControllerBase
    {

        UsersContext db = new();

        [HttpGet("get_notes")]
        public async Task<ActionResult<Note>> Get_Notes(Note request)
        {
            try
            {
                var notes = db.notes.Where(x => x.user_id == request.user_id).ToList();
                if (notes.Any())
                {
                    return Ok(notes);
                }
                else
                {
                    return BadRequest();
                }
            }
            catch
            {
                return BadRequest();
            }

        }

        [HttpPut("add_note")]
        public async Task<ActionResult<Note>> Add_Note(Note request)
        {
            Note new_note = new Note() { note = request.note, created_at = request.created_at.ToUniversalTime(), user_id = request.user_id};
            try
            {
                db.notes.Add(new_note);
                db.SaveChanges();
                return Ok(new_note);
            }
            catch
            {
                return BadRequest();
            }
        }

        [HttpPatch("edit_note")]
        public async Task<ActionResult<Note>> Edit_Note(Note request)
        {
            try
            {
                var note = db.notes.Find(request.id);
                if(request.user_id == note.user_id)
                {
                    try
                    {
                        note.note = request.note;
                        note.created_at = request.created_at.ToUniversalTime();
                        db.SaveChanges();
                        return Ok(note);
                    }
                    catch
                    {
                        return BadRequest();
                    }
                }
                else
                {
                    return BadRequest();
                }
            }
            catch
            {
                return BadRequest();
            }

        }

        [HttpDelete("delete_note")]
        public async Task<ActionResult<Note>> Delete_Note(Note request)
        {
            try
            {
                var note = db.notes.Find(request.id);
                if (request.user_id == note.user_id)
                {
                    try
                    {
                        db.notes.Remove(note);
                        db.SaveChanges();
                        return Ok(note);
                    }
                    catch
                    {
                        return BadRequest();
                    }
                }
                else
                {
                    return BadRequest();
                }
            }
            catch
            {
                return BadRequest();
            }

        }
    }
}
