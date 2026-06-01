/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_wind_bankingficlasscbrc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_wind_bankingficlasscbrc
whenever sqlerror continue none;
drop table ${msl_schema}.msl_wind_bankingficlasscbrc purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_wind_bankingficlasscbrc(
    ETL_DT DATE
    ,OBJECT_ID VARCHAR2(100)
    ,S_INFO_COMPCODE VARCHAR2(40)
    ,S_INFO_COMPNAME VARCHAR2(100)
    ,S_INFO_TYPECODE VARCHAR2(50)
    ,ENTRY_DT VARCHAR2(8)
    ,REMOVE_DT VARCHAR2(8)
    ,CUR_SIGN VARCHAR2(10)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant

-- comment
comment on table ${msl_schema}.msl_wind_bankingficlasscbrc is '国内银行业金融机构分类(银监会)';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.ETL_DT is 'ETL处理日期';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.OBJECT_ID is '对象ID';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.S_INFO_COMPCODE is '公司ID';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.S_INFO_COMPNAME is '公司名称';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.S_INFO_TYPECODE is '分类代码';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.ENTRY_DT is '纳入日期';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.REMOVE_DT is '剔除日期';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.CUR_SIGN is '最新标志';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.START_DT is '开始时间';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.END_DT is '结束时间';
comment on column ${msl_schema}.msl_wind_bankingficlasscbrc.ID_MARK is '增删标志';
