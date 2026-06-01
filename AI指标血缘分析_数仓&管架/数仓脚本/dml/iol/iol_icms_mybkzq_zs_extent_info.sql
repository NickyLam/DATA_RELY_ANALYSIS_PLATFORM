/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzq_zs_extent_info
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
drop table ${iol_schema}.icms_mybkzq_zs_extent_info_ex purge;
alter table ${iol_schema}.icms_mybkzq_zs_extent_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_mybkzq_zs_extent_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_mybkzq_zs_extent_info_ex nologging
compress
as
select * from ${iol_schema}.icms_mybkzq_zs_extent_info where 0=1;

insert /*+ append */ into ${iol_schema}.icms_mybkzq_zs_extent_info_ex(
    serialno -- 业务流水号
    ,injectid -- 转让批次号
    ,drawndnseqno -- 支用编号
    ,loantype -- 贷款类型
    ,loanusetype -- 贷款用途
    ,assetclass -- 贷款五级分类
    ,currencytype -- 币种
    ,amt -- 合同金额（元）
    ,bal -- 贷款余额（元）
    ,inttype -- 利率浮动方式
    ,intrate -- 贷款利率（%）
    ,initrate -- 初始利率（%）
    ,disbursedate -- 贷款起息日
    ,duedate -- 贷款到期日
    ,termnum -- 贷款期限（月）
    ,reminddays -- 贷款剩余期限（天）
    ,repaymodedesc -- 贷款付息方式（个月/次）
    ,firstloandate -- 用户首次贷款时间
    ,guaranteemethod -- 担保方式
    ,guaranteeitem -- 担保品
    ,creditbal -- 单户授信（元）
    ,butype -- 企业类型（债转特有）
    ,userage -- 年龄
    ,riskseg -- 风险分层
    ,repaymentseg -- 偿债能力
    ,mobilefixedgrade -- 手机号稳定等级
    ,adrstabilitygrade -- 地址稳定等级
    ,devstabilitygrade -- 最近六个月设备稳定等级
    ,totpayamt6mgrade -- 最近六个月支付金额等级
    ,consumegrade -- 消费档次
    ,profession -- 职业信息
    ,bankcardnumber -- 银行卡号
    ,depositbankname -- 开户行名称
    ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
    ,havecarprobgrade -- 有车概率等级
    ,havefangprobgrade -- 有房概率等级
    ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
    ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
    ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
    ,positivebizcnt1ygrade -- 最近一年履约等级
    ,repayamt6mgrade -- 最近六个月还款金额等级
    ,firstloanlengthgrade -- 信贷时长等级
    ,riskscore -- 风险分数
    ,alilast6mtradetotal -- 支付宝交易笔数
    ,baserepaymentseg -- 综合基础偿债
    ,altrepaymentseg -- 大额经营偿债
    ,liquidasset6mgrade -- 近6个月流动资产价值等级
    ,haveaptprobgrade -- 有房概况等级
    ,bizstartgrade -- 经营时长
    ,bizstabilitygrade -- 近6个月经营稳定性分层
    ,totpaycnt6mgrade -- 近6个月交易笔数等级
    ,avgdaybal6mgrade -- 近6个月日均余额
    ,gmtfirstbilllenthgrade -- 信贷时长
    ,clrbillcnt1yrgrade -- 近一年履约等级
    ,maxovddays6mgrade -- 近6个月逾期天数等级
    ,maxovdbillamt6mgrade -- 近6个月逾期金额等级
    ,starts -- 开店日期
    ,countyid -- 商户所属地区
    ,finishedvalidexlovamtrm6 -- 过去6个月月均完成交易金额
    ,finishedvalidexlovamtrm12 -- 过去12个月月均完成交易金额
    ,businessscene -- 业务场景
    ,custipid -- 借款人在网商的会员ID
    ,custiproleid -- 借款人在网商的会员角色ID
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 业务流水号
    ,injectid -- 转让批次号
    ,drawndnseqno -- 支用编号
    ,loantype -- 贷款类型
    ,loanusetype -- 贷款用途
    ,assetclass -- 贷款五级分类
    ,currencytype -- 币种
    ,amt -- 合同金额（元）
    ,bal -- 贷款余额（元）
    ,inttype -- 利率浮动方式
    ,intrate -- 贷款利率（%）
    ,initrate -- 初始利率（%）
    ,disbursedate -- 贷款起息日
    ,duedate -- 贷款到期日
    ,termnum -- 贷款期限（月）
    ,reminddays -- 贷款剩余期限（天）
    ,repaymodedesc -- 贷款付息方式（个月/次）
    ,firstloandate -- 用户首次贷款时间
    ,guaranteemethod -- 担保方式
    ,guaranteeitem -- 担保品
    ,creditbal -- 单户授信（元）
    ,butype -- 企业类型（债转特有）
    ,userage -- 年龄
    ,riskseg -- 风险分层
    ,repaymentseg -- 偿债能力
    ,mobilefixedgrade -- 手机号稳定等级
    ,adrstabilitygrade -- 地址稳定等级
    ,devstabilitygrade -- 最近六个月设备稳定等级
    ,totpayamt6mgrade -- 最近六个月支付金额等级
    ,consumegrade -- 消费档次
    ,profession -- 职业信息
    ,bankcardnumber -- 银行卡号
    ,depositbankname -- 开户行名称
    ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
    ,havecarprobgrade -- 有车概率等级
    ,havefangprobgrade -- 有房概率等级
    ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
    ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
    ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
    ,positivebizcnt1ygrade -- 最近一年履约等级
    ,repayamt6mgrade -- 最近六个月还款金额等级
    ,firstloanlengthgrade -- 信贷时长等级
    ,riskscore -- 风险分数
    ,alilast6mtradetotal -- 支付宝交易笔数
    ,baserepaymentseg -- 综合基础偿债
    ,altrepaymentseg -- 大额经营偿债
    ,liquidasset6mgrade -- 近6个月流动资产价值等级
    ,haveaptprobgrade -- 有房概况等级
    ,bizstartgrade -- 经营时长
    ,bizstabilitygrade -- 近6个月经营稳定性分层
    ,totpaycnt6mgrade -- 近6个月交易笔数等级
    ,avgdaybal6mgrade -- 近6个月日均余额
    ,gmtfirstbilllenthgrade -- 信贷时长
    ,clrbillcnt1yrgrade -- 近一年履约等级
    ,maxovddays6mgrade -- 近6个月逾期天数等级
    ,maxovdbillamt6mgrade -- 近6个月逾期金额等级
    ,starts -- 开店日期
    ,countyid -- 商户所属地区
    ,finishedvalidexlovamtrm6 -- 过去6个月月均完成交易金额
    ,finishedvalidexlovamtrm12 -- 过去12个月月均完成交易金额
    ,businessscene -- 业务场景
    ,custipid -- 借款人在网商的会员ID
    ,custiproleid -- 借款人在网商的会员角色ID
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_mybkzq_zs_extent_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_mybkzq_zs_extent_info exchange partition p_${batch_date} with table ${iol_schema}.icms_mybkzq_zs_extent_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybkzq_zs_extent_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_mybkzq_zs_extent_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybkzq_zs_extent_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);