package com.heritage.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;

import java.util.List;

/**
 * 非遗项目数据传输对象
 * 用于将数据库中的 JSON 字符串转换为前端期望的格式
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class HeritageDTO {
    private Long id;
    private String name;
    private String category;
    private String region;
    private String level;
    private String inheritor;
    private String description;
    private String detailDescription;
    private String thumbnail;
    private List<String> images;
    private String video;
    private String audio;
    private String sidebarImage;
    private List<TimelineItem> timeline;
    private Integer likes;
    private Integer favorites;
    private Integer views;
    private Boolean enabled;

    @Data
    public static class TimelineItem {
        private String year;
        private String event;
    }

    /**
     * 从实体对象转换为DTO
     */
    public static HeritageDTO fromEntity(com.heritage.entity.Heritage heritage) {
        HeritageDTO dto = new HeritageDTO();
        dto.setId(heritage.getId());
        dto.setName(heritage.getName());
        dto.setCategory(heritage.getCategory());
        dto.setRegion(heritage.getRegion());
        dto.setLevel(heritage.getLevel());
        dto.setInheritor(heritage.getInheritor());
        dto.setDescription(heritage.getDescription());
        dto.setDetailDescription(heritage.getDetailDescription());
        dto.setThumbnail(heritage.getThumbnail());
        dto.setVideo(heritage.getVideo());
        dto.setAudio(heritage.getAudio());
        dto.setSidebarImage(heritage.getSidebarImage());
        dto.setLikes(heritage.getLikes());
        dto.setFavorites(heritage.getFavorites());
        dto.setViews(heritage.getViews());
        dto.setEnabled(heritage.getEnabled());

        // 转换 images JSON 字符串为 List<String>
        if (heritage.getImages() != null && !heritage.getImages().trim().isEmpty()) {
            try {
                ObjectMapper mapper = new ObjectMapper();
                dto.setImages(mapper.readValue(heritage.getImages(), new TypeReference<List<String>>() {}));
            } catch (Exception e) {
                // 如果转换失败，设置为空列表
                dto.setImages(List.of());
            }
        } else {
            dto.setImages(List.of());
        }

        // 转换 timeline JSON 字符串为 List<TimelineItem>
        if (heritage.getTimeline() != null && !heritage.getTimeline().trim().isEmpty()) {
            try {
                ObjectMapper mapper = new ObjectMapper();
                dto.setTimeline(mapper.readValue(heritage.getTimeline(), new TypeReference<List<TimelineItem>>() {}));
            } catch (Exception e) {
                // 如果转换失败，设置为空列表
                dto.setTimeline(List.of());
            }
        } else {
            dto.setTimeline(List.of());
        }

        return dto;
    }

    /**
     * 从 DTO 转换为实体对象
     */
    public static com.heritage.entity.Heritage toEntity(HeritageDTO dto) {
        com.heritage.entity.Heritage heritage = new com.heritage.entity.Heritage();
        heritage.setId(dto.getId());
        heritage.setName(dto.getName());
        heritage.setCategory(dto.getCategory());
        heritage.setRegion(dto.getRegion());
        heritage.setLevel(dto.getLevel());
        heritage.setInheritor(dto.getInheritor());
        heritage.setDescription(dto.getDescription());
        heritage.setDetailDescription(dto.getDetailDescription());
        heritage.setThumbnail(dto.getThumbnail());
        heritage.setVideo(dto.getVideo());
        heritage.setAudio(dto.getAudio());
        heritage.setLikes(dto.getLikes());
        heritage.setFavorites(dto.getFavorites());
        heritage.setViews(dto.getViews());
        heritage.setEnabled(dto.getEnabled());

        // 转换 images List<String> 为 JSON 字符串
        if (dto.getImages() != null && !dto.getImages().isEmpty()) {
            try {
                ObjectMapper mapper = new ObjectMapper();
                heritage.setImages(mapper.writeValueAsString(dto.getImages()));
            } catch (Exception e) {
                heritage.setImages("[]");
            }
        } else {
            heritage.setImages("[]");
        }

        // 转换 timeline List<TimelineItem> 为 JSON 字符串
        if (dto.getTimeline() != null && !dto.getTimeline().isEmpty()) {
            try {
                ObjectMapper mapper = new ObjectMapper();
                heritage.setTimeline(mapper.writeValueAsString(dto.getTimeline()));
            } catch (Exception e) {
                heritage.setTimeline("[]");
            }
        } else {
            heritage.setTimeline("[]");
        }

        return heritage;
    }
}