<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Rate extends Model
{
    use HasFactory;
    protected $table="rates";
    protected $fillable = [
        'expert_id',
        'user_id',
        'rate',
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
