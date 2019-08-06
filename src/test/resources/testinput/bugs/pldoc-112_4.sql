CREATE OR REPLACE TYPE BODY pldoc_bug.myType
AS
/**Verify parsing support for UPCAST/DOWNCAST expressions such as 
*<pre>
*<code>
*(SELF AS myParentType)
*</code>
*</pre>
*@headcom
*/

-- This procedure is supposed to be located in an object type that has a parent called myParentType
OVERRIDING MEMBER PROCEDURE someProcedure IS
  meAsParent myParentType;
BEGIN
  (SELF AS myParentType).someProcedure();
  meAsParent := (SELF AS myParentType);
END;

END myType;
/

