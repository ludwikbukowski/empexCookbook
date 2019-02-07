import { Injectable } from '@angular/core';
import { HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

import { ApiService } from './api.service';
import {  Recipe, ArticleListConfig } from '../models';
import { map } from 'rxjs/operators';

@Injectable()
export class ArticlesService {
  constructor (
    private apiService: ApiService
  ) {}

  query(config: ArticleListConfig): Observable<{recipes: Recipe[], recipesCount: number}> {
    // Convert any filters over to Angular's URLSearchParams
    const params = {};

    Object.keys(config.filters)
    .forEach((key) => {
      params[key] = config.filters[key];
    });

    return this.apiService
    .get(
      '/recipes' + ((config.type === 'feed') ? '/feed' : ''),
      new HttpParams({ fromObject: params })
    );
  }

  get(slug): Observable<Recipe> {
    return this.apiService.get('/recipes/' + slug)
      .pipe(map(data => data.recipe));
  }

  destroy(slug) {
    return this.apiService.delete('/recipes/' + slug);
  }

  save(recipe): Observable<Recipe> {
    // If we're updating an existing recipe
    if (recipe.slug) {
      return this.apiService.put('/recipes/' + recipe.slug, {recipe: recipe})
        .pipe(map(data => data.recipe));

    // Otherwise, create a new recipe
    } else {
      return this.apiService.post('/recipes/', {recipe: recipe})
        .pipe(map(data => data.recipe));
    }
  }

  favorite(slug): Observable<Recipe> {
    return this.apiService.post('/recipes/' + slug + '/favorite');
  }

  unfavorite(slug): Observable<Recipe> {
    return this.apiService.delete('/recipes/' + slug + '/favorite');
  }


}
