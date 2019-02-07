import { Profile } from './profile.model';

export interface Recipe {
  slug: string;
  title: string;
  body: string;
  picture: string;
  ingredients:  Array<any>;
  createdAt: string;
  updatedAt: string;
  author: Profile;
}
