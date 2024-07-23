<%-- 
    Document   : HoMapSave
    Created on : 26 Dec, 2022, 4:14:29 PM
    Author     : admin 
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="util.SqlDBUtil"%>
<%@page import="validations.Validations"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<
<!DOCTYPE html>
<%
    
    String sesdcode = session.getAttribute("DCODE").toString();
     String user = session.getAttribute("USER").toString();
    String role = session.getAttribute("ROLE").toString();
    
   
    String homemenu = "";
    //homemenu = util.CommonMethods.getHomemenu(session.getAttribute("ROLE").toString());

%>
<%--<jsp:include page="<%= homemenu%>" flush="true" />--%>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Seed Allocation Target</title>
    </head>
    <body>
        <%
            SqlDBUtil sql = new SqlDBUtil();
            
            Connection con = null;
            PreparedStatement pst = null,pst1=null,pst2=null,pst3=null;
            ResultSet rs = null,rs1=null,rs2=null,rs3=null;
            Validations validations=null;
            String query="",dcode="",msg="";
            int cnt=0,updres=0,insres=0;
            try{
             validations = new Validations();
            String hqmcode="",mcode="";
            int flag = 0;           
            String userid = session.getAttribute("USER").toString();            
            
            dcode=request.getParameter("dcode"); //System.out.println("dcode:"+dcode);
            hqmcode=request.getParameter("hmcode");//System.out.println("hq mcode:"+hqmcode);
            mcode=request.getParameter("mcode");//System.out.println("mcode:"+mcode);
          
            boolean userExists=false;
            
            int valid = 1;
                if(valid == 0){
        %>
                    <h3 style="color: red;" align="center">Improper Data Found1</h3>
        <%
                }
                else{
                    con = sql.getConnection();
                    //String mname=util.MasterFunctions.MasterFunction( hqmcode,"mcode");
                    String insqry= "INSERT INTO public.user_registration(district, blockortehsil,userid,password, retype_password,  datetime, encpassword, status,webloginstatus,type_user)"
	                           +" VALUES (?, ?,  ?, '8177da925c9dccb757ae4611dc3e58a4','8177da925c9dccb757ae4611dc3e58a4', now(), '8177da925c9dccb757ae4611dc3e58a4', 'A', 'A',31');"; 
                   
                    String updqry=" update user_registration set status='A' ,webloginstatus='A' where type_user='31' and district=? and blockortehsil=?  ";
                        query = "insert into adamandals ( dcode,mcode,divcode)  VALUES ( ?, ?, ?);"; //divname,newdivcode,wbdcode

                        pst = con.prepareStatement(query);
                        pst.setInt(1, Integer.parseInt(dcode));
                        pst.setInt(2, Integer.parseInt(mcode));
                        pst.setInt(3, Integer.parseInt((hqmcode)));
                      //  pst.setString(4,"A");
                        int res2 = pst.executeUpdate();
                    
                         String  qry = " select blockortehsil from user_registration where type_user='31' and blockortehsil='"+(dcode+hqmcode)+"'";

                        pst1 = con.prepareStatement(qry);
                       rs1=pst1.executeQuery(); System.out.println("pst1::"+pst1);
                       if(rs1.next()){
                       userExists=true;
                        }

                        if(userExists){
                         pst2 = con.prepareStatement(updqry);
                         pst2.setString(1, dcode);
                         pst2.setString(2, (dcode+hqmcode));                       
                         updres = pst2.executeUpdate();
                        }
                        else{ //System.out.println("in else:");
                         pst3 = con.prepareStatement(insqry);
                         pst3.setString(1, dcode);
                         pst3.setString(2, (dcode+hqmcode));   
                         pst3.setString(3, "ADA_"+dcode+hqmcode);  // System.out.println("pst3 si:"+pst3);
                         insres = pst3.executeUpdate(); //System.out.println("pst3:"+pst3);
                        }


                   // System.out.println("userExists::"+userExists);

                    if(res2>0 &&(updres>0 || insres>0)){ //System.out.println("res2:updres:insres:"+res2+"--upd:"+updres+"---insres:"+insres);
                      msg="Mandals Mapped Successfully";
                          response.sendRedirect("DAOMappingIntf.jsp?msg="+msg);
                    }
                    else{ 
                         msg="Mapping Failed";
                          response.sendRedirect("DAOMappingIntf.jsp?msg="+msg);
                    }
                }
            }
            catch(SQLException e){
            
                e.printStackTrace();
                         msg="Record Already Exists With This Combination";
                          response.sendRedirect("DAOMappingIntf.jsp?msg="+msg);
            }
            catch(Exception e){
                e.printStackTrace();
        %>
                <h3 style="color: red;" align="center">Improper Data Found2</h3>
        <%
            }
            finally{
                if(rs != null){
                    rs.close();
                }
                if(rs1 != null){
                    rs1.close();
                }
                if(pst != null){
                    pst.close();
                }
                 if(pst1 != null){
                    pst1.close();
                }
                if(pst2 != null){
                    pst2.close();
                }
                if(pst3 != null){
                    pst3.close();
                }
                if(con != null){
                    con.close();
                }
            }
        %>
    </body>
</html>
