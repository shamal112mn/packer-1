package com.devxschool.food_delivery.models;

public class Food {

    public enum FoodType{
        Beverages,
        Appetizers,
        MainDish
    }

    private Long id;
    private Float price;
    private String name;
    private FoodType foodType;

    public Food(){

    }
    public Food(Long id, String name, Float price) {
        this.id = id;
        this.name = name;
        this.price = price;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Float getPrice() {
        return price;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

    public FoodType getFoodType() {
        return foodType;
    }

    public void setFoodType(FoodType foodType) {
        this.foodType = foodType;
    }

}
