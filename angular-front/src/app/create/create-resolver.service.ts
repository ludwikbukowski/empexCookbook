import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Resolve, Router, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';

import { Recipe, RecipesService, UserService } from '../core';
import { catchError ,  map } from 'rxjs/operators';

@Injectable()
export class RecipeArticleResolver implements Resolve<Recipe> {
  constructor(
    private recipesService: RecipesService,
    private router: Router,
    private userService: UserService
  ) { }

  resolve(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): Observable<any> {

    return this.recipesService.get(route.params['slug'])
      .pipe(
        map(
          article => {
            if (this.userService.getCurrentUser().username === article.author.username) {
              return article;
            } else {
              this.router.navigateByUrl('/');
            }
          }
        ),
        catchError((err) => this.router.navigateByUrl('/'))
      );
  }
}
