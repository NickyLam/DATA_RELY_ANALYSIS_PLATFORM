/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_voucher_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_voucher_change
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_voucher_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_change(
    company varchar2(20) -- 法人
    ,new_status varchar2(3) -- 新凭证状态
    ,old_status varchar2(3) -- 凭证原状态
    ,post_flag varchar2(1) -- 是否生成分录
    ,status_desc varchar2(50) -- 描述信息
    ,update_after varchar2(1) -- 凭证出售后登记簿更新标志
    ,update_before varchar2(1) -- 凭证出售前登记簿更新标志
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_tb_voucher_change to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_change to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_change to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_voucher_change is '凭证状态变化定义表';
comment on column ${iol_schema}.ncbs_tb_voucher_change.company is '法人';
comment on column ${iol_schema}.ncbs_tb_voucher_change.new_status is '新凭证状态';
comment on column ${iol_schema}.ncbs_tb_voucher_change.old_status is '凭证原状态';
comment on column ${iol_schema}.ncbs_tb_voucher_change.post_flag is '是否生成分录';
comment on column ${iol_schema}.ncbs_tb_voucher_change.status_desc is '描述信息';
comment on column ${iol_schema}.ncbs_tb_voucher_change.update_after is '凭证出售后登记簿更新标志';
comment on column ${iol_schema}.ncbs_tb_voucher_change.update_before is '凭证出售前登记簿更新标志';
comment on column ${iol_schema}.ncbs_tb_voucher_change.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_voucher_change.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_voucher_change.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_voucher_change.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_voucher_change.etl_timestamp is 'ETL处理时间戳';
