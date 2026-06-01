/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_doss_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_doss_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_doss_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_doss_reg(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,amt_type varchar2(10) -- 金额类型
    ,balance number(17,2) -- 余额
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,doss_operate_type varchar2(2) -- 转久悬操作类型
    ,doss_status varchar2(2) -- 久悬状态
    ,hand_flag varchar2(1) -- 手工导入标记
    ,individual_flag varchar2(1) -- 对公对私标志
    ,non_transplant_flag varchar2(1) -- 是否未移植数据
    ,to_bank_ind varchar2(1) -- 转出账号本/他行标志
    ,active_date date -- 激活日期
    ,doss_date date -- 转久悬日期
    ,out_busi_date date -- 转营业外日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,waitdoss_date date -- 待转久悬日期
    ,waitout_date date -- 待转营业外日期
    ,withdrawal_date date -- 久悬清理日期
    ,acct_ccy varchar2(3) -- 账户币种
    ,active_branch varchar2(12) -- 激活机构
    ,active_user_id varchar2(8) -- 激活柜员
    ,doss_branch varchar2(12) -- 转久悬机构
    ,doss_user_id varchar2(8) -- 转久悬柜员
    ,int_amt number(17,2) -- 利息金额
    ,out_busi_user_id varchar2(8) -- 转营业外操作员
    ,por_int_tot number(17,2) -- 本息合计
    ,record_amt number(17,2) -- 实际入账金额
    ,tax_sc number(17,2) -- 账户利息税
    ,to_acct_name varchar2(200) -- 转出户名
    ,to_acct_seq_no varchar2(5) -- 转出账户序列号
    ,to_acct_type varchar2(1) -- 转入账户类型
    ,to_base_acct_no varchar2(50) -- 转出账号
    ,to_ccy varchar2(3) -- 目的币种
    ,todoss_reason varchar2(200) -- 转入久悬原因
    ,waitdoss_branch varchar2(12) -- 待转久悬机构
    ,waitdoss_user_id varchar2(8) -- 待转久悬操作员
    ,waitout_user_id varchar2(8) -- 待转营业外操作员
    ,withdrawal_branch varchar2(12) -- 久悬清理机构
    ,withdrawal_reason varchar2(200) -- 转出久悬原因
    ,withdrawal_user_id varchar2(8) -- 转出柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,bond_version_num varchar2(20) -- 版别
    ,branch varchar2(12) -- 交易机构编号
    ,reference varchar2(50) -- 交易参考号
    ,source_type varchar2(6) -- 渠道编号
    ,tran_amt number(17,2) -- 交易金额
    ,tran_date date -- 交易日期
    ,user_id varchar2(8) -- 交易柜员编号
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
grant select on ${iol_schema}.ncbs_rb_acct_doss_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_doss_reg is '久悬户登记簿';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.balance is '余额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.doss_operate_type is '转久悬操作类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.doss_status is '久悬状态';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.hand_flag is '手工导入标记';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.non_transplant_flag is '是否未移植数据';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.to_bank_ind is '转出账号本/他行标志';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.active_date is '激活日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.doss_date is '转久悬日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.out_busi_date is '转营业外日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.waitdoss_date is '待转久悬日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.waitout_date is '待转营业外日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.withdrawal_date is '久悬清理日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.active_branch is '激活机构';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.active_user_id is '激活柜员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.doss_branch is '转久悬机构';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.doss_user_id is '转久悬柜员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.out_busi_user_id is '转营业外操作员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.por_int_tot is '本息合计';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.record_amt is '实际入账金额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.tax_sc is '账户利息税';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.to_acct_name is '转出户名';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.to_acct_seq_no is '转出账户序列号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.to_acct_type is '转入账户类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.to_base_acct_no is '转出账号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.to_ccy is '目的币种';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.todoss_reason is '转入久悬原因';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.waitdoss_branch is '待转久悬机构';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.waitdoss_user_id is '待转久悬操作员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.waitout_user_id is '待转营业外操作员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.withdrawal_branch is '久悬清理机构';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.withdrawal_reason is '转出久悬原因';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.withdrawal_user_id is '转出柜员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.bond_version_num is '版别';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.branch is '交易机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_doss_reg.etl_timestamp is 'ETL处理时间戳';
