/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_voucher_equal_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_voucher_equal_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_voucher_equal_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_equal_detail(
    ccy varchar2(3) -- 币种
    ,doc_type varchar2(10) -- 凭证类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_status varchar2(3) -- 凭证状态
    ,company varchar2(20) -- 法人
    ,equal_detail_seq_no varchar2(50) -- 凭证碰库详情序号
    ,equal_seq_no varchar2(50) -- 碰库序号
    ,prefix varchar2(10) -- 前缀
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,voucher_num number(6) -- 凭证数量
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_amt number(17,2) -- 交易金额
    ,voucher_end_no varchar2(50) -- 凭证终止号码
    ,voucher_start_no varchar2(50) -- 凭证起始号码
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
grant select on ${iol_schema}.ncbs_tb_voucher_equal_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_equal_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_equal_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_equal_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_voucher_equal_detail is '凭证碰库详情表';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.company is '法人';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.equal_detail_seq_no is '凭证碰库详情序号';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.equal_seq_no is '碰库序号';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.prefix is '前缀';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.voucher_num is '凭证数量';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_voucher_equal_detail.etl_timestamp is 'ETL处理时间戳';
