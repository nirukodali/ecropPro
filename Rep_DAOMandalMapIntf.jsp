<%-- 
    Document   : Rep_DAOMandalMapIntf
    Created on : 24 Apr, 2024, 4:26:42 PM
    Author     : HP
--%>
<%@page import="javax.management.relation.Role"%>
<%@page import="validations.Validations"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="util.MasterFunctions"%> 

<%


    String user = session.getAttribute("USER").toString();
    String role = session.getAttribute("ROLE").toString();
    String sesdcode = session.getAttribute("DCODE").toString();
   // String sesmcode = session.getAttribute("MCODE").toString();
    if (!(role.equals("9"))) {
        response.sendRedirect("logout.jsp");
    }

   // String homemenu = "";
    //homemenu = util.CommonMethods.getHomemenu(session.getAttribute("ROLE").toString());


%>
<%--<jsp:include page="<%= homemenu%>" flush="true" />--%>  

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <script src="js/jquery.js"></script>
        <script src="js/jquery-ui.js"></script>
        <script src="scripts/datetimepicker.js"></script>
        <link rel="stylesheet" href="styles/reportstylesheet.css">

        <script>
            function submitme()
            {
                document.forms[0].action = 'Rep_DAOMandalMapIntf.jsp';
                document.forms[0].submit();
            }
  
          
    
        </script>

       <script>
      function CallPrint(strid)
{
 var prtContent = document.getElementById(strid);
 var WinPrint = window.open('','','letf=0,top=0,width=900,height=600,toolbar=1,scrollbars=1,status=1');
 WinPrint.document.write(prtContent.innerHTML);
 WinPrint.document.close();
 WinPrint.focus();
 WinPrint.print();
 prtContent.innerHTML=strOldOne;
 WinPrint.close();
}
        </script>  
        <script language="javascript">             
            var tableToExcel = (function() {
            var uri = 'data:application/vnd.ms-excel;base64,'
                            , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table align="center">{table}</table></body></html>'
            , base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
               , format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
               return function(table, name) {
                   if (!table.nodeType) table = document.getElementById(table)
                   var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
                   window.location.href = uri + base64(format(template, ctx))
               }
            })()
        </script>
        
        <script>
           function back()

            {
            document.forms[0].action = 'JdaRibbon.jsp';
            document.forms[0].submit();
            }
        </script>

        
        
          <style type="text/css">
            table{
                border: 0px;
/*                border-collapse:separate;*/
                border-style: 0px;
                     
            }
            th{
                position:sticky;
                top: 0px;
                background-color:grey;
                color:white;
            }
/*            .table_wrapper{
                overflow-y: scroll;
                overflow-x: scroll;
            }*/
        </style>    
    </head>
    <body>
        <%
            Connection con = null;
            util.SqlDBUtil test = new util.SqlDBUtil();
            con = test.getConnection();

            PreparedStatement pst = null, pst1 = null, pst2 = null;
            ResultSet rs = null, rs1 = null, rs2 = null;
            int z = 1;
            String qry = "", mcode = "", distname = "";

            try {
        %>
        <form name="f1" >
<!--             <div onscroll='scroller("scrollme", "scroller")' style="overflow-x:scroll; height:300px" id=scrollme> -->
            <div align="center"   id="divPrint" >
            <table border="1" align="center" style="width:800px" id="absseasondistwise" >
                <tr>
                    <th colspan="8" align="center" class="heading">ADA Mapped Mandals</th>
                </tr>


                <%


                    boolean flag = false;
                   %>

              

                <tr>       
                    <th> <b> S.No. </b> </th>
                   
                    <th> <b>District </b> </th>
                    <th> <b> Head Quarter   </b> </th>  
                    <th> <b> Mandal  </b> </th>
                  
                </tr>

                <%


                
                   qry=" select dname,c.mname,d.mname as hqname,a.dcode,a.mcode,a.divcode from adamandals a,district_2011_cs b,mandal_2011_cs c ,mandal_2011_cs d "
+" where a.dcode=b.dcode and a.dcode=c.dcode and a.mcode=c.mcode and a.dcode=d.dcode and a.divcode=d.mcode and a.dcode="+sesdcode+"  order by dname,hqname,mname";
                    pst = con.prepareStatement(qry);
                   
                    rs = pst.executeQuery(); 
                    if (rs.next()) {

                        do {%>

                <tr>    
                    <td class="tdnum"><%=z++%></td> 
                     <td> <%=rs.getString("dname")%> </td>
                    <td> <%=rs.getString("hqname")%> </td>
                    <td> <%=rs.getString("mname")%> </td>
                   
                </tr>             
                <%
                            } while (rs.next());
                            flag = true;
                        }//if rs.next
                    
                %>

            </table> 
                </div>
<!--             </div>-->
               <%if(flag){%> 
        <div align="center"> 
            <input style="color: black" name="ctl00$ContentPlaceHolder1$btnPrint" type="button" id="ctl00_ContentPlaceHolder1_btnPrint" onClick="javascript:CallPrint('divPrint')" value="Print" >
            <input style="color:black" type="button" onclick="tableToExcel('absseasondistwise', 'Abstract')" value="Excel">
                                    <input type="button" value="Go Back" onclick="back()">

        </div>

            <%}else {%>
            <div>
                <table>
                    <tr>
                        <td align="center">No Records Found</td>
                    </tr>
                </table>
            </div>
            <%}%>
            <%                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("Exception " + e + "temp2");
                    //response.sendRedirect("index.jsp");
                } finally {
                    if (pst != null) {
                        pst.close();
                    }

                    if (rs != null) {
                        rs.close();
                    }
                    if (pst1 != null) {
                        pst1.close();
                    }

                    if (rs1 != null) {
                        rs1.close();
                    }
                    if (pst2 != null) {
                        pst2.close();
                    }

                    if (rs2 != null) {
                        rs2.close();
                    }

                    con.close();
                }
            %>




        </form>        
    </body>
</html>



