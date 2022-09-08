Create or replace Trigger User_Audit
after insert or update or delete 
on User_ for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('User_',L_transaction,USER,CURRENT_TIMESTAMP);

end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger Chef_Audit
after insert or update or delete 
on Chef for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('Chef',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger Waiter_Audit
after insert or update or delete 
on Waiter for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('Waiter',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger Supplier_Audit
after insert or update or delete 
on Supplier for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('Supplier',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger RestaurantManager_Audit
after insert or update or delete 
on RestaurantManager for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('RestaurantManager',L_transaction,USER,CURRENT_TIMESTAMP);
       
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger Customer_Audit
after insert or update or delete 
on Customer for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('Customer',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger BoxMoney_Audit
after insert or update or delete 
on BoxMoney for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('BoxMoney',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger Categorey_Audit
after insert or update or delete 
on Categorey for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('Categorey',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger product_Audit
after insert or update or delete 
on product for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('product',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger Order_Audit
after insert or update or delete 
on Order_ for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('Order_',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger OrderDetail_Audit
after insert or update or delete 
on OrderDetail for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('OrderDetail',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger Customer_FeedBack_Audit
after insert or update or delete 
on Customer_FeedBack for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('Customer_FeedBack',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger table_Audit
after insert or update or delete 
on table_ for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('table_',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger reservation_Audit
after insert or update or delete 
on reservation for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('reservation',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger InfoAboutRestaurant_Audit
after insert or update or delete 
on InfoAboutRestaurant for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('InfoAboutRestaurant',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger Login_Audit
after insert or update or delete 
on Login for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('Login',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
Create or replace Trigger Stored_Audit
after insert or update or delete 
on Stored_ for each row 
Declare
L_transaction audits.transaction_name%type;
begin

        L_transaction := case
        when inserting then 'insert'
        when updating then 'Update'
        when deleting then 'Delete'
        end;

        insert into audits(table_name,transaction_name,by_user,transaction_Date) 
        values('Stored_',L_transaction,USER,CURRENT_TIMESTAMP);
        
end;
--##############################################################################
--##############################################################################
--##############################################################################
commit;