/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_doss_reg_hist
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_doss_reg_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_acct_doss_reg_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_acct_doss_reg_hist;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_acct_doss_reg_hist_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_acct_doss_reg_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_acct_doss_reg_hist_ex(
    batch_no -- 批次号
    ,doss_operate_type -- 转久悬操作类型
    ,hand_flag -- 手工导入标记
    ,internal_key -- 账户内部键值
    ,client_no -- 客户编号
    ,base_acct_no -- 交易账号/卡号
    ,prod_type -- 产品编号
    ,acct_ccy -- 账户币种
    ,acct_seq_no -- 账户子账号
    ,acct_name -- 账户名称
    ,amt_type -- 金额类型
    ,balance -- 余额
    ,int_amt -- 利息金额
    ,por_int_tot -- 本息合计
    ,tax_sc -- 账户利息税
    ,waitdoss_branch -- 待转久悬机构
    ,waitdoss_user_id -- 待转久悬操作员
    ,waitdoss_date -- 待转久悬日期
    ,waitout_date -- 待转营业外日期
    ,waitout_user_id -- 待转营业外操作员
    ,withdrawal_date -- 久悬清理日期
    ,withdrawal_branch -- 久悬清理机构
    ,withdrawal_user_id -- 转出柜员
    ,withdrawal_reason -- 转出久悬原因
    ,doss_status -- 久悬状态
    ,doss_date -- 转久悬日期
    ,doss_branch -- 转久悬机构
    ,doss_user_id -- 转久悬柜员
    ,todoss_reason -- 转入久悬原因
    ,active_date -- 激活日期
    ,active_branch -- 激活机构
    ,active_user_id -- 激活柜员
    ,out_busi_date -- 转营业外日期
    ,out_busi_user_id -- 转营业外操作员
    ,individual_flag -- 对公对私标志
    ,non_transplant_flag -- 是否未移植数据
    ,to_bank_ind -- 转出账号本/他行标志
    ,to_base_acct_no -- 转出账号
    ,to_ccy -- 目的币种
    ,to_acct_seq_no -- 转出账户序列号
    ,to_acct_name -- 转出户名
    ,to_acct_type -- 转入账户类型
    ,remark -- 备注
    ,tran_timestamp -- 交易时间戳
    ,company -- 法人
    ,record_amt -- 实际入账金额
    ,tran_date -- 交易日期
    ,branch -- 交易机构编号
    ,user_id -- 交易柜员编号
    ,tran_amt -- 交易金额
    ,reference -- 交易参考号
    ,auth_user_id -- 授权柜员
    ,source_type -- 渠道编号
    ,bond_version_num -- 版别
    ,seq_no -- 序号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    batch_no -- 批次号
    ,doss_operate_type -- 转久悬操作类型
    ,hand_flag -- 手工导入标记
    ,internal_key -- 账户内部键值
    ,client_no -- 客户编号
    ,base_acct_no -- 交易账号/卡号
    ,prod_type -- 产品编号
    ,acct_ccy -- 账户币种
    ,acct_seq_no -- 账户子账号
    ,acct_name -- 账户名称
    ,amt_type -- 金额类型
    ,balance -- 余额
    ,int_amt -- 利息金额
    ,por_int_tot -- 本息合计
    ,tax_sc -- 账户利息税
    ,waitdoss_branch -- 待转久悬机构
    ,waitdoss_user_id -- 待转久悬操作员
    ,waitdoss_date -- 待转久悬日期
    ,waitout_date -- 待转营业外日期
    ,waitout_user_id -- 待转营业外操作员
    ,withdrawal_date -- 久悬清理日期
    ,withdrawal_branch -- 久悬清理机构
    ,withdrawal_user_id -- 转出柜员
    ,withdrawal_reason -- 转出久悬原因
    ,doss_status -- 久悬状态
    ,doss_date -- 转久悬日期
    ,doss_branch -- 转久悬机构
    ,doss_user_id -- 转久悬柜员
    ,todoss_reason -- 转入久悬原因
    ,active_date -- 激活日期
    ,active_branch -- 激活机构
    ,active_user_id -- 激活柜员
    ,out_busi_date -- 转营业外日期
    ,out_busi_user_id -- 转营业外操作员
    ,individual_flag -- 对公对私标志
    ,non_transplant_flag -- 是否未移植数据
    ,to_bank_ind -- 转出账号本/他行标志
    ,to_base_acct_no -- 转出账号
    ,to_ccy -- 目的币种
    ,to_acct_seq_no -- 转出账户序列号
    ,to_acct_name -- 转出户名
    ,to_acct_type -- 转入账户类型
    ,remark -- 备注
    ,tran_timestamp -- 交易时间戳
    ,company -- 法人
    ,record_amt -- 实际入账金额
    ,tran_date -- 交易日期
    ,branch -- 交易机构编号
    ,user_id -- 交易柜员编号
    ,tran_amt -- 交易金额
    ,reference -- 交易参考号
    ,auth_user_id -- 授权柜员
    ,source_type -- 渠道编号
    ,bond_version_num -- 版别
    ,seq_no -- 序号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_acct_doss_reg_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_acct_doss_reg_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_doss_reg_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_doss_reg_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_acct_doss_reg_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_doss_reg_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);