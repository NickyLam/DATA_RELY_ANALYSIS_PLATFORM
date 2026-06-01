/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubinstid
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubinstid
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubinstid purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubinstid(
    instid varchar2(17) -- 银联机构号
    ,instna varchar2(600) -- 机构名称
    ,addr varchar2(600) -- 机构所属地
    ,remark1 varchar2(150) -- 备用字段
    ,remark2 varchar2(300) -- 备用字段
    ,remark3 varchar2(600) -- 备用字段
    ,remark4 varchar2(600) -- 备用字段
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
grant select on ${iol_schema}.mpcs_a51ubinstid to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubinstid to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubinstid to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubinstid to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubinstid is '中台的银联机构信息表';
comment on column ${iol_schema}.mpcs_a51ubinstid.instid is '银联机构号';
comment on column ${iol_schema}.mpcs_a51ubinstid.instna is '机构名称';
comment on column ${iol_schema}.mpcs_a51ubinstid.addr is '机构所属地';
comment on column ${iol_schema}.mpcs_a51ubinstid.remark1 is '备用字段';
comment on column ${iol_schema}.mpcs_a51ubinstid.remark2 is '备用字段';
comment on column ${iol_schema}.mpcs_a51ubinstid.remark3 is '备用字段';
comment on column ${iol_schema}.mpcs_a51ubinstid.remark4 is '备用字段';
comment on column ${iol_schema}.mpcs_a51ubinstid.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubinstid.etl_timestamp is 'ETL处理时间戳';
