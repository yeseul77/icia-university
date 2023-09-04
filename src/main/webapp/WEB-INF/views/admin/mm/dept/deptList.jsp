<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학과관리</title>
    
    <jsp:include page="/WEB-INF/views/layout/head-js.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/layout/head-css.jsp"></jsp:include>
    
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
                url : '/admin/mm/dept/api/write',
                data : obj
                
            }).done(function(res) {
                alert(res)
                location.href = '/admin/mm/dept'
                
            }).fail(function(res) {
                console.log(res)
            })
        }
        
        function update() {
            const obj = $('form[name="detailFrm"]').serializeObject()
            console.log(obj)
            
            $.ajax({
                method : 'PATCH',
                url : '/admin/mm/dept/api/update',
                data : obj
                
            }).done(function(res) {
                alert(res)
                location.href = '/admin/mm/dept'
                
            }).fail(function(res) {
                console.log(res)
            })
        }
        
        function del() {
            const deptId = document.detailFrm.querySelector('input[name="deptId"]').value
            
            $.ajax({
                method : 'DELETE',
                url : '/admin/mm/dept/api/delete/' + deptId
                
            }).done(function(res) {
                alert(res)
                location.href = '/admin/mm/dept'
                
            }).fail(function(res) {
                console.log(res)
            })
        }
        
        function detail(id) {
            $.ajax({
                method : 'GET',
                url : '/admin/mm/dept/api/detail/' + id
                
            }).done(function(res) {
                document.detailFrm.querySelector('input[name="facultyId"]').value = res['facultyId']
                document.detailFrm.querySelector('input[name="facultyName"]').value = res['facultyName']
                document.detailFrm.querySelector('input[name="deptId"]').value = res['deptId']
                document.detailFrm.querySelector('input[name="deptName"]').value = res['deptName']
                document.detailFrm.querySelector('input[name="createDate"]').value = res['createDate']
                
                const statuses = document.detailFrm.querySelectorAll('input[name="status"]')
                statuses.forEach(status=>{
                    if(status.value == res['status']) {
                        status.checked = true
                    }
                })
                
            }).fail(function(res) {
                console.log(res)
            })
        }
        
        function search(kind) {
            $.ajax({
                method : "GET",
                url : "/admin/mm/faculty/api/list/" + kind
                
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
                document.frm.querySelector('input[name="facultyId"]').value = id
                document.frm.querySelector('input[name="facultyName"]').value = name
            }
            else if (kind == 'update') {
                document.detailFrm.querySelector('input[name="facultyId"]').value = id
                document.detailFrm.querySelector('input[name="facultyName"]').value = name
                $('#detailModal').modal('show')
            }
        }
    </script>
</head>

<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"></jsp:include>

<div class="container">
    <div class="row mb-3 mt-3">
        <h3>학과관리</h1>
    </div>

    <div class="row">
        <div class="card bg-light">
            <div class="card-body py-4">
            
                <div class="row">
                    <div class="col">
                        <div class="table-responsive text-center">
                            <table class="table table-bordered table-hover">
                                <thead class="table-primary">
                                    <tr>
	                                    <th>번호</th>
	                                    <th>학부번호</th>
	                                    <th>학부명</th>
	                                    <th>학과번호</th>
	                                    <th>학과명</th>
	                                    <th>운영상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="dept" items="${deptList}">
                                        <tr>
                                            <td>${dept.rnum}</td>
                                            <td>${dept.facultyId}</td>
                                            <td>${dept.facultyName}</td>
                                            <td>${dept.deptId}</td>
                                            <td>
                                                <a href="#" onclick="detail('${dept.deptId}')"
                                                    data-bs-toggle="modal" data-bs-target="#detailModal" style="cursor:pointer" class="link-offset-2 link-underline link-underline-opacity-0">
                                                    ${dept.deptName}
                                                </a>
                                            </td>
                                            <td>
	                                            <c:if test="${dept.status eq '1'}">운영</c:if>
	                                            <c:if test="${dept.status eq '0'}">폐지</c:if>
                                            </td>
                                         </tr>
                                     </c:forEach>
                                 </tbody>
                             </table>
                         </div>
                    </div>
                    
                    <div class="col-4">
                        <form name="frm">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="facultyId" name="facultyId" placeholder="학부 고유번호를 입력해주세요." readonly>
                                <label for="facultyId">학부번호</label>
                            </div>
                            
                            <div class="row">
                                <div class="col">
                                    <div class="form-floating mb-3">
                                        <input type="text" class="form-control" id="facultyName" name="facultyName" placeholder="학부명을 입력해주세요." readonly>
                                <label for="facultyName">학부명</label>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <button type="button" class="btn btn-primary btn-search-save"
                                        data-bs-toggle="modal" data-bs-target="#searchModal">찾아보기</button>
                                </div>
                            </div>
                            
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" name="deptId" placeholder="학과 고유번호를 입력해주세요.">
                                <label for="deptId">학과번호</label>
                            </div>
                            
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" name="deptName" placeholder="학과명을 입력해주세요.">
                                <label for="deptName">학과명</label>
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
                        <h1 class="modal-title fs-5" id="detailModalLabel">학과</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      
                      <div class="modal-body">
                        <form name="detailFrm">
                            <table class="table table-bordered">
                                <tr>
                                    <th class="table-primary align-middle">학부번호</th>
                                    <td>
                                        <input type="text" name="facultyId" class="form-control" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="table-primary align-middle">학부명</th>
                                    <td>
	                                    <div class="row">
	                                          <div class="col">
	                                            <input type="text" name="facultyName" class="form-control" readonly>
	                                          </div>
	                                          <div class="col">
	                                                <button type="button" class="btn btn-primary btn-search-update"
	                                                    data-bs-toggle="modal" data-bs-target="#searchModal">찾아보기</button>
	                                          </div>
	                                      </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="table-primary align-middle">학과번호</th>
                                    <td>
                                        <input type="text" name="deptId" class="form-control-plaintext" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="table-primary align-middle">학과명</th>
                                    <td>
                                        <input type="text" name="deptName" class="form-control">
                                    </td>
                                </tr>
                                <tr>
                                    <th class="table-primary align-middle">등록일</th>
                                    <td>
                                        <input type="text" name="createDate" class="form-control-plaintext" disabled>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="table-primary align-middle">운영상태</th>
                                    <td>
                                        <input type="radio" id="operating" name="status" class="" value="1">
	                                    <label for="operating" class="form-label">운영</label>
	                                    <input type="radio" id="drop" name="status" class="" value="0">
	                                    <label for="drop" class="form-label">폐지</label>
                                    </td>
                                </tr>
                            </table>
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
                        <h1 class="modal-title fs-5" id="searchModalLabel">학부</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      
                      <div class="modal-body">
                        <table class="table table-bordered table-hover text-center">
                            <thead class="table-primary">
                                <th>번호</th>
                                <th>학부번호</th>
                                <th>학부명</th>
                            </thead>
                            <tbody id="modal-body">
                            </tbody>
                        </table>
                      </div>
                      
                      <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-close-searchModal"
                            data-bs-dismiss="modal">닫기</button>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- end Search Modal -->
                
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"></jsp:include>
    
</div>
</body>
</html>