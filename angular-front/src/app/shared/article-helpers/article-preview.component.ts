import { Component, Input } from '@angular/core';

import { Recipe } from '../../core';

@Component({
  selector: 'app-article-preview',
  templateUrl: './article-preview.component.html'
})
export class ArticlePreviewComponent {
  @Input() recipe: Recipe;

  onToggleFavorite(favorited: boolean) {

  }
}
