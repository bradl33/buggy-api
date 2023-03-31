package com.buggy.api.model.enums;

import lombok.Getter;

@Getter
public enum BugStatus {
    NEW("NEW"),
    OPEN("OPEN"),
    ASSIGNED("ASSIGNED"),
    IN_PROGRESS("IN_PROGRESS"),
    TESTING("TESTING"),
    VERIFIED("VERIFIED"),
    CLOSED("CLOSED"),
    REOPENED("REOPENED");

    private final String value;

    BugStatus(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
