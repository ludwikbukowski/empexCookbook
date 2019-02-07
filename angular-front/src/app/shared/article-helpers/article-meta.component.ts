import { Component, Input } from '@angular/core';

import { Recipe } from '../../core';

@Component({
  selector: 'app-article-meta',
  templateUrl: './article-meta.component.html'
})
export class ArticleMetaComponent {
  @Input() recipe: Recipe;
}
