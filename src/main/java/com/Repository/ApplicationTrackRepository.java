package com.Repository;

import com.model.ApplicationModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ApplicationTrackRepository extends JpaRepository<ApplicationModel, Integer> {

    List<ApplicationModel> findByUserid(int userid);
}