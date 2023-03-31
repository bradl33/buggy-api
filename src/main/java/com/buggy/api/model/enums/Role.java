package com.buggy.api.model.enums;

import lombok.Getter;

@Getter
public enum Role {
    PROJECT_MANAGER("PROJECT_MANAGER"),
    QA("QA"),
    DEVELOPER("DEVELOPER"),
    CLIENT("CLIENT");

    private final String value;

    Role(String value) {
        this.value = value;
    }

    public String getValue(){
        return value;
    }
}
