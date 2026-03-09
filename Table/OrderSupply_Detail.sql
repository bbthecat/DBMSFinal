CREATE TABLE OrderSupply_Detail (
    Order_Detail_ID char(10),
    Order_Qty       number,
    Payment         VARCHAR2(100),
    Order_ID    char(10),
    Product_ID CHAR(13),

    CONSTRAINT OrSupDet_pk PRIMARY KEY (Order_Detail_ID)
    CONSTRAINT OrSupDet_Order_fk FOREIGN KEY (Order_ID)
        REFERENCES OrderSupply_Header(Order_ID),
    CONSTRAINT Order_fk_Product FOREIGN KEY (product_ID)
        REFERENCES Product (Product_ID)
);
