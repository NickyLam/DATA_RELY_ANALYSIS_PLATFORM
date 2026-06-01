/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_sign
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_sign(
    ccy varchar2(3) -- 币种
    ,reference varchar2(50) -- 交易参考号
    ,cash_sign_type varchar2(1) -- 长短款标记
    ,cash_sign_id varchar2(50) -- 现金长短款汇总编号
    ,cash_sign_status varchar2(1) -- 现金状态
    ,company varchar2(20) -- 法人
    ,cash_sign_amt number(17,2) -- 长短款金额(ovg)
    ,reserve_flag varchar2(1) -- 冲正标志
    ,seq_no varchar2(50) -- 序号
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,cash_sign_date date -- 现金长短款挂账日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cash_sign_user varchar2(8) -- 长短款登记柜员
    ,leaderr_cash_branch varchar2(12) -- 导致长短钞差错机构
    ,leaderr_user_id varchar2(8) -- 导致长短钞差错柜员
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
grant select on ${iol_schema}.ncbs_tb_cash_sign to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_sign to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_sign to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_sign is '现金长短款挂账汇总表';
comment on column ${iol_schema}.ncbs_tb_cash_sign.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_cash_sign.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_cash_sign.cash_sign_type is '长短款标记';
comment on column ${iol_schema}.ncbs_tb_cash_sign.cash_sign_id is '现金长短款汇总编号';
comment on column ${iol_schema}.ncbs_tb_cash_sign.cash_sign_status is '现金状态';
comment on column ${iol_schema}.ncbs_tb_cash_sign.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_sign.cash_sign_amt is '长短款金额(ovg)';
comment on column ${iol_schema}.ncbs_tb_cash_sign.reserve_flag is '冲正标志';
comment on column ${iol_schema}.ncbs_tb_cash_sign.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_cash_sign.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_cash_sign.cash_sign_date is '现金长短款挂账日期';
comment on column ${iol_schema}.ncbs_tb_cash_sign.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_sign.cash_sign_user is '长短款登记柜员';
comment on column ${iol_schema}.ncbs_tb_cash_sign.leaderr_cash_branch is '导致长短钞差错机构';
comment on column ${iol_schema}.ncbs_tb_cash_sign.leaderr_user_id is '导致长短钞差错柜员';
comment on column ${iol_schema}.ncbs_tb_cash_sign.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_cash_sign.etl_timestamp is 'ETL处理时间戳';
