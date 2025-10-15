import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('kategori')
export class Category {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 100 })
  nama_kategori: string;
}
