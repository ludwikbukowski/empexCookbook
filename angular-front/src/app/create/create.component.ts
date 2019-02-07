import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, FormControl } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';

import { Recipe, RecipesService } from '../core';

@Component({
  selector: 'app-recipe-page',
  templateUrl: './create.component.html'
})


export class RecipeComponent implements OnInit {

  recipeForm: FormGroup;
  recipe: Recipe = {} as Recipe;
  tagField = new FormControl();
  errors: Object = {};
  ingredients;
  txtName;
  isSubmitting = false;

  constructor(
    private recipesService: RecipesService,
    private route: ActivatedRoute,
    private router: Router,
    private fb: FormBuilder
  ) {
    // use the FormBuilder to create a form group
    this.recipeForm = this.fb.group({
      title: '',
      body: '',
      ingredients: [],
      picture: 'https://www.rawshorts.com/freeicons/wp-content/uploads/2017/01/Travel-pict-dinner.png'
    });

    // Initialized tagList as empty array
   // this.recipe.tagList = [];

    // Optional: subscribe to value changes on the form
    // this.recipeForm.valueChanges.subscribe(value => this.updateRecipe(value));
  }

  ngOnInit() {
  this.ingredients = []
    // If there's an recipe prefetched, load it
    this.route.data.subscribe((data: { recipe: Recipe }) => {
      if (data.recipe) {
        this.recipe = data.recipe;
        this.recipeForm.patchValue(data.recipe);
      }
    });
  }

  addIngredient(){
    this.ingredients.push({name: this.txtName})
  }

  deleteIngredient(name){
    for(var i=0;i< this.ingredients.length; i++){
      if(this.ingredients[i]["name"] == name){
        this.ingredients.splice(i,1);
      }
    }
   }



  submitForm() {
    this.isSubmitting = true;

    // update the model
    this.updateRecipe(this.recipeForm.value);

    // post the changes
    this.recipe.ingredients = this.ingredients
    console.log('recipe sent is ' + JSON.stringify(this.recipe))


    this.recipesService.save(this.recipe).subscribe(
      recipe => this.router.navigateByUrl('/'),
      err => {
        this.errors = err;
        this.isSubmitting = false;
      }
    );
  }

  updateRecipe(values: Object) {
    Object.assign(this.recipe, values);
  }
}
