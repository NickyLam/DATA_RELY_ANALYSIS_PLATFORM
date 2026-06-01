/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_voucher_special
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_voucher_special
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_voucher_special purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_special(
    doc_type varchar2(10) -- 凭证类型
    ,voucher_no varchar2(50) -- 凭证号码
    ,company varchar2(20) -- 法人
    ,prefix varchar2(10) -- 前缀
    ,seq_no varchar2(50) -- 序号
    ,status varchar2(1) -- 状态
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
grant select on ${iol_schema}.ncbs_tb_voucher_special to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_special to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_special to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_special to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_voucher_special is '特殊凭证登记薄';
comment on column ${iol_schema}.ncbs_tb_voucher_special.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_voucher_special.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_tb_voucher_special.company is '法人';
comment on column ${iol_schema}.ncbs_tb_voucher_special.prefix is '前缀';
comment on column ${iol_schema}.ncbs_tb_voucher_special.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_voucher_special.status is '状态';
comment on column ${iol_schema}.ncbs_tb_voucher_special.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_voucher_special.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_voucher_special.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_voucher_special.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_voucher_special.etl_timestamp is 'ETL处理时间戳';
