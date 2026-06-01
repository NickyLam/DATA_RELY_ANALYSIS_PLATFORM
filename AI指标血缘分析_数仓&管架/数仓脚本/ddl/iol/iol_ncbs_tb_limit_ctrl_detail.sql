/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_limit_ctrl_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_limit_ctrl_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_limit_ctrl_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_limit_ctrl_detail(
    ccy varchar2(3) -- 币种
    ,doc_type varchar2(10) -- 凭证类型
    ,company varchar2(20) -- 法人
    ,ctrl_detail_id varchar2(50) -- 控制明细编号
    ,ctrl_id varchar2(50) -- 控制编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,high_limit number(17,2) -- 收费金额上限
    ,eod_high_limit number(17,2) -- 日终上限
    ,low_limit number(17,2) -- 收费金额下限
    ,eod_low_limit number(17,2) -- 日终下限
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
grant select on ${iol_schema}.ncbs_tb_limit_ctrl_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_limit_ctrl_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_limit_ctrl_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_limit_ctrl_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_limit_ctrl_detail is '尾箱限额控制信息表';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.company is '法人';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.ctrl_detail_id is '控制明细编号';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.ctrl_id is '控制编号';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.high_limit is '收费金额上限';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.eod_high_limit is '日终上限';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.low_limit is '收费金额下限';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.eod_low_limit is '日终下限';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl_detail.etl_timestamp is 'ETL处理时间戳';
