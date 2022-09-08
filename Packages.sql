Set serveroutput on;
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################

create or replace package User_Package as
            procedure GetAllUsers;
            procedure CeateUsers(UuserType in varchar , Uusername in varchar , Uphone in varchar , Udate in date , Uemail in varchar,UPass in varchar ,ULoginID in int);
            procedure UpdateUsers(Uid in int, UuserType in varchar , Uusername in varchar , Uphone in varchar , Udate in date , Uemail in varchar,UPass in varchar ,ULoginID in int);
            procedure DeleteUsers(Uid in int);

end User_Package;



create or replace package body User_Package as

                procedure GetAllUsers as
                c_all SYS_REFCURSOR;
                begin
                open c_all for
                select * from User_;
                DBMS_sql.return_result(c_all);
                end GetAllUsers;
                
                procedure CeateUsers(UuserType in varchar , Uusername in varchar , Uphone in varchar , Udate in date , Uemail in varchar,UPass in varchar ,ULoginID in int)
                as
                begin
                insert into User_(User_ID,User_Type,User_Name,User_PhoneNumber,User_DateOfBirth,User_Email,User_Pass,User_LoginID)
                values(UserID_sequence.nextVal,UuserType,Uusername,Uphone,Udate,Uemail,UPass,ULoginID);
                commit;
                end CeateUsers;
                
                procedure UpdateUsers(Uid in int, UuserType in varchar , Uusername in varchar , Uphone in varchar , Udate in date , Uemail in varchar,UPass in varchar ,ULoginID in int)
                as
                begin 
                update User_ set 
                User_Type = UuserType,
                User_Name = Uusername,
                User_PhoneNumber = Uphone,
                User_DateOfBirth = Udate,
                User_Email = Uemail,
                User_Pass = UPass,
                User_LoginID = ULoginID
                where User_ID = Uid ;
                commit;
                end UpdateUsers;
                
                
                procedure DeleteUsers(Uid in int)
                as
                begin
                delete from User_ where User_ID = Uid;
                commit;
                end DeleteUsers;
                
end User_Package;




--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################

Create or replace package  P_Chef as
         procedure  ApprovalOrder(OrdeID in Order_.Order_ID%type,ChefID in Chef.Chef_ID%type); 
         procedure  DisapprovalOrder(OrdeID in Order_.Order_ID%type,ChefID in Chef.Chef_ID%type);
         procedure  UpdateState_OrderIsInProgress(OrdeID in Order_.Order_ID%type);
         procedure  UpdateState_OrderComplete(OrdeID in Order_.Order_ID%type);
         
         procedure GetAllChef;
         procedure CreateChef(CSalary in number , CDate in date ,CuserId in int);
         procedure UpdateChef(Cid in int ,CSalary in number , CDate in date , CuserId in int);
         Procedure DeleteChef(Cid in int);            
end  P_Chef;



Create or replace package body  P_Chef as
    
          procedure   ApprovalOrder(OrdeID in Order_.Order_ID%type,ChefID in Chef.Chef_ID%type)
          is
                    Before_CustomerCheck  Order_.CustomerCheck%type;
                    Before_ChefCheck  Order_.ChefCheck%type;
          begin
                  
                        DBMS_OUTPUT.put_line('');
                        DBMS_OUTPUT.put_line('Start : ApprovalOrder');
                        DBMS_OUTPUT.put_line('');
                        
                  select CustomerCheck,ChefCheck 
                  into Before_CustomerCheck,Before_ChefCheck 
                  from Order_ 
                  where Order_ID=OrdeID;
                  
                  if Before_CustomerCheck ='Execution of the order'  and Before_ChefCheck='waiting' then
                  
                            update Order_ SET ChefCheck='Approval' ,Order_ChefID=ChefID
                            WHERE Order_ID=OrdeID ;
                            commit;
                            DBMS_OUTPUT.put_line('The order is being prepared');
                            
                  elsif Before_CustomerCheck='Failure to fulfill the order' and Before_ChefCheck='waiting' then
                  
                            DBMS_OUTPUT.put_line('The customer has not yet fulfilled the order');
                            
                  elsif Before_CustomerCheck='Execution of the order' and Before_ChefCheck='Approval' then
                  
                            DBMS_OUTPUT.put_line('The order is under preparation');
                   
                  end if;
                  
                  
                        DBMS_OUTPUT.put_line('');
                        DBMS_OUTPUT.put_line('End : ApprovalOrder');
                        DBMS_OUTPUT.put_line('');
                 
          end ApprovalOrder;
          
          
          ----------------------------------------------------------------------
          
          procedure   DisapprovalOrder(OrdeID in Order_.Order_ID%type,ChefID in Chef.Chef_ID%type)
          is
                    Before_CustomerCheck  Order_.CustomerCheck%type;
                    Before_ChefCheck  Order_.ChefCheck%type;
          begin
                  
                        DBMS_OUTPUT.put_line('');
                        DBMS_OUTPUT.put_line('Start : DisapprovalOrder');
                        DBMS_OUTPUT.put_line('');
                        
                  select CustomerCheck,ChefCheck 
                  into Before_CustomerCheck,Before_ChefCheck 
                  from Order_ 
                  where Order_ID=OrdeID;
                  
                  if Before_CustomerCheck ='Execution of the order'  and Before_ChefCheck='waiting' then
                  
                            update Order_ SET ChefCheck='Disapproval' ,Order_ChefID=ChefID
                            WHERE Order_ID=OrdeID ;
                            commit;
                            DBMS_OUTPUT.put_line('The order was rejected by the chef');
                            
                  elsif Before_CustomerCheck='Failure to fulfill the order' and Before_ChefCheck='waiting' then
                  
                            DBMS_OUTPUT.put_line('The customer has not yet fulfilled the order');
                            
                elsif Before_CustomerCheck='Execution of the order' and Before_ChefCheck='Disapproval' then
                  
                            DBMS_OUTPUT.put_line('The order was rejected by the chef');
                            
                  elsif Before_CustomerCheck='Execution of the order' and Before_ChefCheck='Approval' then
                  
                            DBMS_OUTPUT.put_line('The order is under preparation');
                   
                  end if;
                  
                  
                        DBMS_OUTPUT.put_line('');
                        DBMS_OUTPUT.put_line('End : DisapprovalOrder');
                        DBMS_OUTPUT.put_line('');
                 
          end DisapprovalOrder;
          
          ----------------------------------------------------------------------
          
          procedure   UpdateState_OrderIsInProgress(OrdeID in Order_.Order_ID%type)
          is
                    Before_CustomerCheck  Order_.CustomerCheck%type;
                    Before_ChefCheck  Order_.ChefCheck%type;
                    Before_Waiter_Chef_StateOrder Order_.Waiter_Chef_StateOrder%type;
          begin
                  
                        DBMS_OUTPUT.put_line('');
                        DBMS_OUTPUT.put_line('Start : UpdateState_OrderIsInProgress');
                        DBMS_OUTPUT.put_line('');
                        
                  select CustomerCheck,ChefCheck,Waiter_Chef_StateOrder
                  into Before_CustomerCheck,Before_ChefCheck,Before_Waiter_Chef_StateOrder  
                  from Order_ 
                  where Order_ID=OrdeID;
                  
                  if Before_CustomerCheck ='Execution of the order'  and Before_ChefCheck='Approval' and  Before_Waiter_Chef_StateOrder='waiting' then
                  
                            update Order_ SET Waiter_Chef_StateOrder='Order is in progress'
                            WHERE Order_ID=OrdeID ;
                            commit;
                            DBMS_OUTPUT.put_line('Status modified successfully');
                            
                  elsif Before_CustomerCheck='Failure to fulfill the order' and Before_ChefCheck='waiting' then
                  
                            DBMS_OUTPUT.put_line('The customer has not yet fulfilled the order');
                            
                 elsif Before_CustomerCheck='Execution of the order' and Before_ChefCheck='Disapproval' then
                  
                            DBMS_OUTPUT.put_line('The order was rejected by the chef');
 
                 end if;
                  
                  
                        DBMS_OUTPUT.put_line('');
                        DBMS_OUTPUT.put_line('End : UpdateState_OrderIsInProgress');
                        DBMS_OUTPUT.put_line('');
                 
          end UpdateState_OrderIsInProgress;
          
          ----------------------------------------------------------------------
          procedure   UpdateState_OrderComplete(OrdeID in Order_.Order_ID%type)
          is
                    Before_CustomerCheck  Order_.CustomerCheck%type;
                    Before_ChefCheck  Order_.ChefCheck%type;
                    Before_Waiter_Chef_StateOrder Order_.Waiter_Chef_StateOrder%type;
          begin
                  
                        DBMS_OUTPUT.put_line('');
                        DBMS_OUTPUT.put_line('Start : UpdateState_OrderComplete');
                        DBMS_OUTPUT.put_line('');
                        
                  select CustomerCheck,ChefCheck,Waiter_Chef_StateOrder
                  into Before_CustomerCheck,Before_ChefCheck,Before_Waiter_Chef_StateOrder  
                  from Order_ 
                  where Order_ID=OrdeID;
                  
                  if Before_CustomerCheck ='Execution of the order'  and Before_ChefCheck='Approval' and  (Before_Waiter_Chef_StateOrder='Order is in progress' or Before_Waiter_Chef_StateOrder='waiting' )then
                  
                            update Order_ SET Waiter_Chef_StateOrder='Order Complete'
                            WHERE Order_ID=OrdeID ;
                            commit;
                            DBMS_OUTPUT.put_line('Status modified successfully');
                            
                  elsif Before_CustomerCheck='Failure to fulfill the order' then
                  
                            DBMS_OUTPUT.put_line('The customer has not yet fulfilled the order');
                            
                 elsif Before_CustomerCheck='Execution of the order' and Before_ChefCheck='Disapproval' then
                  
                            DBMS_OUTPUT.put_line('The order was rejected by the chef');
 
                 end if;
                  
                  
                        DBMS_OUTPUT.put_line('');
                        DBMS_OUTPUT.put_line('End : UpdateState_OrderComplete');
                        DBMS_OUTPUT.put_line('');
                 
          end UpdateState_OrderComplete;

          ----------------------------------------------------------------------
          ----------------------------------------------------------------------
          
            procedure GetAllChef as
                c_all sys_refcursor;
                begin
                open c_all for
                select * from chef;
                DBMS_sql.return_result(c_all);
                end GetAllChef;


            procedure CreateChef(CSalary in number , CDate in date ,CuserId in int)
            as 
            begin
            insert into Chef (Chef_ID ,Chef_Salary ,Chef_DateOfHiring ,Chef_UserID)
            values (ChefID_sequence.nextVal,CSalary ,CDate , CuserId);
            commit;
            end CreateChef;


            procedure UpdateChef(Cid in int ,CSalary in number , CDate in date , CuserId in int)
            as
            begin
            update Chef set Chef_Salary = CSalary , Chef_DateOfHiring = CDate , Chef_UserID = CuserId
            where Chef_ID = Cid;
            commit;
            
            end UpdateChef;
            
            
            Procedure DeleteChef(Cid in int)
            as
            begin
            delete from Chef where Chef_ID= Cid;
            commit;
            end DeleteChef;

