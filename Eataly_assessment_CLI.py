import os
import tarfile
import json
import pandas as pd
from datetime import date
import argparse

def process_tar_file(loc, N, output_loc):
    lst_extract = []

    with tarfile.open(os.path.join(loc, "data.tar.gz"), 'r') as tar:
        members = tar.getmembers()

        for m in members:
            if m.name.endswith('.json'):
                with tar.extractfile(m) as json_file:
                    json_content = json_file.read().decode('utf-8')
                    json_data = json.loads(json_content)
                    lst_extract.append(json_data)

    df = pd.json_normalize(lst_extract)

    qty_sold_lst = [receipt['qty_sold'] for products in df['products'] for receipt in products]
    prod_lst = [receipt['product_name'] for products in df['products'] for receipt in products]

    d = dict(zip(prod_lst, qty_sold_lst))

    result = pd.DataFrame(d.items(), columns=['product_name', 'qty_sold'])

    agg_result = (
        result
        .groupby('product_name')[['qty_sold']].sum()
        .reset_index()
        .sort_values('qty_sold', ascending=False)
    )

    agg_result['Rank'] = agg_result['qty_sold'].rank(method='dense', ascending=False)
    final = agg_result[agg_result['Rank'] <= N]

    formatted_date = date.today().strftime('%Y_%m_%d')

    d_result = {
        'source_folder': loc,
        'run_date': formatted_date,
        'file_count': df['products'].shape[0],
        'best_sellers': final.to_dict(orient='records')
    }

    output_filename = f"top_{N}_{formatted_date}.json"
    with open(os.path.join(output_loc, output_filename), "w") as f:
        json.dump(d_result, f)

def main():
    parser = argparse.ArgumentParser(description='Process receipt files and generate best-sellers report.')
    parser.add_argument('-d', '--directory', type=str, required=True,
                        help='String filepath to the directory of receipt files')
    parser.add_argument('-n', '--number-of-products', type=int, required=True,
                        help='Integer number of best-selling products to return')
    parser.add_argument('-o', '--output-filepath', type=str, required=True,
                        help='String filepath to the output file')

    args = parser.parse_args()

    process_tar_file(args.directory, args.number_of_products, args.output_filepath)

if __name__ == "__main__":
    main()