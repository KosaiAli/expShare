<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Appointment extends Model
{
    use HasFactory;
    protected $table="appointments";
    protected $fillable = [
        'expert_id',
        'user_id',
        'time_id',

    ];
    /*
    * My FK belongs to?
    */
    public function expert(): BelongsTo
    {
        return $this->belongsTo('experts');
    }
    public function user(): BelongsTo
    {
        return $this->belongsTo('users');
    }
    public function time(): BelongsTo
    {
        return $this->belongsTo('times');
    }
    /*
     * My PK is FK where?
     */
}
