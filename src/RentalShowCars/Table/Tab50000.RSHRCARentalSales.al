//збірна таблиця інформації щодо покупців та продавців
table 50000 "RSH RCA Rental Sales"
{
    Caption = 'Rental Order Cars';
    DataClassification = CustomerContent;


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = '№.';
            DataClassification = CustomerContent;
            // тригер валідації (перевірка) відсотрованих даних
            trigger OnValidate()
            var
                RetalSetup: Record "RSH Rental Car Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "No." <> xRec."No." then begin
                    TestNoSeries(RetalSetup);
                    NoSeriesMgt.TestManual(RetalSetup."Rental Nos.");
                end;
            end;
        }
        field(10; "Order number"; Code[10])
        {
            TableRelation = "RSH RCA Rental Order Car";
            Caption = 'Order number';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Saler_name"; Text[30])
        {
            Caption = 'Saler name';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(40; "Ordered_rental_period"; Duration)
        {
            Caption = 'Ordered rental period';
            DataClassification = CustomerContent;
        }
        field(50; "Car_code"; Code[20])
        {
            Caption = 'Car code';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Saler_name)
        {

        }
    }
    // вставка полів
    trigger OnInsert()
    begin
        InitInsert();
    end;

    trigger OnDelete()
    var
        ToDeleteSales: Report "RCA Rental Utils";
    begin
        ToDeleteSales.DeleteDetail(Rec."No.");
    end;

    local procedure InitInsert()
    var
        RentalSetup: Record "RSH Rental Car Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." <> '' then
            exit;

        TestNoSeries(RentalSetup);
        // NoSeriesMgt.InitSeries(RadioShowSetup."Radio Show Nos.", xRec."No. Series", 0D, "No.", "No. Series");
    end;

    local procedure TestNoSeries(var RadioShowSetup: Record "RSH Rental Car Setup")
    // var
    //     RadioShowNosErr: Label 'The field %1 should not be empty in Table %2!', Comment = '%1 = fieldCaption,%2 = TableCaption';
    begin
        if not RadioShowSetup.get() then begin
            RadioShowSetup.Insert();
            Commit();
        end;
        RadioShowSetup.TestField("Rental Nos.");
        IF true THEN;
        // if RadioShowSetup."Radio Show Nos    ." = '' then
        //     Error(RadioShowNosErr, RadioShowSetup.FieldCaption("Radio Show Nos."), RadioShowSetup.TableCaption());
    end;

    local procedure OnValidateItemNo()
    var
        Item: Record Item;
    begin
        // if Rec."Item No." = '' then
        //     Rec.Validate(Saler_name, '')
        // else begin
        //     Item.get(Rec."Item No.");
        //     CopyFromItem(Item);
        // end;
        // Rec.CalcFields("Item Description");
    end;

    local procedure CopyFromItem(Item: Record Item)
    begin
        Rec.Validate(Saler_name, Item.Description);
    end;

    local procedure SetDiscount()
    var
        Customer: Record Customer;
        Item: Record Item;
    begin
        // if Rec."Customer No." <> '' then
        //     Customer.get("Customer No.");

        // if Rec."Item No." <> '' then
        //     Item.get("Item No.");

        // Rec.Discount := Item."RSH Car Discount";

        // if Customer."RSH Car Discount" > Item."RSH Car Discount" then
        //     Rec.Discount := Customer."RSH Car Discount";
        // Rec.Validate(Discount);
    end;

    var
        testTxt: text;


    [IntegrationEvent(TRUE, TRUE)]
    local procedure MyProcedure()
    begin
    end;
}
