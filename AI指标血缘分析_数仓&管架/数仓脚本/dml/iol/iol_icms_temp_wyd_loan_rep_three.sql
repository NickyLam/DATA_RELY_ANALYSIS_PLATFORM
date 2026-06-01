/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_temp_wyd_loan_rep_three
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
drop table ${iol_schema}.icms_temp_wyd_loan_rep_three_ex purge;
alter table ${iol_schema}.icms_temp_wyd_loan_rep_three add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_temp_wyd_loan_rep_three;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_temp_wyd_loan_rep_three_ex nologging
compress
as
select * from ${iol_schema}.icms_temp_wyd_loan_rep_three where 0=1;

insert /*+ append */ into ${iol_schema}.icms_temp_wyd_loan_rep_three_ex(
    orgid -- 合作机构号
    ,busisno -- 提款准入流水
    ,ccif -- 客户号
    ,custtype -- 客户类型
    ,loanno -- 主借据号
    ,customername -- 客户姓名
    ,termdate -- 贷款期限
    ,putoutdate -- 起始日期
    ,maturity -- 到期日期
    ,tremmonth -- 期限月
    ,currency -- 币种
    ,businesssum -- 贷款金额
    ,balance -- 贷款余额
    ,businessrate -- 贷款利率
    ,overduefine -- 逾期利率
    ,startinterestdate -- 起息日
    ,payday -- 还款日
    ,loanstatus -- 贷款状态
    ,productid -- 核算产品号
    ,composedproductid -- 组合产品号
    ,projectid -- 项目编号
    ,writeoffdate -- 核销日期
    ,finishdate -- 结清日期
    ,corpuspaymethod -- 还款方式
    ,payacctno -- 贷款还款账号
    ,payacctnoname -- 贷款还款账号名称
    ,payacctbankno -- 贷款还款行号
    ,payacctbank -- 贷款还款行名
    ,inacctno -- 贷款入账账号
    ,inacctnoname -- 贷款入账账号名称
    ,inacctbankno -- 贷款入账行号
    ,inacctbank -- 贷款入账行名
    ,lprbaserate -- lpr基准利率
    ,participantratio -- 合作方出资比例
    ,loanusage -- 贷款用途
    ,recommender -- 推荐人
    ,guaranteeflag -- 中小担标志
    ,loanchangefrequency -- 延期还款次数
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    orgid -- 合作机构号
    ,busisno -- 提款准入流水
    ,ccif -- 客户号
    ,custtype -- 客户类型
    ,loanno -- 主借据号
    ,customername -- 客户姓名
    ,termdate -- 贷款期限
    ,putoutdate -- 起始日期
    ,maturity -- 到期日期
    ,tremmonth -- 期限月
    ,currency -- 币种
    ,businesssum -- 贷款金额
    ,balance -- 贷款余额
    ,businessrate -- 贷款利率
    ,overduefine -- 逾期利率
    ,startinterestdate -- 起息日
    ,payday -- 还款日
    ,loanstatus -- 贷款状态
    ,productid -- 核算产品号
    ,composedproductid -- 组合产品号
    ,projectid -- 项目编号
    ,writeoffdate -- 核销日期
    ,finishdate -- 结清日期
    ,corpuspaymethod -- 还款方式
    ,payacctno -- 贷款还款账号
    ,payacctnoname -- 贷款还款账号名称
    ,payacctbankno -- 贷款还款行号
    ,payacctbank -- 贷款还款行名
    ,inacctno -- 贷款入账账号
    ,inacctnoname -- 贷款入账账号名称
    ,inacctbankno -- 贷款入账行号
    ,inacctbank -- 贷款入账行名
    ,lprbaserate -- lpr基准利率
    ,participantratio -- 合作方出资比例
    ,loanusage -- 贷款用途
    ,recommender -- 推荐人
    ,guaranteeflag -- 中小担标志
    ,loanchangefrequency -- 延期还款次数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_temp_wyd_loan_rep_three
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_temp_wyd_loan_rep_three exchange partition p_${batch_date} with table ${iol_schema}.icms_temp_wyd_loan_rep_three_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_temp_wyd_loan_rep_three to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_temp_wyd_loan_rep_three_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_temp_wyd_loan_rep_three',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);