/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_redsct_credit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_redsct_credit
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_redsct_credit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_redsct_credit(
    id varchar2(60) -- 
    ,top_branch_no varchar2(15) -- 总行机构号
    ,branch_no varchar2(15) -- 机构号
    ,credit_sum_amt number(18,2) -- 再贴现授信总额的
    ,credit_balance_amt number(18,2) -- 再贴现授信余额
    ,credit_occurred_amt number(18,2) -- 再贴现授信累计发生额
    ,is_valid varchar2(2) -- 是否有效： 0 否 1 是
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,credit_balance_flag varchar2(2) -- 再贴现余额有效标识： 0 否 1 是
    ,credit_occurred_flag varchar2(2) -- 再贴现发生额有效标识： 0 否 1 是
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_cpes_redsct_credit to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_credit to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_credit to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_credit to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_redsct_credit is '再贴现授信信息表';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.id is '';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.branch_no is '机构号';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.credit_sum_amt is '再贴现授信总额的';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.credit_balance_amt is '再贴现授信余额';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.credit_occurred_amt is '再贴现授信累计发生额';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.is_valid is '是否有效： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.credit_balance_flag is '再贴现余额有效标识： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.credit_occurred_flag is '再贴现发生额有效标识： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_redsct_credit.etl_timestamp is 'ETL处理时间戳';
