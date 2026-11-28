-- MM-Arrival PMS procedure bundle (generated from DatabaseMigrator; do not edit by hand).
-- catalog-version: 4
-- @@mmarrival:batch picture
IF DB_ID('SMILE_PICTURE') IS NULL
            CREATE DATABASE SMILE_PICTURE
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.objects WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND type = 'U')
        BEGIN
            CREATE TABLE SMILE_PICTURE.dbo.FontDeskSignture (
                Seq                                   BIGINT        NOT NULL IDENTITY(1,1) PRIMARY KEY,
                FolioNum                              DECIMAL(18,0) NULL,
                IdAddition                            DECIMAL(18,0) NULL,
                FOGuestCheck                          INT           NULL,
                SignatureGuest                        IMAGE         NULL,
                SignaturePath                         VARCHAR(500)  NULL,
                FOHouseKeeping                        INT           NULL,
                SignatureHouseKeeping                 IMAGE         NULL,
                SignatureHouseKeepingPath             VARCHAR(500)  NULL,
                FODeposit                             INT           NULL,
                SignatureDeposit                      IMAGE         NULL,
                SignatureDepositPath                  VARCHAR(500)  NULL,
                FOGroupConfirmation                   INT           NULL,
                SignatureGroupConfirmation            IMAGE         NULL,
                SignatureGroupConfirmationPath        VARCHAR(500)  NULL,
                FOConfirmation                        INT           NULL,
                SignatureConfirmation                 IMAGE         NULL,
                SignatureConfirmationPath             VARCHAR(500)  NULL,
                FORegistrationCard                    INT           NULL,
                SignatureRegistrationCard             IMAGE         NULL,
                SignatureRegistrationCardPath         VARCHAR(500)  NULL,
                FORegistrationCardName                NVARCHAR(MAX) NULL,
                FORegistrationCardCreateDate          DATETIME      NULL,
                FORegistrationCard_CheckOut           INT           NULL,
                SignatureRegistrationCard_CO          IMAGE         NULL,
                SignatureRegistrationCardPath_CO      VARCHAR(500)  NULL,
                FORegistrationCardName_CO             NVARCHAR(MAX) NULL,
                FORegistrationCard_CHECKEDBY          INT           NULL,
                SignatureRegistrationCard_CHECKEDBY   IMAGE         NULL,
                SignatureRegistrationCardPath_CHECKEDBY VARCHAR(500) NULL,
                FORegistrationCardName_CHECKEDBY      NVARCHAR(MAX) NULL,
                FORegistrationCardCreateDate_CHECKEDBY DATETIME     NULL,
                FORegistrationCardPath_CHECKEDBY      NVARCHAR(MAX) NULL,
                CreateDate                            DATETIME      NOT NULL DEFAULT GETDATE(),
                HotelID                               VARCHAR(30)   NULL
            );
            CREATE INDEX IX_FontDeskSignture_FolioNum   ON SMILE_PICTURE.dbo.FontDeskSignture (FolioNum);
            CREATE INDEX IX_FontDeskSignture_IdAddition ON SMILE_PICTURE.dbo.FontDeskSignture (IdAddition);
        END
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.objects WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.ProfilePicture') AND type = 'U')
        BEGIN
            CREATE TABLE SMILE_PICTURE.dbo.ProfilePicture (
                Id            BIGINT        NOT NULL IDENTITY(1,1) PRIMARY KEY,
                FolioNum      DECIMAL(18,0) NOT NULL,
                IdAddition    DECIMAL(18,0) NOT NULL,
                ProfileNumber DECIMAL(18,0) NULL,
                PictureType   NVARCHAR(20)  NOT NULL,
                ImageData     IMAGE         NULL,
                ImagePath     NVARCHAR(500) NULL,
                MimeType      NVARCHAR(50)  NULL,
                UploadedAt    DATETIME2(0)  NOT NULL CONSTRAINT DF_ProfilePicture_UploadedAt DEFAULT (SYSUTCDATETIME()),
                HotelID       VARCHAR(30)   NULL
            );
            CREATE INDEX IX_ProfilePicture_Folio   ON SMILE_PICTURE.dbo.ProfilePicture (FolioNum, IdAddition);
            CREATE INDEX IX_ProfilePicture_Profile ON SMILE_PICTURE.dbo.ProfilePicture (ProfileNumber);
            CREATE INDEX IX_ProfilePicture_Type    ON SMILE_PICTURE.dbo.ProfilePicture (PictureType, UploadedAt DESC);
        END
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'FORegistrationCardName')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD FORegistrationCardName NVARCHAR(MAX) NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'FORegistrationCardName_CO')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD FORegistrationCardName_CO NVARCHAR(MAX) NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'FORegistrationCardCreateDate_CHECKEDBY')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD FORegistrationCardCreateDate_CHECKEDBY DATETIME NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'FORegistrationCardPath_CHECKEDBY')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD FORegistrationCardPath_CHECKEDBY NVARCHAR(MAX) NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'FORegistrationCardName_CHECKEDBY')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD FORegistrationCardName_CHECKEDBY NVARCHAR(MAX) NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'Seq')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD Seq BIGINT NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'SignatureGuest')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD SignatureGuest IMAGE NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'SignaturePath')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD SignaturePath VARCHAR(500) NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'SignatureRegistrationCard')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD SignatureRegistrationCard IMAGE NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'SignatureRegistrationCardPath')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD SignatureRegistrationCardPath VARCHAR(500) NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'SignatureRegistrationCard_CO')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD SignatureRegistrationCard_CO IMAGE NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'SignatureRegistrationCardPath_CO')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD SignatureRegistrationCardPath_CO VARCHAR(500) NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'SignatureRegistrationCard_CHECKEDBY')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD SignatureRegistrationCard_CHECKEDBY IMAGE NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'SignatureRegistrationCardPath_CHECKEDBY')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD SignatureRegistrationCardPath_CHECKEDBY VARCHAR(500) NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'FORegistrationCard_CheckOut')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD FORegistrationCard_CheckOut DECIMAL(18,0) NULL
-- @@mmarrival:batch picture
IF NOT EXISTS (SELECT 1 FROM SMILE_PICTURE.sys.columns WHERE object_id = OBJECT_ID('SMILE_PICTURE.dbo.FontDeskSignture') AND name = 'FORegistrationCard_CHECKEDBY')
            ALTER TABLE SMILE_PICTURE.dbo.FontDeskSignture ADD FORegistrationCard_CHECKEDBY DECIMAL(18,0) NULL
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.UnicodeToTCVN', 'FN') IS NULL
EXEC('CREATE FUNCTION dbo.UnicodeToTCVN(@s NVARCHAR(4000))
RETURNS VARCHAR(4000)
AS
BEGIN
    IF @s IS NULL RETURN NULL;
    DECLARE @out VARCHAR(4000) = '''';
    DECLARE @i INT = 1, @n INT = DATALENGTH(@s) / 2, @cp INT;
    WHILE @i <= @n
    BEGIN
        SET @cp = UNICODE(SUBSTRING(@s, @i, 1));
        SET @out = @out +
            CASE @cp
                WHEN 192 THEN CHAR(161)
                WHEN 193 THEN CHAR(162)
                WHEN 195 THEN CHAR(163)
                WHEN 224 THEN CHAR(181)
                WHEN 225 THEN CHAR(184)
                WHEN 226 THEN CHAR(169)
                WHEN 227 THEN CHAR(182)
                WHEN 232 THEN CHAR(204)
                WHEN 233 THEN CHAR(208)
                WHEN 234 THEN CHAR(170)
                WHEN 236 THEN CHAR(215)
                WHEN 237 THEN CHAR(221)
                WHEN 242 THEN CHAR(223)
                WHEN 243 THEN CHAR(227)
                WHEN 244 THEN CHAR(171)
                WHEN 245 THEN CHAR(225)
                WHEN 249 THEN CHAR(239)
                WHEN 250 THEN CHAR(243)
                WHEN 253 THEN CHAR(253)
                WHEN 258 THEN CHAR(167)
                WHEN 259 THEN CHAR(168)
                WHEN 272 THEN CHAR(166)
                WHEN 273 THEN CHAR(174)
                WHEN 297 THEN CHAR(220)
                WHEN 361 THEN CHAR(242)
                WHEN 417 THEN CHAR(172)
                WHEN 432 THEN CHAR(173)
                WHEN 7840 THEN CHAR(165)
                WHEN 7841 THEN CHAR(185)
                WHEN 7842 THEN CHAR(164)
                WHEN 7843 THEN CHAR(183)
                WHEN 7845 THEN CHAR(202)
                WHEN 7847 THEN CHAR(199)
                WHEN 7849 THEN CHAR(200)
                WHEN 7851 THEN CHAR(201)
                WHEN 7853 THEN CHAR(203)
                WHEN 7855 THEN CHAR(190)
                WHEN 7857 THEN CHAR(187)
                WHEN 7859 THEN CHAR(189)
                WHEN 7861 THEN CHAR(188)
                WHEN 7863 THEN CHAR(198)
                WHEN 7865 THEN CHAR(209)
                WHEN 7867 THEN CHAR(207)
                WHEN 7869 THEN CHAR(206)
                WHEN 7871 THEN CHAR(213)
                WHEN 7873 THEN CHAR(210)
                WHEN 7875 THEN CHAR(211)
                WHEN 7877 THEN CHAR(212)
                WHEN 7879 THEN CHAR(214)
                WHEN 7881 THEN CHAR(216)
                WHEN 7883 THEN CHAR(222)
                WHEN 7885 THEN CHAR(228)
                WHEN 7887 THEN CHAR(224)
                WHEN 7889 THEN CHAR(232)
                WHEN 7891 THEN CHAR(229)
                WHEN 7893 THEN CHAR(230)
                WHEN 7895 THEN CHAR(231)
                WHEN 7897 THEN CHAR(233)
                WHEN 7899 THEN CHAR(237)
                WHEN 7901 THEN CHAR(234)
                WHEN 7903 THEN CHAR(235)
                WHEN 7905 THEN CHAR(236)
                WHEN 7907 THEN CHAR(238)
                WHEN 7909 THEN CHAR(244)
                WHEN 7911 THEN CHAR(241)
                WHEN 7913 THEN CHAR(248)
                WHEN 7915 THEN CHAR(245)
                WHEN 7917 THEN CHAR(246)
                WHEN 7919 THEN CHAR(247)
                WHEN 7921 THEN CHAR(249)
                WHEN 7923 THEN CHAR(250)
                WHEN 7925 THEN CHAR(254)
                WHEN 7927 THEN CHAR(251)
                WHEN 7929 THEN CHAR(252)
                WHEN 194 THEN CHAR(65)+CHAR(169)
                WHEN 200 THEN CHAR(69)+CHAR(204)
                WHEN 201 THEN CHAR(69)+CHAR(208)
                WHEN 202 THEN CHAR(69)+CHAR(170)
                WHEN 204 THEN CHAR(73)+CHAR(215)
                WHEN 205 THEN CHAR(73)+CHAR(221)
                WHEN 210 THEN CHAR(79)+CHAR(223)
                WHEN 211 THEN CHAR(79)+CHAR(227)
                WHEN 212 THEN CHAR(79)+CHAR(171)
                WHEN 213 THEN CHAR(79)+CHAR(225)
                WHEN 217 THEN CHAR(85)+CHAR(239)
                WHEN 218 THEN CHAR(85)+CHAR(243)
                WHEN 221 THEN CHAR(89)+CHAR(253)
                WHEN 296 THEN CHAR(73)+CHAR(220)
                WHEN 360 THEN CHAR(85)+CHAR(242)
                WHEN 416 THEN CHAR(79)+CHAR(172)
                WHEN 431 THEN CHAR(85)+CHAR(173)
                WHEN 7844 THEN CHAR(65)+CHAR(202)
                WHEN 7846 THEN CHAR(65)+CHAR(199)
                WHEN 7848 THEN CHAR(65)+CHAR(200)
                WHEN 7850 THEN CHAR(65)+CHAR(201)
                WHEN 7852 THEN CHAR(65)+CHAR(203)
                WHEN 7854 THEN CHAR(65)+CHAR(190)
                WHEN 7856 THEN CHAR(65)+CHAR(187)
                WHEN 7858 THEN CHAR(65)+CHAR(189)
                WHEN 7860 THEN CHAR(65)+CHAR(188)
                WHEN 7862 THEN CHAR(65)+CHAR(198)
                WHEN 7864 THEN CHAR(69)+CHAR(209)
                WHEN 7866 THEN CHAR(69)+CHAR(207)
                WHEN 7868 THEN CHAR(69)+CHAR(206)
                WHEN 7870 THEN CHAR(69)+CHAR(213)
                WHEN 7872 THEN CHAR(69)+CHAR(210)
                WHEN 7874 THEN CHAR(69)+CHAR(211)
                WHEN 7876 THEN CHAR(69)+CHAR(212)
                WHEN 7878 THEN CHAR(69)+CHAR(214)
                WHEN 7880 THEN CHAR(73)+CHAR(216)
                WHEN 7882 THEN CHAR(73)+CHAR(222)
                WHEN 7884 THEN CHAR(79)+CHAR(228)
                WHEN 7886 THEN CHAR(79)+CHAR(224)
                WHEN 7888 THEN CHAR(79)+CHAR(232)
                WHEN 7890 THEN CHAR(79)+CHAR(229)
                WHEN 7892 THEN CHAR(79)+CHAR(230)
                WHEN 7894 THEN CHAR(79)+CHAR(231)
                WHEN 7896 THEN CHAR(79)+CHAR(233)
                WHEN 7898 THEN CHAR(79)+CHAR(237)
                WHEN 7900 THEN CHAR(79)+CHAR(234)
                WHEN 7902 THEN CHAR(79)+CHAR(235)
                WHEN 7904 THEN CHAR(79)+CHAR(236)
                WHEN 7906 THEN CHAR(79)+CHAR(238)
                WHEN 7908 THEN CHAR(85)+CHAR(244)
                WHEN 7910 THEN CHAR(85)+CHAR(241)
                WHEN 7912 THEN CHAR(85)+CHAR(248)
                WHEN 7914 THEN CHAR(85)+CHAR(245)
                WHEN 7916 THEN CHAR(85)+CHAR(246)
                WHEN 7918 THEN CHAR(85)+CHAR(247)
                WHEN 7920 THEN CHAR(85)+CHAR(249)
                WHEN 7922 THEN CHAR(89)+CHAR(250)
                WHEN 7924 THEN CHAR(89)+CHAR(254)
                WHEN 7926 THEN CHAR(89)+CHAR(251)
                WHEN 7928 THEN CHAR(89)+CHAR(252)
                ELSE CONVERT(VARCHAR(4), SUBSTRING(@s, @i, 1))
            END;
        SET @i = @i + 1;
    END
    RETURN @out;
END')
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.fTCVNToUnicode', 'FN') IS NULL
EXEC('CREATE FUNCTION dbo.fTCVNToUnicode(@s VARCHAR(4000))
RETURNS NVARCHAR(4000)
AS
BEGIN
    IF @s IS NULL RETURN NULL;
    DECLARE @out NVARCHAR(4000) = N'''';
    DECLARE @i INT = 1, @n INT = DATALENGTH(@s), @b INT, @b2 INT, @up INT;
    WHILE @i <= @n
    BEGIN
        SET @b = ASCII(SUBSTRING(@s, @i, 1));
        SET @up = NULL;
        IF @b IN (65,69,73,79,85,89) AND @i < @n
        BEGIN
            SET @b2 = ASCII(SUBSTRING(@s, @i + 1, 1));
            SET @up =
                CASE (@b * 256 + @b2)
                    WHEN 16809 THEN 194
                    WHEN 17868 THEN 200
                    WHEN 17872 THEN 201
                    WHEN 17834 THEN 202
                    WHEN 18903 THEN 204
                    WHEN 18909 THEN 205
                    WHEN 20447 THEN 210
                    WHEN 20451 THEN 211
                    WHEN 20395 THEN 212
                    WHEN 20449 THEN 213
                    WHEN 21999 THEN 217
                    WHEN 22003 THEN 218
                    WHEN 23037 THEN 221
                    WHEN 18908 THEN 296
                    WHEN 22002 THEN 360
                    WHEN 20396 THEN 416
                    WHEN 21933 THEN 431
                    WHEN 16842 THEN 7844
                    WHEN 16839 THEN 7846
                    WHEN 16840 THEN 7848
                    WHEN 16841 THEN 7850
                    WHEN 16843 THEN 7852
                    WHEN 16830 THEN 7854
                    WHEN 16827 THEN 7856
                    WHEN 16829 THEN 7858
                    WHEN 16828 THEN 7860
                    WHEN 16838 THEN 7862
                    WHEN 17873 THEN 7864
                    WHEN 17871 THEN 7866
                    WHEN 17870 THEN 7868
                    WHEN 17877 THEN 7870
                    WHEN 17874 THEN 7872
                    WHEN 17875 THEN 7874
                    WHEN 17876 THEN 7876
                    WHEN 17878 THEN 7878
                    WHEN 18904 THEN 7880
                    WHEN 18910 THEN 7882
                    WHEN 20452 THEN 7884
                    WHEN 20448 THEN 7886
                    WHEN 20456 THEN 7888
                    WHEN 20453 THEN 7890
                    WHEN 20454 THEN 7892
                    WHEN 20455 THEN 7894
                    WHEN 20457 THEN 7896
                    WHEN 20461 THEN 7898
                    WHEN 20458 THEN 7900
                    WHEN 20459 THEN 7902
                    WHEN 20460 THEN 7904
                    WHEN 20462 THEN 7906
                    WHEN 22004 THEN 7908
                    WHEN 22001 THEN 7910
                    WHEN 22008 THEN 7912
                    WHEN 22005 THEN 7914
                    WHEN 22006 THEN 7916
                    WHEN 22007 THEN 7918
                    WHEN 22009 THEN 7920
                    WHEN 23034 THEN 7922
                    WHEN 23038 THEN 7924
                    WHEN 23035 THEN 7926
                    WHEN 23036 THEN 7928
                    ELSE NULL
                END;
        END
        IF @up IS NOT NULL
        BEGIN
            SET @out = @out + NCHAR(@up);
            SET @i = @i + 2;
        END
        ELSE
        BEGIN
            SET @out = @out +
                CASE @b
                WHEN 161 THEN NCHAR(192)
                WHEN 162 THEN NCHAR(193)
                WHEN 163 THEN NCHAR(195)
                WHEN 164 THEN NCHAR(7842)
                WHEN 165 THEN NCHAR(7840)
                WHEN 166 THEN NCHAR(272)
                WHEN 167 THEN NCHAR(258)
                WHEN 168 THEN NCHAR(259)
                WHEN 169 THEN NCHAR(226)
                WHEN 170 THEN NCHAR(234)
                WHEN 171 THEN NCHAR(244)
                WHEN 172 THEN NCHAR(417)
                WHEN 173 THEN NCHAR(432)
                WHEN 174 THEN NCHAR(273)
                WHEN 181 THEN NCHAR(224)
                WHEN 182 THEN NCHAR(227)
                WHEN 183 THEN NCHAR(7843)
                WHEN 184 THEN NCHAR(225)
                WHEN 185 THEN NCHAR(7841)
                WHEN 187 THEN NCHAR(7857)
                WHEN 188 THEN NCHAR(7861)
                WHEN 189 THEN NCHAR(7859)
                WHEN 190 THEN NCHAR(7855)
                WHEN 198 THEN NCHAR(7863)
                WHEN 199 THEN NCHAR(7847)
                WHEN 200 THEN NCHAR(7849)
                WHEN 201 THEN NCHAR(7851)
                WHEN 202 THEN NCHAR(7845)
                WHEN 203 THEN NCHAR(7853)
                WHEN 204 THEN NCHAR(232)
                WHEN 206 THEN NCHAR(7869)
                WHEN 207 THEN NCHAR(7867)
                WHEN 208 THEN NCHAR(233)
                WHEN 209 THEN NCHAR(7865)
                WHEN 210 THEN NCHAR(7873)
                WHEN 211 THEN NCHAR(7875)
                WHEN 212 THEN NCHAR(7877)
                WHEN 213 THEN NCHAR(7871)
                WHEN 214 THEN NCHAR(7879)
                WHEN 215 THEN NCHAR(236)
                WHEN 216 THEN NCHAR(7881)
                WHEN 220 THEN NCHAR(297)
                WHEN 221 THEN NCHAR(237)
                WHEN 222 THEN NCHAR(7883)
                WHEN 223 THEN NCHAR(242)
                WHEN 224 THEN NCHAR(7887)
                WHEN 225 THEN NCHAR(245)
                WHEN 227 THEN NCHAR(243)
                WHEN 228 THEN NCHAR(7885)
                WHEN 229 THEN NCHAR(7891)
                WHEN 230 THEN NCHAR(7893)
                WHEN 231 THEN NCHAR(7895)
                WHEN 232 THEN NCHAR(7889)
                WHEN 233 THEN NCHAR(7897)
                WHEN 234 THEN NCHAR(7901)
                WHEN 235 THEN NCHAR(7903)
                WHEN 236 THEN NCHAR(7905)
                WHEN 237 THEN NCHAR(7899)
                WHEN 238 THEN NCHAR(7907)
                WHEN 239 THEN NCHAR(249)
                WHEN 241 THEN NCHAR(7911)
                WHEN 242 THEN NCHAR(361)
                WHEN 243 THEN NCHAR(250)
                WHEN 244 THEN NCHAR(7909)
                WHEN 245 THEN NCHAR(7915)
                WHEN 246 THEN NCHAR(7917)
                WHEN 247 THEN NCHAR(7919)
                WHEN 248 THEN NCHAR(7913)
                WHEN 249 THEN NCHAR(7921)
                WHEN 250 THEN NCHAR(7923)
                WHEN 251 THEN NCHAR(7927)
                WHEN 252 THEN NCHAR(7929)
                WHEN 253 THEN NCHAR(253)
                WHEN 254 THEN NCHAR(7925)
                    ELSE SUBSTRING(@s, @i, 1)
                END;
            SET @i = @i + 1;
        END
    END
    RETURN @out;
END')
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Clerk') AND name = 'TouchPass')
            ALTER TABLE dbo.Clerk ADD TouchPass NVARCHAR(50) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Clerk') AND name = 'Signture')
            ALTER TABLE dbo.Clerk ADD Signture NVARCHAR(500) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Clerk') AND name = 'DeleteFlag')
            ALTER TABLE dbo.Clerk ADD DeleteFlag BIT NULL DEFAULT 0
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Folio') AND name = 'CIOnlineFlag')
            ALTER TABLE dbo.Folio ADD CIOnlineFlag INT NULL DEFAULT 0
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Folio') AND name = 'IsSendMail')
            ALTER TABLE dbo.Folio ADD IsSendMail INT NULL DEFAULT 0
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Folio') AND name = 'CruiseCode')
            ALTER TABLE dbo.Folio ADD CruiseCode VARCHAR(20) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.RoomType') AND name = 'CIImage')
            ALTER TABLE dbo.RoomType ADD CIImage NVARCHAR(MAX) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelName')
            ALTER TABLE dbo.HotelParameter ADD HotelName NVARCHAR(200) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelAddress')
            ALTER TABLE dbo.HotelParameter ADD HotelAddress NVARCHAR(200) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelCity')
            ALTER TABLE dbo.HotelParameter ADD HotelCity NVARCHAR(100) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelState')
            ALTER TABLE dbo.HotelParameter ADD HotelState NVARCHAR(100) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelZipCode')
            ALTER TABLE dbo.HotelParameter ADD HotelZipCode NVARCHAR(20) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelCountry')
            ALTER TABLE dbo.HotelParameter ADD HotelCountry NVARCHAR(100) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelPhone')
            ALTER TABLE dbo.HotelParameter ADD HotelPhone NVARCHAR(50) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelFax')
            ALTER TABLE dbo.HotelParameter ADD HotelFax NVARCHAR(50) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelEmail')
            ALTER TABLE dbo.HotelParameter ADD HotelEmail NVARCHAR(200) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'HotelWebSite')
            ALTER TABLE dbo.HotelParameter ADD HotelWebSite NVARCHAR(200) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'CheckInTime')
            ALTER TABLE dbo.HotelParameter ADD CheckInTime NVARCHAR(10) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'CheckOutTime')
            ALTER TABLE dbo.HotelParameter ADD CheckOutTime NVARCHAR(10) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'CurrencyCode')
            ALTER TABLE dbo.HotelParameter ADD CurrencyCode VARCHAR(10) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'CurrencySymbol')
            ALTER TABLE dbo.HotelParameter ADD CurrencySymbol NVARCHAR(10) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'VATCode')
            ALTER TABLE dbo.HotelParameter ADD VATCode NVARCHAR(50) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.HotelParameter') AND name = 'VATPercent')
            ALTER TABLE dbo.HotelParameter ADD VATPercent DECIMAL(5,2) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.FolioTransaction') AND name = 'Qty')
            ALTER TABLE dbo.FolioTransaction ADD Qty DECIMAL(18,2) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.FolioTransaction') AND name = 'UnitPrice')
            ALTER TABLE dbo.FolioTransaction ADD UnitPrice DECIMAL(18,2) NULL
