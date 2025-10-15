import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Category } from '../../categories/entities/category.entity';

@Entity('barang')
export class Product {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 255 })
  nama_barang: string;

  @Column()
  kategori_id: number;

  @Column({ default: 0 })
  stok: number;

  @Column({ length: 100 })
  kelompok_barang: string;

  @Column('decimal', { precision: 15, scale: 2 })
  harga: number;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @ManyToOne(() => Category, (category) => category.id)
  @JoinColumn({ name: 'kategori_id' })
  category: Category;
}
