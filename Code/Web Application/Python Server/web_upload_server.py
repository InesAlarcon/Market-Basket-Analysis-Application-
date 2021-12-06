from flask import Flask, request, make_response
import os
from flask import jsonify 
import dataframe_image as dfi

#Data Analysis
import numpy as np 
import pandas as pd
import matplotlib.pyplot as plt
import squarify
import seaborn as sns
from mlxtend.frequent_patterns import apriori
from mlxtend.frequent_patterns import association_rules 
import networkx as nx
from wordcloud import WordCloud
import warnings
from mlxtend.preprocessing import TransactionEncoder
from mlxtend.frequent_patterns import apriori
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
import matplotlib
matplotlib.use('Agg')
from datetime import date
from datetime import datetime

from io import BytesIO
import base64

app = Flask(__name__)

# Create a directory in a known location to save files to.
uploads_dir = os.path.join(os.getcwd(), 'saved_files')
os.makedirs(uploads_dir, exist_ok=True)

@app.route('/file', methods=['POST', 'OPTIONS'])
def save_file():
    if request.method == "OPTIONS":  # CORS preflight
        response = make_response()
        response.access_control_allow_origin = "*"
        response.access_control_allow_methods = "POST"
        response.access_control_allow_headers = "*"
        return response
    elif request.method == "POST":  # The actual request following the preflight
        # Saving file
        file_to_save = request.files['filebytes']
        file_to_save.save(os.path.join(uploads_dir, file_to_save.filename))
        file_name = request.files['filebytes'].filename

        # Do more stuff

        #Read data
        data = pd.read_csv(uploads_dir + r'\\' + file_name, header = 0, low_memory=False, encoding= 'unicode_escape')
        data = data.dropna()
        print(data)
        print(data.shape)
        #for col in data.columns:
        #    print(col)

        
        now = datetime.now()
        today = now.strftime("%d/%m/%Y")
        print("Today's date:", today)

        now = datetime.now()
        current_time = now.strftime("%H:%M:%S")
        print("Current Time =", current_time)

        transactions = data.InvoiceNo.nunique()
        print(transactions)

        #word cloud 
        plt.rcParams['figure.figsize'] = (10, 10)
        wordcloud = WordCloud(background_color = 'white', width = 1000,  height = 1000, max_words = 300).generate(str(data["Description"]))
        plt.imshow(wordcloud)
        plt.axis('off')
        plt.title('Most Popular Items',fontsize = 20)
        plt.savefig(uploads_dir + r'\\'+ 'wordcloud.png', bbox_inches = 'tight', dpi=500)
        #plt.show()
        figfile = BytesIO()
        plt.savefig(figfile, format='png')
        figfile.seek(0)
        wordclpudflutter = base64.b64encode(figfile.getvalue()).decode('ascii')
        #print(figdata_png)

        plt.clf()

        #Frequency 
        plt.rcParams['figure.figsize'] = (15, 10)
        color = plt.cm.cool(np.linspace(0, 1, 25))
        data["Description"].value_counts().head(25).plot.bar(color = color)
        plt.title('frequency of most popular items', fontsize = 20)
        plt.xticks(rotation = 90)
        plt.savefig(uploads_dir + r'\\'+ 'frequency.png', bbox_inches = 'tight', dpi=1000)
        #plt.show()
        figfile = BytesIO()
        plt.savefig(figfile, format='png')
        figfile.seek(0)
        frequencyflutter = base64.b64encode(figfile.getvalue()).decode('ascii')
        plt.clf()

        #Map tree 
        y = data["Description"].value_counts().head(25).to_frame()
        y.index
        # We add an alpha layer to ensure black labels show through
        plt.rcParams['figure.figsize'] = (15, 10)
        color = plt.cm.cool(np.linspace(0, 1, 25))
        squarify.plot(sizes = y.values, label = y.index, alpha=0.6, color = color,  text_kwargs={'fontsize':5})
        plt.title('Tree Map for Popular Items')
        plt.axis('off')
        plt.savefig(uploads_dir + r'\\'+'maptree.png', bbox_inches = 'tight', dpi=1000)
        #plt.show()
        figfile = BytesIO()
        plt.savefig(figfile, format='png')
        figfile.seek(0)
        maptreeflutter = base64.b64encode(figfile.getvalue()).decode('ascii')
        plt.clf()


        #transforming data 
        data_plus = data [data["Quantity"]>0]
        #data_plus.info()

        data_plus = (data_plus.groupby(["InvoiceNo","Description"])["Quantity"].sum().unstack().reset_index().fillna(0).set_index("InvoiceNo"))
        #print (data_plus.head())
        def encode_units (x):
            if x <= 0:
                return 0
            if x >= 1:
                return 1
        basket_encode_plus = data_plus.applymap (encode_units)
        #print (basket_encode_plus.head())


        basket_filter_plus = basket_encode_plus [(basket_encode_plus > 0).sum(axis=1) >= 2]
        frequent_itemsets_plus = apriori(basket_filter_plus, min_support = 0.03, use_colnames = True).sort_values('support',ascending = False).reset_index(drop = True )
        frequent_itemsets_plus['lenght'] = frequent_itemsets_plus['itemsets'].apply(lambda x : len(x))
        #print (frequent_itemsets_plus.head())
        #dfi.export(frequent_itemsets_plus.head(), uploads_dir + r'\\'+ 'frequent_itemsets_plus.png')


        frequent_itemsets_plus = association_rules(frequent_itemsets_plus, metric = 'lift', min_threshold = 1).sort_values('lift',ascending = False).reset_index(drop = True)
        print (frequent_itemsets_plus)
        dfi.export(frequent_itemsets_plus, uploads_dir + r'\\'+ 'frequent_itemsets_plus2.png')
        freqitemsimg = base64.b64encode(open(uploads_dir + r'\\'+ 'frequent_itemsets_plus2.png', "rb").read()).decode('ascii')

        ##########################################################################################################################################################################

        df = pd.read_csv(uploads_dir + r'\\' + file_name, header = 0, low_memory=False, encoding= 'unicode_escape')
        df[['Date','Time']] = df.InvoiceDate.str.split(" ",expand=True,) 
        #print(df.head())
        df[['Day','Month','Year']] = df.Date.str.split("/",expand=True,)
        table = pd.pivot_table(df,index=["Year","Month","Day","Description"],values=["Quantity"],aggfunc=np.sum)
        print(table.head())
        table.to_excel(uploads_dir + r'\\' + 'Pivot.xlsx')
        # Read the file and convert it to a base 64 string
        js = " "
        with open(uploads_dir + r'\\' + 'Pivot.xlsx', 'rb') as file:
            encoded_file = base64.b64encode(file.read())
            js = encoded_file.decode('utf-8')
            #print(response_dict["file64"])

        
        ##########################################################################################################################################################################

        # Return Response
        response = make_response(
            jsonify(
                    {
                    "message": "CONNECTED SUCCESFULLY",
                    "time": current_time,
                    "date": today,
                    "transactions": transactions,
                    "wordcloud": wordclpudflutter,
                    "frequency": frequencyflutter,
                    "maptree": maptreeflutter,
                    "freqitems": freqitemsimg,
                    "file64": js,
                    "extension": "xlsx"
                    }
                )
            )
        response.status_code = 200
        response.headers.add("Access-Control-Allow-Origin", "*")
        return response
    else:
        response = make_response()
        response.status_code = 405
        response.headers.add("Access-Control-Allow-Origin", "*")
        return response

if __name__ == '__main__':
    app.run(host="localhost", port=15000, debug=True)