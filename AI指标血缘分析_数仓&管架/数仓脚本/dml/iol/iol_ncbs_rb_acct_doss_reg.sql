/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_doss_reg
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_acct_doss_reg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct_doss_reg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_doss_reg_op purge;
drop table ${iol_schema}.ncbs_rb_acct_doss_reg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_doss_reg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_doss_reg where 0=1;

create table ${iol_schema}.ncbs_rb_acct_doss_reg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_doss_reg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_doss_reg_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,amt_type -- 金额类型
            ,balance -- 余额
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,batch_no -- 批次号
            ,company -- 法人
            ,doss_operate_type -- 转久悬操作类型
            ,doss_status -- 久悬状态
            ,hand_flag -- 手工导入标记
            ,individual_flag -- 对公对私标志
            ,non_transplant_flag -- 是否未移植数据
            ,to_bank_ind -- 转出账号本/他行标志
            ,active_date -- 激活日期
            ,doss_date -- 转久悬日期
            ,out_busi_date -- 转营业外日期
            ,tran_timestamp -- 交易时间戳
            ,waitdoss_date -- 待转久悬日期
            ,waitout_date -- 待转营业外日期
            ,withdrawal_date -- 久悬清理日期
            ,acct_ccy -- 账户币种
            ,active_branch -- 激活机构
            ,active_user_id -- 激活柜员
            ,doss_branch -- 转久悬机构
            ,doss_user_id -- 转久悬柜员
            ,int_amt -- 利息金额
            ,out_busi_user_id -- 转营业外操作员
            ,por_int_tot -- 本息合计
            ,record_amt -- 实际入账金额
            ,tax_sc -- 账户利息税
            ,to_acct_name -- 转出户名
            ,to_acct_seq_no -- 转出账户序列号
            ,to_acct_type -- 转入账户类型
            ,to_base_acct_no -- 转出账号
            ,to_ccy -- 目的币种
            ,todoss_reason -- 转入久悬原因
            ,waitdoss_branch -- 待转久悬机构
            ,waitdoss_user_id -- 待转久悬操作员
            ,waitout_user_id -- 待转营业外操作员
            ,withdrawal_branch -- 久悬清理机构
            ,withdrawal_reason -- 转出久悬原因
            ,withdrawal_user_id -- 转出柜员
            ,auth_user_id -- 授权柜员
            ,bond_version_num -- 版别
            ,branch -- 交易机构编号
            ,reference -- 交易参考号
            ,source_type -- 渠道编号
            ,tran_amt -- 交易金额
            ,tran_date -- 交易日期
            ,user_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_doss_reg_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,amt_type -- 金额类型
            ,balance -- 余额
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,batch_no -- 批次号
            ,company -- 法人
            ,doss_operate_type -- 转久悬操作类型
            ,doss_status -- 久悬状态
            ,hand_flag -- 手工导入标记
            ,individual_flag -- 对公对私标志
            ,non_transplant_flag -- 是否未移植数据
            ,to_bank_ind -- 转出账号本/他行标志
            ,active_date -- 激活日期
            ,doss_date -- 转久悬日期
            ,out_busi_date -- 转营业外日期
            ,tran_timestamp -- 交易时间戳
            ,waitdoss_date -- 待转久悬日期
            ,waitout_date -- 待转营业外日期
            ,withdrawal_date -- 久悬清理日期
            ,acct_ccy -- 账户币种
            ,active_branch -- 激活机构
            ,active_user_id -- 激活柜员
            ,doss_branch -- 转久悬机构
            ,doss_user_id -- 转久悬柜员
            ,int_amt -- 利息金额
            ,out_busi_user_id -- 转营业外操作员
            ,por_int_tot -- 本息合计
            ,record_amt -- 实际入账金额
            ,tax_sc -- 账户利息税
            ,to_acct_name -- 转出户名
            ,to_acct_seq_no -- 转出账户序列号
            ,to_acct_type -- 转入账户类型
            ,to_base_acct_no -- 转出账号
            ,to_ccy -- 目的币种
            ,todoss_reason -- 转入久悬原因
            ,waitdoss_branch -- 待转久悬机构
            ,waitdoss_user_id -- 待转久悬操作员
            ,waitout_user_id -- 待转营业外操作员
            ,withdrawal_branch -- 久悬清理机构
            ,withdrawal_reason -- 转出久悬原因
            ,withdrawal_user_id -- 转出柜员
            ,auth_user_id -- 授权柜员
            ,bond_version_num -- 版别
            ,branch -- 交易机构编号
            ,reference -- 交易参考号
            ,source_type -- 渠道编号
            ,tran_amt -- 交易金额
            ,tran_date -- 交易日期
            ,user_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.doss_operate_type, o.doss_operate_type) as doss_operate_type -- 转久悬操作类型
    ,nvl(n.doss_status, o.doss_status) as doss_status -- 久悬状态
    ,nvl(n.hand_flag, o.hand_flag) as hand_flag -- 手工导入标记
    ,nvl(n.individual_flag, o.individual_flag) as individual_flag -- 对公对私标志
    ,nvl(n.non_transplant_flag, o.non_transplant_flag) as non_transplant_flag -- 是否未移植数据
    ,nvl(n.to_bank_ind, o.to_bank_ind) as to_bank_ind -- 转出账号本/他行标志
    ,nvl(n.active_date, o.active_date) as active_date -- 激活日期
    ,nvl(n.doss_date, o.doss_date) as doss_date -- 转久悬日期
    ,nvl(n.out_busi_date, o.out_busi_date) as out_busi_date -- 转营业外日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.waitdoss_date, o.waitdoss_date) as waitdoss_date -- 待转久悬日期
    ,nvl(n.waitout_date, o.waitout_date) as waitout_date -- 待转营业外日期
    ,nvl(n.withdrawal_date, o.withdrawal_date) as withdrawal_date -- 久悬清理日期
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.active_branch, o.active_branch) as active_branch -- 激活机构
    ,nvl(n.active_user_id, o.active_user_id) as active_user_id -- 激活柜员
    ,nvl(n.doss_branch, o.doss_branch) as doss_branch -- 转久悬机构
    ,nvl(n.doss_user_id, o.doss_user_id) as doss_user_id -- 转久悬柜员
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.out_busi_user_id, o.out_busi_user_id) as out_busi_user_id -- 转营业外操作员
    ,nvl(n.por_int_tot, o.por_int_tot) as por_int_tot -- 本息合计
    ,nvl(n.record_amt, o.record_amt) as record_amt -- 实际入账金额
    ,nvl(n.tax_sc, o.tax_sc) as tax_sc -- 账户利息税
    ,nvl(n.to_acct_name, o.to_acct_name) as to_acct_name -- 转出户名
    ,nvl(n.to_acct_seq_no, o.to_acct_seq_no) as to_acct_seq_no -- 转出账户序列号
    ,nvl(n.to_acct_type, o.to_acct_type) as to_acct_type -- 转入账户类型
    ,nvl(n.to_base_acct_no, o.to_base_acct_no) as to_base_acct_no -- 转出账号
    ,nvl(n.to_ccy, o.to_ccy) as to_ccy -- 目的币种
    ,nvl(n.todoss_reason, o.todoss_reason) as todoss_reason -- 转入久悬原因
    ,nvl(n.waitdoss_branch, o.waitdoss_branch) as waitdoss_branch -- 待转久悬机构
    ,nvl(n.waitdoss_user_id, o.waitdoss_user_id) as waitdoss_user_id -- 待转久悬操作员
    ,nvl(n.waitout_user_id, o.waitout_user_id) as waitout_user_id -- 待转营业外操作员
    ,nvl(n.withdrawal_branch, o.withdrawal_branch) as withdrawal_branch -- 久悬清理机构
    ,nvl(n.withdrawal_reason, o.withdrawal_reason) as withdrawal_reason -- 转出久悬原因
    ,nvl(n.withdrawal_user_id, o.withdrawal_user_id) as withdrawal_user_id -- 转出柜员
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.bond_version_num, o.bond_version_num) as bond_version_num -- 版别
    ,nvl(n.branch, o.branch) as branch -- 交易机构编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_doss_reg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct_doss_reg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.amt_type <> n.amt_type
        or o.balance <> n.balance
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.prod_type <> n.prod_type
        or o.remark <> n.remark
        or o.batch_no <> n.batch_no
        or o.company <> n.company
        or o.doss_operate_type <> n.doss_operate_type
        or o.doss_status <> n.doss_status
        or o.hand_flag <> n.hand_flag
        or o.individual_flag <> n.individual_flag
        or o.non_transplant_flag <> n.non_transplant_flag
        or o.to_bank_ind <> n.to_bank_ind
        or o.active_date <> n.active_date
        or o.doss_date <> n.doss_date
        or o.out_busi_date <> n.out_busi_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.waitdoss_date <> n.waitdoss_date
        or o.waitout_date <> n.waitout_date
        or o.withdrawal_date <> n.withdrawal_date
        or o.acct_ccy <> n.acct_ccy
        or o.active_branch <> n.active_branch
        or o.active_user_id <> n.active_user_id
        or o.doss_branch <> n.doss_branch
        or o.doss_user_id <> n.doss_user_id
        or o.int_amt <> n.int_amt
        or o.out_busi_user_id <> n.out_busi_user_id
        or o.por_int_tot <> n.por_int_tot
        or o.record_amt <> n.record_amt
        or o.tax_sc <> n.tax_sc
        or o.to_acct_name <> n.to_acct_name
        or o.to_acct_seq_no <> n.to_acct_seq_no
        or o.to_acct_type <> n.to_acct_type
        or o.to_base_acct_no <> n.to_base_acct_no
        or o.to_ccy <> n.to_ccy
        or o.todoss_reason <> n.todoss_reason
        or o.waitdoss_branch <> n.waitdoss_branch
        or o.waitdoss_user_id <> n.waitdoss_user_id
        or o.waitout_user_id <> n.waitout_user_id
        or o.withdrawal_branch <> n.withdrawal_branch
        or o.withdrawal_reason <> n.withdrawal_reason
        or o.withdrawal_user_id <> n.withdrawal_user_id
        or o.auth_user_id <> n.auth_user_id
        or o.bond_version_num <> n.bond_version_num
        or o.branch <> n.branch
        or o.reference <> n.reference
        or o.source_type <> n.source_type
        or o.tran_amt <> n.tran_amt
        or o.tran_date <> n.tran_date
        or o.user_id <> n.user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_doss_reg_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,amt_type -- 金额类型
            ,balance -- 余额
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,batch_no -- 批次号
            ,company -- 法人
            ,doss_operate_type -- 转久悬操作类型
            ,doss_status -- 久悬状态
            ,hand_flag -- 手工导入标记
            ,individual_flag -- 对公对私标志
            ,non_transplant_flag -- 是否未移植数据
            ,to_bank_ind -- 转出账号本/他行标志
            ,active_date -- 激活日期
            ,doss_date -- 转久悬日期
            ,out_busi_date -- 转营业外日期
            ,tran_timestamp -- 交易时间戳
            ,waitdoss_date -- 待转久悬日期
            ,waitout_date -- 待转营业外日期
            ,withdrawal_date -- 久悬清理日期
            ,acct_ccy -- 账户币种
            ,active_branch -- 激活机构
            ,active_user_id -- 激活柜员
            ,doss_branch -- 转久悬机构
            ,doss_user_id -- 转久悬柜员
            ,int_amt -- 利息金额
            ,out_busi_user_id -- 转营业外操作员
            ,por_int_tot -- 本息合计
            ,record_amt -- 实际入账金额
            ,tax_sc -- 账户利息税
            ,to_acct_name -- 转出户名
            ,to_acct_seq_no -- 转出账户序列号
            ,to_acct_type -- 转入账户类型
            ,to_base_acct_no -- 转出账号
            ,to_ccy -- 目的币种
            ,todoss_reason -- 转入久悬原因
            ,waitdoss_branch -- 待转久悬机构
            ,waitdoss_user_id -- 待转久悬操作员
            ,waitout_user_id -- 待转营业外操作员
            ,withdrawal_branch -- 久悬清理机构
            ,withdrawal_reason -- 转出久悬原因
            ,withdrawal_user_id -- 转出柜员
            ,auth_user_id -- 授权柜员
            ,bond_version_num -- 版别
            ,branch -- 交易机构编号
            ,reference -- 交易参考号
            ,source_type -- 渠道编号
            ,tran_amt -- 交易金额
            ,tran_date -- 交易日期
            ,user_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_doss_reg_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,amt_type -- 金额类型
            ,balance -- 余额
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,batch_no -- 批次号
            ,company -- 法人
            ,doss_operate_type -- 转久悬操作类型
            ,doss_status -- 久悬状态
            ,hand_flag -- 手工导入标记
            ,individual_flag -- 对公对私标志
            ,non_transplant_flag -- 是否未移植数据
            ,to_bank_ind -- 转出账号本/他行标志
            ,active_date -- 激活日期
            ,doss_date -- 转久悬日期
            ,out_busi_date -- 转营业外日期
            ,tran_timestamp -- 交易时间戳
            ,waitdoss_date -- 待转久悬日期
            ,waitout_date -- 待转营业外日期
            ,withdrawal_date -- 久悬清理日期
            ,acct_ccy -- 账户币种
            ,active_branch -- 激活机构
            ,active_user_id -- 激活柜员
            ,doss_branch -- 转久悬机构
            ,doss_user_id -- 转久悬柜员
            ,int_amt -- 利息金额
            ,out_busi_user_id -- 转营业外操作员
            ,por_int_tot -- 本息合计
            ,record_amt -- 实际入账金额
            ,tax_sc -- 账户利息税
            ,to_acct_name -- 转出户名
            ,to_acct_seq_no -- 转出账户序列号
            ,to_acct_type -- 转入账户类型
            ,to_base_acct_no -- 转出账号
            ,to_ccy -- 目的币种
            ,todoss_reason -- 转入久悬原因
            ,waitdoss_branch -- 待转久悬机构
            ,waitdoss_user_id -- 待转久悬操作员
            ,waitout_user_id -- 待转营业外操作员
            ,withdrawal_branch -- 久悬清理机构
            ,withdrawal_reason -- 转出久悬原因
            ,withdrawal_user_id -- 转出柜员
            ,auth_user_id -- 授权柜员
            ,bond_version_num -- 版别
            ,branch -- 交易机构编号
            ,reference -- 交易参考号
            ,source_type -- 渠道编号
            ,tran_amt -- 交易金额
            ,tran_date -- 交易日期
            ,user_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.amt_type -- 金额类型
    ,o.balance -- 余额
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.remark -- 备注
    ,o.batch_no -- 批次号
    ,o.company -- 法人
    ,o.doss_operate_type -- 转久悬操作类型
    ,o.doss_status -- 久悬状态
    ,o.hand_flag -- 手工导入标记
    ,o.individual_flag -- 对公对私标志
    ,o.non_transplant_flag -- 是否未移植数据
    ,o.to_bank_ind -- 转出账号本/他行标志
    ,o.active_date -- 激活日期
    ,o.doss_date -- 转久悬日期
    ,o.out_busi_date -- 转营业外日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.waitdoss_date -- 待转久悬日期
    ,o.waitout_date -- 待转营业外日期
    ,o.withdrawal_date -- 久悬清理日期
    ,o.acct_ccy -- 账户币种
    ,o.active_branch -- 激活机构
    ,o.active_user_id -- 激活柜员
    ,o.doss_branch -- 转久悬机构
    ,o.doss_user_id -- 转久悬柜员
    ,o.int_amt -- 利息金额
    ,o.out_busi_user_id -- 转营业外操作员
    ,o.por_int_tot -- 本息合计
    ,o.record_amt -- 实际入账金额
    ,o.tax_sc -- 账户利息税
    ,o.to_acct_name -- 转出户名
    ,o.to_acct_seq_no -- 转出账户序列号
    ,o.to_acct_type -- 转入账户类型
    ,o.to_base_acct_no -- 转出账号
    ,o.to_ccy -- 目的币种
    ,o.todoss_reason -- 转入久悬原因
    ,o.waitdoss_branch -- 待转久悬机构
    ,o.waitdoss_user_id -- 待转久悬操作员
    ,o.waitout_user_id -- 待转营业外操作员
    ,o.withdrawal_branch -- 久悬清理机构
    ,o.withdrawal_reason -- 转出久悬原因
    ,o.withdrawal_user_id -- 转出柜员
    ,o.auth_user_id -- 授权柜员
    ,o.bond_version_num -- 版别
    ,o.branch -- 交易机构编号
    ,o.reference -- 交易参考号
    ,o.source_type -- 渠道编号
    ,o.tran_amt -- 交易金额
    ,o.tran_date -- 交易日期
    ,o.user_id -- 交易柜员编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_acct_doss_reg_bk o
    left join ${iol_schema}.ncbs_rb_acct_doss_reg_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_doss_reg_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct_doss_reg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct_doss_reg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct_doss_reg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct_doss_reg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct_doss_reg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_doss_reg_cl;
alter table ${iol_schema}.ncbs_rb_acct_doss_reg exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_doss_reg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_doss_reg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_doss_reg_op purge;
drop table ${iol_schema}.ncbs_rb_acct_doss_reg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_doss_reg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_doss_reg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
