package com.Repository;

import com.model.application;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ApplicationRepository extends JpaRepository<application, Integer>
{
    List<application> findAll();
}