end P_Chef;





--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


Create or replace package  P_Waiter as
         procedure  ViewReadyOrders;
         procedure  ViewCustomerFeedBack ;
         procedure  UpdateGiveOrderToCustomer (OrderID in Order_.Order_ID%TYPE);
         procedure GetAllWaiter;
         procedure CreateWaiter(WSalary in number , WDateOfHiring in date , WuserId in int);
         procedure UpdateWaiter(Wid in int ,WSalary in number , WDateOfHiring in date , WuserId in int);
         Procedure DeleteWaiter(Wid in int);
end  P_Waiter;



Create or replace package body  P_Waiter as

        procedure  ViewReadyOrders
        IS
                Cursor C_ViewReadyOrders is 
                SELECT Order_.Order_ID ,User_.User_Name,product.product_name,product.product_price,OrderDetail.OrderDetail_productAmount
                FROM Customer 
                INNER JOIN User_  
                ON Customer.Customer_UserID=User_.User_ID
                INNER JOIN Order_  
                ON Customer.Customer_ID=Order_.Order_CustomerID
                INNER JOIN OrderDetail  
                ON Order_.Order_ID=OrderDetail.OrderDetail_OrderID
                INNER JOIN product  
                ON OrderDetail.OrderDetail_productID=product.product_ID
                WHERE  Order_.CustomerCheck='Execution of the order' 
                And Order_.ChefCheck='Approval' 
                And Order_.Waiter_Chef_StateOrder='Order Complete'
                And Order_.GiveOrderToCustomer='On'
                Order by Order_.Order_ID;
                
                C_orderID Order_.Order_ID%type;
                C_UserName User_.User_Name%type;
                C_ProName product.product_name%type;
                C_Proprice product.product_price%type;
                C_ProAmount OrderDetail.OrderDetail_productAmount%type;
        
        BEGIN
                if not C_ViewReadyOrders%isopen then
                open C_ViewReadyOrders;
                end if;
                
                
                loop
                fetch C_ViewReadyOrders into C_orderID,C_UserName,C_ProName,C_Proprice,C_ProAmount;
                exit when C_ViewReadyOrders%notfound;
                DBMS_OUTPUT.put_line('Order ID: '|| C_orderID || ' ~~~~~ ' || 'User Name: '|| C_UserName);
                DBMS_OUTPUT.put_line('Product Name: '|| C_ProName || ' | ' || 'Product price:  '|| C_Proprice || ' | ' || 'Product Amount:  '|| C_ProAmount);
                DBMS_OUTPUT.put_line('_________________________________________');
                end loop;
                
                   DBMS_OUTPUT.put_line('_____________________');
                   DBMS_OUTPUT.put_line('Row Number: '|| C_ViewReadyOrders%rowcount);
        
                close C_ViewReadyOrders;
                
                
        END ViewReadyOrders;
    
        -----------------------------------
        procedure  ViewCustomerFeedBack 
        IS
                Cursor C_ViewCustomerFeedBack is 
                SELECT Order_.Order_ID,User_.User_Name,Customer_FeedBack.FeedBack_Food,Customer_FeedBack.FeedBack_Note
                FROM Customer_FeedBack 
                INNER JOIN Customer  
                ON Customer_FeedBack.CustomerID=Customer.Customer_ID
                INNER JOIN User_ 
                ON User_.User_ID=Customer.Customer_UserID
                INNER JOIN Order_  
                ON Customer_FeedBack.OrderID=Order_.Order_ID
                Order by Order_.Order_ID;
                
                C_OrderID Order_.Order_ID%Type;
                C_UserName User_.User_Name%Type;
                C_FB_Food Customer_FeedBack.FeedBack_Food%Type;
                C_FB_Note Customer_FeedBack.FeedBack_Note%Type;
        BEGIN
        
                if not C_ViewCustomerFeedBack%isopen then
                open C_ViewCustomerFeedBack;
                end if;
                
                loop
                fetch C_ViewCustomerFeedBack into C_OrderID,C_UserName,C_FB_Food,C_FB_Note;
                exit when C_ViewCustomerFeedBack%notfound;
                DBMS_OUTPUT.put_line('Order ID: '|| C_OrderID || ' ~~~~ ' ||' User Name: '||C_UserName);
                DBMS_OUTPUT.put_line('FeedBack For Food: '|| C_FB_Food);
                DBMS_OUTPUT.put_line('FeedBack For Note: '||C_FB_Note);
                DBMS_OUTPUT.put_line('---------------------');
                end loop;
                
                   
                DBMS_OUTPUT.put_line('_____________________');
                DBMS_OUTPUT.put_line('Row Number: '|| C_ViewCustomerFeedBack%rowcount);
                
                
                close C_ViewCustomerFeedBack;
                
                
        END ViewCustomerFeedBack;
        
        -----------------------------------
        procedure  UpdateGiveOrderToCustomer (OrderID in Order_.Order_ID%TYPE)  
        is
                
                L_CustomerCheck  Order_.CustomerCheck%type;
                L_ChefCheck   Order_.ChefCheck%type;
                L_Waiter_Chef_StateOrder  Order_.Waiter_Chef_StateOrder%type;
                L_GiveOrderToCustomer  Order_.GiveOrderToCustomer%type;
        begin
        
        SELECT 
        CustomerCheck,ChefCheck,Waiter_Chef_StateOrder,GiveOrderToCustomer
        into L_CustomerCheck,L_ChefCheck,L_Waiter_Chef_StateOrder,L_GiveOrderToCustomer
        FROM Order_
        WHERE Order_ID=OrderID;
        
        if L_CustomerCheck='Execution of the order' and 
           L_ChefCheck='Approval' and
           L_Waiter_Chef_StateOrder='Order Complete' then

            UPDATE Order_ set GiveOrderToCustomer='Yes' where Order_ID=OrderID;
            DBMS_OUTPUT.put_line('operation accomplished successfully');
        else
              DBMS_OUTPUT.put_line('The operation was not successful');
        end if;
        end UpdateGiveOrderToCustomer;
            
        ----------------------------------------------------------------------
        ----------------------------------------------------------------------
        procedure GetAllWaiter as
        c_all sys_refcursor;
        begin
        open c_all for
        select * from waiter;
        DBMS_sql.return_result(c_all);
        end GetAllWaiter;

        
        procedure CreateWaiter(WSalary in number , WDateOfHiring in date , WuserId in int)
        as 
        begin
        insert into waiter (Waiter_ID ,Waiter_Salary ,Waiter_DateOfHiring ,Waiter_UserID)
        values (WaiterID_sequence.nextVal,WSalary,WDateOfHiring, WuserId);
        commit;
        end CreateWaiter;
        
        
        
        procedure UpdateWaiter(Wid in int ,WSalary in number , WDateOfHiring in date , WuserId in int)
        as
        begin
        update Waiter 
        set
        Waiter_Salary = WSalary ,
        Waiter_DateOfHiring = WDateOfHiring ,
        Waiter_UserID = WuserId
        where Waiter_ID = Wid;
        commit;
        end UpdateWaiter;
        
        
        
        Procedure DeleteWaiter(Wid in int)
        as
        begin
        delete from Waiter where Waiter_ID= Wid;
        commit;
        end DeleteWaiter;
        
