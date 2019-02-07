import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { RecipeComponent } from './create.component';
import { RecipeArticleResolver } from './create-resolver.service';
import { AuthGuard } from '../core';
import { SharedModule } from '../shared';

const routes: Routes = [
  {
    path: '',
    component: RecipeComponent,
    canActivate: [AuthGuard]
  },
  {
    path: ':slug',
    component: RecipeComponent,
    canActivate: [AuthGuard],
    resolve: {
      article: RecipeArticleResolver
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class RecipeRoutingModule {}


