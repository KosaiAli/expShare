<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Time extends Model
{
    use HasFactory;
    protected $table="times";
    protected $fillable = [
        'expert_id',
        'start',
        'end',
        'day',
        'available',
    ];
    /*
   * My FK belongs to?
   */

    public function expert(): BelongsTo
    {
        return $this->belongsTo('experts');
    }

    /*
     * My PK is FK where?
     */
    public function appointment (): HasMany
    {
        return $this->hasMany('appointments');
    }
}
