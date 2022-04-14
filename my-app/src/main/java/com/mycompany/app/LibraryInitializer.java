package com.mycompany.app;

import org.infinispan.protostream.GeneratedSchema;
import org.infinispan.protostream.annotations.AutoProtoSchemaBuilder;

@AutoProtoSchemaBuilder(includeClasses = { Author.class, Book.class, UUIDAdaptor.class, java.math.BigInteger }, schemaFileName = "library.proto", schemaFilePath = "proto", schemaPackageName = "library")
public interface LibraryInitalizer extends SerializationContextInitializer {

}