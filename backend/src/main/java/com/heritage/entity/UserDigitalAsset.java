package com.heritage.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "user_digital_asset", uniqueConstraints = {
        @UniqueConstraint(name = "uk_user_item", columnNames = {"user_id", "item_id"}),
        @UniqueConstraint(name = "uk_item_edition", columnNames = {"item_id", "edition_no"})
})
public class UserDigitalAsset {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "item_id", nullable = false)
    private Long itemId;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 50)
    private String serial;

    @Column(name = "edition_no")
    private Integer editionNo;


    @Column(length = 100)
    private String origin;

    @Column(length = 500)
    private String cover;

    @Column(length = 20)
    private String rarity;

    @Column(name = "rarity_class", length = 20)
    private String rarityClass;

    @Column(length = 20)
    private String source;

    @Column(name = "owned_at", length = 30)
    private String ownedAt;

    @Column(name = "token_uri", columnDefinition = "TEXT")
    private String tokenUri;

    @Column(name = "token_id", length = 80)
    private String tokenId;

    @Column(name = "tx_hash", nullable = false, length = 100)
    private String txHash;

    @Column(name = "block_number", length = 30)
    private String blockNumber;

    @Column(name = "contract_address", nullable = false, length = 50)
    private String contractAddress;

    @Column(name = "chain_name", nullable = false, length = 30)
    private String chain = "Sepolia";

    @Column(name = "explorer_url", length = 255)
    private String explorerUrl;

    @Column(name = "on_chain", nullable = false)
    private Boolean onChain = true;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
}
