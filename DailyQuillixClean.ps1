function ExecNonQuery{
        param ($cmdText)
        # Instantiate new SqlConnection object.
        $Connection = New-Object System.Data.SQLClient.SQLConnection
        
        # Set the SqlConnection object's connection string to the passed value.
        $Connection.ConnectionString = "server=.\SQLEXPRESS;database=QuillixProd;trusted_connection=true;"
        
        # Perform database operations in try-catch-finally block since database operations often fail.
        try
        {
            $Connection.Open()
            
            $Command = New-Object System.Data.SQLClient.SQLCommand
            $Command.Connection = $Connection
            $Command.CommandText = $cmdText

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
                # Close the currently open connection.
                $Connection.Close()
            }
        }
}


ExecNonQuery -cmdText "delete from Q_CASEITEMS where caseid in (select CASEID from q_cases where CREATED < DATEADD(month, -3, GETDATE()))"
ExecNonQuery -cmdText "delete from Q_QUEUE where caseid in (select CASEID from q_cases where CREATED < DATEADD(month, -3, GETDATE()))"
ExecNonQuery -cmdText "delete from QM_BATCHES where caseid in (select CASEID from q_cases where CREATED < DATEADD(month, -3, GETDATE()))"
ExecNonQuery -cmdText "delete from q_cases where CREATED < DATEADD(month, -3, GETDATE())"
