/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_mem_inner_brh_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_mem_inner_brh_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_mem_inner_brh_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_mem_inner_brh_info(
    id varchar2(60) -- ID
    ,mem_no varchar2(9) -- 会员代码
    ,brh_no varchar2(14) -- 机构代码
    ,branch_no varchar2(30) -- 机构号
    ,top_branch_no varchar2(30) -- 总行机构号
    ,last_upr_id varchar2(15) -- 最后修改操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,remark1 varchar2(1500) -- 备注1
    ,remark2 varchar2(1500) -- 备注2
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
grant select on ${iol_schema}.bdms_cpes_mem_inner_brh_info to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_mem_inner_brh_info to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_mem_inner_brh_info to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_mem_inner_brh_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_mem_inner_brh_info is '行内机构信息表';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.mem_no is '会员代码';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.brh_no is '机构代码';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.branch_no is '机构号';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.last_upr_id is '最后修改操作员';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.remark1 is '备注1';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.remark2 is '备注2';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_cpes_mem_inner_brh_info.etl_timestamp is 'ETL处理时间戳';