end P_Waiter;



--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


Create or replace package  P_Supplier as
         procedure  ViewStored;
         procedure UpdateItemInStore(
         l_ItemID IN Stored_.Item_ID%TYPE,
         l_ItemName IN Stored_.Item_Name%TYPE,
         l_ItemExpirationDate IN Stored_.ItemExpirationDate%TYPE,
         l_AmountOfItemAvailable IN Stored_.AmountOfItemAvailable%TYPE,
         l_Notes_ComponentAboutTheItem IN Stored_.Notes_ComponentAboutTheItem%TYPE,
         l_StResMangId in int,
         l_StSupplierID in int
         );
         procedure GetAllSupplier;
         Procedure CreateSupplier(ScontractSigningDate in date ,SuserID in int);
         Procedure UpdateSupplier(Supid in int, ScontractSigningDate in date ,SuserID in int);
         Procedure DeleteSupplier(Supid in int);
end  P_Supplier;



Create or replace package body  P_Supplier as

        procedure  ViewStored
            IS
                    Cursor C_ViewStored is 
                    Select *
                    from Stored_;
                    
                    
                    C_ItemID Stored_.Item_ID%type;
                    C_ItemName Stored_.Item_Name%type;
                    C_ItemExpirationDate Stored_.ItemExpirationDate%type;
                    C_AmountOfItemAvailable Stored_.AmountOfItemAvailable%type;
                    C_Notes_ComponentAboutTheItem Stored_.Notes_ComponentAboutTheItem%type;
                    C_StResMangId int;
                    C_StSupplierID int;
            
            BEGIN
                    if not C_ViewStored%isopen then
                    open C_ViewStored;
                    end if;
                    
                    
                    loop
                    fetch C_ViewStored into C_ItemID,C_ItemName,C_ItemExpirationDate,C_AmountOfItemAvailable,C_Notes_ComponentAboutTheItem,C_StResMangId,C_StSupplierID;
                    exit when C_ViewStored%notfound;
                    DBMS_OUTPUT.put_line('Item ID: '|| C_ItemID || ' ~~~~~ ' || 'Item Name: '|| C_ItemName || ' ~~~~~ ' || 'Amount Of Ttem Available: '|| C_AmountOfItemAvailable);
                    DBMS_OUTPUT.put_line('Item Expiration Date: '|| C_ItemExpirationDate );
                    DBMS_OUTPUT.put_line('Notes/Component About The Item: '|| C_Notes_ComponentAboutTheItem);
                    DBMS_OUTPUT.put_line('Restaurant Manager ID : '|| C_StResMangId);
                    DBMS_OUTPUT.put_line('Supplier ID: '|| C_StSupplierID);
                    DBMS_OUTPUT.put_line('_________________________________________');
                    end loop;
                    
                       DBMS_OUTPUT.put_line('_____________________');
                       DBMS_OUTPUT.put_line('Row Number: '|| C_ViewStored%rowcount);
            
                    close C_ViewStored;
                    
                
        END ViewStored;
        
        ----------------------------------------
        procedure UpdateItemInStore(
            l_ItemID IN Stored_.Item_ID%TYPE,
            l_ItemName IN Stored_.Item_Name%TYPE,
            l_ItemExpirationDate IN Stored_.ItemExpirationDate%TYPE,
            l_AmountOfItemAvailable IN Stored_.AmountOfItemAvailable%TYPE,
            l_Notes_ComponentAboutTheItem IN Stored_.Notes_ComponentAboutTheItem%TYPE,
            l_StResMangId in int,
            l_StSupplierID in int
            )
            IS
            
            BEGIN
            
                       Update Stored_ set 
                       Item_Name=l_ItemName ,
                       ItemExpirationDate=l_ItemExpirationDate ,
                       AmountOfItemAvailable=l_AmountOfItemAvailable ,
                       Notes_ComponentAboutTheItem=l_Notes_ComponentAboutTheItem,
                       Stored_ResMangId=l_StResMangId,
                       Stored_SupplierID=l_StSupplierID
                       Where Item_ID=l_ItemID;
        
        END UpdateItemInStore;
       --------------------------------------------------------------------------------
       --------------------------------------------------------------------------------
       procedure GetAllSupplier as
        c_all sys_refcursor;
        begin
        open c_all for
        select * from Supplier;
        DBMS_sql.return_result(c_all);
        end GetAllSupplier;
        
        
        Procedure CreateSupplier(ScontractSigningDate in date ,SuserID in int)
        as 
        begin
        insert into Supplier (Supplier_ID ,Supplier_ContractSigningDate,Supplier_UserID )
        values (SupplierID_sequence.nextVal,ScontractSigningDate ,SuserID);
        commit;
        end CreateSupplier;



        Procedure UpdateSupplier(Supid in int, ScontractSigningDate in date ,SuserID in int)
        as
        begin
        update Supplier set Supplier_ContractSigningDate = ScontractSigningDate , Supplier_UserID = SuserID
        where Supplier_ID = Supid;
        commit;
        end UpdateSupplier;
        
        Procedure DeleteSupplier(Supid in int)
        as
        begin
        delete from Supplier where Supplier_ID= Supid;
        commit;
        end DeleteSupplier;


end P_Supplier; 




--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


Create or replace package  P_RestaurantManager as
        procedure  ViewStored;
        procedure WeekSalesShow_MyBoxMoney(ManID in RestaurantManager.ResMan_ID%type);
        procedure  UpdateInfoAboutRestaurant(
         L_InfoID IN InfoAboutRestaurant.Info_ID%TYPE,
         L_DateOfEstablishment IN InfoAboutRestaurant.DateOfEstablishment%TYPE,
         L_NumberOfTables IN InfoAboutRestaurant.NumberOfTables%TYPE,
         L_OpeningTime IN InfoAboutRestaurant.OpeningTime%TYPE,
         L_ClosingTime IN InfoAboutRestaurant.ClosingTime%TYPE,
         L_NumberOfEmployees IN InfoAboutRestaurant.NumberOfEmployees%TYPE,
         L_TotalSalary IN InfoAboutRestaurant.TotalSalary%TYPE,
         RMangId in int
         ); 

        procedure GetAllResturantManager;
        procedure CreateResturantManager(RSalary in number, RuserId in int);
        procedure UpdateResturantManager(Rid in int,RSalary in number, RuserId in int);
        procedure DeleteResturantManager(Rid in int);
end  P_RestaurantManager;



