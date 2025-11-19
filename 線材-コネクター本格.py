import streamlit as st
import os
import pandas as pd
#input_num = st.number_input('Input a number', value=0)

file_name=r'SOKUDO DUO標準コネクタ・ケーブル適合表リソwire.xlsx'
dir=r'C:\Users\1011701N\Documents\01-線材資料'
file_path=os.path.join(dir,file_name)
df=pd.read_excel(file_path)
df = df.replace('\n', '', regex=True)
#st.dataframe(df)
#df=df.iloc[3:3,4:6]
#st.dataframe(df)
# ダミーデータ
#data = pd.DataFrame({
#    "メーカ": ["日立東日電線", "東日京三電線", "日立電線", "太陽ｹｰﾌﾞﾙﾃｯｸ","潤工社","日合通信","沖電線","立井電線","タツタ電線","大電","平河H"],
#    "型式": ["飲み物", "お菓子", "デザート", "お菓子"],
#    "AWGサイズ": ["飲み物", "お菓子", "デザート", "お菓子"],
#})

#data = pd.DataFrame({
#    "メーカ": ["日立東日電線", "東日京三電線", "日立電線", "太陽ｹｰﾌﾞﾙﾃｯｸ","潤工社","日合通信","沖電線","立井電線","タツタ電線","大電","平河H"]
#    "型式": ["飲み物", "お菓子", "デザート", "お菓子"],
#    "AWGサイズ": ["飲み物", "お菓子", "デザート", "お菓子"],
#})


# プルダウン
maker = st.selectbox("メーカ",options=["日立東日電線", "東日京三電線", "日立電線", "太陽ｹｰﾌﾞﾙﾃｯｸ","潤工社","日合通信","沖電線","立井電線","タツタ電線","大電","平河H"])
st.write(maker)
# プルダウン
model = st.selectbox("型式",options=["日立東日電線", "東日京三電線", "日立電線", "太陽ｹｰﾌﾞﾙﾃｯｸ","潤工社","日合通信","沖電線","立井電線","タツタ電線","大電","平河H"])
st.write(model)
awg_size = st.selectbox("AWGサイズ",options=["日立東日電線", "東日京三電線", "日立電線", "太陽ｹｰﾌﾞﾙﾃｯｸ","潤工社","日合通信","沖電線","立井電線","タツタ電線","大電","平河H"])
st.write(model)

# カテゴリの選択s
#selected_maker = st.selectbox("メーカを選択：", data["メーカ"].unique())
#selected_modle = st.selectbox("型式を選択：", data["型式"].unique())
#selected_awg = st.selectbox("AWGサイズを選択：", data["AWGサイズ"].unique()) 



#df_1=df.iloc[5:,:]
#print(df_1)
#selected_maker = st.selectbox("メーカを選択：", df_1["メーカ"].unique())


# カテゴリの選択
        #selected_maker = st.selectbox("メーカを選択：", data["メーカ"].unique())
        #selected_modle = st.selectbox("型式を選択：", data["型式"].unique())
        #selected_awg = st.selectbox("AWGサイズを選択：", data["AWGサイズ"].unique()) 
# タグの選択

# 選択されたカテゴリーでフィルタリング
        #filtered_df = df[df['Category'] == selected_category]

# 結果を表示
        #st.write(f"選択されたカテゴリー: {selected_category}")




