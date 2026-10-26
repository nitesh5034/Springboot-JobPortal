package com.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class review 
{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
private int id;

	private int rating;
String name,text;
public int getId() {
	return id;
}
public void setId(int id) {
	this.id = id;
}
public int getRating() {
	return rating;
}
public void setRating(int rating) {
	this.rating = rating;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public String getText() {
	return text;
}
public void setText(String text) {
	this.text = text;
}

}
