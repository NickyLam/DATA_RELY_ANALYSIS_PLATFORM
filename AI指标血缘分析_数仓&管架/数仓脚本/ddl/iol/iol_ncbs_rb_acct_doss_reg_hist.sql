/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_doss_reg_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_doss_reg_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_doss_reg_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_doss_reg_hist(
    batch_no varchar2(50) -- 批次号
    ,doss_operate_type varchar2(2) -- 转久悬操作类型
    ,hand_flag varchar2(1) -- 手工导入标记
    ,internal_key number(15,0) -- 账户内部键值
    ,client_no varchar2(16) -- 客户编号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,prod_type varchar2(12) -- 产品编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_name varchar2(200) -- 账户名称
    ,amt_type varchar2(10) -- 金额类型
    ,balance number(17,2) -- 余额
    ,int_amt number(17,2) -- 利息金额
    ,por_int_tot number(17,2) -- 本息合计
    ,tax_sc number(17,2) -- 账户利息税
    ,waitdoss_branch varchar2(12) -- 待转久悬机构
    ,waitdoss_user_id varchar2(8) -- 待转久悬操作员
    ,waitdoss_date date -- 待转久悬日期
    ,waitout_date date -- 待转营业外日期
    ,waitout_user_id varchar2(8) -- 待转营业外操作员
    ,withdrawal_date date -- 久悬清理日期
    ,withdrawal_branch varchar2(12) -- 久悬清理机构
    ,withdrawal_user_id varchar2(8) -- 转出柜员
    ,withdrawal_reason varchar2(200) -- 转出久悬原因
    ,doss_status varchar2(2) -- 久悬状态
    ,doss_date date -- 转久悬日期
    ,doss_branch varchar2(12) -- 转久悬机构
    ,doss_user_id varchar2(8) -- 转久悬柜员
    ,todoss_reason varchar2(200) -- 转入久悬原因
    ,active_date date -- 激活日期
    ,active_branch varchar2(12) -- 激活机构
    ,active_user_id varchar2(8) -- 激活柜员
    ,out_busi_date date -- 转营业外日期
    ,out_busi_user_id varchar2(8) -- 转营业外操作员
    ,individual_flag varchar2(1) -- 对公对私标志
    ,non_transplant_flag varchar2(1) -- 是否未移植数据
    ,to_bank_ind varchar2(1) -- 转出账号本/他行标志
    ,to_base_acct_no varchar2(50) -- 转出账号
    ,to_ccy varchar2(3) -- 目的币种
    ,to_acct_seq_no varchar2(5) -- 转出账户序列号
    ,to_acct_name varchar2(200) -- 转出户名
    ,to_acct_type varchar2(1) -- 转入账户类型
    ,remark varchar2(600) -- 备注
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,record_amt number(17,2) -- 实际入账金额
    ,tran_date date -- 交易日期
    ,branch varchar2(12) -- 交易机构编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,tran_amt number(17,2) -- 交易金额
    ,reference varchar2(50) -- 交易参考号
    ,auth_user_id varchar2(8) -- 授权柜员
    ,source_type varchar2(6) -- 渠道编号
    ,bond_version_num varchar2(20) -- 版别
    ,seq_no varchar2(50) -- 序号
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
grant select on ${iol_schema}.ncbs_rb_acct_doss_reg_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_reg_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_reg_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_reg_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_doss_reg_hist is '久悬登记簿操作历史表';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.doss_operate_type is '转久悬操作类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.hand_flag is '手工导入标记';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.balance is '余额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.por_int_tot is '本息合计';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.tax_sc is '账户利息税';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.waitdoss_branch is '待转久悬机构';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.waitdoss_user_id is '待转久悬操作员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.waitdoss_date is '待转久悬日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.waitout_date is '待转营业外日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.waitout_user_id is '待转营业外操作员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.withdrawal_date is '久悬清理日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.withdrawal_branch is '久悬清理机构';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.withdrawal_user_id is '转出柜员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.withdrawal_reason is '转出久悬原因';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.doss_status is '久悬状态';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.doss_date is '转久悬日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.doss_branch is '转久悬机构';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.doss_user_id is '转久悬柜员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.todoss_reason is '转入久悬原因';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.active_date is '激活日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.active_branch is '激活机构';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.active_user_id is '激活柜员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.out_busi_date is '转营业外日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.out_busi_user_id is '转营业外操作员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.non_transplant_flag is '是否未移植数据';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.to_bank_ind is '转出账号本/他行标志';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.to_base_acct_no is '转出账号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.to_ccy is '目的币种';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.to_acct_seq_no is '转出账户序列号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.to_acct_name is '转出户名';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.to_acct_type is '转入账户类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.record_amt is '实际入账金额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.branch is '交易机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.bond_version_num is '版别';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg_hist.etl_timestamp is 'ETL处理时间戳';