-- @@mmarrival:batch pms
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.FolioTransaction') AND name = 'FolioTransNum')
            ALTER TABLE dbo.FolioTransaction ADD FolioTransNum INT NULL
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_LoginUser', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_LoginUser
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_LoginUser
    @ClerkID  VARCHAR(30),
    @Password VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @HotelDate DATETIME, @ResultClerk VARCHAR(30)='', @EmployeeName VARCHAR(100)='', @Position NVARCHAR(100)='', @SecurityLevel INT=99, @Result INT=0, @ResultMes VARCHAR(200)='';
    IF ISNULL(@ClerkID,'')='' OR ISNULL(@Password,'')=''
    BEGIN SET @Result=400; SET @ResultMes='Username and password are required.'; END
    ELSE
    BEGIN
        SELECT TOP 1 @ResultClerk=ISNULL(ClerkID,''), @EmployeeName=ISNULL(LastName,''), @Position=ISNULL(Position,''), @SecurityLevel=ISNULL(SecurityLevel,99)
        FROM dbo.Clerk WITH (NOLOCK) WHERE ClerkID=@ClerkID AND SecurityCode=@Password AND ISNULL(DisabledFlag,0)=0;
        IF ISNULL(@ResultClerk,'')=''
        BEGIN SET @Result=400; SET @ResultMes='Oops! It seems like your username or password is incorrect. Please check and try again!'; END
        ELSE
        BEGIN SET @Result=200; SET @ResultMes='Login successful. The system is ready for you to use.'; END
    END
    SELECT TOP 1 HotelDate, AuditorDate, ReportDate, @Result AS Result, @ResultMes AS ResultMes, @ResultClerk AS ClerkID, @EmployeeName AS EmployeeName, @Position AS Position, @SecurityLevel AS SecurityLevel
    FROM dbo.HotelParameter WITH (NOLOCK);
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetCIOnlineSettings', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetCIOnlineSettings
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetCIOnlineSettings AS BEGIN SET NOCOUNT ON;
    SELECT SettingName, SettingValue, SettingDescription, TitleSetting FROM (VALUES
    ('CIOnlineShowRoom',(SELECT TOP 1 ISNULL(ParaString,'0') FROM dbo.GlobalParameter WITH (NOLOCK) WHERE ParaName='C.IOnlShowRoom'),'Indicates if the room number should be hidden during online check-in.','Hide Room Number')
    ) AS t(SettingName,SettingValue,SettingDescription,TitleSetting); END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_UpdateCIOnlineSetting', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_UpdateCIOnlineSetting
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_UpdateCIOnlineSetting @SettingName NVARCHAR(50), @SettingValue NVARCHAR(50) AS BEGIN SET NOCOUNT ON;
    DECLARE @ParaName NVARCHAR(50)=CASE @SettingName WHEN 'CIOnlineShowRoom' THEN 'C.IOnlShowRoom' ELSE @SettingName END;
    UPDATE dbo.GlobalParameter SET ParaString=@SettingValue WHERE ParaName=@ParaName; SELECT @@ROWCOUNT AS AffectedRows; END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_PortalSearchByConfirm', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_PortalSearchByConfirm
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_PortalSearchByConfirm
    @ConfirmNum  VARCHAR(50) = '0'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @HotelDate DATETIME;
    SELECT TOP 1 @HotelDate = HotelDate FROM dbo.HotelParameter WITH (NOLOCK);

    DECLARE @SConfirmNum DECIMAL(18,0) = 0;

    -- External booking reference (OTA / channel) is free-text, matched case-insensitively
    -- with whitespace collapsed (not just trimmed) - OTA copy/paste and older PMS interface
    -- rows are not guaranteed clean. UPPER() + explicit collation makes the match independent
    -- of server/column collation, and the space-collapse loop normalizes runs of internal
    -- whitespace (tabs, double spaces) without touching the stored value.
    -- Sentinel '' for empty/'0'/whitespace so it can never match a blank ExternalConfirmNumber.
    DECLARE @ExtNum VARCHAR(50) = UPPER(LTRIM(RTRIM(ISNULL(@ConfirmNum, ''))));
    SET @ExtNum = REPLACE(REPLACE(REPLACE(@ExtNum, CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' ');
    WHILE CHARINDEX('  ', @ExtNum) > 0
        SET @ExtNum = REPLACE(@ExtNum, '  ', ' ');
    IF @ExtNum = '0' SET @ExtNum = '';

    -- Phone / name fallback: match reserved folios only, no date restriction.
    -- Length check uses the trimmed value so accidental leading/trailing whitespace from
    -- copy/paste can't push a phone-length input into the ConfirmNum numeric branch below.
    DECLARE @TrimmedConfirmNum VARCHAR(50) = LTRIM(RTRIM(ISNULL(@ConfirmNum, '')));
    IF LEN(@TrimmedConfirmNum) > 9
    BEGIN
        SELECT TOP 1 @SConfirmNum = ISNULL(ConfirmNum, 0)
        FROM dbo.Folio WITH (NOLOCK)
        WHERE FolioStatus = 1 AND RoomTypeCode <> '**' AND ISNULL(CancelNum, 0) = 0
          AND (
              REPLACE(REPLACE(REPLACE(REPLACE(TelNumM,'(',''),')',''),' ',''),'-','') = @TrimmedConfirmNum
              OR Booker = @TrimmedConfirmNum
          )
        ORDER BY FolioNum DESC;

        IF ISNULL(@SConfirmNum, 0) = 0
            SELECT TOP 1 @SConfirmNum = ISNULL(A.ConfirmNum, 0)
            FROM dbo.AdditionalName A WITH (NOLOCK)
            LEFT JOIN dbo.Folio B WITH (NOLOCK) ON A.FolioNum = B.FolioNum
            WHERE A.AdtStatus = 1 AND ISNULL(B.CancelNum, 0) = 0
              AND B.FolioStatus = 1
              AND REPLACE(REPLACE(REPLACE(REPLACE(A.TeleNum,'(',''),')',''),' ',''),'-','') = @TrimmedConfirmNum;
    END
    ELSE
        SET @SConfirmNum = CASE WHEN ISNUMERIC(@TrimmedConfirmNum) = 1 THEN CAST(@TrimmedConfirmNum AS DECIMAL(18,0)) END;

    -- Every folio the typed value points at, found in ONE read of Folio: the confirmation number or the
    -- external (OTA) reference. The reference match wraps the column in UPPER/LTRIM/RTRIM so it cannot
    -- seek; with a ConfirmNum index the optimizer may still seek that half, without one this is a single
    -- scan. (Before, the same predicate was repeated in four statements, i.e. up to four Folio reads.)
    -- No speed-up beyond that is claimed: it needs an index on ExternalConfirmNumber, which we do not own.
    DECLARE @Hit TABLE (FolioNum DECIMAL(18,0) NOT NULL);
    INSERT INTO @Hit (FolioNum)
    SELECT DISTINCT F.FolioNum FROM dbo.Folio F WITH (NOLOCK)
    WHERE F.ConfirmNum = @SConfirmNum
       OR (@ExtNum <> '' AND UPPER(LTRIM(RTRIM(F.ExternalConfirmNumber))) COLLATE Latin1_General_CI_AS = @ExtNum COLLATE Latin1_General_CI_AS);

    -- Folio-number fallback: hotels hand guests the folio number as often as the confirmation
    -- number. It applies only when the typed number is no booking's confirmation (or external)
    -- number (no hit above), so a confirmation number never also pulls in an unrelated booking whose
    -- folio number happens to be the same.
    IF ISNULL(@SConfirmNum, 0) > 0 AND NOT EXISTS (SELECT 1 FROM @Hit)
        INSERT INTO @Hit (FolioNum)
        SELECT F.FolioNum FROM dbo.Folio F WITH (NOLOCK) WHERE F.FolioNum = @SConfirmNum;

    -- One row per folio: guest (AdditionalName) list is fetched separately via
    -- fetchGuestNames(folioNum) when the guest selects a folio, so it must NOT
    -- be joined here — a LEFT JOIN to AdditionalName duplicates the folio row
    -- once per companion guest and shows the same folio multiple times.
    SELECT TOP 100
        F.FolioNum, F.ConfirmNum,
        dbo.fTCVNToUnicode(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'')) AS Booker,
        ISNULL(F.GroupCode,'')  AS GroupCode,
        ISNULL(F.NumAdult, 0)  AS NumAdult,
        ISNULL(F.NumChild, 0)  AS NumChild,
        ISNULL(F.NumEnf,   0)  AS NumEnf,
        F.FolioStatus, F.ArrivalDate,
        @HotelDate              AS HotelDate,
        F.CIOnlineFlag          AS CheckInOnlFlag,
        NULL                    AS CheckInOnlineDate,
        F.DepartureDate, F.RoomCode, F.RoomTypeCode,
        ISNULL(RT.Description, F.RoomTypeCode) AS RoomTypeName,
        -- Booked room type (PMS "Bkd" next to "Actual Rm"): what the guest reserved, which is what
        -- the portal shows. Falls back to the actual type for folios saved without one.
        RB.RoomTypeBooked,
        ISNULL(RTB.Description, RB.RoomTypeBooked) AS RoomTypeBookedName
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
    CROSS APPLY (SELECT ISNULL(NULLIF(LTRIM(RTRIM(F.RoomTypeBooked)), ''), F.RoomTypeCode) AS RoomTypeBooked) RB
    LEFT JOIN dbo.RoomType RTB WITH (NOLOCK) ON RTB.RoomTypeCode = RB.RoomTypeBooked
    WHERE F.FolioNum IN (SELECT FolioNum FROM @Hit)
      AND F.RoomTypeCode <> '**'
      AND F.FolioStatus = 1
      AND ISNULL(F.CancelNum, 0) = 0
    ORDER BY F.ArrivalDate;

    -- Second result set: meta flags so the portal can distinguish
    --   (predicate matches internal ConfirmNum, the folio-number fallback OR external ExternalConfirmNumber)
    --   * not_found        — no folio with this ConfirmNum at all
    --   * already_checked_in — confirm exists but every folio is InHouse/CheckOut/Cancelled
    --   * ok               — at least one Reserved folio (RS1 has rows)
    -- Frontend uses these to show a more helpful message than 'not found'.
    -- NOTE: these two EXISTS checks intentionally omit the RoomTypeCode <> '**' filter that
    -- the main SELECT applies - a booking still awaiting room-type assignment in the PMS
    -- would otherwise fall through to a bare 'not_found' instead of a real status, even
    -- though the confirm number is valid and the guest typed it correctly.
    SELECT
        CASE WHEN EXISTS (SELECT 1 FROM @Hit) THEN 1 ELSE 0 END AS ConfirmExists,
        CASE WHEN EXISTS (
            SELECT 1 FROM dbo.Folio WITH (NOLOCK)
            WHERE FolioNum IN (SELECT FolioNum FROM @Hit)
              AND RoomTypeCode <> '**'
              AND FolioStatus IN (2,3) AND ISNULL(CancelNum,0) = 0
        ) THEN 1 ELSE 0 END AS HasCheckedIn;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_SearchAdvance', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_SearchAdvance
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_SearchAdvance
    @NoShow            BIT          = 0,
    @Reserved          BIT          = 0,
    @Canceled          BIT          = 0,
    @InHouse           BIT          = 0,
    @ArrivalToday      BIT          = 0,
    @CheckOutToday     BIT          = 0,
    @CheckOut          BIT          = 0,
    @sNumInfo          VARCHAR(50)  = '',
    @FirstName         VARCHAR(100) = '',
    @LastName          VARCHAR(100) = '',
    @CompanyID         VARCHAR(50)  = '',
    @GroupID           VARCHAR(50)  = '',
    @CountryID         VARCHAR(10)  = '',
    @RoomCode          VARCHAR(10)  = '',
    @ArrivalDateFrom   VARCHAR(20)  = '',
    @ArrivalDateTo     VARCHAR(20)  = '',
    @DepartureDateFrom VARCHAR(20)  = '',
    @DepartureDateTo   VARCHAR(20)  = '',
    @HotelDate         VARCHAR(20)  = '',
    @Exactly           BIT          = 0,
    @RoomType          VARCHAR(20)  = '',
    @MemberID          VARCHAR(50)  = '',
    @ExtCode           VARCHAR(50)  = '',
    @PageNumber        INT          = 1,
    @PageSize          INT          = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    DECLARE @HD DATETIME = ISNULL(CASE WHEN ISDATE(NULLIF(@HotelDate,'')) = 1 THEN CAST(NULLIF(@HotelDate,'') AS DATETIME) END, [dbo].[fnGetHotelDate]());
    -- Dapper sends SQL NULL when C# bool? = null (default when UI ticks no status box).
    -- Coalesce flags here so the OR-chain below does not collapse to UNKNOWN -> empty set.
    SET @NoShow        = ISNULL(@NoShow,        0);
    SET @Reserved      = ISNULL(@Reserved,      0);
    SET @Canceled      = ISNULL(@Canceled,      0);
    SET @InHouse       = ISNULL(@InHouse,       0);
    SET @ArrivalToday  = ISNULL(@ArrivalToday,  0);
    SET @CheckOutToday = ISNULL(@CheckOutToday, 0);
    SET @CheckOut      = ISNULL(@CheckOut,      0);
    SET @Exactly       = ISNULL(@Exactly,       0);
    DECLARE @AnyStatus BIT =
        CASE WHEN (CAST(@Reserved      AS INT) + CAST(@InHouse  AS INT)
                 + CAST(@CheckOut      AS INT) + CAST(@Canceled AS INT)
                 + CAST(@NoShow        AS INT) + CAST(@ArrivalToday AS INT)
                 + CAST(@CheckOutToday AS INT)) = 0
             THEN 1 ELSE 0 END;
    ;WITH __paged AS (
    SELECT
        F.FolioNum, F.ConfirmNum, F.FolioStatus,
        F.FirstName, F.LastName, F.TitleCodeM,
        F.ArrivalDate, F.DepartureDate,
        F.RoomCode, F.RoomTypeCode,
        RT.Description AS RoomTypeName,
        F.NumAdult, F.NumChild,
        F.RateAmount, F.FolioCurrencyCode,
        F.GroupCode, F.CancelNum,
        F.CompanyName, F.TelNumM, F.MailM,
        F.BookStatus, F.NoShowFlag, F.MemberID,
        A.NationalityCode,
        COUNT(*) OVER() AS TotalRows,
        ROW_NUMBER() OVER (ORDER BY F.ArrivalDate DESC, F.FolioNum DESC) AS __rn
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
    OUTER APPLY (
        SELECT TOP 1 A.NationalityCode
        FROM dbo.AdditionalName A WITH (NOLOCK)
        WHERE A.FolioNum = F.FolioNum AND A.IsChild = 0 AND ISNULL(A.ACancelNum,0) = 0
        ORDER BY A.IdAddition
    ) A
    WHERE
        (
               @AnyStatus     = 1
            OR (@Reserved      = 1 AND F.FolioStatus = 1 AND COALESCE(F.CancelNum,0)=0)
            OR (@InHouse       = 1 AND F.FolioStatus = 2 AND COALESCE(F.CancelNum,0)=0)
            OR (@CheckOut      = 1 AND F.FolioStatus = 3 AND COALESCE(F.CancelNum,0)=0)
            OR (@Canceled      = 1 AND COALESCE(F.CancelNum,0)>0)
            OR (@NoShow        = 1 AND ISNULL(F.NoShowFlag,0)=1 AND COALESCE(F.CancelNum,0)=0)
            OR (@ArrivalToday  = 1 AND F.ArrivalDate    = CAST(@HD AS DATE) AND F.FolioStatus=1 AND COALESCE(F.CancelNum,0)=0)
            OR (@CheckOutToday = 1 AND F.DepartureDate  = CAST(@HD AS DATE) AND F.FolioStatus=2 AND COALESCE(F.CancelNum,0)=0)
        )
        AND (
                ISNULL(@sNumInfo,'') = ''
             OR (
                  (CASE WHEN ISNUMERIC(@sNumInfo)=1 THEN CAST(@sNumInfo AS DECIMAL(18,0)) END) IS NOT NULL
                  AND (F.FolioNum = (CASE WHEN ISNUMERIC(@sNumInfo)=1 THEN CAST(@sNumInfo AS DECIMAL(18,0)) END)
                    OR F.ConfirmNum = (CASE WHEN ISNUMERIC(@sNumInfo)=1 THEN CAST(@sNumInfo AS DECIMAL(18,0)) END))
                )
            )
        AND (ISNULL(@FirstName,'') = '' OR EXISTS (
                SELECT 1 FROM dbo.AdditionalName AN WITH (NOLOCK)
                WHERE AN.FolioNum = F.FolioNum AND AN.IsChild = 0 AND ISNULL(AN.ACancelNum,0) = 0
                  AND ((@Exactly=1 AND AN.FirstName = @FirstName) OR (@Exactly=0 AND AN.FirstName LIKE '%'+@FirstName+'%'))
             ))
        AND (ISNULL(@LastName,'')  = '' OR EXISTS (
                SELECT 1 FROM dbo.AdditionalName AN WITH (NOLOCK)
                WHERE AN.FolioNum = F.FolioNum AND AN.IsChild = 0 AND ISNULL(AN.ACancelNum,0) = 0
                  AND ((@Exactly=1 AND AN.LastName = @LastName) OR (@Exactly=0 AND AN.LastName LIKE '%'+@LastName+'%'))
             ))
        AND (ISNULL(@CompanyID,'') = '' OR F.TravelAgent1Code = (CASE WHEN ISNUMERIC(@CompanyID)=1 THEN CAST(@CompanyID AS INT) END))
        AND (ISNULL(@GroupID,'')   = '' OR F.GroupCode  = @GroupID)
        AND (ISNULL(@CountryID,'') = '' OR EXISTS (
                SELECT 1 FROM dbo.AdditionalName AN WITH (NOLOCK)
                WHERE AN.FolioNum = F.FolioNum AND AN.IsChild = 0 AND ISNULL(AN.ACancelNum,0) = 0
                  AND AN.NationalityCode = @CountryID
             ))
        AND (ISNULL(@RoomCode,'')  = '' OR F.RoomCode   = @RoomCode)
        AND (ISNULL(@RoomType,'')  = '' OR F.RoomTypeCode = @RoomType)
        AND (ISNULL(@MemberID,'')  = '' OR F.MemberID   = @MemberID)
        AND (ISNULL(@ArrivalDateFrom,'')   = '' OR F.ArrivalDate   >= (CASE WHEN ISDATE(@ArrivalDateFrom)=1 THEN CAST(@ArrivalDateFrom AS DATE) END))
        AND (ISNULL(@ArrivalDateTo,'')     = '' OR F.ArrivalDate   <= (CASE WHEN ISDATE(@ArrivalDateTo)=1 THEN CAST(@ArrivalDateTo AS DATE) END))
        AND (ISNULL(@DepartureDateFrom,'') = '' OR F.DepartureDate >= (CASE WHEN ISDATE(@DepartureDateFrom)=1 THEN CAST(@DepartureDateFrom AS DATE) END))
        AND (ISNULL(@DepartureDateTo,'')   = '' OR F.DepartureDate <= (CASE WHEN ISDATE(@DepartureDateTo)=1 THEN CAST(@DepartureDateTo AS DATE) END))
    )
    SELECT
        FolioNum, ConfirmNum, FolioStatus,
        FirstName, LastName, TitleCodeM,
        ArrivalDate, DepartureDate,
        RoomCode, RoomTypeCode,
        RoomTypeName,
        NumAdult, NumChild,
        RateAmount, FolioCurrencyCode,
        GroupCode, CancelNum,
        CompanyName, TelNumM, MailM,
        BookStatus, NoShowFlag, MemberID,
        NationalityCode,
        TotalRows
    FROM __paged
    WHERE __rn > @Offset AND __rn <= @Offset + @PageSize
    ORDER BY __rn;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_WalkInRoomTypes', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_WalkInRoomTypes
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_WalkInRoomTypes
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CutOff DATE = CAST(DATEADD(DAY, -365, GETDATE()) AS DATE);
    SELECT TOP 100
        F.RoomTypeCode,
        ISNULL(RT.Description, F.RoomTypeCode) AS RoomTypeName
    FROM (
        SELECT DISTINCT RoomTypeCode
        FROM dbo.Folio WITH (NOLOCK)
        WHERE ISNULL(RoomTypeCode,'') <> ''
          AND ArrivalDate >= @CutOff
    ) F
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK)
           ON RT.RoomTypeCode = F.RoomTypeCode
    ORDER BY F.RoomTypeCode;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_WalkInAvailableRooms', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_WalkInAvailableRooms
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_WalkInAvailableRooms
    @ArrivalDate   DATE        = NULL,
    @DepartureDate DATE        = NULL,
    @RoomType      VARCHAR(20) = ''
