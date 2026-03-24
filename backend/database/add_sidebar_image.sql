USE heritage_platform;

ALTER TABLE heritage
  ADD COLUMN sidebar_image VARCHAR(500) NULL COMMENT '侧栏图URL' AFTER audio;
