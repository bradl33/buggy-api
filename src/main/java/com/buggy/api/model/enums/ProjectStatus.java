package com.buggy.api.model.enums;

import lombok.Getter;

@Getter
public enum ProjectStatus {
    DEVELOPMENT("DEVELOPMENT"),
    PRODUCTION("PRODUCTION"),
    MAINTENANCE("MAINTENANCE"),
    ARCHIVED("ARCHIVED");

    private final String value;

    ProjectStatus(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
