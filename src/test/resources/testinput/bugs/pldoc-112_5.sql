CREATE OR REPLACE PROCEDURE pldoc_bug.bug_112_5
/**Verify parsing support for Object Type tests , such as 
*<pre>
*<code>
* IF  a IS [ NOT ] OF TYPE (type-name) THEN ...
*</code>
*</pre>
*@headcom
*/
AS
  myObj myType := myType();
  isNotOf BOOLEAN;
BEGIN
  IF myObj IS OF TYPE (myType) THEN
    dbms_output.put_line("OK");
  END IF;

  isNotOf := myObj IS NOT OF (myType);
END;
/

