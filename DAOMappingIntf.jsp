<%-- 
    Document   : HoMappingIntf
    Created on : 26 Dec, 2022, 3:30:30 PM
    Author     : admin
--%>

<%@page import="login.struts.utils.CommonUtils"%>
<%@page import="util.MasterFunctions"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="javax.servlet.http.*"%>

<script src="js/jquery.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="scripts/datetimepicker.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/req.js" ></script>  

<link rel="stylesheet" href="styles/reportstylesheet.css"/>
<script  type="text/javascript" src="<%=request.getContextPath()%>/scripts/js/epvalidations.js"/></script>
<%
    String role = session.getAttribute("ROLE").toString();
    String user = session.getAttribute("USER").toString();
    String sesdcode = session.getAttribute("DCODE").toString();

    if (!(role.equals("9"))) {
        response.sendRedirect("logout.jsp");
    }

    String homemenu = "";
    homemenu = util.CommonMethods.getHomemenu(session.getAttribute("ROLE").toString());

%>
<jsp:include page="<%= homemenu%>" flush="true" />  
<html>
    <%
        String seasonCropyear = null, cropyear = "";

        PreparedStatement ps1 = null, ps2 = null;
        ResultSet rst1 = null, rst2 = null;
        Connection con = null;
        ResultSet rs = null, rs1 = null, rs2 = null, rs3 = null;
        PreparedStatement pstmt = null, pstmt1 = null, pstmt2 = null, pstmt3 = null, pstmt4 = null, pstmt5 = null;

        String qry = "", msg = "";
        String imgrslt = "false";
        int i = 0, cnt = 1;
        CommonUtils commonUtils = null;

        try {
            util.SqlDBUtil test = new util.SqlDBUtil();
            con = test.getConnection();


    %>   

    <head>
        <script type="text/javascript">

            function setSubmite()
            {

                var hqmandal = document.getElementById("hmcode").value;
                var mandal = document.getElementById("mcode").value;


                if (hqmandal == "") {
                    alert("ADA Division ");
                    document.getElementById("hqmcode").focus();
                    return false;
                }
                if (mandal == "") {
                    alert("Select Mandal ");
                    document.getElementById("mcode").focus();
                    return false;
                }
                document.forms[0].action = "MapSaveDAO.jsp";
                document.forms[0].submit();
                return true;

            }

            window.onload = function () {
                getHoMandal();
                getMandal();
            }

            function getHoMandal() {
                var dist_code = <%=sesdcode%>;

                $.post("AjaxcensusMandal.jsp",
                        {
                            dcode: dist_code
                        },
                        function (data, status) {
                            var selectmandal = "<select>"
                            selectmandal += "<option value=>--Select--</option>"
                            if (data.trim() == "") {
                                alert("No Records");
                                selectmandal += "</select>";
                            } else {
                                var obj = JSON.parse(data.trim());
                                for (var i = 0; i < obj.mandallist.length; i++) {
                                    selectmandal += "<option value=" + obj.mandallist[i].mcode + ">" + obj.mandallist[i].mname + "</option>";
                                }
                                selectmandal += "</select>";
                            }
                            $("#hmcode").html(selectmandal);
                        }
                );
            }


            function getMandal() {
                var dist_code =<%=sesdcode%>;

                $.post("AjaxMapHoMandal.jsp",
                        {
                            dcode: dist_code
                        },
                        function (data, status) {
                            var selectmandal = "<select>"
                            selectmandal += "<option value=>--Select--</option>"
                            if (data.trim() == "") {
                                alert("No Records");
                                selectmandal += "</select>";
                            } else {
                                var obj = JSON.parse(data.trim());
                                for (var i = 0; i < obj.mandallist.length; i++) {
                                    selectmandal += "<option value=" + obj.mandallist[i].mcode + ">" + obj.mandallist[i].mname + "</option>";
                                }
                                selectmandal += "</select>";
                            }
                            $("#mcode").html(selectmandal);
                        }
                );
            }



            setTimeout(function () {
                $('#tr_msg').hide();
            }, 4000);

        </script> 

        <script>
            function back()

            {
                document.forms[0].action = 'JdaRibbon.jsp';
                document.forms[0].submit();
            }
        </script>
    </head>
    <body >
        <div>
            <form name="myform">
                <table align="center" style="background-color: #ffffff !important">
                    <tr><th colspan="2" class="heading" style="color:white"><b>ADA Jurisdictions </b></th>   </tr>

                    <%
                        msg = request.getParameter("msg");
                        if (msg != null && msg != "") {
                    %>
                    <tr  id="tr_msg">
                        <td colspan="3" align="center"><font style="color: green;"><h2><%=msg%></h2></font></td>
                    </tr> 
                    <%}%>

                    <%
                        qry = "select distinct on (a.cropyear,a.season) concat(a.season,'@',cropyear) as seasonvalue,concat(b.seasonname,' ',cropyear) as cropyear ";
                        qry += " from activeseason a,season b  where   a.season=b.season and a.active='A'  and a.season='R' order by a.cropyear,a.season";
                        pstmt = con.prepareStatement(qry);
                        rs = pstmt.executeQuery();
                    %>

                    <tr>
                        <td class="tdnum" width="50%"><b> ADA Division <font color="red">*</font> </b>  &nbsp;&nbsp;&nbsp;</font></td>
                        <td class="tdtext">
                            <select id="hmcode" name="hmcode"    style="width: 250px"  >
                                <option value="">----Select----</option>
                            </select>                        
                        </td>
                    </tr>
                    <tr>
                        <td class="tdnum" width="50%"><b> Select Mandal-Map  <font color="red">*</font> </b>  &nbsp;&nbsp;&nbsp;</font></td>
                        <td class="tdtext">

                            <select id="mcode" name="mcode"    style="width: 250px"  >
                                <option value="">----Select----</option>
                            </select>                        
                        </td>
                    </tr>
                    <input type="hidden"  id="dcode" name="dcode" value="<%=sesdcode%>">
                </table>
            </form>
        </div> 
        <div align="center">  
            <input type=button  value="Add "  onClick="setSubmite(this)" style="width: 12%" >
        </div>
        <div>
            <jsp:include page="Rep_DAOMandalMapIntf.jsp"/>
        </div>

    </body>
    <%
        } catch (Exception e) {
        } finally {

            if (rs != null) {
                rs.close();
                rs = null;
            }
            if (rs1 != null) {
                rs1.close();
                rs1 = null;
            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            if (pstmt1 != null) {
                pstmt1.close();
                pstmt1 = null;
            }
            if (con != null) {
                con.close();
                con = null;
            }
        }
    %>
</html>
