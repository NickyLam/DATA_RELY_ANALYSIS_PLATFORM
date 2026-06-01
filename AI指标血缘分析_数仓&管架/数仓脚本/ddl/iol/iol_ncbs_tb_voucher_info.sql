/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_voucher_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_voucher_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_voucher_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_info(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,doc_type varchar2(10) -- 凭证类型
    ,remark varchar2(600) -- 备注
    ,voucher_status varchar2(3) -- 凭证状态
    ,company varchar2(20) -- 法人
    ,prefix varchar2(10) -- 前缀
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,voucher_id varchar2(30) -- 凭证主键
    ,voucher_sum number(5) -- 凭证合计数
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,update_date date -- 更新日期
    ,last_user_id varchar2(8) -- 上一柜员id
    ,tran_amt number(17,2) -- 交易金额
    ,voucher_end_no varchar2(50) -- 凭证终止号码
    ,voucher_start_no varchar2(50) -- 凭证起始号码
    ,voucher_sum_last_prev number(5) -- 上上日期初凭证合计数|上上日期初凭证合计数
    ,voucher_sum_prev number(5) -- 期初凭证合计数|期初凭证合计数
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
grant select on ${iol_schema}.ncbs_tb_voucher_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_voucher_info is '尾箱凭证表';
comment on column ${iol_schema}.ncbs_tb_voucher_info.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_voucher_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_voucher_info.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_voucher_info.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_voucher_info.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_tb_voucher_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_voucher_info.prefix is '前缀';
comment on column ${iol_schema}.ncbs_tb_voucher_info.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_voucher_info.voucher_id is '凭证主键';
comment on column ${iol_schema}.ncbs_tb_voucher_info.voucher_sum is '凭证合计数';
comment on column ${iol_schema}.ncbs_tb_voucher_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_voucher_info.update_date is '更新日期';
comment on column ${iol_schema}.ncbs_tb_voucher_info.last_user_id is '上一柜员id';
comment on column ${iol_schema}.ncbs_tb_voucher_info.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_voucher_info.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_tb_voucher_info.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_tb_voucher_info.voucher_sum_last_prev is '上上日期初凭证合计数|上上日期初凭证合计数';
comment on column ${iol_schema}.ncbs_tb_voucher_info.voucher_sum_prev is '期初凭证合计数|期初凭证合计数';
comment on column ${iol_schema}.ncbs_tb_voucher_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_voucher_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_voucher_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_voucher_info.etl_timestamp is 'ETL处理时间戳';
