
/*
USE master; 
GO 
CREATE DATABASE SampleDb  
ON      ( NAME = SampleDb_dat, FILENAME = 'C:\data\SampleDb.mdf') 
LOG ON  ( NAME = SampleDb_log, FILENAME = 'C:\data\SampleDb.ldf'); 
GO
--*/

USE [SampleDb]
GO

IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [SystemUsers] (
    [Id] int NOT NULL IDENTITY,
    [FirstName] nvarchar(max) NOT NULL,
    [LastName] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_SystemUsers] PRIMARY KEY ([Id])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230818184803_InitialMigration', N'7.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT INTO [SystemUsers] ([FirstName],[LastName]) VALUES ('Aftab','Ahmad');INSERT INTO [SystemUsers] ([FirstName],[LastName]) VALUES ('Usman','Nisar');
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230818185536_InitialData', N'7.0.10');
GO

COMMIT;
GO

