/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_loan
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
drop table ${iol_schema}.icms_wyd_loan_ex purge;
alter table ${iol_schema}.icms_wyd_loan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wyd_loan truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wyd_loan_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_loan where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wyd_loan_ex(
    operorg -- 合作机构号
    ,contractno -- 借款合同号
    ,lendingref -- 借据号
    ,seqno -- 流水号
    ,fullname -- 客户姓名
    ,termdate -- 贷款期限
    ,putoutdate -- 起始日期
    ,maturity -- 到期日期
    ,tremmonth -- 期限月
    ,businesscurrency -- 币种
    ,businesssum -- 贷款金额
    ,balance -- 贷款余额
    ,businessrate -- 贷款利率
    ,overduefine -- 逾期利率
    ,startinterestdate -- 起息日
    ,payday -- 还款日
    ,status -- 处理标志
    ,loanstatus -- 贷款状态
    ,absstatus -- 资产转让状态
    ,projectid -- 项目编号
    ,corpuspaymethod -- 还款方式
    ,payacctno -- 贷款还款账号
    ,payacctnoname -- 贷款还款账号名称
    ,payacctbankno -- 贷款还款行号
    ,payacctbank -- 贷款还款行名
    ,inacctno -- 贷款入账账号
    ,inacctnoname -- 贷款入账账号名称
    ,inacctbankno -- 贷款入账行号
    ,inacctbank -- 贷款入账行名
    ,bondacctno -- 保证金帐号
    ,typeofcust -- 客户类型
    ,termflag -- 短期中长期的标识
    ,lprbaserate -- lpr基准利率
    ,loanchangfrequency -- 申请延期还款交易成功次数
    ,loanusage -- 贷款用途
    ,withdrawsettleid -- 放款清算交易编号
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 五级分类
    ,ipcode -- 结息方式
    ,interestcalculatetype -- 计息方式
    ,rateadjusttype -- 利率调整方式
    ,repricetermunit -- 利率调整周期单位
    ,repricetermfrequency -- 利率调整周期频率
    ,baseratetype -- 基准利率类型
    ,ratefloattype -- 利率浮动方式
    ,ratefloatvalue -- 利率浮动值
    ,isriskcreditwhite -- 风控返回是否征信白户
    ,remart -- 资产三分类
    ,accrueinterday -- 当日应计利息
    ,ysintamt -- 应收欠息
    ,rcvaaccrpnlt -- 应收应计罚息。
    ,ysodpamt -- 应收罚息
    ,category -- 国标行业分类
    ,fksdbusinesssum -- 放款时点额度金额
    ,putoutorgid -- 账务机构
    ,taxflag -- 涉税标识(是否免税,0-否,1-是)
    ,loanusagedesc -- 贷款用途原描述
    ,overduedays -- 逾期天数
    ,paidoutdate -- 结清日期
    ,ddtyp -- 放款类型
    ,participantratio -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    operorg -- 合作机构号
    ,contractno -- 借款合同号
    ,lendingref -- 借据号
    ,seqno -- 流水号
    ,fullname -- 客户姓名
    ,termdate -- 贷款期限
    ,putoutdate -- 起始日期
    ,maturity -- 到期日期
    ,tremmonth -- 期限月
    ,businesscurrency -- 币种
    ,businesssum -- 贷款金额
    ,balance -- 贷款余额
    ,businessrate -- 贷款利率
    ,overduefine -- 逾期利率
    ,startinterestdate -- 起息日
    ,payday -- 还款日
    ,status -- 处理标志
    ,loanstatus -- 贷款状态
    ,absstatus -- 资产转让状态
    ,projectid -- 项目编号
    ,corpuspaymethod -- 还款方式
    ,payacctno -- 贷款还款账号
    ,payacctnoname -- 贷款还款账号名称
    ,payacctbankno -- 贷款还款行号
    ,payacctbank -- 贷款还款行名
    ,inacctno -- 贷款入账账号
    ,inacctnoname -- 贷款入账账号名称
    ,inacctbankno -- 贷款入账行号
    ,inacctbank -- 贷款入账行名
    ,bondacctno -- 保证金帐号
    ,typeofcust -- 客户类型
    ,termflag -- 短期中长期的标识
    ,lprbaserate -- lpr基准利率
    ,loanchangfrequency -- 申请延期还款交易成功次数
    ,loanusage -- 贷款用途
    ,withdrawsettleid -- 放款清算交易编号
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 五级分类
    ,ipcode -- 结息方式
    ,interestcalculatetype -- 计息方式
    ,rateadjusttype -- 利率调整方式
    ,repricetermunit -- 利率调整周期单位
    ,repricetermfrequency -- 利率调整周期频率
    ,baseratetype -- 基准利率类型
    ,ratefloattype -- 利率浮动方式
    ,ratefloatvalue -- 利率浮动值
    ,isriskcreditwhite -- 风控返回是否征信白户
    ,remart -- 资产三分类
    ,accrueinterday -- 当日应计利息
    ,ysintamt -- 应收欠息
    ,rcvaaccrpnlt -- 应收应计罚息。
    ,ysodpamt -- 应收罚息
    ,category -- 国标行业分类
    ,fksdbusinesssum -- 放款时点额度金额
    ,putoutorgid -- 账务机构
    ,taxflag -- 涉税标识(是否免税,0-否,1-是)
    ,loanusagedesc -- 贷款用途原描述
    ,overduedays -- 逾期天数
    ,paidoutdate -- 结清日期
    ,ddtyp -- 放款类型
    ,participantratio -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wyd_loan
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wyd_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_loan_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_loan to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wyd_loan_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_loan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);