Create or replace package body  P_RestaurantManager as

        procedure  ViewStored
            IS
                    Cursor C_ViewStored is 
                    Select *
                    from Stored_;
                    
                    
                    C_ItemID Stored_.Item_ID%type;
                    C_ItemName Stored_.Item_Name%type;
                    C_ItemExpirationDate Stored_.ItemExpirationDate%type;
                    C_AmountOfItemAvailable Stored_.AmountOfItemAvailable%type;
                    C_Notes_ComponentAboutTheItem Stored_.Notes_ComponentAboutTheItem%type;
                    C_StResMangId int;
                    C_StSupplierID int;
            
            BEGIN
                    if not C_ViewStored%isopen then
                    open C_ViewStored;
                    end if;
                    
                    
                    loop
                    fetch C_ViewStored into C_ItemID,C_ItemName,C_ItemExpirationDate,C_AmountOfItemAvailable,C_Notes_ComponentAboutTheItem,C_StResMangId,C_StSupplierID;
                    exit when C_ViewStored%notfound;
                    DBMS_OUTPUT.put_line('Item ID: '|| C_ItemID || ' ~~~~~ ' || 'Item Name: '|| C_ItemName || ' ~~~~~ ' || 'Amount Of Ttem Available: '|| C_AmountOfItemAvailable);
                    DBMS_OUTPUT.put_line('Item Expiration Date: '|| C_ItemExpirationDate );
                    DBMS_OUTPUT.put_line('Notes/Component About The Item: '|| C_Notes_ComponentAboutTheItem);
                    DBMS_OUTPUT.put_line('Restaurant Manager ID : '|| C_StResMangId);
                    DBMS_OUTPUT.put_line('Supplier ID: '|| C_StSupplierID);
                    DBMS_OUTPUT.put_line('_________________________________________');
                    end loop;
                    
                       DBMS_OUTPUT.put_line('_____________________');
                       DBMS_OUTPUT.put_line('Row Number: '|| C_ViewStored%rowcount);
            
                    close C_ViewStored;
                    
                
        END ViewStored;
        
        ----------------------------------------
        procedure WeekSalesShow_MyBoxMoney(ManID in RestaurantManager.ResMan_ID%type)
        is
        
        l_BoxMoneyID BoxMoney.BoxMoney_ID%type;
        l_UserName User_.User_Name%type;
        
        l_TotalAmount Product.Product_price%type;
        
        begin
        
                        select BoxMoney.BoxMoney_ID,                   
                        User_.User_Name
                        Into
                        l_BoxMoneyID,l_UserName
                        from BoxMoney
                        inner join RestaurantManager
                        on BoxMoney.ResManID=RestaurantManager.ResMan_ID
                        inner join User_
                        on User_.User_ID=RestaurantManager.ResMan_UserID
                        WHERE RestaurantManager.ResMan_ID=ManID;
                        
                     
                        
                        select SUM(Product.Product_price*OrderDetail.OrderDetail_productAmount)
                        into l_TotalAmount
                        from Order_
                        inner join OrderDetail
                        on OrderDetail.OrderDetail_OrderID=Order_.Order_ID
                        inner join Product
                        on Product.Product_ID=OrderDetail.OrderDetail_ProductID
                        WHERE Order_.BoxMoneyID=l_BoxMoneyID AND
                        Order_.CustomerCheck='Execution of the order' AND
                        Order_.ChefCheck='Approval' AND
                        Order_.Waiter_Chef_StateOrder ='Order Complete' AND                
                        Order_.GiveOrderToCustomer='Yes' AND
                        Order_.Order_Data between CURRENT_TIMESTAMP- interval '7' Day and CURRENT_TIMESTAMP 
                        Order By Order_.Order_ID; 
                         
                
                       
                    DBMS_OUTPUT.put_line('WeekSalesShow_MyBoxMoney');
                    DBMS_OUTPUT.put_line('ResMan ID: '|| ManID ||' ~~~~ '||'User Name : '||l_UserName);
                    DBMS_OUTPUT.put_line('Total Amount : '|| l_TotalAmount );
                        
        end WeekSalesShow_MyBoxMoney;
        
        
        ------------------------------------------
        procedure  UpdateInfoAboutRestaurant(
         L_InfoID IN InfoAboutRestaurant.Info_ID%TYPE,
         L_DateOfEstablishment IN InfoAboutRestaurant.DateOfEstablishment%TYPE,
         L_NumberOfTables IN InfoAboutRestaurant.NumberOfTables%TYPE,
         L_OpeningTime IN InfoAboutRestaurant.OpeningTime%TYPE,
         L_ClosingTime IN InfoAboutRestaurant.ClosingTime%TYPE,
         L_NumberOfEmployees IN InfoAboutRestaurant.NumberOfEmployees%TYPE,
         L_TotalSalary IN InfoAboutRestaurant.TotalSalary%TYPE,
          RMangId in int
         )
        IS
                
        BEGIN
              
              Update   InfoAboutRestaurant 
              set 
              DateOfEstablishment=L_DateOfEstablishment,
              NumberOfTables=L_NumberOfTables,
              OpeningTime=L_OpeningTime,
              ClosingTime=L_ClosingTime,
              NumberOfEmployees=L_NumberOfEmployees,
              TotalSalary=L_TotalSalary,
              ResMangId=RMangId
              Where Info_ID=L_InfoID;
                commit;
        END UpdateInfoAboutRestaurant;
        
        ------------------------------------------
        ------------------------------------------
        procedure GetAllResturantManager
        as
        c_all SYS_REFCURSOR;
        begin
        open c_all for
        select * from RestaurantManager;
        dbms_sql.return_result(c_all);
        end GetAllResturantManager;
        
        
        
        procedure CreateResturantManager(RSalary in number, RuserId in int)
        as
        begin
        insert into RestaurantManager (ResMan_ID,ResMan_Salary,ResMan_UserID) 
        values (ResManID_sequence.nextVal,RSalary,RuserId );
        commit;
        end CreateResturantManager;
        
        
        procedure UpdateResturantManager(Rid in int,RSalary in number, RuserId in int)
        as
        begin
        update RestaurantManager set ResMan_Salary = RSalary ,ResMan_UserID  =RuserId 
        where ResMan_ID = Rid;
        commit;
        end UpdateResturantManager;
        
        
        
        procedure DeleteResturantManager(Rid in int)
        as
        begin
        delete from RestaurantManager where ResMan_ID = Rid;
        commit;
        end DeleteResturantManager;
        
        
end P_RestaurantManager; 




--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################

Create or replace package  P_Customert as
        procedure MenuFood;
        procedure MenuFoodByCategoreyName(gatName Categorey.Categorey_Name%type);
         procedure MenuFoodByProductprice(lowestPrice IN product.product_price%TYPE, higherPrice IN product.product_price%TYPE);
        procedure  SelectFoodFromMenu(
        CusTID in Customer.Customer_ID%type,
        PriID in product.product_ID%type,
        productAmount in OrderDetail.OrderDetail_productAmount%type,
        OrderType Order_.Order_Type%type
        );
        procedure ViewCart_MyOrder(CusTID in Customer.Customer_ID%type,OrdeID in Order_.Order_ID%type);
        procedure CustomerCheck_ExecutionOrder(CusTID in Customer.Customer_ID%type,OrdeID in Order_.Order_ID%type);
        procedure inser_FeedBack(
        FB_Rest in Customer_FeedBack.FeedBack_Restaurant%type,
        FB_Food in Customer_FeedBack.FeedBack_Food%type,
        FB_Chef in Customer_FeedBack.FeedBack_Chef%type,
        FB_Waiter in Customer_FeedBack.FeedBack_Waiter%type,
        FB_Note  in Customer_FeedBack.FeedBack_Note%type,
        CustomerID in Customer.Customer_ID%type,
        OrderID in Order_.Order_ID%type
        );
        
        
       procedure GetAllCustomer;
       procedure CreateCustomer(CavailableBalance in number , CuserId in int,CvisaNumber in varchar);
       procedure UpdateCustomer(Cid in int , CavailableBalance in number , CuserId in int , CvisaNumber in varchar);
       procedure DeleteCustomer(Cid in int);
end P_Customert;



