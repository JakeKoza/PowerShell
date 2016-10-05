# Performs an ExecuteNonQuery command against the database connection.
function ExecNonQuery{
        param ($cmdText)
        write-Host "Creating SQL Connection..."
        # Instantiate new SqlConnection object.
        $Connection = New-Object System.Data.SQLClient.SQLConnection
        
        # Set the SqlConnection object's connection string to the passed value.
        $Connection.ConnectionString = "server=.\SQLEXPRESS;database=QuillixProd;trusted_connection=true;"
        
        # Perform database operations in try-catch-finally block since database operations often fail.
        try
        {
            write-Host "Opening SQL Connection..."
            
            $Connection.Open()
            
            write-Host "Creating SQL Command..."
            
            $Command = New-Object System.Data.SQLClient.SQLCommand
            $Command.Connection = $Connection
            $Command.CommandText = $cmdText
            
            write-Host "Executing SQL Command..."

            # Execute the command against the database without returning results (NonQuery).
            $Command.ExecuteNonQuery()
        }
        catch [System.Data.SqlClient.SqlException]
        {
            # A SqlException occurred. 
            write-Host "Unable to complete query. Please check your query and data then try again."
        }
        catch
        {
            # An generic error occurred somewhere in the try area.
            write-Host "An error occurred while attempting to open the database connection and execute a command."
        }
        finally {
            # Determine if the connection was opened.
            if ($Connection.State -eq "Open")
            {
                write-Host "Closing Connection..."
                # Close the currently open connection.
                $Connection.Close()
            }
        }
}

function ExecQuery{
    param ($cmdText)
    write-Host "Creating SQL Connection..."
    # Instantiate new SqlConnection object.
    $Connection = New-Object System.Data.SQLClient.SQLConnection
        
    # Set the SqlConnection object's connection string to the passed value.
    $Connection.ConnectionString = "server=.\SQLEXPRESS;database=QuillixProd;trusted_connection=true;"

    try
        {
            write-Host "Opening SQL Connection..."
            
            $Connection.Open()
            $cmd=new-object system.Data.SqlClient.SqlCommand($Query,$conn)
            $cmd.CommandTimeout=$QueryTimeout
            $ds=New-Object system.Data.DataSet
            $da=New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
            [void]$da.fill($ds)
            $dbItem = $ds.Tables.Name
            foreach($item in $dbItem){
                Remove-Item -Path $procStore\$item -Recurse
            }
           
        }
        catch [System.Data.SqlClient.SqlException]
        {
            # A SqlException occurred.
            write-Host "Unable to complete query. Please check your query and data then try again."
        }
        catch
        {
            # An generic error occurred somewhere in the try area.
            write-Host "An error occurred while attempting to open the database connection and execute a command."
        }
        finally {
            # Determine if the connection was opened.
            if ($Connection.State -eq "Open")
            {
                write-Host "Closing Connection..."
                # Close the currently open connection.
                $Connection.Close()
            }
        }
}

$procStore = 'C:\Users\n00974115\Documents\Quillix Testing\processdatastore'
Get-ChildItem $procStore | Select Name | ConvertTo-Csv -NoTypeInformation | % {$_.Replace('"','')} | Out-File C:\temp\files.csv

# Execute SQL Command Against Database.
ExecNonQuery -cmdText "create table Files$ (Name nvarchar(255))

bulk insert Files$ from 'C:\temp\files.csv' with
(firstrow = 2, fieldterminator = ',', rowterminator = '\n', tablock)"

ExecQuery -cmdText "select name from Files$ left join Q_CASEITEMS on name = ITEMID where ITEMID is null"

ExecNonQuery -cmdText "delete from Q_CASEITEMS where itemid in ( select itemid
from Files$ right join Q_CASEITEMS on name = ITEMID where name is null)"

ExecNonQuery -cmdText "delete from Q_CASES
where caseid in (select caseid
from Files$ right join Q_CASEITEMS on name = ITEMID where name is null)"

ExecNonQuery -cmdText "delete from Q_QUEUE
where caseid in (select caseid
from Files$ right join Q_CASEITEMS on name = ITEMID where name is null)"

ExecNonQuery -cmdText "delete from QM_BATCHES
where caseid in (select caseid
from Files$ right join Q_CASEITEMS on name = ITEMID where name is null)"

ExecNonQuery -cmdText "drop table Files$"

write-Host "Querys Complete!"