AS
BEGIN
    SET NOCOUNT ON;
    IF @ArrivalDate   IS NULL SET @ArrivalDate   = CAST(GETDATE() AS DATE);
    IF @DepartureDate IS NULL SET @DepartureDate = DATEADD(DAY, 1, @ArrivalDate);
    SET @RoomType = ISNULL(@RoomType, '');

    SELECT TOP 200
        known.RoomCode,
        CAST(NULL AS INT)          AS FloorNum,
        CAST(NULL AS NVARCHAR(50)) AS RoomView,
        known.RoomTypeCode,
        ISNULL(RT.Description, known.RoomTypeCode) AS RoomTypeName,
        CAST(NULL AS INT)          AS HkStatus
    FROM (
        SELECT DISTINCT F.RoomCode, F.RoomTypeCode
        FROM dbo.Folio F WITH (NOLOCK)
        WHERE ISNULL(F.RoomCode,'') <> ''
          AND (ISNULL(@RoomType,'') = '' OR F.RoomTypeCode = @RoomType)
    ) AS known
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = known.RoomTypeCode
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Folio occ WITH (NOLOCK)
        WHERE occ.RoomCode     = known.RoomCode
          AND occ.FolioStatus  = 2
          AND COALESCE(occ.CancelNum,0) = 0
          AND occ.ArrivalDate   < @DepartureDate
          AND occ.DepartureDate > @ArrivalDate
    )
    ORDER BY FloorNum, known.RoomCode;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_WalkInReservedToday', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_WalkInReservedToday
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_WalkInReservedToday
    @SearchTerm NVARCHAR(200) = '',
    @HotelDate  VARCHAR(20)   = ''
AS
BEGIN
    SET NOCOUNT ON;
    SET @SearchTerm = ISNULL(LTRIM(RTRIM(@SearchTerm)), '');
    DECLARE @HD DATE = CAST(
        ISNULL(CASE WHEN ISDATE(NULLIF(@HotelDate,'')) = 1 THEN CAST(NULLIF(@HotelDate,'') AS DATETIME) END, GETDATE())
    AS DATE);

    SELECT TOP 100
        F.FolioNum,
        F.ConfirmNum,
        ISNULL(F.FirstName,'')  AS FirstName,
        ISNULL(F.LastName,'')   AS LastName,
        LTRIM(RTRIM(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,''))) AS GuestName,
        ISNULL(F.RoomCode,'')     AS RoomCode,
        ISNULL(F.RoomTypeCode,'') AS RoomTypeCode,
        ISNULL(RT.Description, F.RoomTypeCode) AS RoomTypeName,
        F.ArrivalDate,
        F.DepartureDate,
        ISNULL(F.NumAdult,1) + ISNULL(F.NumChild,0) AS NumGuest
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
    WHERE F.FolioStatus  = 1
      AND F.ArrivalDate  = @HD
      AND ISNULL(F.CancelNum,0)  = 0
      AND ISNULL(F.NoShowFlag,0) = 0
      AND (
            @SearchTerm = ''
         OR LTRIM(RTRIM(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,''))) LIKE '%' + @SearchTerm + '%'
         OR F.RoomCode LIKE '%' + @SearchTerm + '%'
      )
    ORDER BY ISNULL(F.LastName,''), ISNULL(F.FirstName,'');
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GroupsArrivingOn', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GroupsArrivingOn
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GroupsArrivingOn
    @ArrivalDate DATE        = NULL,
    @HotelDate   VARCHAR(20) = ''
AS
BEGIN
    SET NOCOUNT ON;
    IF @ArrivalDate IS NULL
        SET @ArrivalDate = CAST(
            ISNULL(CASE WHEN ISDATE(NULLIF(@HotelDate,'')) = 1 THEN CAST(NULLIF(@HotelDate,'') AS DATETIME) END, GETDATE())
        AS DATE);

    SELECT
        F.GroupCode,
        -- SMILE keeps no separate group-name column: the group's lead folio (lowest FolioNum) is named after the group.
        NULLIF(LTRIM(RTRIM(dbo.fTCVNToUnicode(ISNULL(MAX(L.LastName),'') + ' ' + ISNULL(MAX(L.FirstName),'')))), '') AS GroupName,
        COUNT(*)                                                AS TotalFolios,
        SUM(CASE WHEN F.FolioStatus = 2 THEN 1 ELSE 0 END)     AS InHouseFolios,
        SUM(CASE WHEN F.FolioStatus = 1 THEN 1 ELSE 0 END)     AS ReservedFolios,
        MIN(F.ArrivalDate)                                      AS ArrivalDate,
        MAX(F.DepartureDate)                                    AS DepartureDate
    FROM dbo.Folio F WITH (NOLOCK)
    OUTER APPLY (SELECT TOP 1 F2.LastName, F2.FirstName FROM dbo.Folio F2 WITH (NOLOCK)
                 WHERE F2.GroupCode = F.GroupCode AND ISNULL(F2.CancelNum,0) = 0
                 ORDER BY F2.FolioNum) L
    WHERE F.ArrivalDate  = @ArrivalDate
      AND ISNULL(F.CancelNum,0)   = 0
      AND ISNULL(F.GroupCode,'') <> ''
    GROUP BY F.GroupCode
    ORDER BY F.GroupCode;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GroupFolios', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GroupFolios
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GroupFolios
    @GroupCode NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 500
        F.FolioNum,
        F.ConfirmNum,
        ISNULL(F.FirstName,'')  AS FirstName,
        ISNULL(F.LastName,'')   AS LastName,
        LTRIM(RTRIM(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,''))) AS GuestName,
        ISNULL(F.RoomCode,'')     AS RoomCode,
        ISNULL(F.RoomTypeCode,'') AS RoomTypeCode,
        ISNULL(RT.Description, F.RoomTypeCode) AS RoomTypeName,
        F.FolioStatus,
        ISNULL(F.NumAdult,1) + ISNULL(F.NumChild,0) AS NumGuest,
        F.ArrivalDate,
        F.DepartureDate
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
    WHERE F.GroupCode          = @GroupCode
      AND ISNULL(F.CancelNum,0) = 0
    ORDER BY F.FolioStatus DESC, ISNULL(F.LastName,''), ISNULL(F.FirstName,'');
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GroupAutoAssign', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GroupAutoAssign
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GroupAutoAssign
    @GroupCode     NVARCHAR(50),
    @FolioNumsJson NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Input TABLE (
        Seq      INT IDENTITY(1,1) PRIMARY KEY,
        FolioNum DECIMAL(18,0) NOT NULL
    );
    DECLARE @xml XML = CAST('<r><n>' +
        REPLACE(
          REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(@FolioNumsJson,''),'[',''),']',''),'"',''),' ',''),
        ',', '</n><n>') + '</n></r>' AS XML);
    INSERT INTO @Input (FolioNum)
    SELECT TOP 50 CAST(x.n.value('.', 'VARCHAR(40)') AS DECIMAL(18,0))
    FROM @xml.nodes('/r/n') AS x(n)
    WHERE LTRIM(RTRIM(x.n.value('.', 'VARCHAR(40)'))) <> ''
      AND ISNUMERIC(x.n.value('.', 'VARCHAR(40)')) = 1;

    DECLARE @Folios TABLE (
        Seq          INT PRIMARY KEY,
        FolioNum     DECIMAL(18,0) NOT NULL,
        RoomTypeCode VARCHAR(20),
        ArrivalDate  DATE,
        DepartDate   DATE,
        AssignedRoom VARCHAR(20),
        ErrMsg       NVARCHAR(200)
    );
    INSERT INTO @Folios (Seq, FolioNum, RoomTypeCode, ArrivalDate, DepartDate)
    SELECT I.Seq, I.FolioNum, F.RoomTypeCode, F.ArrivalDate, F.DepartureDate
    FROM @Input I
    LEFT JOIN dbo.Folio F WITH (NOLOCK) ON F.FolioNum = I.FolioNum;

    UPDATE @Folios SET ErrMsg = 'Folio not found in PMS'
    WHERE RoomTypeCode IS NULL OR ArrivalDate IS NULL;

    DECLARE @Assigned TABLE (RoomCode VARCHAR(20) PRIMARY KEY);

    DECLARE @Seq      INT, @FolioNum DECIMAL(18,0),
            @RoomType VARCHAR(20), @ArrDate DATE, @DepDate DATE, @BestRoom VARCHAR(20);

    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT Seq, FolioNum, RoomTypeCode, ArrivalDate, DepartDate
        FROM @Folios WHERE ErrMsg IS NULL ORDER BY Seq;
    OPEN cur;
    FETCH NEXT FROM cur INTO @Seq, @FolioNum, @RoomType, @ArrDate, @DepDate;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @BestRoom = NULL;
        SELECT TOP 1 @BestRoom = cand.RoomCode
        FROM (
            SELECT DISTINCT RoomCode
            FROM dbo.Folio WITH (NOLOCK)
            WHERE ISNULL(RoomTypeCode,'') = @RoomType AND ISNULL(RoomCode,'') <> ''
        ) AS cand
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.Folio occ WITH (NOLOCK)
            WHERE occ.RoomCode     = cand.RoomCode
              AND occ.FolioStatus  = 2
              AND ISNULL(occ.CancelNum,0) = 0
              AND occ.ArrivalDate   < @DepDate
              AND occ.DepartureDate > @ArrDate
        )
        AND cand.RoomCode NOT IN (SELECT RoomCode FROM @Assigned)
        ORDER BY cand.RoomCode;

        IF @BestRoom IS NOT NULL
        BEGIN
            UPDATE @Folios SET AssignedRoom = @BestRoom WHERE Seq = @Seq;
            INSERT INTO @Assigned (RoomCode) VALUES (@BestRoom);
        END
        ELSE
            UPDATE @Folios
            SET ErrMsg = 'No available room found for type: ' + ISNULL(@RoomType,'?')
            WHERE Seq = @Seq;

        FETCH NEXT FROM cur INTO @Seq, @FolioNum, @RoomType, @ArrDate, @DepDate;
    END
    CLOSE cur; DEALLOCATE cur;

    SELECT FolioNum, AssignedRoom AS AssignedRoomCode, ErrMsg AS ErrorMessage
    FROM @Folios ORDER BY Seq;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_PaletteSearch', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_PaletteSearch
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_PaletteSearch
    @query     NVARCHAR(200),
    @typesCsv  NVARCHAR(100) = 'folio,guest,room,group',
    @top       INT           = 5,
    @hotelDate DATE          = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @hotelDate IS NULL SET @hotelDate = CAST(GETDATE() AS DATE);
    DECLARE @q NVARCHAR(202) = N'%' + @query + N'%';

    IF CHARINDEX('folio', @typesCsv) > 0
    BEGIN
        SELECT TOP (@top)
            N'folio'                                AS [Type],
            CAST(f.FolioNum AS NVARCHAR(20))        AS [Id],
            ISNULL(f.TitleCodeM + ' ', '') +
            ISNULL(f.FirstName  + ' ', '') +
            ISNULL(f.LastName, '')                  AS [Label],
            N'Folio #' + CAST(f.FolioNum AS NVARCHAR(20))
            + ISNULL(N' · ' + f.RoomCode, '')       AS [Subtitle]
        FROM dbo.Folio f WITH (NOLOCK)
        WHERE ISNULL(f.CancelNum,0) = 0
          AND (   CAST(f.FolioNum AS NVARCHAR(20)) LIKE @q
               OR ISNULL(f.FirstName,'') + ' ' + ISNULL(f.LastName,'') LIKE @q
               OR ISNULL(f.LastName,'') + ', ' + ISNULL(f.FirstName,'') LIKE @q
              )
        ORDER BY f.ArrivalDate DESC, f.FolioNum DESC;
    END

    IF CHARINDEX('guest', @typesCsv) > 0
    BEGIN
        SELECT TOP (@top)
            N'guest'                                AS [Type],
            CAST(f.FolioNum AS NVARCHAR(20))        AS [Id],
            ISNULL(f.TitleCodeM + ' ', '') +
            ISNULL(f.FirstName  + ' ', '') +
            ISNULL(f.LastName, '')                  AS [Label],
            ISNULL(f.MailM, '')                     AS [Subtitle]
        FROM (
            SELECT FolioNum, TitleCodeM, FirstName, LastName, MailM,
                   ROW_NUMBER() OVER (
                       PARTITION BY LOWER(ISNULL(FirstName,'')), LOWER(ISNULL(LastName,''))
                       ORDER BY FolioNum DESC
                   ) AS rn
            FROM dbo.Folio WITH (NOLOCK)
            WHERE ISNULL(CancelNum,0) = 0
              AND (   ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') LIKE @q
                   OR ISNULL(LastName,'')  + ', ' + ISNULL(FirstName,'') LIKE @q
                  )
        ) f
        WHERE f.rn = 1
        ORDER BY f.FolioNum DESC;
    END

    IF CHARINDEX('room', @typesCsv) > 0
    BEGIN
        SELECT TOP (@top)
            N'room'                                 AS [Type],
            f.RoomCode                              AS [Id],
            f.RoomCode                              AS [Label],
            ISNULL(RT.Description, f.RoomTypeCode)  AS [Subtitle]
        FROM (
            SELECT DISTINCT f.RoomCode, f.RoomTypeCode
            FROM dbo.Folio f WITH (NOLOCK)
            WHERE f.RoomCode LIKE @q AND ISNULL(f.CancelNum,0) = 0
        ) f
        LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = f.RoomTypeCode
        ORDER BY f.RoomCode;
    END

    IF CHARINDEX('group', @typesCsv) > 0
    BEGIN
        SELECT TOP (@top)
            N'group'                                AS [Type],
            f.GroupCode                             AS [Id],
            f.GroupCode                             AS [Label],
            ''                                      AS [Subtitle]
        FROM (
            SELECT DISTINCT GroupCode
            FROM dbo.Folio WITH (NOLOCK)
            WHERE GroupCode IS NOT NULL
              AND ISNULL(CancelNum,0) = 0
              AND GroupCode LIKE @q
        ) f
        ORDER BY f.GroupCode;
    END
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_ReportOccupancy', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_ReportOccupancy
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_ReportOccupancy
    @from DATE,
    @to   DATE
AS
BEGIN
    SET NOCOUNT ON;
    ;WITH calendar AS (
        SELECT @from AS d
        UNION ALL
        SELECT DATEADD(DAY, 1, d) FROM calendar WHERE d < @to
    )
    SELECT
        c.d                             AS [Date],
        ISNULL(occupied.RoomsOccupied, 0) AS RoomsOccupied,
        cap.TotalRooms                  AS RoomsAvailable,
        CASE WHEN cap.TotalRooms > 0
             THEN CAST(100.0 * ISNULL(occupied.RoomsOccupied,0) / cap.TotalRooms AS DECIMAL(5,2))
             ELSE 0
        END                             AS OccupancyPct
    FROM calendar c
    CROSS JOIN (
        SELECT COUNT(DISTINCT RoomCode) AS TotalRooms
        FROM dbo.Folio WITH (NOLOCK)
        WHERE FolioStatus IN (1, 2) AND ISNULL(CancelNum,0) = 0
          AND ArrivalDate >= DATEADD(DAY, -90, GETDATE())
    ) cap
    LEFT JOIN (
        SELECT cal.d, COUNT(DISTINCT f.RoomCode) AS RoomsOccupied
        FROM calendar cal
        JOIN dbo.Folio f WITH (NOLOCK)
          ON f.ArrivalDate   <= cal.d
         AND f.DepartureDate  > cal.d
         AND f.FolioStatus   IN (1, 2)
         AND ISNULL(f.CancelNum,0) = 0
        GROUP BY cal.d
    ) occupied ON occupied.d = c.d
    ORDER BY c.d
    OPTION (MAXRECURSION 400);
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_ReportNationality', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_ReportNationality
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_ReportNationality
    @from DATE,
    @to   DATE
AS
BEGIN
    SET NOCOUNT ON;
    ;WITH base AS (
        SELECT
            ISNULL(NULLIF(LTRIM(RTRIM(A.NationalityCode)), ''), 'Unknown') AS Nationality,
            COUNT(*)                                                          AS GuestCount,
            SUM(DATEDIFF(DAY, F.ArrivalDate, F.DepartureDate))               AS RoomNights
        FROM dbo.Folio F WITH (NOLOCK)
        LEFT JOIN dbo.AdditionalName A WITH (NOLOCK)
               ON A.FolioNum = F.FolioNum AND A.IsChild = 0 AND ISNULL(A.ACancelNum,0) = 0
        WHERE F.FolioStatus IN (1, 2) AND ISNULL(F.CancelNum,0) = 0
          AND CAST(F.ArrivalDate AS DATE) BETWEEN @from AND @to
        GROUP BY ISNULL(NULLIF(LTRIM(RTRIM(A.NationalityCode)), ''), 'Unknown')
    ),
    totals AS (SELECT SUM(RoomNights) AS TotalRoomNights FROM base)
    SELECT
        b.Nationality,
        b.GuestCount,
        b.RoomNights,
        CASE WHEN t.TotalRoomNights > 0
             THEN CAST(100.0 * b.RoomNights / t.TotalRoomNights AS DECIMAL(5,2))
             ELSE 0
        END AS Pct
    FROM base b CROSS JOIN totals t
    ORDER BY b.RoomNights DESC;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.fnGetHotelDate', 'FN') IS NULL
        EXEC('CREATE FUNCTION dbo.fnGetHotelDate() RETURNS DATETIME AS BEGIN RETURN (SELECT TOP 1 HotelDate FROM dbo.HotelParameter WITH (NOLOCK)); END')
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_LstCheckInOnline', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_LstCheckInOnline
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_LstCheckInOnline
    @sInfo      VARCHAR(50)  = '',
    @PageNumber INT          = 1,
    @PageSize   INT          = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    ;WITH __paged AS (
        SELECT
            F.FolioNum, F.ConfirmNum, F.FolioStatus,
            dbo.fTCVNToUnicode(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'')) AS GuestName,
            F.RoomCode, F.ArrivalDate, F.DepartureDate,
            F.CIOnlineFlag AS CheckInOnlFlag,
            F.NumAdult, F.NumChild,
            COUNT(*) OVER() AS TotalRows,
            ROW_NUMBER() OVER (ORDER BY F.ArrivalDate DESC, F.FolioNum DESC) AS __rn
        FROM dbo.Folio F WITH (NOLOCK)
        WHERE ISNULL(F.CIOnlineFlag,0) = 1
          AND (ISNULL(@sInfo,'') = ''
               OR CAST(F.ConfirmNum AS VARCHAR(20)) LIKE '%'+@sInfo+'%'
               OR CAST(F.FolioNum   AS VARCHAR(20)) LIKE '%'+@sInfo+'%')
    )
    SELECT
        FolioNum, ConfirmNum, FolioStatus,
        GuestName,
        RoomCode, ArrivalDate, DepartureDate,
        CheckInOnlFlag,
        NumAdult, NumChild,
        TotalRows
    FROM __paged
    WHERE __rn > @Offset AND __rn <= @Offset + @PageSize
    ORDER BY __rn;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_UpdGuestInfor', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_UpdGuestInfor
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_UpdGuestInfor
    @FolioNum   DECIMAL(18,0),
    @XMLDetails XML = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @XMLDetails IS NULL BEGIN SELECT 0 AS AffectedRows; RETURN; END;

    DECLARE @x XML = @XMLDetails;
    UPDATE A
    -- Name/address columns are TCVN-3 varchar(CP1252) (read back via
    -- dbo.fTCVNToUnicode), so encode the Unicode input to TCVN on write.
    -- UnicodeToTCVN is a no-op for plain ASCII, so existing rows are safe.
    SET A.LastName        = ISNULL(dbo.UnicodeToTCVN(NULLIF(n.LastName,'')),  A.LastName),
        -- ClearFirstName = 1: the whole name is in LastName (tenant option), so blank FirstName
        -- instead of keeping the old value, which would otherwise repeat the given name.
        A.FirstName       = CASE WHEN n.ClearFirstName = '1' AND NULLIF(n.LastName,'') IS NOT NULL THEN ''
                                 ELSE ISNULL(dbo.UnicodeToTCVN(NULLIF(n.FirstName,'')), A.FirstName) END,
        A.Title           = ISNULL(NULLIF(n.Title,''),           A.Title),
        A.IsChild         = ISNULL(n.IsChild,                    A.IsChild),
        A.Gender          = ISNULL(n.Gender,                     A.Gender),
        A.BirthDate       = ISNULL(n.BirthDate,                  A.BirthDate),
        A.TeleNum         = ISNULL(NULLIF(n.MobileNum,''),       A.TeleNum),
        A.MobileNum       = ISNULL(NULLIF(n.MobileNum,''),       A.MobileNum),
        A.Email           = ISNULL(NULLIF(n.Email,''),           A.Email),
        A.PassportNum     = ISNULL(NULLIF(n.PassportNum,''),     A.PassportNum),
        A.NationalityCode = ISNULL(NULLIF(n.NationalityCode,''), A.NationalityCode),
        A.Occupation      = ISNULL(dbo.UnicodeToTCVN(NULLIF(n.Occupation,'')), A.Occupation),
        A.Address1        = ISNULL(dbo.UnicodeToTCVN(NULLIF(n.Address1,'')),   A.Address1)
    FROM dbo.AdditionalName A
    JOIN (
        SELECT
            CASE WHEN ISNUMERIC(g.value('(IdAddition/text())[1]', 'varchar(20)')) = 1 THEN CAST(g.value('(IdAddition/text())[1]', 'varchar(20)') AS DECIMAL(18,0)) END AS IdAddition,
            g.value('(LastName/text())[1]',               'nvarchar(100)') AS LastName,
            g.value('(FirstName/text())[1]',              'nvarchar(100)') AS FirstName,
            g.value('(ClearFirstName/text())[1]',         'varchar(5)')    AS ClearFirstName,
            g.value('(Title/text())[1]',                  'nvarchar(20)')  AS Title,
            CASE WHEN ISNUMERIC(g.value('(IsChild/text())[1]', 'varchar(5)')) = 1 THEN CAST(CAST(g.value('(IsChild/text())[1]', 'varchar(5)') AS DECIMAL(18,0)) AS BIT) END AS IsChild,
            CASE WHEN ISNUMERIC(g.value('(Gender/text())[1]', 'varchar(5)')) = 1 THEN CAST(CAST(g.value('(Gender/text())[1]', 'varchar(5)') AS DECIMAL(18,0)) AS BIT) END AS Gender,
            CASE WHEN ISDATE(g.value('(BirthDate/text())[1]', 'varchar(20)')) = 1 THEN CAST(g.value('(BirthDate/text())[1]', 'varchar(20)') AS DATETIME) END AS BirthDate,
            g.value('(MobileNum/text())[1]',              'varchar(30)')   AS MobileNum,
            g.value('(Email/text())[1]',                  'nvarchar(200)') AS Email,
            g.value('(PassportNum/text())[1]',            'varchar(50)')   AS PassportNum,
            -- NationalityCode column is varchar(3) — store ISO-3 code only; truncate defensively
            LEFT(g.value('(NationalityCode/text())[1]', 'varchar(10)'), 3) AS NationalityCode,
            -- Occupation shredded as nvarchar so diacritics survive into UnicodeToTCVN below
            g.value('(Occupation/text())[1]',             'nvarchar(50)')  AS Occupation,
            g.value('(Address1/text())[1]',               'nvarchar(400)') AS Address1
        FROM @x.nodes('/Guests/Guest') AS t(g)
    ) n ON n.IdAddition = A.IdAddition
    WHERE A.FolioNum = @FolioNum;

    SELECT @@ROWCOUNT AS AffectedRows, 200 AS Result;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_UpdGuestByConfirmation', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_UpdGuestByConfirmation
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_UpdGuestByConfirmation
    @XMLDetails NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 0 AS AffectedRows;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GuestConfirmation', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GuestConfirmation
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GuestConfirmation
    @sFolioNum VARCHAR(20) = '',
    @Sts       VARCHAR(10) = ''
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @FolioNum DECIMAL(18,0) = CASE WHEN ISNUMERIC(NULLIF(@sFolioNum,'')) = 1 THEN CAST(NULLIF(@sFolioNum,'') AS DECIMAL(18,0)) END;
    SELECT TOP 200
        F.FolioNum, F.ConfirmNum, F.FolioStatus,
        dbo.fTCVNToUnicode(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'')) AS GuestName,
        F.RoomCode, F.ArrivalDate, F.DepartureDate
    FROM dbo.Folio F WITH (NOLOCK)
    WHERE (@FolioNum IS NULL OR F.FolioNum = @FolioNum)
      AND COALESCE(F.CancelNum,0) = 0
    ORDER BY F.ArrivalDate DESC;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GroupConfirmation', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GroupConfirmation
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GroupConfirmation
    @Groupcode VARCHAR(50) = ''
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 500
        F.FolioNum, F.ConfirmNum, F.GroupCode, F.FolioStatus,
        dbo.fTCVNToUnicode(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'')) AS GuestName,
        F.RoomCode, F.ArrivalDate, F.DepartureDate
    FROM dbo.Folio F WITH (NOLOCK)
    WHERE F.GroupCode = @Groupcode AND COALESCE(F.CancelNum,0) = 0
    ORDER BY F.FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_SearchAllFolio', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_SearchAllFolio
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_SearchAllFolio
    @sInfo          VARCHAR(50)  = '',
    @ClientFolioNum INT          = 0,
    @RoomType       VARCHAR(20)  = '',
    @Cruise         VARCHAR(20)  = '',
    @GroupID        VARCHAR(50)  = '',
    @SearchSts      INT          = 0,
    @PageNumber     INT          = 1,
    @PageSize       INT          = 20