Create or replace package body P_Customert as

        procedure MenuFood
        is
                Cursor C_MenuFood is 
                SELECT cat.Categorey_Name,pro.product_name,pro.product_price 
                FROM product pro
                INNER JOIN Categorey cat 
                ON cat.Categorey_ID=pro.product_Categorey_ID;
                M_CategoreyName Categorey.Categorey_Name%TYPE;
                M_productName product.product_name%TYPE;
                M_productPrice product.product_price%TYPE;
        begin
                
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('Start : procedure MenuFood');
                DBMS_OUTPUT.put_line('');
                
                if not C_MenuFood%isopen then
                open C_MenuFood;
                end if;
                
                
                loop
                    fetch C_MenuFood into M_CategoreyName,M_productName,M_productPrice;
                    exit when C_MenuFood%notfound;
                        DBMS_OUTPUT.put_line('Categorey Name: '|| M_CategoreyName);
                        DBMS_OUTPUT.put_line('Product Name: '|| M_productName);
                        DBMS_OUTPUT.put_line('Product Price: '|| M_productPrice);
                        DBMS_OUTPUT.put_line('---------------------');
                end loop;
                
                DBMS_OUTPUT.put_line('_____________________');
                DBMS_OUTPUT.put_line('Row Number: '|| C_MenuFood%rowcount);
                
                close C_MenuFood;
                
                
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('End : procedure MenuFood');
                DBMS_OUTPUT.put_line('');
                
                
        end MenuFood;
        ------------------------------------------------------------------------
        procedure MenuFoodByCategoreyName(gatName Categorey.Categorey_Name%type)
        is
                Cursor C_MenuFoodByCategoreyName is 
                SELECT cat.Categorey_Name,pro.product_name,pro.product_price 
                FROM product pro
                INNER JOIN Categorey cat 
                ON cat.Categorey_ID=pro.product_Categorey_ID
                where cat.Categorey_Name=gatName;
                
                M_CategoreyName Categorey.Categorey_Name%TYPE;
                M_productName product.product_name%TYPE;
                M_productPrice product.product_price%TYPE;
        begin
                
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('Start : procedure MenuFoodByCategoreyName');
                DBMS_OUTPUT.put_line('');
                
                if not C_MenuFoodByCategoreyName%isopen then
                open C_MenuFoodByCategoreyName;
                end if;
                
                
                loop
                    fetch C_MenuFoodByCategoreyName into M_CategoreyName,M_productName,M_productPrice;
                    exit when C_MenuFoodByCategoreyName%notfound;
                        DBMS_OUTPUT.put_line('Categorey Name: '|| M_CategoreyName);
                        DBMS_OUTPUT.put_line('Product Name: '|| M_productName);
                        DBMS_OUTPUT.put_line('Product Price: '|| M_productPrice);
                        DBMS_OUTPUT.put_line('---------------------');
                end loop;
                
                DBMS_OUTPUT.put_line('_____________________');
                DBMS_OUTPUT.put_line('Row Number: '|| C_MenuFoodByCategoreyName%rowcount);
                
                close C_MenuFoodByCategoreyName;
                
                
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('End : procedure MenuFoodByCategoreyName');
                DBMS_OUTPUT.put_line('');
                
                
        end MenuFoodByCategoreyName;
        ------------------------------------------------------------------------
        procedure MenuFoodByProductprice(lowestPrice IN product.product_price%TYPE, higherPrice IN product.product_price%TYPE)
        is
                Cursor C_MenuFoodByProductprice is 
                SELECT cat.Categorey_Name,pro.product_name,pro.product_price 
                FROM product pro
                INNER JOIN Categorey cat 
                ON cat.Categorey_ID=pro.product_Categorey_ID
                where pro.product_price between lowestPrice and higherPrice;
                
                M_CategoreyName Categorey.Categorey_Name%TYPE;
                M_productName product.product_name%TYPE;
                M_productPrice product.product_price%TYPE;
        begin
                
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('Start : procedure MenuFoodByCategoreyName');
                DBMS_OUTPUT.put_line('');
                
                if not C_MenuFoodByProductprice%isopen then
                open C_MenuFoodByProductprice;
                end if;
                
                
                loop
                    fetch C_MenuFoodByProductprice into M_CategoreyName,M_productName,M_productPrice;
                    exit when C_MenuFoodByProductprice%notfound;
                        DBMS_OUTPUT.put_line('Categorey Name: '|| M_CategoreyName);
                        DBMS_OUTPUT.put_line('Product Name: '|| M_productName);
                        DBMS_OUTPUT.put_line('Product Price: '|| M_productPrice);
                        DBMS_OUTPUT.put_line('---------------------');
                end loop;
                
                DBMS_OUTPUT.put_line('_____________________');
                DBMS_OUTPUT.put_line('Row Number: '|| C_MenuFoodByProductprice%rowcount);
                
                close C_MenuFoodByProductprice;
                
                
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('End : procedure MenuFoodByCategoreyName');
                DBMS_OUTPUT.put_line('');
                
                
        end MenuFoodByProductprice;
        ------------------------------------------------------------------------
        procedure  SelectFoodFromMenu(
        CusTID in Customer.Customer_ID%type,
        PriID in product.product_ID%type,
        productAmount in OrderDetail.OrderDetail_productAmount%type,
        OrderType Order_.Order_Type%type
        )
        is
                 next_OrderID Order_.Order_ID%type;
                 nextOrderID_Test int;
        begin
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('Start : procedure SelectFoodFromMenu');
                DBMS_OUTPUT.put_line('');
                
                
                select COUNT(*)into nextOrderID_Test
                from Order_ 
                where Order_CustomerID=CusTID AND CURRENT_TIMESTAMP between Order_Data- interval '10' minute and Order_Data+ interval '10' minute And CustomerCheck='Failure to fulfill the order';
                
                
                if nextOrderID_Test != 0 then
                
                    select Order_ID into next_OrderID
                    from Order_ 
                    where Order_CustomerID=CusTID AND CURRENT_TIMESTAMP between Order_Data- interval '10' minute and Order_Data+ interval '10' minute ;
                
                    insert into OrderDetail (OrderDetail_ID,OrderDetail_OrderID,OrderDetail_productID,OrderDetail_productAmount)
                    values(OrderDetail_sequence.nextVal,next_OrderID,PriID,productAmount);
                    
                    commit;
                else
                  next_OrderID:=OrderID_sequence.nextVal;
                  --DBMS_OUTPUT.put_line(next_OrderID);
                  
                  insert into Order_ (Order_ID,Order_Data,Order_Type,Order_CustomerID)
                  values(next_OrderID,CURRENT_TIMESTAMP,OrderType,CusTID);
                  
                  insert into OrderDetail (OrderDetail_ID,OrderDetail_OrderID,OrderDetail_productID,OrderDetail_productAmount)
                  values(OrderDetail_sequence.nextVal,next_OrderID,PriID,productAmount);
                    
                    commit;
                end if;
        
                
                DBMS_OUTPUT.put_line('The order has been successfully added');
                
                
                
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('End : procedure SelectFoodFromMenu');
                DBMS_OUTPUT.put_line('');
                
        end SelectFoodFromMenu;
          
          
        ------------------------------------------------------------------------
        
        procedure ViewCart_MyOrder(CusTID in Customer.Customer_ID%type,OrdeID in Order_.Order_ID%type)
        is
                
                Cursor C_ViewCart is 
                SELECT Order_.Order_Data,Order_.Order_Type,
                product.product_name,product.product_price,
                OrderDetail.OrderDetail_productAmount
                FROM Customer 
                INNER JOIN Order_  
                ON Customer.Customer_ID=Order_.Order_CustomerID
                INNER JOIN OrderDetail  
                ON Order_.Order_ID=OrderDetail.OrderDetail_OrderID
                INNER JOIN product  
                ON OrderDetail.OrderDetail_productID=product.product_ID
                WHERE Customer.Customer_ID=CusTID AND Order_.Order_ID=OrdeID;
                
                C_OrderData Order_.Order_Data%type;
                C_OrderType Order_.Order_Type%type;
                C_proName product.product_name%type;
                C_proprice product.product_price%type;
                C_OrderDetail_proAmount OrderDetail.OrderDetail_productAmount%type;
                
                
                
                C_UserName User_.User_Name%type;
                C_UserType User_.User_Type%type;
                
                C_totalPrice product.product_price%type;

        begin
        
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('Start : procedure ViewCart_MyOrder');
                DBMS_OUTPUT.put_line('');
        
               Select User_Name,User_Type into C_UserName,C_UserType 
               from User_
               INNER JOIN Customer  
               ON Customer.Customer_UserID=User_.User_ID
               where Customer.Customer_ID=CusTID;
                
                DBMS_OUTPUT.put('welcome '|| C_UserType);
                DBMS_OUTPUT.put_line('.'|| C_UserName);
        
                if not C_ViewCart%isopen then
                open C_ViewCart;
                end if;
                
                
                loop
                    fetch C_ViewCart into C_OrderData,C_OrderType,C_proName,C_proprice,C_OrderDetail_proAmount;
                    exit when C_ViewCart%notfound;
                        DBMS_OUTPUT.put_line('');
                        DBMS_OUTPUT.put_line('Order Data: '|| C_OrderData);
                        DBMS_OUTPUT.put_line('Order Type: '|| C_OrderType);
                        DBMS_OUTPUT.put_line('Product Name: '|| C_proName);
                        DBMS_OUTPUT.put_line('Product Price: '|| C_proprice);
                        DBMS_OUTPUT.put_line('Product Amount: '|| C_OrderDetail_proAmount);
                        DBMS_OUTPUT.put_line('---------------------');
                end loop;
                
                
                      DBMS_OUTPUT.put_line('_____________________');
                      DBMS_OUTPUT.put_line('Row Number: '|| C_ViewCart%rowcount);
                
                close C_ViewCart;
                
                SELECT sum(product.product_price*OrderDetail.OrderDetail_productAmount)
                INTO C_totalPrice
                FROM Customer 
                INNER JOIN Order_  
                ON Customer.Customer_ID=Order_.Order_CustomerID
                INNER JOIN OrderDetail  
                ON Order_.Order_ID=OrderDetail.OrderDetail_OrderID
                INNER JOIN product  
                ON OrderDetail.OrderDetail_productID=product.product_ID
                WHERE Customer.Customer_ID=CusTID AND Order_.Order_ID=OrdeID;
                
                DBMS_OUTPUT.put_line('Total Price :'||C_totalPrice);
            
            
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('End : procedure ViewCart_MyOrder');
                DBMS_OUTPUT.put_line('');
                
        end ViewCart_MyOrder;
        
        
        ------------------------------------------------------------------------
        procedure CustomerCheck_ExecutionOrder(CusTID in Customer.Customer_ID%type,OrdeID in Order_.Order_ID%type)
          is
          Before_CustomerCheck Order_.CustomerCheck%type;
          TotalPrice product.product_price%type;
          AvailableBalance Customer.Customer_AvailableBalance%type;
          resulting product.product_price%type;
          begin
          
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('Start : CustomerCheck_ExecutionOrder');
                DBMS_OUTPUT.put_line('');
                
                SELECT sum(product.product_price*OrderDetail.OrderDetail_productAmount)
                INTO TotalPrice
                FROM Customer 
                INNER JOIN Order_  
                ON Customer.Customer_ID=Order_.Order_CustomerID
                INNER JOIN OrderDetail  
                ON Order_.Order_ID=OrderDetail.OrderDetail_OrderID
                INNER JOIN product  
                ON OrderDetail.OrderDetail_productID=product.product_ID
                WHERE Customer.Customer_ID=CusTID and Order_.Order_ID=OrdeID;
                
                
                Select Customer_AvailableBalance INTO AvailableBalance from Customer where Customer.Customer_ID=CusTID;
                
                if AvailableBalance>=TotalPrice then
                          select CustomerCheck into Before_CustomerCheck from Order_ 
                          where Order_ID=OrdeID and Order_CustomerID=CusTID;
                          
                          if Before_CustomerCheck ='Failure to fulfill the order' then
                                    update Order_ SET CustomerCheck='Execution of the order' 
                                    WHERE Order_ID=OrdeID and Order_CustomerID=CusTID;
                                    
                                    DBMS_OUTPUT.put_line('The order is being prepared');
                                    
                          elsif Before_CustomerCheck='Execution of the order' then
                          
                                    DBMS_OUTPUT.put_line('The order is being prepared');
                          end if;
                        
                        resulting:=  AvailableBalance-TotalPrice;
                        update Customer SET Customer_AvailableBalance=resulting where Customer.Customer_ID=CusTID;
                            
                    commit;
                                    
                else
                
                DBMS_OUTPUT.put_line('The available balance is insufficient');
                end if;
          
          
                DBMS_OUTPUT.put_line('');
                DBMS_OUTPUT.put_line('End : CustomerCheck_ExecutionOrder');
                DBMS_OUTPUT.put_line('');
         
          end CustomerCheck_ExecutionOrder;
        
        ------------------------------------------------------------------------
        procedure inser_FeedBack(
        FB_Rest in Customer_FeedBack.FeedBack_Restaurant%type,
        FB_Food in Customer_FeedBack.FeedBack_Food%type,
        FB_Chef in Customer_FeedBack.FeedBack_Chef%type,
        FB_Waiter in Customer_FeedBack.FeedBack_Waiter%type,
        FB_Note  in Customer_FeedBack.FeedBack_Note%type,
        CustomerID in Customer.Customer_ID%type,
        OrderID in Order_.Order_ID%type
        )
        IS
        
        BEGIN
        
        Insert into Customer_FeedBack(FeedBack_ID,FeedBack_Restaurant,FeedBack_Food,FeedBack_Chef,FeedBack_Waiter,FeedBack_Note,CustomerID,OrderID)
        values(FeedBackID_sequence.nextVal,FB_Rest,FB_Food,FB_Chef,FB_Waiter,FB_Note,CustomerID,OrderID);
        commit;
        DBMS_OUTPUT.put_line('Successfully evaluated');
        
        END inser_FeedBack;
        
        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        procedure GetAllCustomer
        as
        c_all sys_refcursor;
        begin
        open c_all for
        select * from Customer;
        dbms_sql.return_result(c_all);
        end GetAllCustomer;
        
        
        
        procedure CreateCustomer(CavailableBalance in number , CuserId in int,CvisaNumber in varchar)
        as
        begin
        insert into Customer (Customer_ID,Customer_AvailableBalance,Customer_UserID,Customer_VisaCardNumber) 
        values (CustomerID_sequence.nextVal,CavailableBalance,CuserId,CvisaNumber);
        commit;
        end CreateCustomer;
        
        
        procedure UpdateCustomer(Cid in int , CavailableBalance in number , CuserId in int , CvisaNumber in varchar)
        as
        begin
        update Customer 
        set 
        Customer_AvailableBalance = CavailableBalance ,
        Customer_UserID = CuserId,
        Customer_VisaCardNumber = CvisaNumber 
        where Customer_ID = Cid;
        commit;
        end UpdateCustomer;
        
        
        
        procedure DeleteCustomer(Cid in int)
        as 
        begin
        delete from Customer where Customer_ID = Cid;
        commit;
        end DeleteCustomer;
        

