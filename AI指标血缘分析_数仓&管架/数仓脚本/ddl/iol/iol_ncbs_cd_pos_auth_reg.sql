/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_pos_auth_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_pos_auth_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_pos_auth_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_pos_auth_reg(
    card_no varchar2(50) -- 卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,remark varchar2(600) -- 备注
    ,auth_id varchar2(50) -- 预授权码
    ,auth_seq_no varchar2(50) -- 预授权登记簿流水号
    ,channel_tran_status varchar2(1) -- 渠道业务处理状态
    ,company varchar2(20) -- 法人
    ,cup_send_code varchar2(10) -- 发送机构标识码
    ,merchant_code varchar2(50) -- 商行编号
    ,res_seq_no varchar2(50) -- 限制编号
    ,source_type varchar2(6) -- 渠道编号
    ,terminal_id varchar2(50) -- 交易终端编号
    ,auth_from_date date -- 预授权有效起始日期
    ,auth_thru_date date -- 预授权有效截止日期
    ,cup_date date -- 银联日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cup_area_code varchar2(15) -- 受理方标识码
    ,full_amt number(17,2) -- 预授权完成金额
    ,tran_amt number(17,2) -- 交易金额
    ,sub_seq_no varchar2(100) -- 系统子流水号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,reference varchar2(50) -- 交易参考号
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
grant select on ${iol_schema}.ncbs_cd_pos_auth_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_pos_auth_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_pos_auth_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_pos_auth_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_pos_auth_reg is '卡片pos预授权登记簿';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.card_no is '卡号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.ccy is '币种';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.remark is '备注';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.auth_id is '预授权码';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.auth_seq_no is '预授权登记簿流水号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.channel_tran_status is '渠道业务处理状态';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.company is '法人';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.cup_send_code is '发送机构标识码';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.merchant_code is '商行编号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.auth_from_date is '预授权有效起始日期';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.auth_thru_date is '预授权有效截止日期';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.cup_date is '银联日期';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.cup_area_code is '受理方标识码';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.full_amt is '预授权完成金额';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.sub_seq_no is '系统子流水号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cd_pos_auth_reg.etl_timestamp is 'ETL处理时间戳';
