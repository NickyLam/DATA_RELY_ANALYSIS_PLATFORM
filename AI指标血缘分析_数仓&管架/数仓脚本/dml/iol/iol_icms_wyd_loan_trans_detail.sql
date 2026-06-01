/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_loan_trans_detail
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
drop table ${iol_schema}.icms_wyd_loan_trans_detail_ex purge;
alter table ${iol_schema}.icms_wyd_loan_trans_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wyd_loan_trans_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wyd_loan_trans_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_loan_trans_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wyd_loan_trans_detail_ex(
    consumertransid -- 核心流水号
    ,systransid -- 系统调用流水号
    ,txnseq -- 交易流水号
    ,txndate -- 交易日期
    ,orgid -- 机构号
    ,logicalcardno -- 逻辑卡号
    ,lendingref -- 借据号
    ,currcd -- 币种
    ,txncode -- 交易码
    ,txndesc -- 交易描述
    ,dbcrind -- 借贷标记
    ,postamt -- 入账金额
    ,postglind -- 入账方式
    ,owningbranch -- 支行
    ,subject -- 科目
    ,redflag -- 红蓝字标识
    ,queue -- 排序
    ,agegroup -- 账龄组
    ,bnpgroup -- 余额成分组
    ,bankgroupid -- 银团代码
    ,bankno -- 银行代码
    ,term -- 期数
    ,batchdate -- 交易日期
    ,txntime -- 交易时间
    ,acctno -- 帐号
    ,accttype -- 账户类型
    ,txnbalance -- 账户余额
    ,cashflag -- 现转标志
    ,postdate -- 入账日期
    ,posttime -- 入账时间
    ,youracctno -- 对方账号
    ,youracctname -- 对方户名
    ,yourbankid -- 对方行号
    ,yourbankname -- 对方行名
    ,qchannelid -- 交易渠道编号
    ,trasnuser -- 交易柜员号
    ,uesrserno -- 柜员流水号
    ,authuser -- 授权柜员号
    ,vouchertype -- 主凭证种类
    ,voucherno -- 主凭证号
    ,transflag -- 冲补抹标志
    ,agentname -- 代办人姓名
    ,agentidtype -- 代办人证件类别
    ,agentidno -- 代办人证件号码
    ,payeracct -- 付款人账号
    ,payername -- 付款人名称
    ,payerbrno -- 付款人开户行行号
    ,payerbrname -- 付款人开户行名称
    ,payeeacct -- 收款人账号
    ,payeename -- 收款人名称
    ,payeebrno -- 收款人开户行行号
    ,payeebrname -- 收款人开户行名称
    ,settleid -- 还款清算交易编号
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    consumertransid -- 核心流水号
    ,systransid -- 系统调用流水号
    ,txnseq -- 交易流水号
    ,txndate -- 交易日期
    ,orgid -- 机构号
    ,logicalcardno -- 逻辑卡号
    ,lendingref -- 借据号
    ,currcd -- 币种
    ,txncode -- 交易码
    ,txndesc -- 交易描述
    ,dbcrind -- 借贷标记
    ,postamt -- 入账金额
    ,postglind -- 入账方式
    ,owningbranch -- 支行
    ,subject -- 科目
    ,redflag -- 红蓝字标识
    ,queue -- 排序
    ,agegroup -- 账龄组
    ,bnpgroup -- 余额成分组
    ,bankgroupid -- 银团代码
    ,bankno -- 银行代码
    ,term -- 期数
    ,batchdate -- 交易日期
    ,txntime -- 交易时间
    ,acctno -- 帐号
    ,accttype -- 账户类型
    ,txnbalance -- 账户余额
    ,cashflag -- 现转标志
    ,postdate -- 入账日期
    ,posttime -- 入账时间
    ,youracctno -- 对方账号
    ,youracctname -- 对方户名
    ,yourbankid -- 对方行号
    ,yourbankname -- 对方行名
    ,qchannelid -- 交易渠道编号
    ,trasnuser -- 交易柜员号
    ,uesrserno -- 柜员流水号
    ,authuser -- 授权柜员号
    ,vouchertype -- 主凭证种类
    ,voucherno -- 主凭证号
    ,transflag -- 冲补抹标志
    ,agentname -- 代办人姓名
    ,agentidtype -- 代办人证件类别
    ,agentidno -- 代办人证件号码
    ,payeracct -- 付款人账号
    ,payername -- 付款人名称
    ,payerbrno -- 付款人开户行行号
    ,payerbrname -- 付款人开户行名称
    ,payeeacct -- 收款人账号
    ,payeename -- 收款人名称
    ,payeebrno -- 收款人开户行行号
    ,payeebrname -- 收款人开户行名称
    ,settleid -- 还款清算交易编号
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wyd_loan_trans_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wyd_loan_trans_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_loan_trans_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_loan_trans_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wyd_loan_trans_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_loan_trans_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);