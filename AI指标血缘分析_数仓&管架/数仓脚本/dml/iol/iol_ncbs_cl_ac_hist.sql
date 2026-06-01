/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_ac_hist
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
drop table ${iol_schema}.ncbs_cl_ac_hist_ex purge;
alter table ${iol_schema}.ncbs_cl_ac_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_ac_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_ac_hist_ex nologging
for exchange with table
${iol_schema}.ncbs_cl_ac_hist;

insert /*+ append */ into ${iol_schema}.ncbs_cl_ac_hist_ex(
    internal_key -- 账户内部键值|账户内部键值
    ,loan_no -- 贷款号|贷款号
    ,seq_no -- 序号|序号
    ,dd_no -- 发放号|贷款发放号，采用顺序数字，表示在同一贷款号、贷款账户类型、币种下的不同借据
    ,acct_ccy -- 账户币种|账户币种 对于aio账户和一本通账户
    ,prod_type -- 产品编号|产品类型
    ,acct_desc -- 账户描述|账户描述,目前同账户名称
    ,client_no -- 客户编号|客户号
    ,client_type -- 客户类型|客户大类，目前一般分为个人，公司，金融机构和内部客户。取之于cif_client_type.client_type
    ,tran_date -- 交易日期|交易日期
    ,tran_type -- 交易类型|交易类型
    ,event_type -- 事件类型|事件类型
    ,ccy -- 币种|币种
    ,amt_type -- 金额类型|金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金
    ,tran_amt -- 交易金额|交易金额
    ,branch -- 交易机构编号|机构代码
    ,source_type -- 渠道编号|渠道类型
    ,reference -- 交易参考号|交易参考号
    ,bank_seq_no -- 银行交易序号|银行交易序号,单一机构下发生交易序号，按顺序递增 格式为 "机构_序号"
    ,reversal -- 是否冲正标志|是否冲正标志|y-是,n-否
    ,reversal_tran_type -- 冲正交易类型|冲正交易类型
    ,reversal_date -- 冲正日期|冲正日期
    ,narrative -- 摘要|开户时的账号用途，销户时的销户原因
    ,profit_center -- 利润中心 |利润中心
    ,business_unit -- 账套|账套|cbt-综合人民币账套,ubt-综合美元账套,ybt-原币账套
    ,source_module -- 源模块|源模块|rb-存款,cl-贷款,gl-总账,all-所有
    ,lender -- 贷款人|贷款人
    ,acct_status -- 账户状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-活动,d-睡眠,s-久悬,o-转营业外,p-逾期,c-关闭,u-手工解除
    ,accounting_status -- 核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq_逾期,fyj-非应计,fy-手工转非应计,wrn-核销,ter-终止
    ,acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
    ,gl_posted_flag -- 过账标记|过账标记|y-是,n-否
    ,marketing_prod -- 营销产品|营销产品
    ,marketing_prod_desc -- 营销产品名称|营销产品名称
    ,tran_category -- 交易种类|交易种类
    ,reserve1 -- 预留字段1|预留字段1
    ,reserve2 -- 预留字段2|预留字段2
    ,user_id -- 交易柜员编号|交易柜员
    ,company -- 法人|法人
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,bus_seq_no -- 业务流水号|业务流水号
    ,reaccount_cd -- 对账代码|对账代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    internal_key -- 账户内部键值|账户内部键值
    ,loan_no -- 贷款号|贷款号
    ,seq_no -- 序号|序号
    ,dd_no -- 发放号|贷款发放号，采用顺序数字，表示在同一贷款号、贷款账户类型、币种下的不同借据
    ,acct_ccy -- 账户币种|账户币种 对于aio账户和一本通账户
    ,prod_type -- 产品编号|产品类型
    ,acct_desc -- 账户描述|账户描述,目前同账户名称
    ,client_no -- 客户编号|客户号
    ,client_type -- 客户类型|客户大类，目前一般分为个人，公司，金融机构和内部客户。取之于cif_client_type.client_type
    ,tran_date -- 交易日期|交易日期
    ,tran_type -- 交易类型|交易类型
    ,event_type -- 事件类型|事件类型
    ,ccy -- 币种|币种
    ,amt_type -- 金额类型|金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金
    ,tran_amt -- 交易金额|交易金额
    ,branch -- 交易机构编号|机构代码
    ,source_type -- 渠道编号|渠道类型
    ,reference -- 交易参考号|交易参考号
    ,bank_seq_no -- 银行交易序号|银行交易序号,单一机构下发生交易序号，按顺序递增 格式为 "机构_序号"
    ,reversal -- 是否冲正标志|是否冲正标志|y-是,n-否
    ,reversal_tran_type -- 冲正交易类型|冲正交易类型
    ,reversal_date -- 冲正日期|冲正日期
    ,narrative -- 摘要|开户时的账号用途，销户时的销户原因
    ,profit_center -- 利润中心 |利润中心
    ,business_unit -- 账套|账套|cbt-综合人民币账套,ubt-综合美元账套,ybt-原币账套
    ,source_module -- 源模块|源模块|rb-存款,cl-贷款,gl-总账,all-所有
    ,lender -- 贷款人|贷款人
    ,acct_status -- 账户状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-活动,d-睡眠,s-久悬,o-转营业外,p-逾期,c-关闭,u-手工解除
    ,accounting_status -- 核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq_逾期,fyj-非应计,fy-手工转非应计,wrn-核销,ter-终止
    ,acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
    ,gl_posted_flag -- 过账标记|过账标记|y-是,n-否
    ,marketing_prod -- 营销产品|营销产品
    ,marketing_prod_desc -- 营销产品名称|营销产品名称
    ,tran_category -- 交易种类|交易种类
    ,reserve1 -- 预留字段1|预留字段1
    ,reserve2 -- 预留字段2|预留字段2
    ,user_id -- 交易柜员编号|交易柜员
    ,company -- 法人|法人
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,bus_seq_no -- 业务流水号|业务流水号
    ,reaccount_cd -- 对账代码|对账代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_ac_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_ac_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_ac_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_ac_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_ac_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_ac_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);