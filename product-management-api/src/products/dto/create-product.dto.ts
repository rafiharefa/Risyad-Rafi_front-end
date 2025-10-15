import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsPositive,
  Min,
  MaxLength,
} from 'class-validator';

export class CreateProductDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  nama_barang: string;

  @IsNumber()
  @IsPositive()
  kategori_id: number;

  @IsNumber()
  @Min(0)
  stok: number;

  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  kelompok_barang: string;

  @IsNumber()
  @IsPositive()
  harga: number;
}
