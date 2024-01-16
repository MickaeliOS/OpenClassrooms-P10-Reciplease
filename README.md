# OpenClassrooms-P10-Reciplease

## Important

If you want to try this project, you will have to provide the API key and the app ID that are necessary for the app to work.

 - [Edamam](https://www.edamam.com)

Once you did that, you should create a Struct named APIConfiguration containing the API key and the app ID : 

```swift
  struct APIConfiguration {
    // MARK: - SINGELTON
    static let shared = APIConfiguration()
    private init() {}

    // MARK: - EDAMAM API CONFIGURATION
    let baseURL = "https://api.edamam.com/api/recipes/v2?type=public"
    let apiKey = "YOUR_API_KEY"
    let appID = "YOUR_APP_ID"
    
    // Emergency URL
    // let baseURL = "https://api.edamam.com/search"
}
```

## Welcome !

Welcome to Reciplease, where you can discover a variety of recipes to satisfy your hunger!

Our app offers a convenient way to create an ingredients list and search for recipes based on your selection.  
Once you provide your ingredients, you'll be presented with a list of recipes to choose from.  
Each recipe provides detailed informations to help you decide which one suits your taste.  
Reciplease also offers a "Favorites" feature, powered by CoreData, allowing you to save and access your preferred recipes with ease.  
If you need more detailed instructions, you can visit the original website where the recipe originated from.  

During the development of the 10th OpenClassrooms project, we gained experience in using CoreData, a reliable data persistence tool.  
This allowed us to effectively manage and store recipe data, ensuring a smooth user experience.

In addition, we successfully integrated CocoaPods, a popular dependency manager, to streamline the functionality and efficiency of our app.

Join us on a culinary journey with Reciplease and discover delicious recipes at your fingertips!

<div align="center">
  <h2> Recipes </h2>
  <img src="https://github.com/MickaeliOS/OpenClassrooms-P10-Reciplease/blob/master/Divers/Images/Recipes.png" width="200">
</div>

<div align="center">
    <h2> Recipe Detail </h2>
  <img src="https://github.com/MickaeliOS/OpenClassrooms-P10-Reciplease/blob/master/Divers/Images/RecipeDetails.png" width="200">
</div>

<div align="center">
    <h2> Favorites </h2>
  <img src="https://github.com/MickaeliOS/OpenClassrooms-P10-Reciplease/blob/master/Divers/Images/Favorites.png" width="200">
</div>
