package com.devxschool.food_delivery.controllers;

import com.devxschool.food_delivery.models.Food;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
public class FoodController {

    private List<Food> foodList = new ArrayList<>();

    @GetMapping("/")
    public String getIndex(){
        return "layout";
    }

    @GetMapping("/about")
    public String getAbout(){
        return "about";
    }

    @GetMapping("/food/list")
    public String listFoods(Model model){

        model.addAttribute("food", foodList);
      
        return "food_list";
    }

    @GetMapping("/food/new")
    public String createFood(Model model){
        model.addAttribute("foodType", Food.FoodType.values());
        model.addAttribute("newFood",new Food());
        return "create_food";
    }

    @GetMapping("/food/update")
    public String updateFood(@RequestParam Long id, Model model){
        Optional<Food> food = foodList.stream().filter(f -> f.getId() == id).findFirst();
        if (!food.isPresent())
            return "redirect:/food/new";

        model.addAttribute("newFood",food.get());
        model.addAttribute("foodType", Food.FoodType.values());
        return "create_food";
    }

    @PostMapping("/food")
    public String createFood(@ModelAttribute Food food){
        Optional<Food> oldFood = foodList.stream().filter(f -> f.getId() == food.getId()).findFirst();
        if (oldFood.isPresent()){
            foodList.remove(oldFood.get());
            foodList.add(food);
        } else {
            foodList.add(food);
        }
            
        return "redirect:/food/list";
    }

    @GetMapping("/food/delete")
    public String deleteFood(@RequestParam Long id) {
        Optional<Food> oldFood = foodList.stream().filter(f -> f.getId() == id).findFirst();
        if (oldFood.isPresent())
            foodList.remove(oldFood.get());
            
        return "redirect:/food/list";
    }

    @GetMapping("/food/detail")
    public String getFoodDetails(@RequestParam Long id, Model model){
        Optional<Food> food = foodList.stream().filter(f -> f.getId() == id).findFirst();
        if (!food.isPresent())
            return "not_found";

        model.addAttribute("food", food.get());

        return "food_details";
    }

}
