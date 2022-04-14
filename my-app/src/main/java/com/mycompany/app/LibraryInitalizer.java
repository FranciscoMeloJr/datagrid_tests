package com.mycompany.app;

import org.infinispan.protostream.GeneratedSchema;
import org.infinispan.protostream.SerializationContextInitializer;
import org.infinispan.protostream.annotations.AutoProtoSchemaBuilder;
import java.math.BigInteger;

@AutoProtoSchemaBuilder(includeClasses = { Author.class, Book.class, UUIDAdapter.class, java.math.BigInteger }, schemaFileName = "library.proto", schemaFilePath = "proto", schemaPackageName = "com.mycompany.app")
public interface LibraryInitalizer extends SerializationContextInitializer {

}