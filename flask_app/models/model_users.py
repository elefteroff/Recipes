from flask_app import app, DATABASE
from flask_app.models import model_recipes
from flask_app.config.mysqlconnection import connectToMySQL
from flask import flash
from flask_bcrypt import Bcrypt
import re

EMAIL_REGEX = re.compile(r'^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+$')
bcrypt = Bcrypt(app)

class User:
    def __init__(self,data):
        self.id = data['id']
        self.first_name = data['first_name']
        self.last_name = data['last_name']
        self.email = data['email']
        self.password = data['pw']
        self.created_at = data['created_at']
        self.updated_at = data['updated_at']

    @classmethod
    def create(cls, data):
        query = 'INSERT INTO users (first_name, last_name, email, pw) VALUES (%(first_name)s, %(last_name)s, %(email)s, %(pw)s);'
        users_id = connectToMySQL(DATABASE).query_db(query,data)
        return users_id

    @classmethod
    def get_one(cls, **data):
        query = 'SELECT * FROM users LEFT JOIN recipes ON users.id = users_id WHERE users.id = %(id)s;'
        results = connectToMySQL(DATABASE).query_db(query,data)
        user = cls(results[0])#object instance of the current class
        user.all_recipes = []#instantiate empty list
        for row in results:
            recipe_data = {#pull out data specific table2
            **row,#spread out all the colums in the row into key/value pairs
            "id":row['recipes.id'],#duplicate columns need the table name prefixed
            "created_at":row['recipes.created_at'],
            "updated_at":row['recipes.updated_at'],
            }
            recipe = model_recipes.Recipe(recipe_data)#create object instance of class2
            user.all_recipes.append(recipe)#append object to list
        return user#return class1 instance object

    @classmethod
    def get_one_email(cls, **data):
        '''Takes in an email and returns a User object'''
        query = 'SELECT * FROM users WHERE email = %(email)s;'
        results = connectToMySQL(DATABASE).query_db(query,data)
        if results:
            return cls(results[0])
        return results

# ********************* VALIDATIONS *********************

    @staticmethod
    def validate_users(data):
        is_valid = True

        if len(data['first_name']) < 3:
            flash("First name must be at least 2 characters.", "error_first_name")
            is_valid = False

        if len(data['last_name']) < 3:
            flash("Last name must be at least 2 characters.", "error_last_name")
            is_valid = False

        if len(data['email']) < 6:
            flash("Email must be 6 or greater.", "error_email")
            is_valid = False

        elif not EMAIL_REGEX.match(data['email']): 
            flash("Invalid email address!")
            is_valid = False

        if len(data['pw']) < 3:
            flash("Password must be at least 8 characters.", "error_password")
            is_valid = False

        if len(data['confirm_password']) < 3:
            flash("Confirm Password.", "error_confirm_password")
            is_valid = False

        return is_valid
