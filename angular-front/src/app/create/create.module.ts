import { ModuleWithProviders, NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';

import { RecipeComponent } from './create.component';
import { RecipeArticleResolver } from './create-resolver.service';
import { AuthGuard } from '../core';
import { SharedModule } from '../shared';
import { RecipeRoutingModule } from './create-routing.module';

@NgModule({
  imports: [SharedModule, RecipeRoutingModule],
  declarations: [RecipeComponent],
  providers: [RecipeArticleResolver]
})
export class RecipeModule {}
