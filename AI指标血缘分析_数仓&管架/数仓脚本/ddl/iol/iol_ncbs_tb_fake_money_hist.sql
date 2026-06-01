/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_fake_money_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_fake_money_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_fake_money_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_fake_money_hist(
    ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,bond_number number(5) -- 套数
    ,bond_version_num varchar2(20) -- 版别
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,fake_ccy_no varchar2(50) -- 假币冠字号码
    ,fake_money_status varchar2(1) -- 假币状态
    ,fake_num number(5) -- 假币张数
    ,hist_seq_no varchar2(50) -- 流水序号
    ,make_type varchar2(1) -- 制作方式
    ,par_value_id varchar2(20) -- 券别代码
    ,seq_no varchar2(50) -- 序号
    ,turn_over_branch varchar2(12) -- 上缴人行机构
    ,capture_date date -- 收缴日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,capture_branch varchar2(12) -- 收缴机构
    ,capture_user_id varchar2(8) -- 收缴柜员
    ,fake_amt number(17,2) -- 假币账面金额
    ,holder_global_id varchar2(60) -- 持有人证件号码
    ,holder_global_type varchar2(4) -- 持有人证件类型
    ,holder_name varchar2(200) -- 持有人名称
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,fake_money_operate_type varchar2(2) -- 假币操作类型
    ,turn_over_date date -- 上缴人行日期
    ,turn_over_user_id varchar2(30) -- 上缴人行柜员
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
grant select on ${iol_schema}.ncbs_tb_fake_money_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_fake_money_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_fake_money_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_fake_money_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_fake_money_hist is '假币管理流水';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.bond_number is '套数';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.bond_version_num is '版别';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.company is '法人';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.fake_ccy_no is '假币冠字号码';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.fake_money_status is '假币状态';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.fake_num is '假币张数';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.hist_seq_no is '流水序号';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.make_type is '制作方式';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.par_value_id is '券别代码';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.turn_over_branch is '上缴人行机构';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.capture_date is '收缴日期';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.capture_branch is '收缴机构';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.capture_user_id is '收缴柜员';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.fake_amt is '假币账面金额';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.holder_global_id is '持有人证件号码';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.holder_global_type is '持有人证件类型';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.holder_name is '持有人名称';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.fake_money_operate_type is '假币操作类型';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.turn_over_date is '上缴人行日期';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.turn_over_user_id is '上缴人行柜员';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_fake_money_hist.etl_timestamp is 'ETL处理时间戳';
