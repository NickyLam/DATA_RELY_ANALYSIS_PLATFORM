/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_mlginfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_mlginfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_mlginfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_mlginfsgmt(
    create_time varchar2(19) -- 入库时间
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,cust_no varchar2(32) -- 客户号码
    ,mailaddr varchar2(100) -- 通讯地址
    ,maildist varchar2(6) -- 通讯地行政区划
    ,deptcode varchar2(14) -- 征信机构代码
    ,mailpc varchar2(6) -- 通讯地邮编
    ,mlginfoupdate varchar2(19) -- 信息更新日期
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
grant select on ${iol_schema}.icms_credit_mlginfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_mlginfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_mlginfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_mlginfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_mlginfsgmt is '个人基本信息记录-通讯地址段';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.mailaddr is '通讯地址';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.maildist is '通讯地行政区划';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.mailpc is '通讯地邮编';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.mlginfoupdate is '信息更新日期';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_mlginfsgmt.etl_timestamp is 'ETL处理时间戳';
