<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<%@include file="../includes/header.jsp"%>


<div class="row">
	<div class="col-lg-12"></div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->


<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 100px;
}
</style>

<style>
.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
}

.bigPicture {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}
</style>

<style>
textarea {
	width: 850px;
	height: 350px;
	overflow: visible;
	resize: none;
}
</style>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<h1>새 글 작성</h1>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<form role="form" action="/board/register" method="post">

					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />

					<div class="form-group">
						<input class="form-control" name='title' placeholder="제목을 입력해주세요.">
					</div>

					<h5>
						작성자 :<sec:authentication property="principal.username" />
					</h5>

					<!-- <hr style="border: solid 0.2px #50bcdf;"> -->

					<!-- 부트스트랩 height 늘리기부터 하면됨 !!! -->
					<!-- <div class="form-group"> -->
					<div>
						<textarea name="content" id="content"></textarea>
					</div>

					<div class="form-group">
						 <input type="hidden" name='writer'
							value='<sec:authentication property="principal.username"/>'>
					</div>
					
					<button type="submit" name="submitBtn" id="submitBtn"
						class="btn btn-default">Submit Button</button>
					<!-- <button type="reset" class="btn btn-default">Reset Button</button> -->
				</form>

			</div>
			<!--  end panel-body -->

		</div>
		<!--  end panel-body -->
	</div>
	<!-- end panel -->
</div>
<!-- /.row -->


<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">File Attach</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name='uploadFile' multiple>
				</div>

				<div class='uploadResult'>
					<ul>

					</ul>
				</div>


			</div>
			<!--  end panel-body -->

		</div>
		<!--  end panel-body -->
	</div>
	<!-- end panel -->
</div>
<!-- /.row -->

<script>
var oEditors = [];
nhn.husky.EZCreator.createInIFrame({
	oAppRef : oEditors,
	elPlaceHolder: "content",
	sSkinURI: "<%=request.getContextPath() %>/smarteditor/SmartEditor2Skin.html", 
	fCreator:"createSEditor2"
});
//oEditors.getById['textarea name="content"'].exec("UPDATE_CONTENTS_FIELD", []);
	$(document).ready(function(e) {

						var formObj = $("form[role='form']");
						var contents = $("textarea[name='content']");
						
						//textarea 변
						$("button[type='submit']").on("click",
										function(e) {
											
											e.preventDefault();
											console.log("submit clicked");
											var str = "";
											
											//스마트에디터의 내용을 textarea의 내용물로 저장
											contents.html("<h3>" + oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []) + "</h3>");
											
											//물음표 제거!!
											contents.val(contents.val().replace(/\ufeff/g, ''));
											


											$(".uploadResult ul li").each(
												function(i, obj) {
													var jobj = $(obj);
													console.dir(jobj);
													console.log("-------------------------");
													console.log(jobj.data("filename"));

													str += "<input type='hidden' name='attachList["
																		+ i
																		+ "].fileName' value='"
																		+ jobj
																				.data("filename")
																		+ "'>";
																str += "<input type='hidden' name='attachList["
																		+ i
																		+ "].uuid' value='"
																		+ jobj
																				.data("uuid")
																		+ "'>";
																str += "<input type='hidden' name='attachList["
																		+ i
																		+ "].uploadPath' value='"
																		+ jobj
																				.data("path")
																		+ "'>";
																str += "<input type='hidden' name='attachList["
																		+ i
																		+ "].fileType' value='"
																		+ jobj
																				.data("type")
																		+ "'>";

															});

											console.log(str);

											formObj.append(str).submit();

										});

						var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
						var maxSize = 5242880; //5MB

						function checkExtension(fileName, fileSize) {

							if (fileSize >= maxSize) {
								alert("파일 사이즈 초과");
								return false;
							}

							if (regex.test(fileName)) {
								alert("해당 종류의 파일은 업로드할 수 없습니다.");
								return false;
							}
							return true;
						}

						var csrfHeaderName = "${_csrf.headerName}";
						var csrfTokenValue = "${_csrf.token}";

						$("input[type='file']")
								.change(
										function(e) {

											var formData = new FormData();

											var inputFile = $("input[name='uploadFile']");

											var files = inputFile[0].files;

											for (var i = 0; i < files.length; i++) {

												if (!checkExtension(
														files[i].name,
														files[i].size)) {
													return false;
												}
												formData.append("uploadFile",
														files[i]);

											}

											$.ajax({
												url : '/uploadAjaxAction',
												processData : false,
												contentType : false,
												beforeSend : function(xhr) {
													xhr.setRequestHeader(
															csrfHeaderName,
															csrfTokenValue);
												},
												data : formData,
												type : 'POST',
												dataType : 'json',
												success : function(result) {
													console.log(result);
													showUploadResult(result); //업로드 결과 처리 함수 

												}
											}); //$.ajax

										});

						function showUploadResult(uploadResultArr) {

							if (!uploadResultArr || uploadResultArr.length == 0) {
								return;
							}

							var uploadUL = $(".uploadResult ul");

							var str = "";

							$(uploadResultArr)
									.each(
											function(i, obj) {

												/* //image type
												if(obj.image){
												  var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
												  str += "<li><div>";
												  str += "<span> "+ obj.fileName+"</span>";
												  str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
												  str += "<img src='/display?fileName="+fileCallPath+"'>";
												  str += "</div>";
												  str +"</li>";
												}else{
												  var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);            
												    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
												      
												  str += "<li><div>";
												  str += "<span> "+ obj.fileName+"</span>";
												  str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
												  str += "<img src='/resources/img/attach.png'></a>";
												  str += "</div>";
												  str +"</li>";
												} */
												//image type
												if (obj.image) {
													var fileCallPath = encodeURIComponent(obj.uploadPath
															+ "/s_"
															+ obj.uuid
															+ "_"
															+ obj.fileName);
													str += "<li data-path='"+obj.uploadPath+"'";
			str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
			str +" ><div>";
													str += "<span> "
															+ obj.fileName
															+ "</span>";
													str += "<button type='button' data-file=\'"+fileCallPath+"\' "
			str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
													str += "<img src='/display?fileName="
															+ fileCallPath
															+ "'>";
													str += "</div>";
													str + "</li>";
												} else {
													var fileCallPath = encodeURIComponent(obj.uploadPath
															+ "/"
															+ obj.uuid
															+ "_"
															+ obj.fileName);
													var fileLink = fileCallPath
															.replace(
																	new RegExp(
																			/\\/g),
																	"/");

													str += "<li "
			str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
													str += "<span> "
															+ obj.fileName
															+ "</span>";
													str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
			str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
													str += "<img src='/resources/img/attach.png'></a>";
													str += "</div>";
													str + "</li>";
												}

											});

							uploadUL.append(str);
						}

						$(".uploadResult").on(
								"click",
								"button",
								function(e) {

									console.log("delete file");

									var targetFile = $(this).data("file");
									var type = $(this).data("type");

									var targetLi = $(this).closest("li");

									$.ajax({
										url : '/deleteFile',
										data : {
											fileName : targetFile,
											type : type
										},
										beforeSend : function(xhr) {
											xhr.setRequestHeader(
													csrfHeaderName,
													csrfTokenValue);
										},

										dataType : 'text',
										type : 'POST',
										success : function(result) {
											alert(result);

											targetLi.remove();
										}
									}); //$.ajax
								});

					});
</script>



<%@include file="../includes/footer.jsp"%>
 