<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
    
    <script src="https://code.jquery.com/jquery-3.7.0.min.js" integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"
    integrity="sha512-Gn0tSSjkIGAkaZQWjx3Ctl/0dVJuTmjW/f9QyB302kFjU4uTNP4HtA32U2qXs/TRlEsK5CoEqMEMs7LnzLOBsA=="
    crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    
    <script>
        document.addEventListener("DOMContentLoaded", function(){
        	document.querySelector('.btn-save').addEventListener('click', ()=>save())
            document.querySelector('.btn-update').addEventListener('click', ()=>update())
            document.querySelector('.btn-delete').addEventListener('click', ()=>del())
            document.querySelector('.btn-search-save').addEventListener('click', ()=>search('save'))
            document.querySelector('.btn-search-update').addEventListener('click', ()=>search('update'))
        })
	    
	    function save() {
	        const obj = $('form[name="frm"]').serializeObject()
	        console.log(obj)
	        
	        $.ajax({
	            method : 'PUT',
	            url : '/admin/mm/faculty/api/write',
	            data : obj
	            
	        }).done(function(res) {
	            alert(res)
	            location.href = '/admin/mm/faculty'
	            
	        }).fail(function(res) {
	            console.log(res)
	        })
	    }
	    
	    function update() {
	        const obj = $('form[name="detailFrm"]').serializeObject()
	        console.log(obj)
	        
	        $.ajax({
	            method : 'PATCH',
	            url : '/admin/mm/faculty/api/update',
	            data : obj
	            
	        }).done(function(res) {
	            alert(res)
	            location.href = '/admin/mm/faculty'
	            
	        }).fail(function(res) {
	            console.log(res)
	        })
	    }
	    
	    function del() {
	        const facultyId = document.detailFrm.querySelector('input[name="facultyId"]').value
	        
	        $.ajax({
	            method : 'DELETE',
	            url : '/admin/mm/faculty/api/delete/' + facultyId
	            
	        }).done(function(res) {
	            alert(res)
	            location.href = '/admin/mm/faculty'
	            
	        }).fail(function(res) {
	            console.log(res)
	        })
	    }
	    
	    function detail(facultyId) {
	        $.ajax({
	            method : 'GET',
	            url : '/admin/mm/faculty/api/detail/' + facultyId
	            
	        }).done(function(res) {
	            document.detailFrm.querySelector('input[name="deptLineId"]').value = res['deptLineId']
	            document.detailFrm.querySelector('input[name="deptLineName"]').value = res['deptLineName']
	            document.detailFrm.querySelector('input[name="facultyId"]').value = res['facultyId']
	            document.detailFrm.querySelector('input[name="facultyName"]').value = res['facultyName']
	            document.detailFrm.querySelector('input[name="createDate"]').value = res['createDate']
	            
	        }).fail(function(res) {
	            console.log(res)
	        })
	    }
	    
	    function search(kind) {
	        $.ajax({
	            method : "GET",
	            url : "/admin/mm/deptline/api/list/" + kind
	            
	        }).done(function(res) {
	            document.querySelector("#modal-body").innerHTML = res
	            if (kind == 'update') {
	                document.querySelector('.btn-close-searchModal').setAttribute('data-bs-target', '#detailModal') 
	                document.querySelector('.btn-close-searchModal').setAttribute('data-bs-toggle', 'modal') 
	            }
	            else {
	                document.querySelector('.btn-close-searchModal').removeAttribute('data-bs-target') 
	                document.querySelector('.btn-close-searchModal').removeAttribute('data-bs-toggle') 
	            }
	            
	        }).fail(function(res) {
	            console.log(res)
	        })
	    }
	    
	    function selected(id, name, kind) {
	        $('#searchModal').modal('hide')
	        
	        if (kind == 'save') {
	            document.frm.querySelector('input[name="deptLineId"]').value = id
	            document.frm.querySelector('input[name="deptLineName"]').value = name
	        }
	        else if (kind == 'update') {
	            document.detailFrm.querySelector('input[name="deptLineId"]').value = id
	            document.detailFrm.querySelector('input[name="deptLineName"]').value = name
	            $('#detailModal').modal('show')
	        }
	    }
    </script>
</head>

