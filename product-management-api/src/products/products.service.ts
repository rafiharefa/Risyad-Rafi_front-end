import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Like, In } from 'typeorm';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { BulkDeleteDto } from './dto/bulk-delete.dto';
import { Product } from './entities/product.entity';

@Injectable()
export class ProductsService {
  constructor(
    @InjectRepository(Product)
    private productRepository: Repository<Product>,
  ) {}

  async create(createProductDto: CreateProductDto): Promise<Product> {
    const product = this.productRepository.create(createProductDto);
    return await this.productRepository.save(product);
  }

  async findAll(
    page: number = 1,
    limit: number = 10,
    search?: string,
  ): Promise<{ data: Product[]; total: number; page: number; limit: number }> {
    const [data, total] = await this.productRepository.findAndCount({
      relations: ['category'],
      where: search
        ? {
            nama_barang: Like(`%${search}%`),
          }
        : {},
      skip: (page - 1) * limit,
      take: limit,
      order: { created_at: 'DESC' },
    });

    return { data, total, page, limit };
  }

  async findOne(id: number): Promise<Product> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: ['category'],
    });

    if (!product) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    return product;
  }

  async update(
    id: number,
    updateProductDto: UpdateProductDto,
  ): Promise<Product> {
    await this.findOne(id); // Check if exists
    await this.productRepository.update(id, updateProductDto);
    return this.findOne(id);
  }

  async remove(id: number): Promise<void> {
    const product = await this.findOne(id);
    await this.productRepository.remove(product);
  }

  async bulkDelete(bulkDeleteDto: BulkDeleteDto): Promise<void> {
    const { ids } = bulkDeleteDto;
    await this.productRepository.delete({
      id: In(ids),
    });
  }

  async search(query: string): Promise<Product[]> {
    return await this.productRepository.find({
      where: {
        nama_barang: Like(`%${query}%`),
      },
      relations: ['category'],
      order: { nama_barang: 'ASC' },
    });
  }
}
