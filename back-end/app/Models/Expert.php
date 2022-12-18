<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Expert extends Model
{
    use HasFactory;
    protected $table="experts";
    protected $fillable = [
        'user_id',
        'specialty_id',
        'imageUrl',
        'phoneNum',
        'address',
        'details',
        'price',
        'birthday',
    ];
    public function user(): BelongsTo
    {
        return $this->belongsTo('users');
    }
    public function speciality(): BelongsTo
    {
        return $this->belongsTo('specialties');
    }
    /*
   * My FK belongs to?
   */

    /*
     * My PK is FK where?
     */
    public function time (): HasMany
    {
        return $this->hasMany('times');
    }
    public function appointment (): HasMany
    {
        return $this->hasMany('appointments');
    }
    public function favorite (): HasMany
    {
        return $this->hasMany('favorites');
    }
}
