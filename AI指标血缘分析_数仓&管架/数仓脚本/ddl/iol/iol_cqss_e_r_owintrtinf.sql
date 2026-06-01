/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_owintrtinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_owintrtinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_owintrtinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_owintrtinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ed030i01
    ,inst_tp varchar2(45) -- 机构类型(业务管理机构类型):ed030d01
    ,mtit_ecd varchar2(192) -- 管理机构编码(业务管理机构代码):ed030i02
    ,ccycd varchar2(5) -- 币种代码(币种):ed030d02
    ,ow_intrt_bal number(38,0) -- 欠息余额:ed030j01
    ,bal_chg_dt date -- 余额变化日期:ed030r01
    ,ow_intrt_tp varchar2(2) -- 欠息类型:ed030d03
    ,infrpt_dt date -- 信息报告日期:ed030r02
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_e_r_owintrtinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_owintrtinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_owintrtinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_owintrtinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_owintrtinf is '欠息信息';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.cr_inf_id is '征信信息编号:ed030i01';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.inst_tp is '机构类型(业务管理机构类型):ed030d01';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.mtit_ecd is '管理机构编码(业务管理机构代码):ed030i02';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.ccycd is '币种代码(币种):ed030d02';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.ow_intrt_bal is '欠息余额:ed030j01';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.bal_chg_dt is '余额变化日期:ed030r01';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.ow_intrt_tp is '欠息类型:ed030d03';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.infrpt_dt is '信息报告日期:ed030r02';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_owintrtinf.etl_timestamp is 'ETL处理时间戳';
