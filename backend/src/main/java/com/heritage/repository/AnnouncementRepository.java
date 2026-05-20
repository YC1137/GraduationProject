package com.heritage.repository;

import com.heritage.entity.Announcement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AnnouncementRepository extends JpaRepository<Announcement, Long> {

    /** 查询已启用的公告，按排序权重升序、创建时间降序 */
    List<Announcement> findByEnabledTrueOrderBySortOrderAscCreateTimeDesc();

    /** 查询所有公告（管理端） */
    List<Announcement> findAllByOrderBySortOrderAscCreateTimeDesc();
}
