package com.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.model.companyverify;
import java.util.Optional;

@Repository
public interface CompanyVerifyRepository extends JpaRepository<companyverify, Integer> {

    // Change findByEmailAndPassword to findFirstByEmailAndPassword
    Optional<companyverify> findFirstByEmailAndPassword(String email, String password);
}