package com.Repository;

import com.model.applymodel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ApplyRepository extends JpaRepository<applymodel, Integer> {


    List<applymodel> findByEmailIgnoreCase(String email);

    List<applymodel> findByJobId(int jobId);

    List<applymodel> findByJobIdIn(List<Integer> jobIds);

    long countByJobId(int jobId);
}