end P_Customert;



--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


create or replace package BoxMoney_Package
as
            procedure GetAllBoxMoney;
            procedure CreateBoxMoney(Bopentime in TIMESTAMP WITH LOCAL TIME ZONE, Bclosingtime TIMESTAMP WITH LOCAL TIME ZONE,Bresmanid in int);
            procedure UpdateBoxMoney(Boxid in int, Bopentime in TIMESTAMP WITH LOCAL TIME ZONE, Bclosingtime TIMESTAMP WITH LOCAL TIME ZONE,Bresmanid in int);
            procedure DeleteBoxMoney(Boxid in int);
end BoxMoney_Package;



create or replace package body BoxMoney_Package
as

                procedure GetAllBoxMoney
                as
                c_all SYS_REFCURSOR;
                begin
                open c_all for
                select * from BoxMoney;
                dbms_sql.return_result(c_all);
                end GetAllBoxMoney;
                
                
                procedure CreateBoxMoney(Bopentime in TIMESTAMP WITH LOCAL TIME ZONE, Bclosingtime TIMESTAMP WITH LOCAL TIME ZONE,Bresmanid in int)
                as
                begin
                insert into BoxMoney (BoxMoney_ID,OpeningTime,ClosingTime,ResManID) 
                values (BoxMoneyID_sequence.nextVal,Bopentime,Bclosingtime,Bresmanid);
                commit;
                end CreateBoxMoney;
                
                
                procedure UpdateBoxMoney(Boxid in int, Bopentime in TIMESTAMP WITH LOCAL TIME ZONE, Bclosingtime TIMESTAMP WITH LOCAL TIME ZONE,Bresmanid in int)
                as
                begin
                update BoxMoney set OpeningTime = Bopentime ,ClosingTime = Bclosingtime , ResManID = Bresmanid
                where BoxMoney_ID = Boxid;
                commit;
                end UpdateBoxMoney;
                
                
                procedure DeleteBoxMoney(Boxid in int)
                as
                begin
                delete from BoxMoney where BoxMoney_ID = Boxid;
                commit;
                end DeleteBoxMoney;
                
                
end BoxMoney_Package;




--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


create or replace Package Category_Package as
                procedure GetAllCategories;
                procedure CreateCategory(CcategoryName in varchar);
                procedure UpdateCategory(Cid in int , CcategoryName in varchar);
                procedure DeleteCategory(Cid in int);
end Category_Package;



create or replace Package body Category_Package as

                procedure GetAllCategories as
                c_all SYS_REFCURSOR;
                begin
                open c_all for
                select * from Categorey;
                DBMS_sql.return_result(c_all);
                end GetAllCategories; 
                
                procedure CreateCategory(CcategoryName in varchar) as
                begin
                insert into Categorey(Categorey_ID,Categorey_Name) values(CategoreyID_sequence.NextVal,CcategoryName);
                commit;
                end CreateCategory;
                
                procedure UpdateCategory(Cid in int,CcategoryName in varchar) as
                begin 
                update Categorey set Categorey_Name = CcategoryName where Categorey_ID = Cid;
                commit;
                end UpdateCategory;
                
                procedure DeleteCategory(Cid int) as
                begin
                delete from Categorey where Categorey_ID=Cid;
                commit;
                end DeleteCategory;
end Category_Package;



--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


create or replace Package Product_Package as
                procedure getAllProduct;
                procedure CreateProduct(Pname in varchar, Pprice in int , PcategoryId in int);
                procedure UpdateProduct(Pid in int , Pname in varchar, Pprice in int , PcategoryId in int);
                procedure DeleteProduct(Pid in int);
end Product_Package;


create or replace Package body Product_Package as

                    procedure GetAllProduct as
                    c_all SYS_REFCURSOR;
                    begin
                    open c_all for
                    select * from Product;
                    DBMS_sql.return_result(c_all);
                    end GetAllProduct; 
                    
                    procedure CreateProduct(Pname in varchar, Pprice in int , PcategoryId in int) as
                    begin
                    insert into Product(product_ID,product_name,product_price,product_Categorey_ID)
                    values(productID_sequence.nextVal,Pname,Pprice,PcategoryId);
                    commit;
                    end CreateProduct;
                    
                    procedure UpdateProduct(Pid in int , Pname in varchar, Pprice in int , PcategoryId in int) as
                    begin 
                    update Product set product_ID = Pid ,product_name = Pname,product_price = Pprice , product_Categorey_ID = PcategoryId
                    where product_ID = Pid;
                    commit;
                    
                    end UpdateProduct;
                     
                    procedure  DeleteProduct(Pid in int) as
                    begin
                    delete from Product where product_ID=Pid;
                    commit;
                    end DeleteProduct;

end Product_Package;


--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################

create or replace package Oder_Package as
                    procedure GetAllOders;
                    procedure CreateOder(Odata in TIMESTAMP WITH LOCAL TIME ZONE ,Otype in varchar , OcutstomerId in int ,OchefId in int ,BoxMID in int);
                    procedure UpdateOrder(
                    OoderId in int ,
                    Odata in TIMESTAMP WITH LOCAL TIME ZONE ,
                    Otype in varchar , 
                    OcustomerCheck in varchar ,
                    OchefCheck in varchar ,
                    Ochef_Waiter_Stateorder in varchar ,
                    OcutstomerId in int ,
                    OchefId in int,
                    OgiveOrderToCustomer in varchar,
                    BoxMID in int
                    );
                    procedure DeleteOrder(OoderId in int);
end Oder_Package;



create or replace package body Oder_Package as
                    procedure GetAllOders
                    as
                    c_all SYS_REFCURSOR;
                    begin
                    open c_all for
                    select * from Order_ ;
                    dbms_sql.return_result(c_all);
                    end GetAllOders;
                    
                 

                    procedure CreateOder(Odata in TIMESTAMP WITH LOCAL TIME ZONE ,Otype in varchar , OcutstomerId in int ,OchefId in int ,BoxMID in int)
                    as
                    begin
                    insert into Order_ (Order_ID,Order_Data ,Order_Type,Order_CustomerID,Order_ChefID,BoxMoneyID)
                    values (OrderID_sequence.nextVal,Odata,Otype,OcutstomerId,OchefId,BoxMID);
                    commit;
                    end CreateOder;
                    
                
                    
                    procedure UpdateOrder(
                    OoderId in int ,
                    Odata in TIMESTAMP WITH LOCAL TIME ZONE ,
                    Otype in varchar , 
                    OcustomerCheck in varchar ,
                    OchefCheck in varchar ,
                    Ochef_Waiter_Stateorder in varchar ,
                    OcutstomerId in int ,
                    OchefId in int,
                    OgiveOrderToCustomer in varchar,
                    BoxMID in int
                    )
                    as
                    begin
                    update Order_
                    set
                    Order_Data =Odata,
                    Order_Type = Otype,
                    CustomerCheck= OcustomerCheck,
                    ChefCheck = OchefCheck,
                    Waiter_Chef_StateOrder =Ochef_Waiter_Stateorder,
                    Order_CustomerID=OcutstomerId,
                    Order_ChefID =OchefId,
                    GiveOrderToCustomer=OgiveOrderToCustomer,
                    BoxMoneyID=BoxMID
                    where Order_ID = OoderId;
                    commit;
                    end UpdateOrder;
                    

                    
                    procedure DeleteOrder(OoderId in int)
                    as
                    begin
                    delete from Order_ where Order_ID = OoderId;
                    commit;
                    end DeleteOrder;
