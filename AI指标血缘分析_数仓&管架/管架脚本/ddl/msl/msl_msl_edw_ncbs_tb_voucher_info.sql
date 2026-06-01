/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_ncbs_tb_voucher_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ncbs_tb_voucher_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ncbs_tb_voucher_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ncbs_tb_voucher_info(
    etl_dt date
    ,branch varchar2(12)
    ,ccy varchar2(3)
    ,doc_type varchar2(10)
    ,remark varchar2(600)
    ,voucher_status varchar2(3)
    ,company varchar2(20)
    ,prefix varchar2(10)
    ,tailbox_id varchar2(30)
    ,voucher_id varchar2(30)
    ,voucher_sum number(5)
    ,tran_timestamp varchar2(26)
    ,update_date date
    ,last_user_id varchar2(8)
    ,tran_amt number(17,2)
    ,voucher_end_no varchar2(50)
    ,voucher_start_no varchar2(50)
    ,start_dt date
    ,end_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ncbs_tb_voucher_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ncbs_tb_voucher_info is '尾箱凭证表';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.branch is '机构编号';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.ccy is '币种';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.doc_type is '凭证类型';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.remark is '备注';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.voucher_status is '凭证状态';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.company is '法人';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.prefix is '前缀';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.tailbox_id is '尾箱代号';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.voucher_id is '凭证主键';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.voucher_sum is '凭证合计数';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.tran_timestamp is '交易时间戳';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.update_date is '更新日期';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.last_user_id is '上一柜员id';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.tran_amt is '交易金额';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.voucher_end_no is '凭证终止号码';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.voucher_start_no is '凭证起始号码';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.start_dt is '开始日期';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.end_dt is '结束日期';
comment on column ${msl_schema}.msl_edw_ncbs_tb_voucher_info.id_mark is '删除标识';
