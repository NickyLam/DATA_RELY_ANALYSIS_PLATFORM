/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cabs_v_sys_clerk_oper
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cabs_v_sys_clerk_oper
whenever sqlerror continue none;
drop table ${iol_schema}.cabs_v_sys_clerk_oper purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cabs_v_sys_clerk_oper(
    txn_dt date -- 交易日期
    ,txn_tm varchar2(29) -- 交易时间
    ,blng_org_id varchar2(15) -- 所属机构编号
    ,oper_teller_id varchar2(24) -- 经办柜员编号
    ,auth_teller_id varchar2(24) -- 授权柜员编号
    ,txn_num varchar2(5) -- 交易码
    ,txn_desc varchar2(383) -- 交易描述
    ,data_src_cd varchar2(5) -- 系统代码
    ,serv_flag varchar2(3) -- 业务交易类型
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
grant select on ${iol_schema}.cabs_v_sys_clerk_oper to ${iml_schema};
grant select on ${iol_schema}.cabs_v_sys_clerk_oper to ${icl_schema};
grant select on ${iol_schema}.cabs_v_sys_clerk_oper to ${idl_schema};
grant select on ${iol_schema}.cabs_v_sys_clerk_oper to ${iel_schema};

-- comment
comment on table ${iol_schema}.cabs_v_sys_clerk_oper is '银企对账2.0系统业务量表';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.txn_dt is '交易日期';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.txn_tm is '交易时间';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.blng_org_id is '所属机构编号';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.oper_teller_id is '经办柜员编号';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.auth_teller_id is '授权柜员编号';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.txn_num is '交易码';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.txn_desc is '交易描述';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.data_src_cd is '系统代码';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.serv_flag is '业务交易类型';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cabs_v_sys_clerk_oper.etl_timestamp is 'ETL处理时间戳';
