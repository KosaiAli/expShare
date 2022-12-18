<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Favorite extends Model
{
    use HasFactory;
    protected $table="favorites";
    protected $fillable = [
        'expert_id',
        'user_id',
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
    /*
     * My PK is FK where?
     */
}
