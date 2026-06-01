/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_wind_ashareindustriescode
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_wind_ashareindustriescode
whenever sqlerror continue none;
drop table ${msl_schema}.msl_wind_ashareindustriescode purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_wind_ashareindustriescode(
     ETL_DT DATE                          
    ,OBJECT_ID VARCHAR2(100)
    ,INDUSTRIESCODE VARCHAR2(38) 
    ,INDUSTRIESNAME VARCHAR2(50) 
    ,LEVELNUM NUMBER(1)    
    ,USED NUMBER(1)    
    ,INDUSTRIESALIAS VARCHAR2(12) 
    ,SEQUENCE1 NUMBER(4)    
    ,MEMO VARCHAR2(100)
    ,START_DT DATE         
    ,END_DT DATE         
    ,ID_MARK VARCHAR2(10) 
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_wind_ashareindustriescode to itl;

-- comment
comment on table ${msl_schema}.msl_wind_ashareindustriescode is '行业代码表';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.OBJECT_ID is '对象ID';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.INDUSTRIESCODE is '行业代码';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.INDUSTRIESNAME is '行业名称';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.LEVELNUM is '级数';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.USED is '是否有效';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.INDUSTRIESALIAS is '板块别名';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.SEQUENCE1 is '展示序号';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.MEMO is '备注';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.START_DT is '开始时间';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.END_DT is '结束时间';
comment on column ${msl_schema}.msl_wind_ashareindustriescode.ID_MARK is '增删标志';