<body>
<div class="container">
    <div class="row">
        <div class="card">
            <div class="card-body">
            
                <div class="row">
                    <div class="col text-center">
                        <div class="row">
                            <div class="col">번호</div>
                            <div class="col">학과계열번호</div>
                            <div class="col">학과계열명</div>
                            <div class="col">학부번호</div>
                            <div class="col">학부명</div>
                        </div>
                        
                        <c:forEach var="faculty" items="${facultyList}">
                            <div class="row" onclick="detail('${faculty.facultyId}')"
                                data-bs-toggle="modal" data-bs-target="#detailModal" style="cursor:pointer">
                                <div class="col">${faculty.rnum}</div>
                                <div class="col">${faculty.deptLineId}</div>
                                <div class="col">${faculty.deptLineName}</div>
                                <div class="col">${faculty.facultyId}</div>
                                <div class="col">${faculty.facultyName}</div>
                            </div>
                        </c:forEach>
                    </div> <!-- end row -->
                    
                    <div class="col">
                        <form name="frm">
                            <div class="row mb-3 align-items-center">
                                <div class="col-3">학과계열번호</div>
                                <div class="col"><input type="text" name="deptLineId" class="form-control" readonly></div>
                            </div>
                            
                            <div class="row mb-3 align-items-center">
                                <div class="col-3">학과계열명</div>
                                <div class="col"><input type="text" name="deptLineName" class="form-control" readonly></div>
                                <div class="col">
                                    <button type="button" class="btn btn-primary btn-search-save"
                                    data-bs-toggle="modal" data-bs-target="#searchModal">찾아보기</button>
                                </div>
                            </div>
                            
                            <div class="row mb-3 align-items-center">
                                <div class="col-3">학부번호</div>
                                <div class="col">
                                    <input type="text" name="facultyId" class="form-control">
                                </div>
                            </div>
                            
                            <div class="row mb-3 align-items-center">
                                <div class="col-3">학부명</div>
                                <div class="col">
                                    <input type="text" name="facultyName" class="form-control">
                                </div>
                            </div>
                        </form>
                        
                        <div class="row">
                            <div class="mb-3 text-lg-end">
                                <button type="button"
                                   class="input-group-text btn waves-effect waves-light btn-primary btn-save">
                                    <i class="mdi mdi-clipboard-edit me-1"></i>저장
                                </button>
                            </div>
                        </div>
                    </div>
                </div> <!-- end row -->
                
                <!-- Detail Modal -->
                <div class="modal fade" id="detailModal" data-bs-backdrop="static" data-bs-keyboard="false"
                    tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h1 class="modal-title fs-5" id="detailModalLabel">학과계열</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      
                      <div class="modal-body">
						<form name="detailFrm">
						    <div class="row mb-3 align-items-center">
						        <div class="col-3">학과계열번호</div>
						        <div class="col">
						            <input type="text" name="deptLineId" class="form-control" readonly>
						        </div>
						    </div>
						    
						    <div class="row mb-3 align-items-center">
						        <div class="col-3">학과계열명</div>
						        <div class="col">
						            <input type="text" name="deptLineName" class="form-control" readonly>
						        </div>
						        <div class="col">
						            <button type="button" class="btn btn-primary btn-search-update"
						                data-bs-toggle="modal" data-bs-target="#searchModal">찾아보기</button>
						        </div>
						    </div>
						    
						    <div class="row mb-3 align-items-center">
						        <div class="col-3">학부번호</div>
						        <div class="col">
						            <input type="text" name="facultyId" class="form-control">
						        </div>
						    </div>
						    
						    <div class="row mb-3 align-items-center">
						        <div class="col-3">학부명</div>
						        <div class="col">
						            <input type="text" name="facultyName" class="form-control">
						        </div>
						    </div>
						    
						    <div class="row mb-3 align-items-center">
						        <div class="col-3">등록일</div>
						        <div class="col">
						            <input type="text" name="createDate" class="form-control-plaintext" disabled>
						        </div>
						    </div>
						</form>
                      </div> <!-- ene modal-body -->
                      
                      <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                        <button type="button" class="btn btn-danger btn-delete">삭제</button>
                        <button type="button" class="btn btn-primary btn-update">수정</button>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- end Detail Modal -->
                
                <!-- Search Modal -->
                <div class="modal fade" id="searchModal" data-bs-backdrop="static" data-bs-keyboard="false"
                    tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h1 class="modal-title fs-5" id="searchModalLabel">학과계열</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      
                      <div class="modal-body">
                        <div class="row">
                            <div class="col">번호</div>
                            <div class="col">학과계열번호</div>
                            <div class="col">학과계열명</div>
                        </div>
                        
                        <div id="modal-body"></div>
                      </div>
                      
                      <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-close-searchModal" data-bs-dismiss="modal">닫기</button>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- end Search Modal -->
                
            </div>
        </div>
    </div>
    
    <button type="button" class="btn btn-primary" onclick="javascript:location.href='/'">홈으로</button>
    
</div>
</body>
</html>