end Oder_Package;


--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


create or replace package OrderDetail_Package
as
        procedure GetAllOrderDetail;
        procedure CreateOrderDetail(OorderId in int ,OproductId in int ,OproductAmount in int);
        procedure UpdateOrderDetail(OrdDetID in int,OorderId in int ,OproductId in int ,OproductAmount in int);
        procedure DeleteOrderDetail(OrdDetID in int);
end OrderDetail_Package;



create or replace package body OrderDetail_Package
as
            procedure GetAllOrderDetail
            as
            c_all SYS_REFCURSOR;
            begin
            open c_all for
            select * from OrderDetail;
            dbms_sql.return_result(c_all);
            end GetAllOrderDetail;
            
            
            procedure CreateOrderDetail(OorderId in int ,OproductId in int ,OproductAmount in int)
            as
            begin
            insert into OrderDetail (OrderDetail_ID,OrderDetail_OrderID,OrderDetail_productID,OrderDetail_productAmount ) 
            values (OrderDetail_sequence.nextVal,OorderId,OproductId,OproductAmount);
            commit;
            end CreateOrderDetail;
            
            
            procedure UpdateOrderDetail(OrdDetID in int,OorderId in int ,OproductId in int ,OproductAmount in int)
            as
            begin
            update OrderDetail set OrderDetail_OrderID =OorderId , OrderDetail_productID=OproductId ,OrderDetail_productAmount=OproductAmount
            where OrderDetail_ID = OrdDetID;
            commit;
            end UpdateOrderDetail;
            
            
            procedure DeleteOrderDetail(OrdDetID in int)
            as
            begin
            delete from OrderDetail where OrderDetail_ID = OrdDetID;
            commit;
            end DeleteOrderDetail;
            
            
end OrderDetail_Package;


--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


create or replace package P_CustomerFeedBack as
        procedure CreateCustomerFeedBack(
        feedBackRestaurant in varchar2,
        feedBackFood in varchar2,
        feedBackChef in varchar2,
        feedBackWaiter in varchar2,
        feedBackNote in varchar2,
        custID in int,
        ordID in int
        );
        
        procedure UdateCustomerFeedBack(
        feedBackID in int,
        feedBackRestaurant in varchar2,
        feedBackFood in varchar2,
        feedBackChef in varchar2,
        feedBackWaiter in varchar2,
        feedBackNote in varchar2,
        custID in int,
        ordID in int
        );
        
        procedure DeleteCustomerFeedBack(feedBackID in int);
        
        procedure GetAllCustomerFeedBack;
        
end P_CustomerFeedBack;


create or replace package body P_CustomerFeedBack as
                procedure CreateCustomerFeedBack(
                            feedBackRestaurant in varchar2,
                            feedBackFood in varchar2,
                            feedBackChef in varchar2,
                            feedBackWaiter in varchar2,
                            feedBackNote in varchar2,
                            custID in int,
                            ordID in int
                            )
                as
                begin
                            Insert into Customer_FeedBack(FeedBack_ID,FeedBack_Restaurant,FeedBack_Food,FeedBack_Chef,FeedBack_Waiter,FeedBack_Note,CustomerID,OrderID)
                            values(FeedBackID_sequence.nextVal,feedBackRestaurant,feedBackFood,feedBackChef,feedBackWaiter,feedBackNote,custID,ordID);
                commit;
                end CreateCustomerFeedBack;
                
                procedure UdateCustomerFeedBack(
                        feedBackID in int,
                        feedBackRestaurant in varchar2,
                        feedBackFood in varchar2,
                        feedBackChef in varchar2,
                        feedBackWaiter in varchar2,
                        feedBackNote in varchar2,
                        custID in int,
                        ordID in int
                        )
                as
                begin
                update Customer_FeedBack 
                 set 
                FeedBack_Restaurant=feedBackRestaurant,
                FeedBack_Food=feedBackFood,
                FeedBack_Chef=feedBackChef,
                FeedBack_Waiter=feedBackWaiter,
                FeedBack_Note=feedBackNote,
                CustomerID=custID,
                OrderID=ordID
                where FeedBack_ID=feedBackID;
                
                commit;
                end UdateCustomerFeedBack;

                procedure DeleteCustomerFeedBack(feedBackID in int) as
                begin
                delete from Customer_FeedBack where FeedBack_ID=feedBackID;
                commit;
                end DeleteCustomerFeedBack;
                
                
                
                procedure GetAllCustomerFeedBack as
                c_all SYS_REFCURSOR;
                begin
                open c_all for
                select * from Customer_FeedBack;
                DBMS_sql.return_result(c_all);
                end GetAllCustomerFeedBack;


end P_CustomerFeedBack;



--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


create or replace package Table_Package as

        PROCEDURE GetAllTables;
        procedure CreateTables(Tcode in varchar , Tstatus in varchar);
        procedure UpdateTables(Tid in int ,Tcode in varchar , Tstatus in varchar);
        procedure DeleteTables(Tid in int);
        
end Table_Package;

create or replace package body Table_Package as

            PROCEDURE GetAllTables as 
            c_all SYS_REFCURSOR;
            begin
            open c_all for
            select * from Table_;
            DBMS_sql.return_result(c_all);
            end GetAllTables;
            
            procedure CreateTables(Tcode in varchar , Tstatus in varchar)
            as
            begin 
            insert into Table_
            (table_ID,table_Code,table_Status)
            values(tableID_sequence.nextVal,Tcode,Tstatus);
            commit;
            end CreateTables;
            
            procedure UpdateTables(Tid in int ,Tcode in varchar , Tstatus in varchar) as
            begin 
            Update Table_ set table_Code = Tcode , table_Status =Tstatus where table_ID = Tid;
            commit;
            end UpdateTables;
            
            procedure DeleteTables(Tid in int) as
            begin 
            delete from Table_ where table_ID = Tid;
            
            end DeleteTables;

end Table_Package;



--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################


Create or replace package  P_Reservation as
         procedure  InquiriesAboutReservations(tabID in table_.table_ID%type, bookDate in reservation.bookingDate%type); 
         procedure CreateReservation(
         tabID in table_.table_ID%type,
         CustID in Customer.Customer_ID%type,
         booSession in reservation.bookingSession%type,
         bookDate in reservation.bookingDate%type
         );
         procedure UpdateTableStatus_NotAvailable(tabID in table_.table_ID%type);
         procedure UpdateTableStatus_Available(tabID in table_.table_ID%type);
        
        
        procedure GetAllReservation;
        procedure DeleteReservation(bookID in int);
end  P_Reservation;


