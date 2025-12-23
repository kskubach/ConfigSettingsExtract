Class Test.Properties [ Abstract ]
{

ClassMethod GetData(filename As %String(MAXLEN=200)) As %Status
{
  set result=""
  set startNS=$NAMESPACE

  set file=##class(%Stream.FileCharacter).%New()
  set tStatus= file.LinkToFile(filename)
  If 'tStatus {
	write "Error:"_$system.Status.GetErrorText(tStatus),!
	Quit tStatus
  }

  do file.WriteLine("Namespace,Category,Item Name,Class Name,Property Name,Value")
  set rs=##class(%ResultSet).%New("%DynamicQuery:SQL")
  set tStatus=rs.Prepare("SELECT ID,ClassName,Category,Name FROM Ens_Config.Item order by category")
  if $$$ISERR(tStatus) {
	write "Error preparing query: ",$system.Status.GetErrorText(tStatus),!
	quit tStatus
  }
  ; Call the ListAll method, passing 'result' by reference to store the output.
  DO ##class(%SYS.Namespace).ListAll(.result)
  
  WRITE "Available Namespaces:", !
  
  ; Use $ORDER to iterate through the keys (namespace names) in the 'result' array.
  SET ns="" 
  SET ns=$ORDER(result(ns))
  FOR  {
  	if ns="" quit
   	ZN ns
    WRITE "  > Currently in $NAMESPACE: ", $NAMESPACE, !

	set tStatus=rs.Execute()
	set category="XXX"
	set tStatus= file.WriteLine($NAMESPACE)
	if $$$ISERR(tStatus) {
		write "Error executing query: ",$system.Status.GetErrorText(tStatus),!
		quit
	}	

	while rs.%Next() { 
		if category'=rs.Data("Category") {
			set category=rs.Data("Category")
		}

		set id =rs.Data("ID")
		set class =rs.Data("ClassName")
		set name =rs.Data("Name")
		set item=##class(Ens.Config.Item).%OpenId(id)
		for i=1:1:item.Settings.Count() {
			// find direcories
			if ($find(item.Settings.GetAt(i).Value,":")>0)||($find(item.Settings.GetAt(i).Value,"/")>0)||($find(item.Settings.GetAt(i).Value,"\")>0) {
				set tStatus=file.WriteLine(","_category_","_name_","_class_","_item.Settings.GetAt(i).Name_","_item.Settings.GetAt(i).Value)
			}
		}
	}
    SET ns=$ORDER(result(ns))
  }
  set tStatus=file.%Save()	
  zn startNS
  WRITE "Returned to starting namespace: ", $NAMESPACE, !
  QUIT $$$OK
}

}
