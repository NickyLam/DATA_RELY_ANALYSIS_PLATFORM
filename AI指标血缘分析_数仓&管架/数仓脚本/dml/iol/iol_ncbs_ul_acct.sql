/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ul_acct
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
drop table ${iol_schema}.ncbs_ul_acct_ex purge;
alter table ${iol_schema}.ncbs_ul_acct add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_ul_acct truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_ul_acct_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ul_acct where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_ul_acct_ex(
    cmisloan_no -- 客户借据编号|客户借据编号
    ,batch_no -- 批次号|批次号
    ,loan_no -- 贷款号|贷款号
    ,dd_no -- 发放号|贷款发放号，采用顺序数字，表示在同一贷款号、贷款账户类型、币种下的不同借据
    ,prod_type -- 产品编号|产品编号
    ,ccy -- 币种|币种
    ,branch -- 交易机构编号|机构代码
    ,client_no -- 客户编号|客户编号
    ,acct_open_date -- 账户开户日期|账户开户日期
    ,effect_date -- 产品生效日期|产品生效日期
    ,open_tran_date -- 开户后首次交易日期|开户后首次交易日期
    ,dd_amt -- 发放金额|发放金额
    ,acct_status -- 账户状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-正常,d-不动户,s-久悬户,o-转营业外,p-逾期,c-关闭,i-预开户,r-预销户
    ,acct_status_prev -- 账户上一状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-活动,d-睡眠,s-久悬,o-转营业外,p-逾期,c-关闭,u-手工解除
    ,acct_status_upd_date -- 账户状态变更日期|账户状态变更日期
    ,accounting_status -- 核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止
    ,accounting_status_prev -- 上次核算状态|上次核算状态|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止
    ,accounting_status_upd_date -- 核算状态变更日期|核算状态变更日期
    ,acct_close_date -- 销户日期|账户销户日期
    ,acct_close_reason -- 关闭原因|账户销户原因，一般由渠道上送
    ,orig_acct_open_date -- 账户原始开立日期|账户原始开立日期，即第一次开立日期，未进行过转存的首次开立日期
    ,ori_maturity_date -- 账户原始到期日期|账户原始到期日期，即第一次开立时的到期日期，未进行期限变更时的到期日
    ,acct_name -- 账户名称|账户名称，一般指中文账户名称
    ,term -- 存期|存款期限
    ,term_type -- 期限单位|期限单位|y-年,q-季,m-月,w-周,d-日
    ,maturity_date -- 到期日期|到期日期
    ,apply_branch -- 申请机构|申请机构
    ,home_branch -- 客户管理行|客户管理行
    ,last_change_date -- 最后修改日期|最后修改日期
    ,lender -- 贷款人|贷款人
    ,five_category -- 贷款五级分类|贷款五级分类|10-正常,20-关注,30-次级,40-可疑,50-损失
    ,sched_mode -- 还款方式|还款方式|1-等额本息,2-等额本金,3-一次性还本付息前收息,4-按频率付息一次还本,5-按频率付息任意本金,6-气球贷,7-等额累进,8-等比累进,9-等本等息,10-组合贷,11-按比例还本,15-自定义还款方式
    ,source_type -- 渠道编号|渠道类型
    ,source_module -- 源模块|源模块|rb-存款,cl-贷款,gl-总账,all-所有
    ,client_type -- 客户类型|客户大类，目前一般分为个人，公司，金融机构和内部客户。取之于cif_client_type,client_type
    ,is_individual -- 个体客户标志|是否个体客户|y-是,n-否
    ,int_ind_flag -- 计息标识|是否计息|y-是、正利率计息,n-否,f-是、负利率计息
    ,cur_stage_no -- 当前期数|当前期次
    ,acct_type -- 账户类型|账户类型|a-aio账户,c-结算账户,d-垫款,e-委托贷款,l-转让贷款,m-普通贷款,s-储蓄账户,t-定期账户,u-贴现贷款,y-银团贷款,z-资产证券化
    ,last_tran_date -- 最后交易日期|最后交易日期
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,first_overdue_date -- 最早逾期日期 |最早逾期日期
    ,manual_change_schedule_flag -- 是否需要手工录入还款计划 |是否需要手工录入还款计划|y-是,n-否
    ,ssi_end_date -- 贴息截止日期 |贴息截止日期
    ,fta_acct_flag -- 是否自贸区账户标识|是否自贸区账户标识|y-是,n-否
    ,marketing_prod -- 营销产品|营销产品
    ,marketing_prod_desc -- 营销产品名称|营销产品名称
    ,formula_amt -- 每期计划还款额|每期计划还款额
    ,purpose -- 贷款用途  |贷款用途
    ,profit_center -- 利润中心 |利润中心
    ,belong_branch -- 归属机构  |归属机构
    ,internal_key -- 账户内部键值|账户内部键值
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cmisloan_no -- 客户借据编号|客户借据编号
    ,batch_no -- 批次号|批次号
    ,loan_no -- 贷款号|贷款号
    ,dd_no -- 发放号|贷款发放号，采用顺序数字，表示在同一贷款号、贷款账户类型、币种下的不同借据
    ,prod_type -- 产品编号|产品编号
    ,ccy -- 币种|币种
    ,branch -- 交易机构编号|机构代码
    ,client_no -- 客户编号|客户编号
    ,acct_open_date -- 账户开户日期|账户开户日期
    ,effect_date -- 产品生效日期|产品生效日期
    ,open_tran_date -- 开户后首次交易日期|开户后首次交易日期
    ,dd_amt -- 发放金额|发放金额
    ,acct_status -- 账户状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-正常,d-不动户,s-久悬户,o-转营业外,p-逾期,c-关闭,i-预开户,r-预销户
    ,acct_status_prev -- 账户上一状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-活动,d-睡眠,s-久悬,o-转营业外,p-逾期,c-关闭,u-手工解除
    ,acct_status_upd_date -- 账户状态变更日期|账户状态变更日期
    ,accounting_status -- 核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止
    ,accounting_status_prev -- 上次核算状态|上次核算状态|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止
    ,accounting_status_upd_date -- 核算状态变更日期|核算状态变更日期
    ,acct_close_date -- 销户日期|账户销户日期
    ,acct_close_reason -- 关闭原因|账户销户原因，一般由渠道上送
    ,orig_acct_open_date -- 账户原始开立日期|账户原始开立日期，即第一次开立日期，未进行过转存的首次开立日期
    ,ori_maturity_date -- 账户原始到期日期|账户原始到期日期，即第一次开立时的到期日期，未进行期限变更时的到期日
    ,acct_name -- 账户名称|账户名称，一般指中文账户名称
    ,term -- 存期|存款期限
    ,term_type -- 期限单位|期限单位|y-年,q-季,m-月,w-周,d-日
    ,maturity_date -- 到期日期|到期日期
    ,apply_branch -- 申请机构|申请机构
    ,home_branch -- 客户管理行|客户管理行
    ,last_change_date -- 最后修改日期|最后修改日期
    ,lender -- 贷款人|贷款人
    ,five_category -- 贷款五级分类|贷款五级分类|10-正常,20-关注,30-次级,40-可疑,50-损失
    ,sched_mode -- 还款方式|还款方式|1-等额本息,2-等额本金,3-一次性还本付息前收息,4-按频率付息一次还本,5-按频率付息任意本金,6-气球贷,7-等额累进,8-等比累进,9-等本等息,10-组合贷,11-按比例还本,15-自定义还款方式
    ,source_type -- 渠道编号|渠道类型
    ,source_module -- 源模块|源模块|rb-存款,cl-贷款,gl-总账,all-所有
    ,client_type -- 客户类型|客户大类，目前一般分为个人，公司，金融机构和内部客户。取之于cif_client_type,client_type
    ,is_individual -- 个体客户标志|是否个体客户|y-是,n-否
    ,int_ind_flag -- 计息标识|是否计息|y-是、正利率计息,n-否,f-是、负利率计息
    ,cur_stage_no -- 当前期数|当前期次
    ,acct_type -- 账户类型|账户类型|a-aio账户,c-结算账户,d-垫款,e-委托贷款,l-转让贷款,m-普通贷款,s-储蓄账户,t-定期账户,u-贴现贷款,y-银团贷款,z-资产证券化
    ,last_tran_date -- 最后交易日期|最后交易日期
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,first_overdue_date -- 最早逾期日期 |最早逾期日期
    ,manual_change_schedule_flag -- 是否需要手工录入还款计划 |是否需要手工录入还款计划|y-是,n-否
    ,ssi_end_date -- 贴息截止日期 |贴息截止日期
    ,fta_acct_flag -- 是否自贸区账户标识|是否自贸区账户标识|y-是,n-否
    ,marketing_prod -- 营销产品|营销产品
    ,marketing_prod_desc -- 营销产品名称|营销产品名称
    ,formula_amt -- 每期计划还款额|每期计划还款额
    ,purpose -- 贷款用途  |贷款用途
    ,profit_center -- 利润中心 |利润中心
    ,belong_branch -- 归属机构  |归属机构
    ,internal_key -- 账户内部键值|账户内部键值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_ul_acct
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_ul_acct exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ul_acct_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ul_acct to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_ul_acct_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ul_acct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);