/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_branch_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_branch_change
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_branch_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_branch_change(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_type varchar2(3) -- 客户类型
    ,file_name varchar2(200) -- 文件名称
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,amend_seq_no varchar2(50) -- 变更序号
    ,batch_no varchar2(50) -- 批次号
    ,branch_change_flag varchar2(1) -- 机构变更处理标志
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,narrative varchar2(400) -- 摘要
    ,system_id varchar2(20) -- 系统id
    ,effect_date date -- 产品生效日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,dest_branch_no varchar2(12) -- 目标机构编号
    ,new_branch varchar2(12) -- 变更后机构
    ,old_branch varchar2(12) -- 变更前机构
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,update_user_id varchar2(8) -- 修改柜员
    ,branch_change_type varchar2(20) -- 机构撤并交易类型
    ,change_custody_item_flag varchar2(1) -- 是否转移代保管物品
    ,change_user_flag varchar2(1) -- 是否转移柜员
    ,old_branch_name varchar2(200) -- 转出机构名称
    ,retain_old_branch_flag varchar2(1) -- 是否保留转出机构
    ,new_branch_name varchar2(200) -- 转入机构名称
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
grant select on ${iol_schema}.ncbs_tb_branch_change to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_branch_change to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_branch_change to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_branch_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_branch_change is '机构撤并登记簿';
comment on column ${iol_schema}.ncbs_tb_branch_change.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_tb_branch_change.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_tb_branch_change.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_branch_change.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_tb_branch_change.file_name is '文件名称';
comment on column ${iol_schema}.ncbs_tb_branch_change.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_tb_branch_change.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_branch_change.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_branch_change.amend_seq_no is '变更序号';
comment on column ${iol_schema}.ncbs_tb_branch_change.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_tb_branch_change.branch_change_flag is '机构变更处理标志';
comment on column ${iol_schema}.ncbs_tb_branch_change.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_tb_branch_change.company is '法人';
comment on column ${iol_schema}.ncbs_tb_branch_change.narrative is '摘要';
comment on column ${iol_schema}.ncbs_tb_branch_change.system_id is '系统id';
comment on column ${iol_schema}.ncbs_tb_branch_change.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_tb_branch_change.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_branch_change.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_branch_change.dest_branch_no is '目标机构编号';
comment on column ${iol_schema}.ncbs_tb_branch_change.new_branch is '变更后机构';
comment on column ${iol_schema}.ncbs_tb_branch_change.old_branch is '变更前机构';
comment on column ${iol_schema}.ncbs_tb_branch_change.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_branch_change.update_user_id is '修改柜员';
comment on column ${iol_schema}.ncbs_tb_branch_change.branch_change_type is '机构撤并交易类型';
comment on column ${iol_schema}.ncbs_tb_branch_change.change_custody_item_flag is '是否转移代保管物品';
comment on column ${iol_schema}.ncbs_tb_branch_change.change_user_flag is '是否转移柜员';
comment on column ${iol_schema}.ncbs_tb_branch_change.old_branch_name is '转出机构名称';
comment on column ${iol_schema}.ncbs_tb_branch_change.retain_old_branch_flag is '是否保留转出机构';
comment on column ${iol_schema}.ncbs_tb_branch_change.new_branch_name is '转入机构名称';
comment on column ${iol_schema}.ncbs_tb_branch_change.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_branch_change.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_branch_change.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_branch_change.etl_timestamp is 'ETL处理时间戳';
