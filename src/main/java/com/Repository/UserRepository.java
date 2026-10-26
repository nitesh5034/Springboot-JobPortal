package com.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.model.UserModel;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserModel, Integer> {

    // Add/Verify this exact declaration:
    Optional<UserModel> findFirstByEmail(String email);

    Optional<UserModel> findFirstByEmailAndPassword(String email, String password);

    List<UserModel> findByIsVerified(int isVerified);

    long countByRole(String role);

    long countByRoleAndIsVerified(String role, int isVerified);
}