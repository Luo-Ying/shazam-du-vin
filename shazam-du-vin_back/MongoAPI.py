from pprint import PrettyPrinter

import certifi
import pymongo
from flask import Flask, request, json, Response
from pymongo import MongoClient

printer = PrettyPrinter()

#This is the a wrapper made to make developpement of the API easier. It containes the basic CRUD method with
#a mix of some custom to work with every endpoint depending of the need
class MongoAPI:
    def __init__(self, data):
        # self.client = MongoClient("mongodb://ip_of_mongo_container:27017/")
        self.client = MongoClient("mongodb://mongodb:27017/")

        database = data['database']
        collection = data['collection']
        cursor = self.client[database]
        self.collection = cursor[collection]
        self.data = data

    def read(self):
        documents = self.collection.find()
        output = [{item: data[item] for item in data if item != '_id'} for data in documents]
        return output

    def readWith(self):
        filt = self.data['filter']
        documents = self.collection.find(filt)
        output = [{item: data[item] for item in data if item != '_id'} for data in documents]
        return output

    def readTop(self):
        documents = self.collection.find().sort("noteGlobale", pymongo.DESCENDING).limit(10)
        output = [{item: data[item] for item in data if item != '_id'} for data in documents]
        return output

    def write(self, data):
        # log.info('Writing Data')
        new_document = data['data']
        response = self.collection.insert_one(new_document)
        output = {'Status': 'Successfully Inserted', 'Document_ID': str(response.inserted_id)}
        return output

    def update(self):
        filt = self.data['filter']
        updated_data = {"$set": self.data['data']}
        response = self.collection.update_one(filt, updated_data)
        output = {'Status': 'Successfully Updated' if response.modified_count > 0 else "Nothing was updated."}
        return output

    def delete(self, data):
        filt = data['filter']
        response = self.collection.delete_one(filt)
        output = {'Status': 'Successfully Updated' if response.deleted_count > 0 else "Nothing was updated."}
        return output

    def ocr(self):
        filt = self.data['filter']
        documents = self.collection.find(filt)
        output = [{item: data[item] for item in data if item != '_id'} for data in documents]
        return output