AS
BEGIN
    SET NOCOUNT ON;
    -- SearchSts values from admin frontend StatusFilter:
    --   0 = All, 1 = Reserved, 2 = InHouse, 3 = CheckOut, 4 = ArrivalToday, 5 = (unused), 6 = Canceled
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    DECLARE @HD DATE = CAST([dbo].[fnGetHotelDate]() AS DATE);

    ;WITH __paged AS (
        SELECT
            F.FolioNum, F.ConfirmNum, F.FolioStatus,
            F.FirstName, F.LastName, F.TitleCodeM,
            F.ArrivalDate, F.DepartureDate,
            F.RoomCode, F.RoomTypeCode,
            RT.Description AS RoomTypeName,
            F.NumAdult, F.NumChild,
            F.RateAmount, F.FolioCurrencyCode,
            F.GroupCode, F.CancelNum,
            F.TelNumM, F.MailM,
            A.NationalityCode,
            COUNT(*) OVER() AS TotalRows,
            ROW_NUMBER() OVER (ORDER BY F.ArrivalDate DESC, F.FolioNum DESC) AS __rn
        FROM dbo.Folio F WITH (NOLOCK)
        LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
        OUTER APPLY (
            SELECT TOP 1 A.NationalityCode
            FROM dbo.AdditionalName A WITH (NOLOCK)
            WHERE A.FolioNum = F.FolioNum AND A.IsChild = 0 AND ISNULL(A.ACancelNum,0) = 0
            ORDER BY A.IdAddition
        ) A
        WHERE
            (
                @SearchSts = 0
                OR (@SearchSts = 1 AND F.FolioStatus = 1 AND COALESCE(F.CancelNum,0) = 0)
                OR (@SearchSts = 2 AND F.FolioStatus = 2 AND COALESCE(F.CancelNum,0) = 0)
                OR (@SearchSts = 3 AND F.FolioStatus = 3 AND COALESCE(F.CancelNum,0) = 0)
                OR (@SearchSts = 4 AND F.FolioStatus = 1 AND CAST(F.ArrivalDate AS DATE) = @HD AND COALESCE(F.CancelNum,0) = 0)
                OR (@SearchSts = 6 AND COALESCE(F.CancelNum,0) > 0)
            )
            AND (ISNULL(@sInfo,'') = ''
                 OR CAST(F.FolioNum AS VARCHAR(20)) LIKE '%'+@sInfo+'%'
                 OR CAST(F.ConfirmNum AS VARCHAR(20)) LIKE '%'+@sInfo+'%'
                 OR ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'') LIKE '%'+@sInfo+'%')
            AND (ISNULL(@RoomType,'') = '' OR F.RoomTypeCode = @RoomType)
            AND (ISNULL(@GroupID,'')  = '' OR F.GroupCode    = @GroupID)
    )
    SELECT
        FolioNum, ConfirmNum, FolioStatus,
        FirstName, LastName, TitleCodeM,
        ArrivalDate, DepartureDate,
        RoomCode, RoomTypeCode,
        RoomTypeName,
        NumAdult, NumChild,
        RateAmount, FolioCurrencyCode,
        GroupCode, CancelNum,
        TelNumM, MailM,
        NationalityCode,
        TotalRows
    FROM __paged
    WHERE __rn > @Offset AND __rn <= @Offset + @PageSize
    ORDER BY __rn;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_HotelInfo', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_HotelInfo
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_HotelInfo
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1
        ISNULL(HotelName,'')    AS HotelName,
        ISNULL(HotelAddress,'') AS HotelAddress,
        ISNULL(HotelCity,'')    AS HotelCity,
        ISNULL(HotelCountry,'') AS HotelCountry,
        ISNULL(HotelPhone,'')   AS HotelPhone,
        ISNULL(HotelEmail,'')   AS HotelEmail,
        ISNULL(HotelWebSite,'') AS HotelWebSite,
        ISNULL(CheckInTime,'')  AS CheckInTime,
        ISNULL(CheckOutTime,'') AS CheckOutTime,
        ISNULL(CurrencyCode,'') AS CurrencyCode,
        ISNULL(CurrencySymbol,'') AS CurrencySymbol,
        ISNULL(VATCode,'')      AS VATCode,
        ISNULL(VATPercent,0)    AS VATPercent,
        HotelDate
    FROM dbo.HotelParameter WITH (NOLOCK);
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetBalanceCode', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetBalanceCode
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetBalanceCode
    @FolioNum DECIMAL(18,0) = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT
        UPPER(LTRIM(RTRIM(FT.FolioBalanceCode))) AS Code,
        UPPER(LTRIM(RTRIM(FT.FolioBalanceCode))) AS Description
    FROM dbo.FolioTransaction FT WITH (NOLOCK)
    WHERE FT.FolioNum = @FolioNum
      AND UPPER(LTRIM(RTRIM(FT.FolioBalanceCode))) NOT IN ('C','V','P') -- RT-1348: never on a signed bill
    ORDER BY Code;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_InformationBill', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_InformationBill
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_InformationBill
    @sFolioNum    DECIMAL(18,0) = 0,
    @sBalanceCode VARCHAR(20)   = NULL
AS
BEGIN
    SET NOCOUNT ON;
    -- RT-1484: the lines come from the shared SA_ layer (dbo.SA_FolioBill): a room charge from a restaurant check or
    -- the minibar is listed as the items of that check / posting (name, unit price, quantity, check no or reference),
    -- every other folio line stays one line. The C / V / P balance-code rule (RT-1348) lives in that function too.
    SELECT TOP 500
        B.FolioNum,
        B.BalanceCode,
        B.Amount,
        -- SMILE leaves Qty, UnitPrice and Description empty on most folio lines: such a line is one unit of its amount,
        -- named after its transaction code (the way the e-invoice collector reads it).
        ISNULL(NULLIF(B.Qty, 0), 1) AS Qty,
        ISNULL(NULLIF(B.UnitPrice, 0), B.Amount / ISNULL(NULLIF(B.Qty, 0), 1)) AS UnitPrice,
        B.TransDate,
        dbo.fTCVNToUnicode(CASE WHEN B.Source = 'FO'
            THEN COALESCE(NULLIF(RTRIM(TC.Description), ''), NULLIF(RTRIM(B.ItemName), ''), '')
            ELSE COALESCE(NULLIF(RTRIM(B.ItemName), ''), NULLIF(RTRIM(B.ItemCode), ''), '') END) AS Description,
        CAST(B.RefNo AS VARCHAR(30)) AS RefNo,
        -- RT-1496: the group of the folio line's code (2 payment, 3 transfer): printed as paid, not as a discount.
        CASE WHEN B.Source = 'FO' THEN TG.TransactionGroup END AS TransactionGroup
    FROM dbo.SA_FolioBill(@sFolioNum, @sBalanceCode) B
    -- RT-1432: the code + sub code join lives in the shared SA_ layer (dbo.SA_TrnCode_Resolve, installed ahead of
    -- this bundle); no exact sub falls back to sub 0, never to another sub code of the same code.
    OUTER APPLY dbo.SA_TrnCode_Resolve(B.TransactionCode, B.TransactionSubCode, 1, 0) TC
    OUTER APPLY (SELECT TOP 1 T.TransactionGroup FROM dbo.TransactionCode T WITH (NOLOCK)
                 WHERE T.TransactionCode = TC.TransactionCode
                   AND (T.TransactionSubCode = TC.TransactionSubCode
                        OR (T.TransactionSubCode IS NULL AND TC.TransactionSubCode IS NULL))) TG
    ORDER BY B.TransDate, B.TransactionID, B.LineSeq;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_FolioInformation', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_FolioInformation
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_FolioInformation
    @FolioNum DECIMAL(18,0) = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1
        F.FolioNum, F.ConfirmNum, F.FolioStatus,
        F.FirstName, F.LastName, F.TitleCodeM,
        F.RoomCode, F.RoomTypeCode,
        RT.Description AS RoomTypeName,
        F.RoomTypeBooked, RTB.Description AS RoomTypeBookedName,
        F.ArrivalDate, F.DepartureDate,
        F.ArrivalTime, F.DepartureTime,
        F.NumAdult, F.NumChild,
        F.RateAmount, F.FolioCurrencyCode,
        F.GroupCode, F.TelNumM, F.MailM,
        F.MemberID, F.ProfileNumber,
        -- Folio.ConfirmPrintFlag = true: the stay price must not be printed on the registration card.
        CAST(ISNULL(F.ConfirmPrintFlag, 0) AS BIT) AS ConfirmPrintFlag
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
    LEFT JOIN dbo.RoomType RTB WITH (NOLOCK) ON RTB.RoomTypeCode = F.RoomTypeBooked
    WHERE F.FolioNum = @FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetAllDropdownData', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetAllDropdownData
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetAllDropdownData
AS
BEGIN
    SET NOCOUNT ON;
    -- 25 result sets consumed by FolioRepository.GetAllDropdownData().
    -- Aliased to Code/Description so the C# CodeDescription DTO binds correctly.
    -- Optional tables (TAClass, ARClass, MealPlan, Package, TitleCode) may not
    -- exist on all SMILE_FO versions; fall back to empty set.
    SELECT SlsCode AS Code, SlsName AS Description FROM dbo.SalesAccount WITH (NOLOCK) ORDER BY SlsName;
    IF OBJECT_ID('dbo.TAClass','U') IS NOT NULL
        EXEC('SELECT Code, Description FROM dbo.TAClass WITH (NOLOCK) ORDER BY Description');
    ELSE SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0;
    SELECT CountryCode AS Code, Description FROM dbo.Country WITH (NOLOCK) ORDER BY Description;
    SELECT CurrencyCode AS Code, CurrencyName AS Description FROM dbo.CurrencyDef WITH (NOLOCK) ORDER BY CurrencyName;
    SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0; -- UserDefines
    IF OBJECT_ID('dbo.ARClass','U') IS NOT NULL
        EXEC('SELECT Code, Description FROM dbo.ARClass WITH (NOLOCK) ORDER BY Description');
    ELSE SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0;
    SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0; -- ARBillingCycles
    SELECT RateCode AS Code, Description FROM dbo.RateCode WITH (NOLOCK) ORDER BY Description;
    SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0; -- ARAccGroups
    SELECT MarketSegmentCode AS Code, Description FROM dbo.MarketSegment WITH (NOLOCK) ORDER BY Description;
    SELECT WingCode AS Code, Description FROM dbo.Wing WITH (NOLOCK) ORDER BY Description;
    SELECT RoomExposureCode AS Code, Description FROM dbo.RoomExposure WITH (NOLOCK) ORDER BY Description;
    SELECT RoomAttributeCode AS Code, Description FROM dbo.RoomAttribute WITH (NOLOCK) ORDER BY Description;
    SELECT RoomTypeCode AS Code, Description FROM dbo.RoomType WITH (NOLOCK) ORDER BY Description;
    SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0; -- Cruises
    SELECT BuildingCode AS Code, Description FROM dbo.Building WITH (NOLOCK) ORDER BY Description;
    SELECT PaymentTypeCode AS Code, Description FROM dbo.PaymentType WITH (NOLOCK) ORDER BY Description;
    SELECT RateReasonCode AS Code, Description FROM dbo.RateReason WITH (NOLOCK) ORDER BY Description;
    SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0; -- BookStatuses
    IF OBJECT_ID('dbo.MealPlan','U') IS NOT NULL
        EXEC('SELECT Code, Description FROM dbo.MealPlan WITH (NOLOCK) ORDER BY Description');
    ELSE SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0;
    IF OBJECT_ID('dbo.Package','U') IS NOT NULL
        EXEC('SELECT Code, Description FROM dbo.Package WITH (NOLOCK) ORDER BY Description');
    ELSE SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0;
    SELECT SpecialServiceCode AS Code, Description FROM dbo.SpecialService WITH (NOLOCK) ORDER BY Description;
    SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0; -- Statistics
    IF OBJECT_ID('dbo.TitleCode','U') IS NOT NULL
        EXEC('SELECT Code, Description FROM dbo.TitleCode WITH (NOLOCK) ORDER BY Description');
    ELSE SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0;
    SELECT CAST(NULL AS VARCHAR(20)) AS Code, CAST(NULL AS VARCHAR(100)) AS Description WHERE 1=0; -- FolioBalanceCode
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_BookerInfo', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_BookerInfo
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_BookerInfo
    @SearchInfo NVARCHAR(100) = ''
AS
BEGIN
    SET NOCOUNT ON;
    SET @SearchInfo = ISNULL(LTRIM(RTRIM(@SearchInfo)), '');
    SELECT TOP 50
        P.ProfileNumber,
        dbo.fTCVNToUnicode(ISNULL(P.LastName,'') + ' ' + ISNULL(P.FirstName,'')) AS FullName,
        ISNULL(P.Email,'')   AS Email,
        ISNULL(P.PhoneNum,'') AS Phone
    FROM dbo.Profile P WITH (NOLOCK)
    WHERE @SearchInfo = ''
       OR ISNULL(P.LastName,'') + ' ' + ISNULL(P.FirstName,'') LIKE '%'+@SearchInfo+'%'
       OR ISNULL(P.Email,'') LIKE '%'+@SearchInfo+'%'
    ORDER BY P.LastName, P.FirstName;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_SearchClientMasterV2Paging', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_SearchClientMasterV2Paging
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_SearchClientMasterV2Paging
    @SearchInfo NVARCHAR(200) = '',
    @Page       INT           = 1,
    @PageSize   INT           = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@Page - 1) * @PageSize;
    ;WITH __paged AS (
        SELECT
            P.ProfileNumber,
            dbo.fTCVNToUnicode(ISNULL(P.LastName,'') + ' ' + ISNULL(P.FirstName,'')) AS FullName,
            ISNULL(P.Email,'')    AS Email,
            ISNULL(P.PhoneNum,'') AS Phone,
            COUNT(*) OVER() AS TotalItems,
            ROW_NUMBER() OVER (ORDER BY P.LastName, P.FirstName) AS __rn
        FROM dbo.Profile P WITH (NOLOCK)
        WHERE ISNULL(@SearchInfo,'') = ''
           OR ISNULL(P.LastName,'') + ' ' + ISNULL(P.FirstName,'') LIKE '%'+@SearchInfo+'%'
           OR ISNULL(P.Email,'') LIKE '%'+@SearchInfo+'%'
           OR EXISTS (
             SELECT 1 FROM dbo.AdditionalName A WITH (NOLOCK)
             WHERE A.AProfileNum = P.ProfileNumber AND A.PassportNum LIKE @SearchInfo + '%'
           )
    )
    SELECT
        ProfileNumber,
        FullName,
        Email,
        Phone,
        TotalItems
    FROM __paged
    WHERE __rn > @Offset AND __rn <= @Offset + @PageSize
    ORDER BY __rn;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetProfileDetail', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetProfileDetail
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetProfileDetail
    @ProfileNumber DECIMAL(18,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        P.ProfileNumber,
        dbo.fTCVNToUnicode(ISNULL(P.LastName,'')) AS LastName,
        dbo.fTCVNToUnicode(ISNULL(P.FirstName,'')) AS FirstName,
        ISNULL(P.Email,'')    AS Email,
        ISNULL(P.PhoneNum,'') AS Phone
    FROM dbo.Profile P WITH (NOLOCK)
    WHERE P.ProfileNumber = @ProfileNumber;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetProfileStays', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetProfileStays
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetProfileStays
    @ProfileNumber DECIMAL(18,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CAST(A.FolioNum AS BIGINT) AS FolioNum,
        F.ConfirmNum,
        F.ArrivalDate,
        F.DepartureDate,
        ISNULL(F.FolioStatus, 0) AS FolioStatus,
        ISNULL(A.PassportNum,'')     AS PassportNum,
        ISNULL(A.NationalityCode,'') AS NationalityCode,
        A.BirthDate
    FROM dbo.AdditionalName A WITH (NOLOCK)
    JOIN dbo.Folio F WITH (NOLOCK) ON F.FolioNum = A.FolioNum
    WHERE A.AProfileNum = @ProfileNumber
    ORDER BY F.ArrivalDate DESC;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetUnsendMailFolio', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetUnsendMailFolio
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetUnsendMailFolio
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 100
        F.FolioNum, F.ConfirmNum,
        dbo.fTCVNToUnicode(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'')) AS GuestName,
        dbo.fTCVNToUnicode(ISNULL(F.FirstName,'')) AS FirstName,
        dbo.fTCVNToUnicode(ISNULL(F.LastName,''))  AS LastName,
        F.MailM AS Email, F.TelNumM,
        F.RoomTypeCode, RT.Description AS RoomTypeName,
        F.ArrivalDate, F.DepartureDate,
        F.NumAdult, F.NumChild,
        F.FolioStatus
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
    WHERE ISNULL(F.IsSendMail, 0) = 0
      AND F.FolioStatus IN (1,2)
      AND ISNULL(F.CancelNum,0) = 0
      AND ISNULL(F.MailM,'') <> ''
    ORDER BY F.ArrivalDate;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_CheckRoomStatusToCheckIn', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_CheckRoomStatusToCheckIn
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_CheckRoomStatusToCheckIn
    @FolioNum DECIMAL(18,0),
    @RoomCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    -- RS1: conflict flag (occupied = another folio is inhouse in the same room)
    DECLARE @Occupied INT = 0;
    SELECT @Occupied = COUNT(*)
    FROM dbo.Folio WITH (NOLOCK)
    WHERE RoomCode = @RoomCode AND FolioStatus = 2
      AND COALESCE(CancelNum,0) = 0 AND FolioNum <> @FolioNum;
    SELECT @Occupied AS IsOccupied,
           CASE WHEN @Occupied = 0 THEN 200 ELSE 409 END AS Result,
           CASE WHEN @Occupied = 0 THEN 'Room available.' ELSE 'Room is currently occupied.' END AS ResultMes;
    -- RS2: all other reserved/inhouse folios sharing the same room (for share warning)
    SELECT F.FolioNum AS ShareFolioNum,
           LTRIM(RTRIM(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,''))) AS GuestName,
           F.FolioStatus, F.ArrivalDate, F.DepartureDate
    FROM dbo.Folio F WITH (NOLOCK)
    WHERE F.RoomCode = @RoomCode AND F.FolioStatus IN (1,2)
      AND COALESCE(F.CancelNum,0) = 0 AND F.FolioNum <> @FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_FOSignature', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_FOSignature
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_FOSignature
    @FolioNum                     DECIMAL(18,0) = NULL,
    @IdAddition                   DECIMAL(18,0) = NULL,
    @SignatureGuest                IMAGE         = NULL,
    @SignaturePath                 VARCHAR(500)  = NULL,
    @FOGuestCheck                  INT           = NULL,
    @FOHouseKeeping                INT           = NULL,
    @FODeposit                     INT           = NULL,
    @FOGroupConfirmation           INT           = NULL,
    @FOConfirmation                INT           = NULL,
    @FORegistrationCard            INT           = NULL,
    @FORegistrationCard_CheckOut   INT           = NULL,
    @FORegistrationCard_CHECKEDBY  INT           = NULL,
    @FORegistrationCardName        VARCHAR(500)  = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Seq BIGINT;

    -- Upsert into SMILE_PICTURE.dbo.FontDeskSignture.
    -- Key on FolioNum ALONE: on PMS-native installs the table pre-exists with its PK on
    -- FolioNum (PK__FontDesk__*), so a second row for the same folio (different/NULL
    -- IdAddition) would violate that PK. One folio carries one FO signature row, so
    -- folio-level upsert is correct on both the PMS-native and app-created schema.
    IF EXISTS (SELECT 1 FROM SMILE_PICTURE.dbo.FontDeskSignture WHERE FolioNum = @FolioNum)
    BEGIN
        UPDATE SMILE_PICTURE.dbo.FontDeskSignture
        SET IdAddition                    = ISNULL(@IdAddition,                  IdAddition),
            FOGuestCheck                  = ISNULL(@FOGuestCheck,                FOGuestCheck),
            SignatureGuest                = ISNULL(@SignatureGuest,              SignatureGuest),
            SignaturePath                 = ISNULL(@SignaturePath,               SignaturePath),
            FORegistrationCard            = ISNULL(@FORegistrationCard,          FORegistrationCard),
            FORegistrationCardName        = ISNULL(@FORegistrationCardName,      FORegistrationCardName),
            FORegistrationCardCreateDate  = CASE WHEN @FORegistrationCard = 1 THEN GETDATE() ELSE FORegistrationCardCreateDate END,
            FORegistrationCard_CheckOut   = ISNULL(@FORegistrationCard_CheckOut, FORegistrationCard_CheckOut),
            FORegistrationCardName_CO     = ISNULL(@FORegistrationCardName,      FORegistrationCardName_CO),
            FORegistrationCard_CHECKEDBY  = ISNULL(@FORegistrationCard_CHECKEDBY,FORegistrationCard_CHECKEDBY),
            FORegistrationCardName_CHECKEDBY = ISNULL(@FORegistrationCardName,   FORegistrationCardName_CHECKEDBY),
            FORegistrationCardCreateDate_CHECKEDBY = CASE WHEN @FORegistrationCard_CHECKEDBY = 1 THEN GETDATE() ELSE FORegistrationCardCreateDate_CHECKEDBY END
        WHERE FolioNum = @FolioNum;
        SELECT @Seq = Seq FROM SMILE_PICTURE.dbo.FontDeskSignture WHERE FolioNum = @FolioNum;
    END
    ELSE
    BEGIN
        INSERT INTO SMILE_PICTURE.dbo.FontDeskSignture
            (FolioNum, IdAddition, FOGuestCheck, SignatureGuest, SignaturePath,
             FORegistrationCard, FORegistrationCardName, FORegistrationCardCreateDate,
             FORegistrationCard_CheckOut, FORegistrationCardName_CO,
             FORegistrationCard_CHECKEDBY, FORegistrationCardName_CHECKEDBY,
             FORegistrationCardCreateDate_CHECKEDBY)
        VALUES
            (@FolioNum, @IdAddition, @FOGuestCheck, @SignatureGuest, @SignaturePath,
             @FORegistrationCard, @FORegistrationCardName,
             CASE WHEN @FORegistrationCard = 1 THEN GETDATE() ELSE NULL END,
             @FORegistrationCard_CheckOut, @FORegistrationCardName,
             @FORegistrationCard_CHECKEDBY, @FORegistrationCardName,
             CASE WHEN @FORegistrationCard_CHECKEDBY = 1 THEN GETDATE() ELSE NULL END);
        SET @Seq = SCOPE_IDENTITY();
    END
    SELECT @Seq AS Seq, 200 AS Result;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_RemoveSign', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_RemoveSign
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_RemoveSign
    @FolioNum           DECIMAL(18,0),
    @Seq                DECIMAL(18,0) = NULL,
    @FOGuestCheck       INT = NULL,
    @FOHouseKeeping     INT = NULL,
    @FODeposit          INT = NULL,
    @FOGroupConfirmation INT = NULL,
    @FOConfirmation     INT = NULL,
    @FORegistrationCard INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SMILE_PICTURE.dbo.FontDeskSignture
    SET SignatureGuest  = CASE WHEN @FOGuestCheck = 1 THEN NULL ELSE SignatureGuest END,
        SignaturePath   = CASE WHEN @FOGuestCheck = 1 THEN NULL ELSE SignaturePath  END,
        FOGuestCheck    = CASE WHEN @FOGuestCheck = 1 THEN 0   ELSE FOGuestCheck   END,
        SignatureRegistrationCard     = CASE WHEN @FORegistrationCard = 1 THEN NULL ELSE SignatureRegistrationCard END,
        SignatureRegistrationCardPath = CASE WHEN @FORegistrationCard = 1 THEN NULL ELSE SignatureRegistrationCardPath END,
        FORegistrationCard            = CASE WHEN @FORegistrationCard = 1 THEN 0   ELSE FORegistrationCard END
    WHERE FolioNum = @FolioNum
      AND (@Seq IS NULL OR Seq = @Seq);
    SELECT @@ROWCOUNT AS AffectedRows;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_POSSignature', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_POSSignature
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_POSSignature
    @CheckNo       DECIMAL(18,0) = NULL,
    @RVCNo         DECIMAL(18,0) = NULL,
    @SignatureGuest IMAGE         = NULL,
    @SignaturePath  VARCHAR(500)  = NULL,
    @POSGuestCheck INT            = NULL
