/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_torg_organ
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_torg_organ
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_torg_organ purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_torg_organ(
    ETL_DT DATE
    ,ORGANID NUMBER(18,0)
    ,OWNERORGANID NUMBER(18,0)
    ,ORGANCODE VARCHAR2(50)
    ,ORGANNUM VARCHAR2(50)
    ,ORGANNAME VARCHAR2(255)
    ,INVOICENAME VARCHAR2(50)
    ,SHORTNAME VARCHAR2(255)
    ,ORGANTYPE NUMBER(18,0)
    ,ISBUILDACCUNT NUMBER(18,0)
    ,ADDRESS VARCHAR2(255)
    ,BUILDDATE TIMESTAMP(6)
    ,INVALIDDATE TIMESTAMP(6)
    ,CORPORATION VARCHAR2(50)
    ,MASTER VARCHAR2(50)
    ,POSTCODE VARCHAR2(50)
    ,LINKPHONE VARCHAR2(50)
    ,FAX VARCHAR2(50)
    ,EMAIL VARCHAR2(50)
    ,TAXNO VARCHAR2(50)
    ,PERSONNELNUM NUMBER(18,0)
    ,ISUSED NUMBER(18,0)
    ,REMARK VARCHAR2(200)
    ,EXT1 VARCHAR2(255)
    ,EXT2 VARCHAR2(100)
    ,EXT3 VARCHAR2(100)
    ,OFFICEDATE TIMESTAMP(6)
    ,MANAGERMASTER VARCHAR2(50)
    ,MOFFICEDATE TIMESTAMP(6)
    ,STATUS NUMBER(18,0)
    ,SOURCE_TYPE VARCHAR2(100)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_torg_organ to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_torg_organ is '机构表';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ORGANID is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.OWNERORGANID is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ORGANCODE is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ORGANNUM is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ORGANNAME is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.INVOICENAME is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.SHORTNAME is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ORGANTYPE is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ISBUILDACCUNT is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ADDRESS is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.BUILDDATE is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.INVALIDDATE is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.CORPORATION is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.MASTER is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.POSTCODE is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.LINKPHONE is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.FAX is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.EMAIL is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.TAXNO is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.PERSONNELNUM is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ISUSED is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.REMARK is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.EXT1 is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.EXT2 is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.EXT3 is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.OFFICEDATE is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.MANAGERMASTER is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.MOFFICEDATE is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.STATUS is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.SOURCE_TYPE is '';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_orws_torg_organ.ID_MARK is '增删标志';
