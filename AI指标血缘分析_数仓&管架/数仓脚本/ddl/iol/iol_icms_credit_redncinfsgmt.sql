/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_redncinfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_redncinfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_redncinfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_redncinfsgmt(
    hometel varchar2(25) -- 住宅电话
    ,create_time varchar2(19) -- 入库时间
    ,cust_no varchar2(32) -- 客户号码
    ,resiinfoupdate varchar2(19) -- 信息更新日期
    ,resistatus varchar2(4) -- 居住状况
    ,deptcode varchar2(14) -- 征信机构代码
    ,resipc varchar2(6) -- 居住地邮编
    ,resiaddr varchar2(100) -- 居住地详细地址
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,residist varchar2(6) -- 居住地行政区划
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_credit_redncinfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_redncinfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_redncinfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_redncinfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_redncinfsgmt is '个人基本信息记录-居住地址段';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.hometel is '住宅电话';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.resiinfoupdate is '信息更新日期';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.resistatus is '居住状况';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.resipc is '居住地邮编';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.resiaddr is '居住地详细地址';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.residist is '居住地行政区划';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_redncinfsgmt.etl_timestamp is 'ETL处理时间戳';
