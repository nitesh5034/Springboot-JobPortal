package com.Repository;

import com.model.Postjob;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface JobRepository extends JpaRepository<Postjob, Object> {

    List<Postjob> findByEmail(String email);

    @Query(value = "SELECT * FROM `company job-update` WHERE job_id = :jobId LIMIT 1", nativeQuery = true)
    Optional<Postjob> findByJobId(@Param("jobId") int jobId);
    @Query(value = "SELECT j.* FROM `company job-update` j INNER JOIN saved_jobs s ON j.job_id = s.job_id WHERE s.user_id = :userId", nativeQuery = true)
    List<Postjob> findSavedJobsByUserId(@Param("userId") int userId);

    @Transactional
    @Modifying
    @Query(value = "DELETE FROM saved_jobs WHERE user_id = :userId AND job_id = :jobId", nativeQuery = true)
    void deleteSavedJob(@Param("userId") int userId, @Param("jobId") int jobId);

    @Transactional
    @Modifying
    @Query(value = "INSERT INTO saved_jobs (user_id, job_id) VALUES (:userId, :jobId)", nativeQuery = true)
    void saveJobForUser(@Param("userId") int userId, @Param("jobId") int jobId);
}