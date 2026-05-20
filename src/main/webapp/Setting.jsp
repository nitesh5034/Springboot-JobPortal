<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Account Settings</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<%
    // Session mathi object lo (Null check safety mate)
    com.model.UserModel u = (com.model.UserModel) session.getAttribute("Model");
    // Jo user login nathi to Guest mode ma khali page dekhase
%>

<div class="container mt-5">
    <div class="row">
        <div class="col-md-3">
            <div class="list-group shadow-sm">
                <a href="#" class="list-group-item list-group-item-action active">Security & Password</a>
                <a href="edit-profile.jsp" class="list-group-item list-group-item-action">Profile Settings</a>
                <a href="Application-track.jsp" class="list-group-item list-group-item-action">Activity Log</a>
            </div>
        </div>

        <div class="col-md-9">
            <div class="card shadow p-4 border-0">
                <h4 class="mb-4">🔐 Change Password</h4>
                
                <form action="UserController" method="post">
                    <input type="hidden" name="action" value="changePassword">
                    <input type="hidden" name="userid" value="<%= (u != null) ? u.getUserid() : 0 %>">

                    <div class="mb-3">
                        <label class="form-label">Current Password</label>
                        <input type="password" name="old_password" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">New Password</label>
                        <input type="password" name="new_password" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Confirm New Password</label>
                        <input type="password" name="confirm_password" class="form-control" required>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary px-4">Update Password</button>
                    </div>
                </form>

                <hr class="my-5">

                <h4 class="text-danger">Danger Zone</h4>
                <p class="text-muted">Once you delete your account, there is no going back. Please be certain.</p>
                <button class="btn btn-outline-danger btn-sm">Delete Account</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>