Create or replace package body  P_Reservation as
    
          procedure   InquiriesAboutReservations(tabID in table_.table_ID%type, bookDate in reservation.bookingDate%type)
          is
                  
                        BSession  Varchar(35);
                        QueryResult INT;
          begin
                        FOR i in 1..16 
                        LOOP 
                        
                        if i = 1 then BSession:='8:00 AM'; end if;
                        if i = 2 then BSession:='9:00 AM'; end if;
                        if i = 3 then BSession:='10:00 AM'; end if;
                        if i = 4 then BSession:='11:00 AM'; end if;
                        if i = 5 then BSession:='12:00 PM'; end if;
                        if i = 6 then BSession:='1:00 PM'; end if;
                        if i = 7 then BSession:='2:00 PM'; end if;
                        if i = 8 then BSession:='3:00 PM'; end if;
                        if i = 9 then BSession:='4:00 PM'; end if;
                        if i = 10 then BSession:='5:00 PM'; end if;
                        if i = 11 then BSession:='6:00 PM'; end if;
                        if i = 12 then BSession:='7:00 PM'; end if;
                        if i = 13 then BSession:='8:00 PM'; end if;
                        if i = 14 then BSession:='9:00 PM'; end if;
                        if i = 15 then BSession:='10:00 PM'; end if;
                        if i = 16 then BSession:='11:00 PM'; end if;
                        
                         SELECT COUNT(*)
                         into QueryResult
                         FROM table_ 
                         WHERE table_ID=tabID AND table_Status='Available' AND table_ID NOT IN 
                         (SELECT tableID FROM reservation WHERE trunc(bookingDate)=trunc(bookDate) AND bookingSession=BSession) 
                         FETCH NEXT 1 ROWS ONLY;
                        
                        
                        if QueryResult !=0 then
                        
                        DBMS_OUTPUT.put_line('Table ID : '|| tabID ||' ~~~~ ' || 'Booking Date : ' || bookDate ||' ~~~~ ' || 'Booking Session : ' || BSession);
                        
                        DBMS_OUTPUT.put_line('____________________________________________________________________');
                       
                        end if;
                        
                        
                        
                        
                        END LOOP; 
          
          end InquiriesAboutReservations;
          ----------------------------------------------------------------------
          procedure CreateReservation(
                                         tabID in table_.table_ID%type,
                                         CustID in Customer.Customer_ID%type,
                                         booSession in reservation.bookingSession%type,
                                         bookDate in reservation.bookingDate%type
                                         )
         is
         
         begin
                  insert into reservation(Booked_ID,bookingSession,bookingDate,tableID,CustomerID)
                  values(reservationID_sequence.nextVal,booSession,bookDate,tabID,CustID);
                  commit;
         end CreateReservation;
        -------------------------------------------------------------------------
        procedure UpdateTableStatus_NotAvailable(tabID in table_.table_ID%type)
        IS
        
        BEGIN
                    Update  table_ Set table_Status='Not available' where table_ID=tabID;
                   commit;
        END UpdateTableStatus_NotAvailable;
        -------------------------------------------------------------------------        
        procedure UpdateTableStatus_Available(tabID in table_.table_ID%type)
        IS
        
        BEGIN
                    Update  table_ Set table_Status='Available' where table_ID=tabID;
                    commit;
        END UpdateTableStatus_Available;
         
         
         -----------------------------------------------------------------------
         -----------------------------------------------------------------------
        procedure GetAllReservation
        as
        c_all sys_refcursor;
        begin
        open c_all for
        select * from reservation;
        dbms_sql.return_result(c_all);
        end GetAllReservation;
         
         
        procedure DeleteReservation(bookID in int)
        as
        begin
        delete from reservation where Booked_ID = bookID;
        commit;
        end DeleteReservation;  
        
        
        
end P_Reservation;



--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################

create or replace package InfoResturant_Package as
            procedure GetAllInfoResturant;
            procedure CreateInfoResturant
            (Rdate in date , Rnumberoftable in int,Ropentime in TIMESTAMP WITH LOCAL TIME ZONE ,Rclosetime in TIMESTAMP WITH LOCAL TIME ZONE , Rnumberofemployee in int,RtotalSalary in number,RMangId in int);
            procedure UpdateInfoResturant
            (Rid in int, Rdate in date , Rnumberoftable in int,Ropentime in TIMESTAMP WITH LOCAL TIME ZONE ,Rclosetime in  TIMESTAMP WITH LOCAL TIME ZONE , Rnumberofemployee in int,RtotalSalary in number,RMangId in int);
            procedure DeleteInfoResturant(Rid in int);
end InfoResturant_Package;

create or replace package body InfoResturant_Package as
            procedure GetAllInfoResturant as
            c_all SYS_REFCURSOR;
            begin
            open c_all for
            select * from InfoAboutRestaurant;
            DBMS_sql.return_result(c_all);
            end GetAllInfoResturant;
            
            procedure CreateInfoResturant
            (Rdate in date , Rnumberoftable in int,Ropentime in TIMESTAMP WITH LOCAL TIME ZONE ,Rclosetime in  TIMESTAMP WITH LOCAL TIME ZONE , Rnumberofemployee in int,RtotalSalary in number ,RMangId in int)
            as
            begin 
            insert into InfoAboutRestaurant (Info_ID,DateOfEstablishment,NumberOfTables,OpeningTime,ClosingTime,NumberOfEmployees,TotalSalary,ResMangId)
            values (InfoID_sequence.nextVal,Rdate,Rnumberoftable,Ropentime,Rclosetime,Rnumberofemployee,RtotalSalary,RMangId);
            commit;
            end CreateInfoResturant;
            
            procedure UpdateInfoResturant
            (Rid in int, Rdate in date , Rnumberoftable in int,Ropentime in TIMESTAMP WITH LOCAL TIME ZONE ,Rclosetime in  TIMESTAMP WITH LOCAL TIME ZONE , Rnumberofemployee in int,RtotalSalary in number,RMangId in int)
            as
            begin 
            Update InfoAboutRestaurant
            set 
            DateOfEstablishment = Rdate ,
            NumberOfTables = Rnumberoftable ,
            OpeningTime = Ropentime ,
            ClosingTime = Rclosetime ,
            NumberOfEmployees = Rnumberofemployee ,
            TotalSalary = RtotalSalary,
            ResMangId=RMangId
            where Info_ID = Rid;
            commit;
            end UpdateInfoResturant;
            
            procedure DeleteInfoResturant(Rid in int) as
            begin 
            delete from InfoAboutRestaurant where Info_ID = Rid;
            end DeleteInfoResturant;

end InfoResturant_Package;




--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################

create or replace package P_login as
        procedure CreateLoginInfo_LoginVerification(email in varchar2,pass in Varchar2);
        procedure UdateLoginInfo(logid in int,email in varchar2,pass in Varchar2);
        procedure DeleteLoginInfo(logid in int);
        procedure GetLoginInfo;
end P_login;


create or replace package body P_login as
            procedure CreateLoginInfo_LoginVerification(email in varchar2,pass in Varchar2)
            as
            LoginVerifica int;
            nextLoginID int;
            
            Uname varchar(35);
            Utype varchar(35);
            begin
            select count(*) into LoginVerifica from User_ where User_Email=email And User_Pass=pass;
            if LoginVerifica = 1 then
            
                    nextLoginID:=LoginID_sequence.nextVal;
                    
                    insert into login(Login_ID,Login_Email,Login_Pass)
                    values(nextLoginID,email,pass);
                    
                    Update User_ set User_LoginID=nextLoginID where User_Email=email And User_Pass=pass;
                    
                    select User_Name,User_Type into Uname,Utype from User_ where User_Email=email And User_Pass=pass And User_LoginID=nextLoginID;
                    DBMS_OUTPUT.put_line('User Type : ' ||Utype || ' ~~~~ ' ||'User Name : '||Uname);
                    DBMS_OUTPUT.put_line('User Email : ' ||email || ' ~~~~ ' ||'User Pass : '||pass);
                    
                    commit;
            else
                    DBMS_OUTPUT.put_line('Wrong login information');
            end if;
            
            end CreateLoginInfo_LoginVerification;
            
            procedure UdateLoginInfo(logid in int,email in varchar2,pass in Varchar2) as
            begin
            update login set Login_Email=email,Login_Pass=pass where Login_ID=logid;
            commit;
            end UdateLoginInfo;
            
            procedure DeleteLoginInfo(logid in int) as
            begin
            delete from login where Login_ID=logid;
            commit;
            end DeleteLoginInfo;
            
            procedure GetLoginInfo as
            c_all SYS_REFCURSOR;
            begin
            open c_all for
            select * from login ;
            DBMS_sql.return_result(c_all);
            end GetLoginInfo;

end P_login;



--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################



create or replace package Stored_Package as
                procedure GetAllStored;
                procedure CreateStored(Sname in varchar , Sexpiredate in date , SamounrOfitemAvailable in varchar , Snotes in varchar,StResMangId in int,StSupplierID in int);
                procedure UpdateStore(StoredId in int,Sname in varchar , Sexpiredate in date , SamounrOfitemAvailable in varchar , Snotes in varchar,StResMangId in int,StSupplierID in int);
                procedure DeleteStored(StoredId in int);

end Stored_Package;


create or replace package body Stored_Package as


            procedure GetAllStored 
            as
            c_all SYS_REFCURSOR;
            begin
            open c_all for
            select * from Stored_;
            dbms_sql.return_result(c_all);
            end GetAllStored;
            
            
            procedure CreateStored(Sname in varchar , Sexpiredate in date , SamounrOfitemAvailable in varchar , Snotes in varchar,StResMangId in int,StSupplierID in int)
            as
            begin
            insert into Stored_ (Item_ID,Item_Name,ItemExpirationDate,AmountOfItemAvailable,Notes_ComponentAboutTheItem ,Stored_ResMangId,Stored_SupplierID )
            values (storedID_sequence.nextVal,Sname ,Sexpiredate,SamounrOfitemAvailable,Snotes,StResMangId,StSupplierID);
            commit;
            end CreateStored;
            
            
            procedure UpdateStore(StoredId in int,Sname in varchar , Sexpiredate in date , SamounrOfitemAvailable in varchar , Snotes in varchar,StResMangId in int,StSupplierID in int)
            as
            begin
            update Stored_ 
            set 
            ItemExpirationDate = Sexpiredate ,
            AmountOfItemAvailable = SamounrOfitemAvailable,
            Notes_ComponentAboutTheItem = Snotes,
            Stored_ResMangId=StResMangId,
            Stored_SupplierID=StSupplierID
            where Item_ID = StoredId;
            commit;
            end UpdateStore;
            
            
            procedure DeleteStored(StoredId in int)
            as
            begin
            delete from Stored_ where Item_ID = StoredId;
            commit;
            end DeleteStored;

end Stored_Package;



--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################
--##############################################################################

Commit;