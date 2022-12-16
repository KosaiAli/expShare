<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Speciality extends Model
{
    use HasFactory;
    protected $table="specialties";
    protected $fillable = [
        'type',
    ];
    /*
     * My FK belongs to?
     */

    /*
     * My PK is FK where?
     */

    public function expert(): HasOne
    {
        return $this->HasOne('experts');
    }
}
