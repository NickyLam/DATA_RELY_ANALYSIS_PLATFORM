/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_wind_financialincomedetails
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_wind_financialincomedetails
whenever sqlerror continue none;
drop table ${msl_schema}.msl_wind_financialincomedetails purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_wind_financialincomedetails(
    ETL_DT DATE
    ,OBJECT_ID VARCHAR2(38)
    ,S_INFO_COMPCODE VARCHAR2(10)
    ,STATEMENT_TYPE VARCHAR2(40)
    ,REPORT_PERIOD VARCHAR2(8)
    ,ANN_DT VARCHAR2(8)
    ,CRNCY_CODE VARCHAR2(10)
    ,SUBJECT_NAME VARCHAR2(200)
    ,ITEM_AMOUNT NUMBER(20,4)
    ,CLASSIFICATION_NUMBER NUMBER(4,0)
    ,PUBLISH_VALUE VARCHAR2(40)
    ,PUBLISH_COUNITDIMENSION VARCHAR2(20)
    ,IS_LISTING_DATA NUMBER(1,0)
    ,ACC_STA_CODE VARCHAR2(40)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant

-- comment
comment on table ${msl_schema}.msl_wind_financialincomedetails is '金融机构利润明细表';
comment on column ${msl_schema}.msl_wind_financialincomedetails.ETL_DT is 'ETL处理日期';
comment on column ${msl_schema}.msl_wind_financialincomedetails.OBJECT_ID is '对象ID';
comment on column ${msl_schema}.msl_wind_financialincomedetails.S_INFO_COMPCODE is '公司id';
comment on column ${msl_schema}.msl_wind_financialincomedetails.STATEMENT_TYPE is '报表类型';
comment on column ${msl_schema}.msl_wind_financialincomedetails.REPORT_PERIOD is '报告期';
comment on column ${msl_schema}.msl_wind_financialincomedetails.ANN_DT is '公告日期';
comment on column ${msl_schema}.msl_wind_financialincomedetails.CRNCY_CODE is '货币代码';
comment on column ${msl_schema}.msl_wind_financialincomedetails.SUBJECT_NAME is '科目名称';
comment on column ${msl_schema}.msl_wind_financialincomedetails.ITEM_AMOUNT is '科目金额';
comment on column ${msl_schema}.msl_wind_financialincomedetails.CLASSIFICATION_NUMBER is '序号';
comment on column ${msl_schema}.msl_wind_financialincomedetails.PUBLISH_VALUE is '公布值';
comment on column ${msl_schema}.msl_wind_financialincomedetails.PUBLISH_COUNITDIMENSION is '公布量纲';
comment on column ${msl_schema}.msl_wind_financialincomedetails.IS_LISTING_DATA is '是否上市后数据';
comment on column ${msl_schema}.msl_wind_financialincomedetails.ACC_STA_CODE is '会计准则类型';
