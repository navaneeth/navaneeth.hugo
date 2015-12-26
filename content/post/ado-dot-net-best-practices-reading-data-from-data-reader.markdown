+++
categories = ["programming", ".net", "c#"]
date = "2009-07-11T12:59:50+05:30"
description = ""
keywords = []
title = "ADO.NET best practices – Reading data from data reader"
+++

I have seen many people using DataReader incorrectly. In this post, I will try to explain some good practices that can be followed when reading from a data reader. Consider the following problematic code,

```csharp
SqlDataReader reader = /* ... */;
while (reader.Read())
{
    string userName = reader["user_name"].ToString();
    int age = int.Parse( reader["age"].ToString() );
    /* ... */
}
reader.Close();
```

How many problems can you figure out from the above code? There are many problems with this code,

* The columns “user_name” and “age” may or may not exist. If the column does not exist in the reader, it will throw error.
* You may be calling `ToString()` on an object which may be pointing to `NULL`. This will lead to a null reference exception.
* `SqlDataReader` implements `IDisposable` and user code has to call `Dispose()` each time to release the resources deterministically. This is not happening here.
* `reader["age"]` may contain values that are not compatible with integer. In such case, `int.Parse()` will throw a `FormatException`.

Following sections will show a safe method to read data from DataReader.

Understanding ordinals
----------------------
Ordinal is the index of a column in the reader. `GetOrdinal()` method will give you the ordinal for the column name supplied. So the first step in reading data from reader should be to find the ordinal of the columns which we want to read. Before getting the ordinal values, you have to ensure that the reader can read. SqlDataReader provides a HasRows property which can be useful here. Here is how you read the ordinals

```csharp
SqlDataReader reader = /* ... */;
int userNameOrdinal;
int ageOrdinal;
if (reader.HasRows)
{
     try
     {
           userNameOrdinal = reader.GetOrdinal("user_name");
     }
     catch (IndexOutOfRangeException)
     {
           throw new YourCustomException("Expected column 'user_name' not found");
     }
     try
     {
           ageOrdinal = reader.GetOrdinal("age");
     }
     catch (IndexOutOfRangeException)
     {
           throw new YourCustomException("Expected column 'age' not found");
     }
}
```

If you have support to “Extension methods”, this code can be simplified further.

```csharp
public static class SqlDataReaderExtensions
{
    public static int GetOrdinalOrThrow(this SqlDataReader reader, string columnName)
    {
        try
        {
            return reader.GetOrdinal(columnName);
        }
        catch (IndexOutOfRangeException)
        {
            throw new YourCustomException(string.Format("Expected column '{0}' not found",columnName));
        }
    }
}

SqlDataReader reader = /* ... */;
int userNameOrdinal;
int ageOrdinal;
if (reader.HasRows)
{
      userNameOrdinal = reader.GetOrdinalOrThrow("user_name");
      ageOrdinal = reader.GetOrdinalOrThrow("age");
}
```

This makes the code more clean. However, I really wish to see a `TryGetOrdinal()` method on `IDataReader` so that we can save the cost of exception handling.

GetOrdinal() method first does a case-sensitive lookup for the column name. If it fails, case-insensitive search is performed. Thus, using the column name in correct case with GetOrdinal() will be more efficient.

Respecting type safety
----------------------

C# is a strongly typed language and each programmer should take full advantage of this. Reading data like, `reader["user_name"]` is not a type safe way as it returns a object. Data reader provides methods to read data in a type safe way.

Here is what MSDN says about it

>     When accessing column data use the typed accessors like GetString, GetInt32, and so on. This saves you the processing required to cast the Object returned from GetValue as a particular type.

Now let us follow the above suggestion and rewrite our code like,

```csharp
while (reader.Read())
{
   string userName = reader.GetString(userNameOrdinal);
   int age = -1;
   try
   {
         age = reader.GetInt32(ageOrdinal);
   }
   catch (InvalidCastException)
   {
         throw new YourCustomException("Unable to read age. Expecting integer value");
   }
   /* ... */
}
```

Releasing resources
--------------------

If any type implements IDisposable, it is like saying “I have something to release explicitly rather than garbage collector to release it“. So it is programmers duty to ensure the calls to Dispose() when using disposable types. C# has “using” statement (stack semantics can be used in C++/CLI) which will ensure calls to Dispose(). Since DataReader is a disposable object, we can write like

```csharp
using(SqlDataReader reader = command.ExecuteReader())
{
      while (reader.Read())
      {
          string userName = reader.GetString(userNameOrdinal);
          int age = -1;
          try
          {
              age = reader.GetInt32(ageOrdinal);
          }
          catch (InvalidCastException)
          {
              throw new YourCustomException("Unable to read age. Expecting integer value");
          }
          /* ... */
      }
}
```

This ensures that the reader is disposed properly even in exceptional situations.

Putting everything together
---------------------------
If you put everything together, code will be like

```csharp
public static class SqlDataReaderExtensions
{
    public static int GetOrdinalOrThrow(this SqlDataReader reader, string columnName)
    {
        try
        {
            return reader.GetOrdinal(columnName);
        }
        catch (IndexOutOfRangeException)
        {
            throw new YourCustomException(string.Format("Expected column '{0}' not found",columnName));
        }
    }
}

int userNameOrdinal = -1;
int ageOrdinal = -1;
if (reader.HasRows)
{
    userNameOrdinal = reader.GetOrdinalOrThrow("user_name");
    ageOrdinal = reader.GetOrdinalOrThrow("age");
}
using (SqlDataReader reader = GetReader())
{
    while (reader.Read())
    {
        string userName = reader.GetString(userNameOrdinal);
        int age = -1;
        try
        {
            age = reader.GetInt32(ageOrdinal);
        }
        catch (InvalidCastException)
        {
            throw new YourCustomException("Unable to read age. Expecting integer value");
        }
        /* ... */
    }
}
```

We have got clean code now. It handles the exceptions and throws informative exceptions to the caller rather than throwing Boneheaded exceptions, we have avoided explicit casting and DataReader is disposed properly.

These are applicable for all types which implements `IDataReader`. `SqlDataReader` is used in this post just for explanation.

Happy programming!
