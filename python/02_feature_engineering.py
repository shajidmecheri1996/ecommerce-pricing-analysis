# ============================================================
# 10. FEATURE ENGINEERING
# ============================================================
# Competitor relative metrics
df['comp_price_ratio']  = df['unit_price'] / df['avg_comp_price'].replace(0, np.nan)
df['freight_ratio']     = df['freight_price'] / df['unit_price'].replace(0, np.nan)
df['revenue_per_unit']  = df['total_price'] / df['qty'].replace(0, np.nan)
df['price_momentum']    = df['unit_price'] - df['lag_price']

# Avg competitor score and freight
df['avg_comp_score']    = (df['ps1'] + df['ps2'] + df['ps3']) / 3
df['avg_comp_freight']  = (df['fp1'] + df['fp2'] + df['fp3']) / 3

# Category encoding
df['category_encoded'] = df['product_category_name'].astype('category').cat.codes

# Interaction features
df['price_x_score']    = df['unit_price'] * df['product_score']
df['weight_volume']    = df['product_weight_g'] * df['volume']

print("New features added. Shape:", df.shape)
df.to_csv('ecommerce_processed.csv', index=False)