AS
BEGIN
    SET NOCOUNT ON;
    -- POS signature is stored in SMILE_POS; this stub returns success.
    SELECT 200 AS Result, 'POS signature recorded.' AS ResultMes;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_SetSignatureHotel', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_SetSignatureHotel
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_SetSignatureHotel
    @Signature     IMAGE         = NULL,
    @AvataHotel    IMAGE         = NULL,
    @SignatureName NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.HotelParameter
    SET HotelName = ISNULL(@SignatureName, HotelName)
    WHERE 1=1;
    SELECT @@ROWCOUNT AS AffectedRows, 200 AS Result;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_AddInforGuest', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_AddInforGuest
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_AddInforGuest
    @IdAddition DECIMAL(18,0) = NULL,
    @ProfileID  DECIMAL(18,0) = NULL,
    @Image      IMAGE         = NULL,
    @IsAvata    INT           = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ProfileNum DECIMAL(18,0) = @ProfileID;

    -- Auto-resolve ProfileID from AdditionalName when caller passes 0
    IF ISNULL(@ProfileNum, 0) = 0
        SELECT TOP 1 @ProfileNum = ISNULL(AProfileNum, 0)
        FROM dbo.AdditionalName WITH (NOLOCK)
        WHERE IdAddition = @IdAddition;

    IF ISNULL(@ProfileNum, 0) > 0
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.GuestPicture WHERE ProfileNumber = @ProfileNum)
            UPDATE dbo.GuestPicture SET Picture = @Image WHERE ProfileNumber = @ProfileNum;
        ELSE
            INSERT INTO dbo.GuestPicture (ProfileNumber, Picture) VALUES (@ProfileNum, @Image);
    END

    SELECT ISNULL(@ProfileNum,0) AS ProfileNumber, 200 AS Result;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_RemoveImage', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_RemoveImage
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_RemoveImage
    @Seq DECIMAL(18,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.GuestPicture WHERE ProfileNumber = @Seq;
    SELECT @@ROWCOUNT AS AffectedRows;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetImageByGuest', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetImageByGuest
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetImageByGuest
    @IdAddition DECIMAL(18,0) = NULL,
    @ProfileID  DECIMAL(18,0) = NULL,
    @FolioNum   DECIMAL(18,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ProfileNum DECIMAL(18,0) = @ProfileID;
    IF ISNULL(@ProfileNum, 0) = 0 AND @IdAddition IS NOT NULL
        SELECT TOP 1 @ProfileNum = ISNULL(AProfileNum, 0)
        FROM dbo.AdditionalName WITH (NOLOCK) WHERE IdAddition = @IdAddition;

    SELECT TOP 10
        GP.ProfileNumber AS seq,
        GP.Picture
    FROM dbo.GuestPicture GP WITH (NOLOCK)
    WHERE GP.ProfileNumber = @ProfileNum AND GP.Picture IS NOT NULL;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetSignatureGuest', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetSignatureGuest
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetSignatureGuest
    @FolioNum DECIMAL(18,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 50
        S.Seq, S.FolioNum, S.IdAddition,
        S.FOGuestCheck, S.SignaturePath,
        S.FORegistrationCard, S.FORegistrationCardName, S.FORegistrationCardCreateDate,
        S.FORegistrationCard_CheckOut, S.FORegistrationCardName_CO,
        S.FORegistrationCard_CHECKEDBY, S.FORegistrationCardName_CHECKEDBY,
        S.FORegistrationCardCreateDate_CHECKEDBY, S.FORegistrationCardPath_CHECKEDBY
    FROM SMILE_PICTURE.dbo.FontDeskSignture S WITH (NOLOCK)
    WHERE S.FolioNum = @FolioNum
    ORDER BY S.Seq;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_SignatureManagement', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_SignatureManagement
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_SignatureManagement
    @StartDate DATE       = NULL,
    @NumDays   INT        = 7,
    @RoomType  VARCHAR(20)= ''
AS
BEGIN
    SET NOCOUNT ON;
    IF @StartDate IS NULL SET @StartDate = CAST([dbo].[fnGetHotelDate]() AS DATE);
    DECLARE @EndDate DATE = DATEADD(DAY, @NumDays, @StartDate);

    SELECT
        F.FolioNum, F.ConfirmNum,
        dbo.fTCVNToUnicode(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'')) AS GuestName,
        F.RoomCode, F.RoomTypeCode,
        F.ArrivalDate, F.DepartureDate,
        CAST(CASE WHEN S.Seq IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS HasSignature,
        S.FORegistrationCardName, S.FORegistrationCardCreateDate
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN SMILE_PICTURE.dbo.FontDeskSignture S WITH (NOLOCK) ON S.FolioNum = F.FolioNum
    WHERE F.FolioStatus IN (1,2)
      AND F.ArrivalDate BETWEEN @StartDate AND @EndDate
      AND COALESCE(F.CancelNum,0) = 0
      AND (ISNULL(@RoomType,'') = '' OR F.RoomTypeCode = @RoomType)
    ORDER BY F.ArrivalDate, F.FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetImageRoomType', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetImageRoomType
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetImageRoomType
    @RoomTypeCode VARCHAR(20) = ''
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 CIImage AS ListPathImageRoomType
    FROM dbo.RoomType WITH (NOLOCK)
    WHERE RoomTypeCode = @RoomTypeCode;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_AddLstImgRoomType', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_AddLstImgRoomType
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_AddLstImgRoomType
    @RoomTypeCode          NVARCHAR(20)  = '',
    @ListPathImageRoomType NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.RoomType
    SET CIImage = @ListPathImageRoomType
    WHERE RoomTypeCode = @RoomTypeCode;
    SELECT @@ROWCOUNT AS AffectedRows;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_REGCardSign', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_REGCardSign
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_REGCardSign
    @Folionum   DECIMAL(18,0) = NULL,
    @IdAddition DECIMAL(18,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM SMILE_PICTURE.dbo.FontDeskSignture WITH (NOLOCK)
        WHERE FolioNum = @Folionum
          AND (@IdAddition IS NULL OR @IdAddition = 0 OR IdAddition = @IdAddition)
    )
    BEGIN
        SELECT TOP 1
            S.Seq, S.FolioNum, S.IdAddition,
            S.FORegistrationCard,
            S.SignatureRegistrationCard,
            S.SignatureRegistrationCardPath    AS Signature,
            S.FORegistrationCardName           AS GuestName,
            S.FORegistrationCardCreateDate,
            S.FORegistrationCard_CheckOut,
            S.SignatureRegistrationCardPath_CO AS SignatureCO,
            S.FORegistrationCardName_CO,
            S.FORegistrationCard_CHECKEDBY,
            S.SignatureRegistrationCardPath_CHECKEDBY,
            S.FORegistrationCardName_CHECKEDBY,
            S.FORegistrationCardCreateDate_CHECKEDBY,
            F.ConfirmNum, F.RoomCode, F.RoomTypeCode,
            ISNULL(RT.Description, F.RoomTypeCode) AS RoomTypeName,
            F.RoomTypeBooked, ISNULL(RTB.Description, F.RoomTypeBooked) AS RoomTypeBookedName,
            F.ArrivalDate, F.DepartureDate,
            ISNULL(F.NumAdult,1) + ISNULL(F.NumChild,0) AS NumGuest,
            F.FolioStatus,
            A.NationalityCode AS Nat, A.BirthDate AS DOB,
            A.PassportNum AS PassportNo, A.TeleNum AS Phone, A.Email,
            A.AProfileNum
        FROM SMILE_PICTURE.dbo.FontDeskSignture S WITH (NOLOCK)
        LEFT JOIN dbo.Folio F WITH (NOLOCK) ON F.FolioNum = S.FolioNum
        LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
        LEFT JOIN dbo.RoomType RTB WITH (NOLOCK) ON RTB.RoomTypeCode = F.RoomTypeBooked
        LEFT JOIN dbo.AdditionalName A WITH (NOLOCK)
               ON A.FolioNum = S.FolioNum AND A.IdAddition = S.IdAddition
        WHERE S.FolioNum = @Folionum
          AND (@IdAddition IS NULL OR @IdAddition = 0 OR S.IdAddition = @IdAddition)
        ORDER BY S.Seq DESC;
        RETURN;
    END

    -- Fallback khi chưa có signature: trả guest info từ Folio + AdditionalName
    SELECT TOP 1
        CAST(NULL AS BIGINT)       AS Seq,
        F.FolioNum, A.IdAddition,
        0                          AS FORegistrationCard,
        CAST(NULL AS IMAGE)        AS SignatureRegistrationCard,
        CAST(NULL AS VARCHAR(500)) AS Signature,
        LTRIM(RTRIM(ISNULL(A.LastName,'') + ' ' + ISNULL(A.FirstName,''))) AS GuestName,
        CAST(NULL AS DATETIME)     AS FORegistrationCardCreateDate,
        0                          AS FORegistrationCard_CheckOut,
        CAST(NULL AS VARCHAR(500)) AS SignatureCO,
        CAST(NULL AS NVARCHAR(MAX)) AS FORegistrationCardName_CO,
        0                          AS FORegistrationCard_CHECKEDBY,
        CAST(NULL AS VARCHAR(500)) AS SignatureRegistrationCardPath_CHECKEDBY,
        CAST(NULL AS NVARCHAR(MAX)) AS FORegistrationCardName_CHECKEDBY,
        CAST(NULL AS DATETIME)     AS FORegistrationCardCreateDate_CHECKEDBY,
        F.ConfirmNum, F.RoomCode, F.RoomTypeCode,
        ISNULL(RT.Description, F.RoomTypeCode) AS RoomTypeName,
        F.RoomTypeBooked, ISNULL(RTB.Description, F.RoomTypeBooked) AS RoomTypeBookedName,
        F.ArrivalDate, F.DepartureDate,
        ISNULL(F.NumAdult,1) + ISNULL(F.NumChild,0) AS NumGuest,
        F.FolioStatus,
        A.NationalityCode AS Nat, A.BirthDate AS DOB,
        A.PassportNum AS PassportNo, A.TeleNum AS Phone, A.Email,
        A.AProfileNum
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
    LEFT JOIN dbo.RoomType RTB WITH (NOLOCK) ON RTB.RoomTypeCode = F.RoomTypeBooked
    LEFT JOIN dbo.AdditionalName A WITH (NOLOCK)
           ON A.FolioNum = F.FolioNum AND A.IsChild = 0 AND ISNULL(A.ACancelNum,0) = 0
          AND (@IdAddition IS NULL OR @IdAddition = 0 OR A.IdAddition = @IdAddition)
    WHERE F.FolioNum = @Folionum
    ORDER BY A.IdAddition;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_RegistrationCard', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_RegistrationCard
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_RegistrationCard
    @FolioNum DECIMAL(18,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1
        S.Seq, S.FolioNum,
        S.FORegistrationCard, S.SignatureRegistrationCardPath,
        S.FORegistrationCardName, S.FORegistrationCardCreateDate,
        S.FORegistrationCard_CheckOut, S.SignatureRegistrationCardPath_CO, S.FORegistrationCardName_CO,
        S.FORegistrationCard_CHECKEDBY, S.SignatureRegistrationCardPath_CHECKEDBY,
        S.FORegistrationCardName_CHECKEDBY, S.FORegistrationCardCreateDate_CHECKEDBY
    FROM SMILE_PICTURE.dbo.FontDeskSignture S WITH (NOLOCK)
    WHERE S.FolioNum = @FolioNum
    ORDER BY S.Seq DESC;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_CheckIn', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_CheckIn
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_CheckIn
    @FolioNum   DECIMAL(18,0) = 0,
    @IdAddition DECIMAL(18,0) = 0,
    @CheckInAll INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @HotelDate DATETIME;
    SELECT TOP 1 @HotelDate = HotelDate FROM dbo.HotelParameter WITH (NOLOCK);

    UPDATE dbo.Folio
    SET FolioStatus    = 2,
        CheckInTime    = @HotelDate,
        CheckInClerkID = NULL
    WHERE FolioNum = @FolioNum;

    UPDATE dbo.AdditionalName SET AdtStatus = 2 WHERE FolioNum = @FolioNum;

    SELECT F.FolioNum, F.ConfirmNum, F.FolioStatus,
           dbo.fTCVNToUnicode(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'')) AS GuestName,
           F.RoomCode, F.RoomTypeCode, F.ArrivalDate, F.DepartureDate,
           @HotelDate AS HotelDate,
           200 AS Result, 'Check-in successful.' AS ResultMes
    FROM dbo.Folio F WITH (NOLOCK)
    WHERE F.FolioNum = @FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_OnlineCheckIn', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_OnlineCheckIn
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_OnlineCheckIn
    @FolioNum DECIMAL(18,0) = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @HotelDate DATETIME;
    SELECT TOP 1 @HotelDate = HotelDate FROM dbo.HotelParameter WITH (NOLOCK);

    UPDATE dbo.Folio
    SET FolioStatus  = 2,
        CheckInTime  = @HotelDate,
        CIOnlineFlag = 1
    WHERE FolioNum = @FolioNum
      AND FolioStatus = 1;

    UPDATE dbo.AdditionalName SET AdtStatus = 2 WHERE FolioNum = @FolioNum;

    SELECT TOP 1
           F.FolioNum,
           dbo.fTCVNToUnicode(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'')) AS GuestName,
           F.RoomCode, F.RoomTypeCode, F.ArrivalDate, F.DepartureDate,
           F.FolioStatus, F.ConfirmNum,
           200 AS Result, 'Online check-in successful.' AS ResultMes
    FROM dbo.Folio F WITH (NOLOCK)
    WHERE F.FolioNum = @FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_ListCheckIn', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_ListCheckIn
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_ListCheckIn
    @ConfirmNum VARCHAR(20) = '0'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @HotelDate DATETIME;
    SELECT TOP 1 @HotelDate = HotelDate FROM dbo.HotelParameter WITH (NOLOCK);

    DECLARE @CNum DECIMAL(18,0) = NULL;
    IF @ConfirmNum IS NOT NULL AND @ConfirmNum <> '' AND @ConfirmNum <> '0'
        SET @CNum = CASE WHEN ISNUMERIC(@ConfirmNum) = 1 THEN CAST(@ConfirmNum AS DECIMAL(18,0)) END;

    SELECT TOP 200
        F.FolioNum, F.ConfirmNum, F.FolioStatus,
        dbo.fTCVNToUnicode(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,'')) AS GuestName,
        F.RoomCode, F.ArrivalDate, F.DepartureDate, @HotelDate AS HotelDate,
        F.CIOnlineFlag AS CheckInOnlFlag, F.NumAdult, F.NumChild,
        F.GroupCode, F.TelNumM, F.MailM
    FROM dbo.Folio F WITH (NOLOCK)
    WHERE F.FolioStatus IN (1,2) AND COALESCE(F.CancelNum,0)=0
        AND (@CNum IS NULL OR F.ConfirmNum=@CNum)
        AND F.ArrivalDate = CAST(@HotelDate AS DATE)
    ORDER BY F.ArrivalDate, F.FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GuestRegitration', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GuestRegitration
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GuestRegitration
    @Confirmation DECIMAL(18,0) = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 500
        F.FolioNum, F.ConfirmNum, F.FolioStatus, A.IdAddition,
        dbo.fTCVNToUnicode(ISNULL(A.LastName,'')) AS ALastName,
        dbo.fTCVNToUnicode(ISNULL(A.FirstName,'')) AS AFirstName,
        ISNULL(A.IsChild,0) AS IsChild, ISNULL(A.Gender,0) AS Gender,
        ISNULL(A.ArrivalTime,'') AS ArrivalTime, ISNULL(A.DepartureTime,'') AS DepartureTime,
        A.BirthDate, A.TeleNum AS MobileNum, A.Email,
        A.PassportNum, A.VisaNum,
        ISNULL(A.NationalityCode,'') AS NationalityCode,
        ISNULL(A.Address1,'') AS GAddress, A.AdtStatus
    FROM dbo.Folio F WITH (NOLOCK)
    JOIN dbo.AdditionalName A WITH (NOLOCK) ON A.FolioNum = F.FolioNum
    WHERE F.ConfirmNum = @Confirmation AND COALESCE(F.CancelNum,0)=0
        AND ISNULL(A.ACancelNum,0) = 0
    ORDER BY A.IdAddition;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_UpdContractBooking', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_UpdContractBooking
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_UpdContractBooking
    @FolioNum DECIMAL(18,0) = 0,
    @Phone    VARCHAR(100) = '',
    @Email    VARCHAR(100) = '',
    @Note     VARCHAR(500) = ''
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Folio
    SET TelNumM = COALESCE(NULLIF(@Phone, ''), TelNumM),
        MailM   = COALESCE(NULLIF(@Email, ''), MailM)
    WHERE FolioNum = @FolioNum;
    SELECT @@ROWCOUNT AS AffectedRows;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_ListDetailPicture', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_ListDetailPicture
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_ListDetailPicture
    @FolioNum   DECIMAL(18,0) = 0,
    @IdAddition DECIMAL(18,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 200
        A.IdAddition, A.FolioNum, A.AdtStatus, A.IsChild, A.Gender,
        dbo.fTCVNToUnicode(ISNULL(A.LastName,'')) AS LastName,
        dbo.fTCVNToUnicode(ISNULL(A.FirstName,'')) AS FirstName,
        A.NationalityCode, A.PassportNum, A.BirthDate,
        A.TeleNum AS Phone, A.Email, A.AProfileNum,
        A.ACancelNum
    FROM dbo.AdditionalName A WITH (NOLOCK)
    WHERE A.FolioNum = @FolioNum
        AND ISNULL(A.ACancelNum,0) = 0
        AND (@IdAddition IS NULL OR A.IdAddition = @IdAddition)
    ORDER BY A.IdAddition;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_Country', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_Country
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_Country
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CountryCode, Description AS CountryName
    FROM dbo.Country WITH (NOLOCK)
    ORDER BY Description;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_AssignRoomToFolio', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_AssignRoomToFolio
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_AssignRoomToFolio
    @FolioNum DECIMAL(18,0),
    @RoomCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @RoomTypeCode VARCHAR(10);
    DECLARE @Affected INT;

    BEGIN TRAN;
        SELECT @RoomTypeCode = RoomTypeCode FROM dbo.Room WITH (UPDLOCK, HOLDLOCK) WHERE RoomCode = @RoomCode;

        UPDATE dbo.Folio
        SET RoomCode     = @RoomCode,
            RoomTypeCode = COALESCE(@RoomTypeCode, RoomTypeCode)
        WHERE FolioNum = @FolioNum;

        SET @Affected = @@ROWCOUNT;
    COMMIT TRAN;

    SELECT @Affected AS AffectedRows, @RoomCode AS RoomCode, @RoomTypeCode AS RoomTypeCode;
END
-- @@mmarrival:batch pms
IF COL_LENGTH('dbo.AdditionalName', 'ConfirmPrintFlag') IS NULL ALTER TABLE dbo.AdditionalName ADD ConfirmPrintFlag BIT NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'VIPLevel') IS NULL ALTER TABLE dbo.AdditionalName ADD VIPLevel INT NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'SmokerFlag') IS NULL ALTER TABLE dbo.AdditionalName ADD SmokerFlag BIT NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'NewspaperCode') IS NULL ALTER TABLE dbo.AdditionalName ADD NewspaperCode VARCHAR(2) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'SequenceNum') IS NULL ALTER TABLE dbo.AdditionalName ADD SequenceNum INT NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'Geographic1Code') IS NULL ALTER TABLE dbo.AdditionalName ADD Geographic1Code VARCHAR(3) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'Geographic2Code') IS NULL ALTER TABLE dbo.AdditionalName ADD Geographic2Code VARCHAR(3) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'ResidenceCard') IS NULL ALTER TABLE dbo.AdditionalName ADD ResidenceCard VARCHAR(30) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'Purpose') IS NULL ALTER TABLE dbo.AdditionalName ADD Purpose VARCHAR(50) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'EntryDateFrom') IS NULL ALTER TABLE dbo.AdditionalName ADD EntryDateFrom DATETIME NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'EntryDateTo') IS NULL ALTER TABLE dbo.AdditionalName ADD EntryDateTo DATETIME NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'EntryFrom') IS NULL ALTER TABLE dbo.AdditionalName ADD EntryFrom VARCHAR(20) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'EntryPort') IS NULL ALTER TABLE dbo.AdditionalName ADD EntryPort VARCHAR(20) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'IsSuedBy') IS NULL ALTER TABLE dbo.AdditionalName ADD IsSuedBy VARCHAR(40) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'Remark') IS NULL ALTER TABLE dbo.AdditionalName ADD Remark VARCHAR(1000) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'IsVNResident') IS NULL ALTER TABLE dbo.AdditionalName ADD IsVNResident INT NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'IsTransfer') IS NULL ALTER TABLE dbo.AdditionalName ADD IsTransfer INT NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'DocType') IS NULL ALTER TABLE dbo.AdditionalName ADD DocType VARCHAR(30) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'DocIssueDate') IS NULL ALTER TABLE dbo.AdditionalName ADD DocIssueDate DATETIME NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'VisaFree') IS NULL ALTER TABLE dbo.AdditionalName ADD VisaFree INT NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'PassportType') IS NULL ALTER TABLE dbo.AdditionalName ADD PassportType VARCHAR(30) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'Religion') IS NULL ALTER TABLE dbo.AdditionalName ADD Religion VARCHAR(30) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'TakeCareC') IS NULL ALTER TABLE dbo.AdditionalName ADD TakeCareC VARCHAR(100) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'TakeCareP') IS NULL ALTER TABLE dbo.AdditionalName ADD TakeCareP VARCHAR(100) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'AProfileNum') IS NULL ALTER TABLE dbo.AdditionalName ADD AProfileNum DECIMAL(18,0) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'ACancelNum') IS NULL ALTER TABLE dbo.AdditionalName ADD ACancelNum DECIMAL(18,0) NULL;
        IF COL_LENGTH('dbo.AdditionalName', 'AOriginCode') IS NULL ALTER TABLE dbo.AdditionalName ADD AOriginCode VARCHAR(10) NULL;
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_UpsertAdditionalName', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_UpsertAdditionalName
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_UpsertAdditionalName
    @FolioNum        DECIMAL(18,0),
    @IdAddition      DECIMAL(18,0) = NULL,
    @FolioSubNum     DECIMAL(18,0) = NULL,
    @ConfirmNum      DECIMAL(18,0) = NULL,
    -- Name/address params are NVARCHAR so Unicode diacritics survive the call
    -- boundary; if declared VARCHAR, SQL Server down-casts the Dapper nvarchar
    -- argument to CP1252 here (dropping 'ầ'/'ũ' -> '?') BEFORE the body runs.
    @LastName        NVARCHAR(50)  = '',
    @FirstName       NVARCHAR(50)  = '',
    @Title           VARCHAR(10)   = '',
    @Gender          BIT           = NULL,
    @BirthDate       DATETIME      = NULL,
    @PassportNum     VARCHAR(20)   = '',
    @NationalityCode VARCHAR(3)    = '',
    @MobileNum       VARCHAR(20)   = '',
    @Email           VARCHAR(50)   = '',
    @Occupation      NVARCHAR(50)  = '',
    @Address1        NVARCHAR(200) = '',
    @IsChild         BIT           = 0,
    @VisaNum         VARCHAR(20)   = NULL,
    @Province        NVARCHAR(200) = NULL,
    @VisaDateA       DATETIME      = NULL,
    @CompanyName     NVARCHAR(200) = NULL,
    @Address2        NVARCHAR(200) = NULL,
    @Address3        NVARCHAR(200) = NULL,
    @Address4        NVARCHAR(200) = NULL,
    @PostalCode      VARCHAR(10)   = NULL,
    @Country         NVARCHAR(20)  = NULL,
    @TeleNum         VARCHAR(20)   = NULL,
    @FaxNum          VARCHAR(20)   = NULL,
    @LanguageCode    VARCHAR(2)    = NULL,
    @WebSite         VARCHAR(35)   = NULL,
    @ArrivalTime     DATETIME      = NULL,
    @DepartureTime   DATETIME      = NULL,
    @AOriginCode     VARCHAR(10)   = NULL,
    @ACancelNum      DECIMAL(18,0) = NULL,
    @AProfileNum     DECIMAL(18,0) = NULL,
    @ConfirmPrintFlag BIT          = NULL,
    @VIPLevel        INT           = NULL,
    @SmokerFlag      BIT           = NULL,
    @NewspaperCode   VARCHAR(2)    = NULL,
    @SequenceNum     INT           = NULL,
    @Geographic1Code VARCHAR(3)    = NULL,
    @Geographic2Code VARCHAR(3)    = NULL,
    @ResidenceCard   VARCHAR(30)   = NULL,
    @Purpose         VARCHAR(50)   = NULL,
    @EntryDateFrom   DATETIME      = NULL,
    @EntryDateTo     DATETIME      = NULL,
    @EntryFrom       VARCHAR(20)   = NULL,
    @EntryPort       VARCHAR(20)   = NULL,
    @IsSuedBy        VARCHAR(40)   = NULL,
    @Remark          VARCHAR(1000) = NULL,
    @IsVNResident    INT           = NULL,
    @IsTransfer      INT           = NULL,
    @DocType         VARCHAR(30)   = NULL,
    @DocIssueDate    DATETIME      = NULL,
    @VisaFree        INT           = NULL,
    @PassportType    VARCHAR(30)   = NULL,
    @Religion        VARCHAR(30)   = NULL,
    @TakeCareC       VARCHAR(100)  = NULL,
    @TakeCareP       VARCHAR(100)  = NULL,
    -- 1 = the caller stores the whole name in @LastName (tenant option): blank FirstName
    -- instead of keeping the old value, which would otherwise repeat the given name.
    @ClearFirstName  BIT           = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @out TABLE (IdAddition DECIMAL(18,0));

    -- Clone-from-first-guest defaults: only consulted for params the caller
    -- left NULL, and only when this folio already has a first guest row.
    DECLARE @FirstArrivalTime DATETIME, @FirstDepartureTime DATETIME,
            @FirstConfirmNum DECIMAL(18,0), @FirstAOriginCode VARCHAR(10),
            @FirstACancelNum DECIMAL(18,0);
    SELECT TOP 1
        @FirstArrivalTime   = ArrivalTime,
        @FirstDepartureTime = DepartureTime,
        @FirstConfirmNum    = ConfirmNum,
        @FirstAOriginCode   = AOriginCode,
        @FirstACancelNum    = ACancelNum
    FROM dbo.AdditionalName WITH (NOLOCK)
    WHERE FolioNum = @FolioNum
    ORDER BY IdAddition;

    -- Folio-level fallback (covers the very first guest of the folio, where
    -- no prior AdditionalName row exists yet to clone from).
    DECLARE @FolioArrivalDate DATETIME, @FolioDepartureDate DATETIME, @FolioConfirmNum DECIMAL(18,0);
    SELECT @FolioArrivalDate = ArrivalDate, @FolioDepartureDate = DepartureDate, @FolioConfirmNum = ConfirmNum
    FROM dbo.Folio WITH (NOLOCK)
    WHERE FolioNum = @FolioNum;

    SET @ArrivalTime   = COALESCE(@ArrivalTime,   @FirstArrivalTime,   @FolioArrivalDate);
    SET @DepartureTime = COALESCE(@DepartureTime, @FirstDepartureTime, @FolioDepartureDate);
    SET @ConfirmNum    = COALESCE(NULLIF(@ConfirmNum, 0), @FirstConfirmNum, @FolioConfirmNum);
    SET @AOriginCode   = COALESCE(@AOriginCode,   @FirstAOriginCode);
    SET @ACancelNum    = COALESCE(@ACancelNum,    @FirstACancelNum, 0);

    MERGE dbo.AdditionalName WITH (HOLDLOCK) AS target
    USING (SELECT @FolioNum AS FolioNum, @IdAddition AS IdAddition, @PassportNum AS PassportNum,
                  @LastName AS LastName, @FirstName AS FirstName) AS src
    ON (
        target.FolioNum = src.FolioNum
        AND (
            (src.IdAddition IS NOT NULL AND target.IdAddition = src.IdAddition)
            OR (src.IdAddition IS NULL AND NULLIF(src.PassportNum,'') IS NOT NULL AND target.PassportNum = src.PassportNum)
            OR (src.IdAddition IS NULL AND NULLIF(src.PassportNum,'') IS NULL
                AND NULLIF(target.LastName,'')  IS NOT NULL
                AND NULLIF(target.FirstName,'') IS NOT NULL
                AND target.LastName  = src.LastName
                AND target.FirstName = src.FirstName)
            OR (src.IdAddition IS NULL AND NULLIF(src.PassportNum,'') IS NULL
                AND @ClearFirstName = 1
                AND NULLIF(src.LastName,'') IS NOT NULL
                AND NULLIF(target.FirstName,'') IS NULL
                AND target.LastName = src.LastName)
        )
    )
    WHEN MATCHED THEN UPDATE SET
        -- Name/address columns are TCVN-3 varchar(CP1252) (read back via
        -- dbo.fTCVNToUnicode), so encode the Unicode input to TCVN on write.
        -- UnicodeToTCVN is a no-op for plain ASCII, so existing rows are safe.
        LastName        = COALESCE(dbo.UnicodeToTCVN(NULLIF(@LastName,'')),  target.LastName),
        FirstName       = CASE WHEN @ClearFirstName = 1 AND NULLIF(@LastName,'') IS NOT NULL THEN ''
                               ELSE COALESCE(dbo.UnicodeToTCVN(NULLIF(@FirstName,'')), target.FirstName) END,
        Title           = COALESCE(NULLIF(@Title,''),          target.Title),
        Gender          = COALESCE(@Gender,                    target.Gender),
        BirthDate       = COALESCE(@BirthDate,                 target.BirthDate),
        PassportNum     = COALESCE(NULLIF(@PassportNum,''),    target.PassportNum),
        NationalityCode = COALESCE(NULLIF(@NationalityCode,''),target.NationalityCode),
        MobileNum       = COALESCE(NULLIF(@MobileNum,''),      target.MobileNum),
        TeleNum         = COALESCE(NULLIF(@TeleNum, @MobileNum), target.TeleNum),
        Email           = COALESCE(NULLIF(@Email,''),          target.Email),
        Occupation      = COALESCE(NULLIF(@Occupation,''), target.Occupation),
        Address1        = COALESCE(NULLIF(@Address1,''),   target.Address1),
        IsChild         = @IsChild,
        VisaNum         = COALESCE(@VisaNum,                   target.VisaNum),
        Province        = COALESCE(dbo.UnicodeToTCVN(@Province), target.Province),
        VisaDateA       = COALESCE(@VisaDateA,                 target.VisaDateA),
        FolioSubNum     = COALESCE(@FolioSubNum,               target.FolioSubNum),
        ConfirmNum      = COALESCE(@ConfirmNum,                target.ConfirmNum),
        CompanyName     = COALESCE(@CompanyName, target.CompanyName),
        Address2        = COALESCE(dbo.UnicodeToTCVN(@Address2),    target.Address2),
        Address3        = COALESCE(dbo.UnicodeToTCVN(@Address3),    target.Address3),
        Address4        = COALESCE(dbo.UnicodeToTCVN(@Address4),    target.Address4),
        PostalCode      = COALESCE(@PostalCode,                target.PostalCode),
        Country         = COALESCE(dbo.UnicodeToTCVN(@Country), target.Country),
        FaxNum          = COALESCE(@FaxNum,                    target.FaxNum),
        LanguageCode    = COALESCE(@LanguageCode,              target.LanguageCode),
        WebSite         = COALESCE(@WebSite,                   target.WebSite),
        ArrivalTime     = COALESCE(@ArrivalTime,               target.ArrivalTime),
        DepartureTime   = COALESCE(@DepartureTime,             target.DepartureTime),
        AOriginCode     = COALESCE(@AOriginCode,               target.AOriginCode),
        ACancelNum      = COALESCE(@ACancelNum,                target.ACancelNum),
        AProfileNum     = COALESCE(@AProfileNum,               target.AProfileNum),
        ConfirmPrintFlag = COALESCE(@ConfirmPrintFlag,         target.ConfirmPrintFlag),
        VIPLevel        = COALESCE(@VIPLevel,                  target.VIPLevel),
        SmokerFlag      = COALESCE(@SmokerFlag,                target.SmokerFlag),
        NewspaperCode   = COALESCE(@NewspaperCode,             target.NewspaperCode),
        SequenceNum     = COALESCE(@SequenceNum,               target.SequenceNum),
        Geographic1Code = COALESCE(@Geographic1Code,           target.Geographic1Code),
        Geographic2Code = COALESCE(@Geographic2Code,           target.Geographic2Code),
        ResidenceCard   = COALESCE(@ResidenceCard,             target.ResidenceCard),
        Purpose         = COALESCE(@Purpose,                   target.Purpose),
        EntryDateFrom   = COALESCE(@EntryDateFrom,             target.EntryDateFrom),
        EntryDateTo     = COALESCE(@EntryDateTo,               target.EntryDateTo),
        EntryFrom       = COALESCE(@EntryFrom,                 target.EntryFrom),
        EntryPort       = COALESCE(@EntryPort,                 target.EntryPort),
        IsSuedBy        = COALESCE(@IsSuedBy,                  target.IsSuedBy),
        Remark          = COALESCE(@Remark,                    target.Remark),
        IsVNResident    = COALESCE(@IsVNResident,              target.IsVNResident),
        IsTransfer      = COALESCE(@IsTransfer,                target.IsTransfer),
        DocType         = COALESCE(@DocType,                   target.DocType),
        DocIssueDate    = COALESCE(@DocIssueDate,              target.DocIssueDate),
        VisaFree        = COALESCE(@VisaFree,                  target.VisaFree),
        PassportType    = COALESCE(@PassportType,              target.PassportType),
        Religion        = COALESCE(@Religion,                  target.Religion),
        TakeCareC       = COALESCE(@TakeCareC,                 target.TakeCareC),
        TakeCareP       = COALESCE(@TakeCareP,                 target.TakeCareP),
        -- Guest has submitted check-in info: guarantee AdtStatus is never left
        -- NULL. 1 = reserved/submitted; leave a later in-house/2 value alone.
        AdtStatus       = COALESCE(target.AdtStatus, 1)
    WHEN NOT MATCHED THEN INSERT (
        FolioNum, FolioSubNum, ConfirmNum, LastName, FirstName, Title, Gender, BirthDate,
        PassportNum, NationalityCode, MobileNum, TeleNum, Email, Occupation, Address1, IsChild,
        VisaNum, Province, VisaDateA, AdtStatus,
        CompanyName, Address2, Address3, Address4, PostalCode, Country, FaxNum, LanguageCode, WebSite,
        ArrivalTime, DepartureTime, AOriginCode, ACancelNum, AProfileNum,
        ConfirmPrintFlag, VIPLevel, SmokerFlag, NewspaperCode, SequenceNum,
        Geographic1Code, Geographic2Code, ResidenceCard, Purpose,
        EntryDateFrom, EntryDateTo, EntryFrom, EntryPort, IsSuedBy, Remark,
        IsVNResident, IsTransfer, DocType, DocIssueDate, VisaFree, PassportType,
        Religion, TakeCareC, TakeCareP
    ) VALUES (
        @FolioNum, @FolioSubNum, @ConfirmNum, dbo.UnicodeToTCVN(@LastName), dbo.UnicodeToTCVN(@FirstName), @Title, @Gender, @BirthDate,
        @PassportNum, @NationalityCode, @MobileNum, COALESCE(@TeleNum, @MobileNum), @Email, @Occupation, @Address1, @IsChild,
        @VisaNum, dbo.UnicodeToTCVN(@Province), @VisaDateA, 1,
        @CompanyName, dbo.UnicodeToTCVN(@Address2), dbo.UnicodeToTCVN(@Address3), dbo.UnicodeToTCVN(@Address4),
        @PostalCode, dbo.UnicodeToTCVN(@Country), @FaxNum, @LanguageCode, @WebSite,
        @ArrivalTime, @DepartureTime, @AOriginCode, @ACancelNum, @AProfileNum,
        @ConfirmPrintFlag, @VIPLevel, @SmokerFlag, @NewspaperCode, @SequenceNum,
        @Geographic1Code, @Geographic2Code, @ResidenceCard, @Purpose,
        @EntryDateFrom, @EntryDateTo, @EntryFrom, @EntryPort, @IsSuedBy, @Remark,
        @IsVNResident, @IsTransfer, @DocType, @DocIssueDate, @VisaFree, @PassportType,
        @Religion, @TakeCareC, @TakeCareP
    )
    OUTPUT inserted.IdAddition INTO @out;

    SELECT IdAddition FROM @out;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_UpsertGuestProfile', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_UpsertGuestProfile
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_UpsertGuestProfile
    @IdAddition   DECIMAL(18,0),
    @LastName     NVARCHAR(50)  = NULL,
    @FirstName    NVARCHAR(50)  = NULL,
    @Title        NVARCHAR(10)  = NULL,
    @NationalCode VARCHAR(20)   = NULL,
    @PassportNum  VARCHAR(20)   = NULL,
    @BirthDate    DATETIME      = NULL,
    @Email        NVARCHAR(50)  = NULL,
    @PhoneNum     VARCHAR(20)   = NULL,
    @Gender       BIT           = NULL,
    @Occupation   VARCHAR(50)   = NULL,
    @Address1     NVARCHAR(200) = NULL,
    -- 1 = the whole name is in @LastName (tenant option): blank FirstName on update.
    @ClearFirstName BIT         = 0
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ProfileNum DECIMAL(18,0);
    DECLARE @ExistingProfileNum DECIMAL(18,0);

    BEGIN TRAN;

    SELECT @ExistingProfileNum = AProfileNum
    FROM dbo.AdditionalName WITH (UPDLOCK, HOLDLOCK)
    WHERE IdAddition = @IdAddition;

    IF @ExistingProfileNum IS NULL OR @ExistingProfileNum = 0
    BEGIN
        UPDATE dbo.AutoProfileNumber SET ProfileNumber = ProfileNumber + 1;

        DECLARE @Allocated DECIMAL(18,0);
        SELECT TOP 1 @Allocated = ProfileNumber FROM dbo.AutoProfileNumber;

        DECLARE @MaxExisting DECIMAL(18,0);
        SELECT @MaxExisting = COALESCE(MAX(ProfileNumber), 0) FROM dbo.Profile WITH (NOLOCK);

        IF @Allocated <= @MaxExisting
        BEGIN
            SET @Allocated = @MaxExisting + 1;
            UPDATE dbo.AutoProfileNumber SET ProfileNumber = @Allocated;
        END

        SET @ProfileNum = @Allocated;

        INSERT INTO dbo.Profile
            (ProfileNumber, LastName, FirstName, Title, NationalCode,
             PassportNum, BirthDate, Email, PhoneNum, Gender, Occupation, Address1)
        VALUES
            (@ProfileNum, @LastName, @FirstName, @Title, @NationalCode,
             @PassportNum, @BirthDate, @Email, @PhoneNum, @Gender, @Occupation, @Address1);

        UPDATE dbo.AdditionalName SET AProfileNum = @ProfileNum WHERE IdAddition = @IdAddition;
    END
    ELSE
    BEGIN
        SET @ProfileNum = @ExistingProfileNum;

        UPDATE dbo.Profile SET
            LastName     = COALESCE(NULLIF(@LastName, ''),     LastName),
            FirstName    = CASE WHEN @ClearFirstName = 1 AND NULLIF(@LastName, '') IS NOT NULL THEN ''
                                ELSE COALESCE(NULLIF(@FirstName, ''), FirstName) END,
            Title        = COALESCE(NULLIF(@Title, ''),        Title),
            NationalCode = COALESCE(NULLIF(@NationalCode, ''), NationalCode),
            PassportNum  = COALESCE(NULLIF(@PassportNum, ''),  PassportNum),
            BirthDate    = COALESCE(@BirthDate,                BirthDate),
            Email        = COALESCE(NULLIF(@Email, ''),        Email),
            PhoneNum     = COALESCE(NULLIF(@PhoneNum, ''),     PhoneNum),
            Gender       = COALESCE(@Gender,                   Gender),
            Occupation   = COALESCE(NULLIF(@Occupation, ''),   Occupation),
            Address1     = COALESCE(NULLIF(@Address1, ''),     Address1)
        WHERE ProfileNumber = @ProfileNum;
    END

    COMMIT TRAN;

    SELECT @ProfileNum AS ProfileNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_WalkInCreateReservation', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_WalkInCreateReservation
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_WalkInCreateReservation
    @ArrivalDate     DATE,
    @DepartureDate   DATE,
    @RoomTypeCode    VARCHAR(20),
    @RoomCode        VARCHAR(20)   = NULL,
    @NumAdult        INT           = 1,
    @NumChild        INT           = 0,
    @RateAmount      NUMERIC(18,2) = 0,
    @LastName        NVARCHAR(60)  = NULL,
    @FirstName       NVARCHAR(60)  = NULL,
    @IsMale          BIT           = 1,
    @NationalityCode VARCHAR(20)   = NULL,
    @PassportNum     VARCHAR(50)   = NULL,
    @Email           NVARCHAR(400) = NULL,
    @MobileNum       VARCHAR(50)   = NULL,
    @Notice          NVARCHAR(500) = NULL,
    @ClerkID         VARCHAR(3)    = NULL   -- PMS ClerkID is a 3-char code, not a username
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FolioNum   NUMERIC(18,0);
    DECLARE @FolioSub   NUMERIC(5,0);
    DECLARE @ConfNum    NUMERIC(18,0);
    DECLARE @Now        DATETIME = GETDATE();
    -- Encode names/notice once (no-op for plain ASCII, so existing data is safe).
    DECLARE @LastTcvn   VARCHAR(60)   = dbo.UnicodeToTCVN(@LastName);
    DECLARE @FirstTcvn  VARCHAR(60)   = dbo.UnicodeToTCVN(@FirstName);
    DECLARE @NoticeTcvn VARCHAR(1500) = dbo.UnicodeToTCVN(@Notice);

    BEGIN TRAN;

    -- Allocate FolioNum + FolioSubNum from AutoFolioNumber (mirrors GetFolioNumber),
    -- serialized so two concurrent walk-ins can't grab the same number.
    IF NOT EXISTS (SELECT 1 FROM dbo.AutoFolioNumber)
        INSERT INTO dbo.AutoFolioNumber (FolioNumber, FolioSubNumber) VALUES (10001, 0);

    UPDATE dbo.AutoFolioNumber WITH (HOLDLOCK, ROWLOCK)
        SET @FolioNum = CASE WHEN FolioNumber + 1 > 999990 THEN 10001 ELSE FolioNumber + 1 END,
            @FolioSub = CASE WHEN FolioNumber + 1 > 999990 THEN FolioSubNumber + 1 ELSE FolioSubNumber END,
            FolioNumber = CASE WHEN FolioNumber + 1 > 999990 THEN 10001 ELSE FolioNumber + 1 END,
            FolioSubNumber = CASE WHEN FolioNumber + 1 > 999990 THEN FolioSubNumber + 1 ELSE FolioSubNumber END;

    -- Allocate ConfirmNum from AutoConfNumber (mirrors GetConfirmNum).
    IF NOT EXISTS (SELECT 1 FROM dbo.AutoConfNumber)
        INSERT INTO dbo.AutoConfNumber (ConfNumber) VALUES (0);
    UPDATE dbo.AutoConfNumber WITH (HOLDLOCK, ROWLOCK)
        SET @ConfNum = ConfNumber + 1, ConfNumber = ConfNumber + 1;

    -- INSERT Folio — PMS defaults per SMILE-HLAPI NewFolio() (PaymentCode '7', VND,
    -- BreakfastCode 'ABU', FolioStatus 1 = reservation, BookStatus 1, WalkInFlag=1).
    INSERT INTO dbo.Folio (
        FolioNum, FolioSubNum, ArrivalDate, DepartureDate, NumRoom,
        RoomTypeCode, RoomCode, RoomTypeBooked, NumAdult, NumChild,
        ConfirmNum, ConfirmPrintFlag, FolioStatus, WalkInFlag, BookStatus,
        ReservationTime, ReservationClerkID, LastChangeClerkID, LastChangeTime,
        PaymentCode, RateOverideFlag, NetRate, IncludeBF, BreakfastCode,
        FolioCurrencyCode, FolioExRate, UpdateExRateAtCI, RateAmount,
        LastName, FirstName, MailM, TelNumM, Notice, CancelNum
    ) VALUES (
        @FolioNum, @FolioSub, @ArrivalDate, @DepartureDate, 1,
        @RoomTypeCode, @RoomCode, @RoomTypeCode, @NumAdult, @NumChild,
        @ConfNum, 1, 1, 1, 1,
        @Now, @ClerkID, @ClerkID, @Now,
        '7', 1, 1, 1, 'ABU',
        'VND', 1, 1, @RateAmount,
        @LastTcvn, @FirstTcvn, @Email, @MobileNum, @NoticeTcvn, 0
    );

    -- INSERT primary AdditionalName (IdAddition is IDENTITY -> plain insert).
    -- AdtStatus 1 = reserved (per project_smile_fo_guest_status).
    INSERT INTO dbo.AdditionalName (
        FolioNum, ConfirmNum, LastName, FirstName, Gender,
        NationalityCode, PassportNum, Email, MobileNum, AdtStatus, ACancelNum, IsChild
    ) VALUES (
        @FolioNum, @ConfNum, @LastTcvn, @FirstTcvn, @IsMale,
        @NationalityCode, @PassportNum, @Email, @MobileNum, 1, 0, 0
    );

    -- INSERT FolioRate for each night in [arrival, departure).
    ;WITH Nights AS (
        SELECT @ArrivalDate AS hDate
        UNION ALL
        SELECT DATEADD(DAY, 1, hDate) FROM Nights WHERE DATEADD(DAY, 1, hDate) < @DepartureDate
    )
    INSERT INTO dbo.FolioRate (FolioNum, hDate, RateAmount, ToDate, isCancel, RateOverride)
    SELECT @FolioNum, hDate, @RateAmount, @DepartureDate, 0, 1 FROM Nights
    OPTION (MAXRECURSION 366);

    COMMIT TRAN;

    SELECT @FolioNum AS FolioNum, @FolioSub AS FolioSubNum, @ConfNum AS ConfirmNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetAdditionalNamesByFolio', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetAdditionalNamesByFolio
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetAdditionalNamesByFolio
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        IdAddition,
        dbo.fTCVNToUnicode(LastName)    AS LastName,
        dbo.fTCVNToUnicode(FirstName)   AS FirstName,
        Gender,
        BirthDate,
        PassportNum,
        NationalityCode,
        MobileNum,
        Email,
        dbo.fTCVNToUnicode(Occupation)  AS Occupation,
        dbo.fTCVNToUnicode(Address1)    AS Address1,
        VisaNum,
        VisaDateA AS VisaIssueDate
    FROM dbo.AdditionalName WITH (NOLOCK)
    WHERE FolioNum = @FolioNum AND ISNULL(ACancelNum, 0) = 0
    ORDER BY IdAddition;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetAdditionalNameIdsByFolio', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetAdditionalNameIdsByFolio
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetAdditionalNameIdsByFolio
    @FolioNum DECIMAL(18,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdAddition FROM dbo.AdditionalName WHERE FolioNum = @FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GroupCheckinProgress', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GroupCheckinProgress
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GroupCheckinProgress
    @GroupCode NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT FolioNum, FolioStatus, RoomCode,
           LTRIM(RTRIM(ISNULL(LastName,'') + ' ' + ISNULL(FirstName,''))) AS GuestName,
           NumAdult, NumChild, ArrivalDate, DepartureDate
    FROM dbo.Folio WITH (NOLOCK)
    WHERE GroupCode = @GroupCode AND COALESCE(CancelNum,0) = 0 AND FolioStatus IN (1,2,3)
    ORDER BY FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_ReportMarketSegment', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_ReportMarketSegment
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_ReportMarketSegment
    @From DATE,
    @To   DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        ISNULL(F.MarketSegmentCode,'OTHER') AS SegmentCode,
        ISNULL(MS.Description, F.MarketSegmentCode) AS SegmentName,
        COUNT(*) AS FolioCount,
        SUM(ISNULL(F.NumAdult,0)+ISNULL(F.NumChild,0)) AS GuestCount,
        AVG(ISNULL(F.RateAmount,0)) AS AvgRate,
        CAST(AVG(CAST(DATEDIFF(day,F.ArrivalDate,F.DepartureDate) AS FLOAT)) AS DECIMAL(10,2)) AS AvgNights,
        CONVERT(CHAR(7),F.ArrivalDate,120) AS Month
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN dbo.MarketSegment MS WITH (NOLOCK) ON MS.MarketSegmentCode = F.MarketSegmentCode
    WHERE F.ArrivalDate BETWEEN CAST(@From AS DATETIME) AND CAST(@To AS DATETIME)
      AND F.FolioStatus IN (1,2,3) AND COALESCE(F.CancelNum,0)=0
    GROUP BY F.MarketSegmentCode, MS.Description, CONVERT(CHAR(7),F.ArrivalDate,120)
    ORDER BY Month, FolioCount DESC;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_ReportCancellations', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_ReportCancellations
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_ReportCancellations
    @From DATE,
    @To   DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CONVERT(char(10), ArrivalDate, 23) AS Month,
        SUM(CASE WHEN COALESCE(CancelNum,0) <> 0 THEN 1 ELSE 0 END) AS CancelCount,
        COUNT(*) AS TotalBookings,
        ISNULL(MarketSegmentCode,'OTHER') AS SegmentCode
    FROM dbo.Folio WITH (NOLOCK)
    WHERE ArrivalDate BETWEEN CAST(@From AS DATETIME) AND CAST(@To AS DATETIME)
    GROUP BY CONVERT(char(10), ArrivalDate, 23), MarketSegmentCode
    ORDER BY Month;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_ReportArrivalsByDay', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_ReportArrivalsByDay
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_ReportArrivalsByDay
    @from DATE,
    @to   DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CAST(ArrivalDate AS DATE) AS [Date], COUNT(*) AS TotalArrivals
    FROM dbo.Folio WITH (NOLOCK)
    WHERE FolioStatus IN (1, 2) AND ISNULL(CancelNum,0) = 0
      AND CAST(ArrivalDate AS DATE) BETWEEN @from AND @to
    GROUP BY CAST(ArrivalDate AS DATE)
    ORDER BY CAST(ArrivalDate AS DATE);
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_ReportClerkNames', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_ReportClerkNames
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_ReportClerkNames
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ClerkID, UserName FROM dbo.Clerk WITH (NOLOCK) ORDER BY ClerkID;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetHotelDate', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetHotelDate
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetHotelDate
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [dbo].[fnGetHotelDate]() AS HotelDate;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_FoGuestNames', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_FoGuestNames
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_FoGuestNames
    @FolioNum DECIMAL(18,0) = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT FolioNum, dbo.fTCVNToUnicode(LastName) AS LastName, dbo.fTCVNToUnicode(FirstName) AS FirstName,
           ArrivalTime, DepartureTime, IdAddition, AdtStatus
    FROM AdditionalName
    WHERE folionum = @FolioNum AND ISNULL(ACancelNum,0) = 0;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetFolioGuestCount', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetFolioGuestCount
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetFolioGuestCount
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 NumAdult, NumChild, FolioStatus FROM Folio WHERE FolioNum = @FolioNum ORDER BY FolioSubNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_UpdateFolioGuestCount', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_UpdateFolioGuestCount
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_UpdateFolioGuestCount
    @FolioNum DECIMAL(18,0),
    @NumAdult INT,
    @NumChild INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Folio SET NumAdult = @NumAdult, NumChild = @NumChild
    WHERE FolioNum = @FolioNum AND FolioSubNum = (SELECT MIN(FolioSubNum) FROM Folio WHERE FolioNum = @FolioNum);
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_MarkFolioNoShow', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_MarkFolioNoShow
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_MarkFolioNoShow
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Folio
    SET NoShowFlag = 1, RoomCode = '', RoomTypeCode = ISNULL(RoomTypeBooked, RoomTypeCode)
    WHERE FolioNum = @FolioNum AND FolioStatus = 1;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_CheckoutFolio', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_CheckoutFolio
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_CheckoutFolio
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RoomCode NVARCHAR(100) = (SELECT TOP 1 RoomCode FROM dbo.Folio WITH (NOLOCK) WHERE FolioNum = @FolioNum);
    UPDATE dbo.Folio SET FolioStatus = 3, CheckOutTime = GETDATE()
    WHERE FolioNum = @FolioNum AND FolioStatus = 2;
    SELECT @RoomCode AS RoomCode;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetFolioGuestProfiles', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetFolioGuestProfiles
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetFolioGuestProfiles
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT A.IdAddition, A.AProfileNum,
           LTRIM(RTRIM(ISNULL(A.LastName,'') + ' ' + ISNULL(A.FirstName,''))) AS GuestName,
           P.NumVisit, P.NumNight, P.TotalRevenue, P.TotalRoomRevenue,
           P.FirstVisitDate, P.VIPLevelCode, P.Email, P.PhoneNum
    FROM dbo.AdditionalName A WITH (NOLOCK)
    LEFT JOIN dbo.Profile P WITH (NOLOCK) ON P.ProfileNumber = A.AProfileNum
    WHERE A.FolioNum = @FolioNum
    ORDER BY A.IdAddition;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetFolioSpecialServices', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetFolioSpecialServices
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetFolioSpecialServices
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT SP.SpecialCode AS SpecialServiceCode,
           ISNULL(SS.Description, SP.SpecialCode) AS Description,
           SS.UponArrival, SS.UponDeparture, SS.AmountCharge
    FROM dbo.SpecialServicePosted SP WITH (NOLOCK)
    LEFT JOIN dbo.SpecialService SS WITH (NOLOCK) ON SS.SpecialServiceCode = SP.SpecialCode
    WHERE SP.FolioNum = @FolioNum
    ORDER BY SP.SpecialCode;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetFolioRates', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetFolioRates
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetFolioRates
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT hDate AS HDate, RateAmount
    FROM dbo.FolioRate WITH (NOLOCK)
    WHERE FolioNum = @FolioNum AND ISNULL(isCancel, 0) = 0
    ORDER BY hDate;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetFolioTrace', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetFolioTrace
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetFolioTrace
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TraceNote, TraceDate FROM dbo.Folio WITH (NOLOCK) WHERE FolioNum = @FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_UpdateFolioTrace', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_UpdateFolioTrace
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_UpdateFolioTrace
    @FolioNum DECIMAL(18,0),
    @Note     NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Folio SET TraceNote = @Note, TraceDate = GETDATE() WHERE FolioNum = @FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetFolioBreakfast', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetFolioBreakfast
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetFolioBreakfast
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT V.VNo, V.VDate, V.AdditionID, V.GuestName, V.PrintBy, V.PrintTime,
           ISNULL(V.isCancel,0) AS IsCancel, V.CancelBy, V.CancelTime
    FROM dbo.BreakfastVoucher V WITH (NOLOCK)
    WHERE V.FolioNum = @FolioNum
    ORDER BY V.VNo DESC;

    SELECT BreakfastCode, BFDescription, BFAmount FROM dbo.BreakfastCode WITH (NOLOCK) WHERE ISNULL(InActive,0) = 0;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_PrintBreakfastVoucher', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_PrintBreakfastVoucher
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_PrintBreakfastVoucher
    @FolioNum   DECIMAL(18,0),
    @AdditionID INT,
    @GuestName  NVARCHAR(4000) = NULL,
    @PrintBy    NVARCHAR(4000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;
    DECLARE @next INT = ISNULL((SELECT MAX(VNo) FROM dbo.BreakfastVoucher WITH (UPDLOCK, HOLDLOCK)), 0) + 1;
    INSERT INTO dbo.BreakfastVoucher (VNo, VDate, FolioNum, AdditionID, GuestName, PrintBy, PrintTime, isCancel)
    VALUES (@next, GETDATE(), @FolioNum, @AdditionID, @GuestName, @PrintBy, GETDATE(), 0);
    COMMIT TRANSACTION;
    SELECT @next AS VNo;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_FoCommandCenterPms', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_FoCommandCenterPms
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_FoCommandCenterPms
    @HotelDate      VARCHAR(20)  = '',
    @ActivityFolios VARCHAR(400) = ''
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @HD DATE = CAST(ISNULL(CASE WHEN ISDATE(NULLIF(@HotelDate,'')) = 1 THEN CAST(NULLIF(@HotelDate,'') AS DATETIME) END, [dbo].[fnGetHotelDate]()) AS DATE);

    DECLARE @HasVipCol BIT =
        CASE WHEN COL_LENGTH('dbo.Folio','VipCode') IS NULL THEN 0 ELSE 1 END;

    DECLARE @VipFolios TABLE (FolioNum DECIMAL(18,0) PRIMARY KEY);
    IF @HasVipCol = 1
    BEGIN
        INSERT INTO @VipFolios (FolioNum)
        EXEC sp_executesql
            N'SELECT FolioNum FROM dbo.Folio WITH (NOLOCK)
              WHERE ArrivalDate = @hd AND ISNULL(VipCode,0) <> 0 AND COALESCE(CancelNum,0) = 0',
            N'@hd DATE', @hd = @HD;
    END

    DECLARE @ArrivalsToday    INT = 0,
            @ArrivedSoFar     INT = 0,
            @InHouse          INT = 0,
            @DeparturesToday  INT = 0,
            @CheckedOutToday  INT = 0,
            @VipArrivalsToday INT = 0;

    SELECT @ArrivalsToday = COUNT(*)
    FROM dbo.Folio WITH (NOLOCK)
    WHERE ArrivalDate = @HD AND FolioStatus IN (1,2) AND COALESCE(CancelNum,0) = 0;

    SELECT @ArrivedSoFar = COUNT(*)
    FROM dbo.Folio WITH (NOLOCK)
    WHERE ArrivalDate = @HD AND FolioStatus = 2 AND COALESCE(CancelNum,0) = 0;

    SELECT @InHouse = COUNT(*)
    FROM dbo.Folio WITH (NOLOCK)
    WHERE FolioStatus = 2 AND COALESCE(CancelNum,0) = 0;

    SELECT @DeparturesToday = COUNT(*)
    FROM dbo.Folio WITH (NOLOCK)
    WHERE DepartureDate = @HD AND FolioStatus IN (2,3) AND COALESCE(CancelNum,0) = 0;

    SELECT @CheckedOutToday = COUNT(*)
    FROM dbo.Folio WITH (NOLOCK)
    WHERE DepartureDate = @HD AND FolioStatus = 3 AND COALESCE(CancelNum,0) = 0;

    SELECT @VipArrivalsToday = COUNT(*) FROM @VipFolios;

    SELECT
        @ArrivalsToday    AS ArrivalsToday,
        @ArrivedSoFar     AS ArrivedSoFar,
        @InHouse          AS InHouse,
        @DeparturesToday  AS DeparturesToday,
        @CheckedOutToday  AS CheckedOutToday,
        @VipArrivalsToday AS VipArrivalsToday,
        @HD               AS HotelDate;

    SELECT TOP 50
        F.FolioNum,
        F.ConfirmNum,
        LTRIM(RTRIM(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,''))) AS GuestName,
        F.RoomCode,
        F.RoomTypeCode,
        RT.Description AS RoomTypeName,
        F.ArrivalDate,
        F.ArrivalTime,
        F.NumAdult,
        F.NumChild,
        CAST(CASE WHEN V.FolioNum IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS IsVip,
        F.MemberID,
        F.GroupCode,
        F.FolioStatus,
        ISNULL(F.NoShowFlag, 0) AS NoShowFlag
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN dbo.RoomType RT WITH (NOLOCK) ON RT.RoomTypeCode = F.RoomTypeCode
    LEFT JOIN @VipFolios V ON V.FolioNum = F.FolioNum
    WHERE F.ArrivalDate = @HD
      AND F.FolioStatus IN (1,2)
      AND COALESCE(F.CancelNum,0) = 0
    ORDER BY
        CASE WHEN V.FolioNum IS NOT NULL THEN 0 ELSE 1 END,
        F.FolioStatus DESC,
        F.ArrivalTime ASC,
        F.FolioNum ASC;

    SELECT TOP 50
        F.FolioNum,
        F.ConfirmNum,
        LTRIM(RTRIM(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,''))) AS GuestName,
        F.RoomCode,
        F.DepartureDate,
        F.DepartureTime,
        CAST(CASE WHEN F.FolioStatus = 3 THEN 1 ELSE 0 END AS BIT) AS CheckedOut,
        CAST(CASE WHEN V.FolioNum IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS IsVip,
        F.FolioStatus,
        CAST(ISNULL(F.DelayCheckOutFlag,0) AS BIT)       AS DelayCheckOut,
        CAST(ISNULL(F.UnexpectedDepartureFlag,0) AS BIT) AS UnexpectedDeparture
    FROM dbo.Folio F WITH (NOLOCK)
    LEFT JOIN @VipFolios V ON V.FolioNum = F.FolioNum
    WHERE F.DepartureDate = @HD
      AND F.FolioStatus IN (2,3)
      AND COALESCE(F.CancelNum,0) = 0
    ORDER BY
        F.FolioStatus ASC,
        F.DepartureTime ASC,
        F.FolioNum ASC;

    SELECT F.FolioNum, COUNT(*) AS FolioRows
    FROM dbo.Folio F WITH (NOLOCK)
    WHERE F.ArrivalDate = @HD AND F.FolioStatus IN (1,2) AND COALESCE(F.CancelNum,0) = 0
    GROUP BY F.FolioNum;

    DECLARE @Activity TABLE (FolioNum DECIMAL(18,0) PRIMARY KEY);
    DECLARE @xml XML = CAST('<r><n>' + REPLACE(REPLACE(ISNULL(@ActivityFolios,''),' ',''), ',', '</n><n>') + '</n></r>' AS XML);
    INSERT INTO @Activity (FolioNum)
    SELECT DISTINCT CAST(x.n.value('.', 'VARCHAR(40)') AS DECIMAL(18,0))
    FROM @xml.nodes('/r/n') AS x(n)
    WHERE x.n.value('.', 'VARCHAR(40)') <> ''
      AND ISNUMERIC(x.n.value('.', 'VARCHAR(40)')) = 1;

    SELECT F.FolioNum,
           LTRIM(RTRIM(ISNULL(F.LastName,'') + ' ' + ISNULL(F.FirstName,''))) AS GuestName
    FROM dbo.Folio F WITH (NOLOCK)
    INNER JOIN @Activity A ON A.FolioNum = F.FolioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_NotificationFolioCandidates', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_NotificationFolioCandidates
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_NotificationFolioCandidates
    @hotelToday DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CONVERT(VARCHAR(40), f.FolioNum) AS FolioNum,
        f.FirstName,
        f.LastName,
        f.FolioStatus,
        CAST(f.ArrivalDate AS DATETIME2)   AS ArrivalDate,
        CAST(f.DepartureDate AS DATETIME2) AS DepartureDate,
        CAST(CASE WHEN ISNULL(f.NoShowFlag, 0) = 0 THEN 0 ELSE 1 END AS BIT) AS NoShow,
        CAST(CASE WHEN EXISTS (
                SELECT 1 FROM dbo.Profile p WITH (NOLOCK)
                WHERE p.ProfileNumber = f.ProfileNumber
                  AND NULLIF(LTRIM(RTRIM(p.VIPLevelCode)), '') IS NOT NULL)
             THEN 1 ELSE 0 END AS BIT) AS ProfileVip
    FROM dbo.Folio f WITH (NOLOCK)
    WHERE COALESCE(f.CancelNum, 0) = 0
      AND ((f.FolioStatus = 1 AND f.ArrivalDate = @hotelToday)
        OR (f.FolioStatus = 2 AND f.DepartureDate < @hotelToday));
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetVipLevels', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetVipLevels
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetVipLevels
AS
BEGIN
    SET NOCOUNT ON;
    SELECT VIPLevel AS Code, Description AS Name
    FROM dbo.VIP WITH (NOLOCK)
    WHERE VIPLevel <> 0
    ORDER BY VIPLevel;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_SetFolioVipLevel', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_SetFolioVipLevel
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_SetFolioVipLevel
    @folioNum BIGINT,
    @vipLevel INT,
    @clerkId  NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.AdditionalName
    SET VIPLevel = CASE WHEN @vipLevel = 0 THEN NULL ELSE @vipLevel END,
        LastChangeClerkID = @clerkId,
        LastChangeTime = GETDATE()
    WHERE FolioNum = @folioNum;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetGuestNamesByFolios', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetGuestNamesByFolios
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetGuestNamesByFolios
    @FolioNums VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Input TABLE (FolioNum DECIMAL(18,0) NOT NULL PRIMARY KEY);
    DECLARE @xml XML = CAST('<r><n>' + REPLACE(REPLACE(ISNULL(@FolioNums, ''), ' ', ''), ',', '</n><n>') + '</n></r>' AS XML);
    INSERT INTO @Input (FolioNum)
    SELECT DISTINCT CAST(x.n.value('.', 'VARCHAR(40)') AS DECIMAL(18,0))
    FROM @xml.nodes('/r/n') AS x(n)
    WHERE LTRIM(RTRIM(x.n.value('.', 'VARCHAR(40)'))) <> ''
      AND ISNUMERIC(x.n.value('.', 'VARCHAR(40)')) = 1;

    SELECT A.FolioNum,
           ISNULL(LTRIM(RTRIM(A.LastName)),  '') AS LastName,
           ISNULL(LTRIM(RTRIM(A.FirstName)), '') AS FirstName
    FROM dbo.AdditionalName A WITH (NOLOCK)
    INNER JOIN @Input I ON I.FolioNum = A.FolioNum
    WHERE ISNULL(A.ACancelNum, 0) = 0
    ORDER BY A.FolioNum, A.IdAddition;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_Retention_GetExpiredFolioCandidates', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_Retention_GetExpiredFolioCandidates
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_Retention_GetExpiredFolioCandidates
    @RetentionDays INT,
    @Top  INT = 200,
    @Skip INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Cutoff DATETIME = DATEADD(DAY, -@RetentionDays, GETDATE());
    ;WITH c AS (
        SELECT CAST(F.FolioNum AS NVARCHAR(40)) AS FolioNum, F.DepartureDate,
               ROW_NUMBER() OVER (ORDER BY F.DepartureDate, F.FolioNum) AS rn
        FROM dbo.Folio F WITH (NOLOCK)
        WHERE F.FolioStatus IN (3,4)
          AND F.DepartureDate IS NOT NULL
          AND F.DepartureDate < @Cutoff
    )
    SELECT FolioNum, DepartureDate
    FROM c
    WHERE rn > @Skip AND rn <= @Skip + @Top
    ORDER BY rn;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_MarkFolioMailSent', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_MarkFolioMailSent
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_MarkFolioMailSent
    @FolioNum DECIMAL(18,0)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Folio SET IsSendMail = 1 WHERE FolioNum = @FolioNum;
    SELECT @@ROWCOUNT AS AffectedRows;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetClerkByTouchPass', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetClerkByTouchPass
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetClerkByTouchPass
    @TouchPass NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 ClerkID, UserName AS ClerkName, TouchPass, Signture AS Signature
    FROM dbo.Clerk
    WHERE TouchPass = @TouchPass AND ISNULL(DeleteFlag, 0) = 0;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_UpdateClerkTouchPass', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_UpdateClerkTouchPass
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_UpdateClerkTouchPass
    @ClerkID   NVARCHAR(50),
    @TouchPass NVARCHAR(50),
    @Signature NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Affected INT;
    UPDATE dbo.Clerk
    SET TouchPass = @TouchPass,
        Signture  = COALESCE(@Signature, Signture)
    WHERE ClerkID = @ClerkID;
    SET @Affected = @@ROWCOUNT;
    SELECT @Affected AS AffectedRows, C.ClerkID, C.UserName AS ClerkName, C.TouchPass, C.Signture AS Signature
    FROM (SELECT 1 AS One) D
    LEFT JOIN dbo.Clerk C ON @Affected > 0 AND C.ClerkID = @ClerkID;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_GetAllClerks', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_GetAllClerks
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_GetAllClerks
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ClerkID, UserName AS ClerkName, TouchPass, Signture AS Signature
    FROM dbo.Clerk
    WHERE ISNULL(DeleteFlag, 0) = 0
    ORDER BY ClerkID;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_HousekeepingRooms', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_HousekeepingRooms
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_HousekeepingRooms
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @HD DATE = CAST(ISNULL((SELECT TOP 1 HotelDate FROM dbo.HotelParameter WITH (NOLOCK)), GETDATE()) AS DATE);

    SELECT R.RoomCode, R.RoomTypeCode, R.HskpStation,
           ISNULL(R.HSKPOccupied, 0) AS HSKPOccupied,
           ISNULL(R.HSKPClean,    0) AS HSKPClean,
           ISNULL(R.Inspected,    0) AS Inspected,
           ISNULL(R.SYSOccupied,  0) AS SYSOccupied,
           R.RStatus,
           CAST(CASE WHEN S.InHouse         > 0 THEN 1 ELSE 0 END AS BIT) AS HasInHouse,
           CAST(CASE WHEN S.ArrivalsToday   > 0 THEN 1 ELSE 0 END AS BIT) AS HasArrivalToday,
           CAST(CASE WHEN S.DeparturesToday > 0 THEN 1 ELSE 0 END AS BIT) AS HasDepartureToday
    FROM dbo.Room R WITH (NOLOCK)
    OUTER APPLY (
        SELECT
            COUNT(CASE WHEN F.FolioStatus = 2 THEN 1 END) AS InHouse,
            COUNT(CASE WHEN F.ArrivalDate   = @HD AND F.FolioStatus IN (1,2) THEN 1 END) AS ArrivalsToday,
            COUNT(CASE WHEN F.DepartureDate = @HD AND F.FolioStatus IN (2,3) THEN 1 END) AS DeparturesToday
        FROM dbo.Folio F WITH (NOLOCK)
        WHERE F.RoomCode = R.RoomCode AND COALESCE(F.CancelNum,0) = 0
    ) S
    WHERE R.RoomTypeCode <> '**' OR R.RoomTypeCode IS NULL
    ORDER BY R.RoomCode;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_HousekeepingUpdateRoomStatus', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_HousekeepingUpdateRoomStatus
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_HousekeepingUpdateRoomStatus
    @RoomCode  VARCHAR(20),
    @Clean     BIT,
    @Inspected BIT,
    @ClerkID   NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @OldClean BIT = 0, @OldIns BIT = 0;
    BEGIN TRANSACTION;
    -- Current values, for the audit log.
    SELECT @OldClean = ISNULL(HSKPClean, 0), @OldIns = ISNULL(Inspected, 0)
    FROM dbo.Room WITH (NOLOCK) WHERE RoomCode = @RoomCode;

    UPDATE dbo.Room SET HSKPClean = @Clean, Inspected = @Inspected
    WHERE RoomCode = @RoomCode;
    DECLARE @Affected INT = @@ROWCOUNT;

    -- SeqNo is IDENTITY: omitted from the INSERT.
    INSERT INTO dbo.HSKPStatusLog (RoomCode, ClerkID, ChangeTime, OldClean, OldIns, NewClean, NewIns)
    VALUES (@RoomCode, @ClerkID, GETDATE(), @OldClean, @OldIns, @Clean, @Inspected);
    COMMIT TRANSACTION;
    SELECT @Affected AS AffectedRows;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_HousekeepingMaintenance', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_HousekeepingMaintenance
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_HousekeepingMaintenance
AS
BEGIN
    SET NOCOUNT ON;
    SELECT nSeq, RoomCode, Status, BeginTime, EndTime,
           AssignStaff, Notes, PendingNotes, CreateDate
    FROM dbo.RoomMaintainant WITH (NOLOCK)
    WHERE EndTime IS NULL OR EndTime > DATEADD(day, -1, GETDATE())
    ORDER BY CreateDate DESC;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_HousekeepingCreateMaintenance', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_HousekeepingCreateMaintenance
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_HousekeepingCreateMaintenance
    @RoomCode    VARCHAR(20),
    @BeginTime   DATETIME       = NULL,
    @AssignStaff NVARCHAR(100)  = NULL,
    @Notes       NVARCHAR(4000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.RoomMaintainant (RoomCode, Status, BeginTime, AssignStaff, Notes, CreateDate)
    VALUES (@RoomCode, 0, @BeginTime, @AssignStaff, @Notes, GETDATE());
    SELECT CAST(SCOPE_IDENTITY() AS BIGINT) AS nSeq;
END
-- @@mmarrival:batch pms
IF OBJECT_ID('dbo.srCI_PostFolioPayment', 'P') IS NOT NULL DROP PROCEDURE dbo.srCI_PostFolioPayment
-- @@mmarrival:batch pms
CREATE PROCEDURE dbo.srCI_PostFolioPayment
    @FolioNum        DECIMAL(18,0),
    @BalanceCode     VARCHAR(20),
    @Amount          DECIMAL(18,2),
    @PaymentTypeCode VARCHAR(20),
    @Reference       NVARCHAR(50) = NULL,
    @UserName        NVARCHAR(40) = NULL,
    @RequestKey      VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET DEADLOCK_PRIORITY LOW;

    DECLARE @Code VARCHAR(20) = UPPER(LTRIM(RTRIM(ISNULL(@BalanceCode, ''))));
    DECLARE @PayCode VARCHAR(20) = UPPER(LTRIM(RTRIM(ISNULL(@PaymentTypeCode, ''))));
    DECLARE @Key VARCHAR(100) = LTRIM(RTRIM(ISNULL(@RequestKey, '')));
    DECLARE @User NVARCHAR(40) = LTRIM(RTRIM(ISNULL(@UserName, N'')));
    IF ISNULL(@FolioNum, 0) <= 0 OR @Code = '' OR LEN(@Code) > 2 OR @Code IN ('C', 'V', 'P')
    BEGIN RAISERROR('srCI_PostFolioPayment: no such folio bill window, nothing posted', 16, 1); RETURN; END
    IF @Amount IS NULL OR @Amount <= 0
    BEGIN RAISERROR('srCI_PostFolioPayment: the amount must be positive, nothing posted', 16, 2); RETURN; END
    IF @PayCode = '' OR @Key = ''
    BEGIN RAISERROR('srCI_PostFolioPayment: payment code and request key are required, nothing posted', 16, 3); RETURN; END

    -- The request key is kept as the line's reference number (30 chars): a key already posted on this folio returns
    -- that first line instead of posting again, before any other check (a retry after the bill changed is a no-op).
    DECLARE @FolioKey VARCHAR(10) = CAST(@FolioNum AS VARCHAR(10));
    DECLARE @Ref VARCHAR(30) = 'CI' + LEFT(CONVERT(VARCHAR(40), HASHBYTES('SHA1', @Key), 2), 28);
    DECLARE @rc INT, @Tid DECIMAL(18,0), @TidFolio VARCHAR(10), @TidCode VARCHAR(5);

    BEGIN TRANSACTION;
    -- The posting lock every azolo writer takes before it touches folio lines (one post at a time). Shorter than the
    -- agent's command timeout, so a busy PMS refuses cleanly instead of timing out mid-call.
    EXEC @rc = sp_getapplock @Resource = 'SMILE_FolioTransaction', @LockMode = 'Exclusive',
        @LockOwner = 'Transaction', @LockTimeout = 5000;
    IF @rc < 0
    BEGIN ROLLBACK TRANSACTION; RAISERROR('srCI_PostFolioPayment: folio posting is busy, nothing posted', 16, 4); RETURN; END

    SELECT TOP 1 @Tid = TransactionID FROM dbo.FolioTransaction
    WHERE FolioNum = @FolioKey AND RefNumber = @Ref
    ORDER BY TransactionID;
    IF @Tid IS NOT NULL
    BEGIN
        COMMIT TRANSACTION;
        SELECT CAST(@Tid AS VARCHAR(30)) AS TransactionRef;
        RETURN;
    END

    -- In house only, never a cancelled or no-post folio (the desk's own posting rules).
    DECLARE @Status INT, @Cancel DECIMAL(18,0), @NoPost INT, @HotelID VARCHAR(50);
    SELECT TOP 1 @Status = FolioStatus, @Cancel = ISNULL(CancelNum, 0), @NoPost = ISNULL(CAST(NoPostFlag AS INT), 0),
        @HotelID = HotelID
    FROM dbo.Folio WITH (UPDLOCK)
    WHERE FolioNum = @FolioNum
    ORDER BY FolioSubNum;
    IF @Status IS NULL OR @Status <> 2 OR @Cancel <> 0
    BEGIN ROLLBACK TRANSACTION; RAISERROR('srCI_PostFolioPayment: the folio is not in house, nothing posted', 16, 5); RETURN; END
    IF @NoPost <> 0
    BEGIN ROLLBACK TRANSACTION; RAISERROR('srCI_PostFolioPayment: posting is blocked on this folio, nothing posted', 16, 6); RETURN; END
    IF NOT EXISTS (SELECT 1 FROM dbo.FolioBalanceCode WHERE UPPER(LTRIM(RTRIM(BalanceCode))) = @Code)
    BEGIN ROLLBACK TRANSACTION; RAISERROR('srCI_PostFolioPayment: no such folio bill window, nothing posted', 16, 7); RETURN; END

    -- The hotel's payment code (Payment, as the cashier picks it), else a payment transaction code itself.
    DECLARE @TrnCode VARCHAR(10), @TrnSub VARCHAR(10), @Desc NVARCHAR(100), @Cur VARCHAR(10), @Group INT;
    SELECT TOP 1 @TrnCode = LTRIM(RTRIM(P.TransactionCode)), @TrnSub = LTRIM(RTRIM(ISNULL(P.TransactionSubCode, ''))),
        @Desc = P.Description, @Cur = LTRIM(RTRIM(ISNULL(P.CurrencyCode, '')))
    FROM dbo.Payment P
    WHERE UPPER(LTRIM(RTRIM(P.PaymentCode))) = @PayCode AND LTRIM(RTRIM(ISNULL(P.TransactionCode, ''))) <> ''
    ORDER BY CASE WHEN P.HotelID = @HotelID THEN 0 ELSE 1 END;
    IF @TrnCode IS NULL
        SELECT TOP 1 @TrnCode = LTRIM(RTRIM(T.TransactionCode)), @TrnSub = LTRIM(RTRIM(ISNULL(T.TransactionSubCode, ''))),
            @Desc = T.Description, @Cur = LTRIM(RTRIM(ISNULL(T.CurrencyCode, '')))
        FROM dbo.TransactionCode T
        WHERE UPPER(LTRIM(RTRIM(T.TransactionCode))) = @PayCode AND T.TransactionGroup = 2
        ORDER BY CASE WHEN LTRIM(RTRIM(ISNULL(T.TransactionSubCode, ''))) IN ('', '0', '00', '000') THEN 0 ELSE 1 END,
            CASE WHEN T.HotelID = @HotelID THEN 0 ELSE 1 END;
    -- The code as the transaction code table spells it (the tax lookup matches it exactly), and it must be a payment.
    SELECT TOP 1 @Group = T.TransactionGroup, @TrnSub = LTRIM(RTRIM(ISNULL(T.TransactionSubCode, '')))
    FROM dbo.TransactionCode T
    WHERE UPPER(LTRIM(RTRIM(T.TransactionCode))) = UPPER(@TrnCode)
    ORDER BY CASE WHEN LTRIM(RTRIM(ISNULL(T.TransactionSubCode, ''))) = @TrnSub THEN 0
                  WHEN LTRIM(RTRIM(ISNULL(T.TransactionSubCode, ''))) IN ('', '0', '00', '000') THEN 1 ELSE 2 END;
    IF @TrnCode IS NULL OR ISNULL(@Group, 0) <> 2
    BEGIN ROLLBACK TRANSACTION; RAISERROR('srCI_PostFolioPayment: the payment code is not a PMS payment, nothing posted', 16, 8); RETURN; END
    IF @TrnSub = '' SET @TrnSub = '0';
    IF @Cur <> '' AND EXISTS (SELECT 1 FROM dbo.CurrencyDef WHERE IsBase = 1)
       AND NOT EXISTS (SELECT 1 FROM dbo.CurrencyDef WHERE IsBase = 1 AND UPPER(LTRIM(RTRIM(CurrencyCode))) = UPPER(@Cur))
    BEGIN ROLLBACK TRANSACTION; RAISERROR('srCI_PostFolioPayment: the payment code is in a foreign currency, nothing posted', 16, 9); RETURN; END

    -- Never more than the bill still owes: the guest paid what the bill showed, so a changed bill is refused.
    DECLARE @Bal DECIMAL(18,2) = (SELECT ISNULL(SUM(TransactionAmount), 0) FROM dbo.FolioTransaction
                                  WHERE FolioNum = @FolioKey AND UPPER(LTRIM(RTRIM(FolioBalanceCode))) = @Code);
    IF @Amount > @Bal
    BEGIN ROLLBACK TRANSACTION; RAISERROR('srCI_PostFolioPayment: the amount is more than the bill balance, nothing posted', 16, 10); RETURN; END

    -- The confirming clerk as the PMS posting clerk when the name is a clerk (the column holds 3 characters).
    DECLARE @Clerk VARCHAR(10) = '';
    IF @User <> N''
        SELECT TOP 1 @Clerk = LTRIM(RTRIM(ClerkID)) FROM dbo.Clerk
        WHERE LTRIM(RTRIM(ClerkID)) = @User OR LTRIM(RTRIM(UserName)) = @User
        ORDER BY CASE WHEN LTRIM(RTRIM(ClerkID)) = @User THEN 0 ELSE 1 END;
    IF LEN(@Clerk) > 3 SET @Clerk = '';

    DECLARE @Neg DECIMAL(18,2) = -@Amount;
    DECLARE @Note NVARCHAR(200) = LEFT(LTRIM(RTRIM(ISNULL(@Reference, N'')))
        + CASE WHEN @User = N'' THEN N'' ELSE N' - ' + @User END, 200);
    DECLARE @Desc50 NVARCHAR(50) = LEFT(LTRIM(RTRIM(ISNULL(@Desc, N''))), 50);
    EXEC dbo.PostOneTransaction @FolioNum = @FolioKey, @BillAmount = @Neg, @BillExRate = 1,
        @TransactionCode = @TrnCode, @TransactionSubCode = @TrnSub, @RefNumber = @Ref,
        @TransactionAmount = @Neg, @FolioBalanceCode = @Code, @Comment = @Note,
        @PostingClerkID = @Clerk, @LastChangeClerkID = @Clerk, @Description = @Desc50;

    -- The hotel's routing can move a line to another folio: a payment must land on the bill the guest paid.
    SET @Tid = NULL;
    SELECT TOP 1 @Tid = TransactionID, @TidFolio = LTRIM(RTRIM(FolioNum)), @TidCode = UPPER(LTRIM(RTRIM(FolioBalanceCode)))
    FROM dbo.FolioTransaction
    WHERE RefNumber = @Ref
      AND (FolioNum = @FolioKey
           OR FolioNum IN (SELECT CAST(CAST(R.ToFolioNum AS DECIMAL(18,0)) AS VARCHAR(10)) FROM dbo.ChargeRoot R
                           WHERE R.FolioNum = @FolioKey AND R.ToFolioNum IS NOT NULL))
    ORDER BY TransactionID;
    IF @Tid IS NULL
    BEGIN ROLLBACK TRANSACTION; RAISERROR('srCI_PostFolioPayment: the posted line was not found, nothing posted', 16, 11); RETURN; END
    IF @TidFolio <> @FolioKey OR @TidCode <> @Code
    BEGIN ROLLBACK TRANSACTION; RAISERROR('srCI_PostFolioPayment: the bill window routes payments to another folio, nothing posted', 16, 12); RETURN; END

    COMMIT TRANSACTION;
    SELECT CAST(@Tid AS VARCHAR(30)) AS TransactionRef;
END
