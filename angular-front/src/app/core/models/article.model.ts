import { Profile } from './profile.model';

export interface Article {
  slug: string;
  title: string;
  description: string;
  picture: string;
  body: string;
  tagList: string[];
  createdAt: string;
  updatedAt: string;
  favorited: boolean;
  favoritesCount: number;
  author: Profile;
}
