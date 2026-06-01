/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_loan_busi_h
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
drop table ${iol_schema}.tgls_loan_busi_h_ex purge;
alter table ${iol_schema}.tgls_loan_busi_h add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_loan_busi_h truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_loan_busi_h_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_loan_busi_h where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_loan_busi_h_ex(
    stacid -- 账套
    ,systid -- 交易来源系统编号
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,bsnssq -- 业务流水
    ,tranbr -- 交易机构编号
    ,acctbr -- 贷款机构
    ,prcscd -- 处理码
    ,prodcd -- 产品编号
    ,loanp1 -- 产品属性1
    ,loanp2 -- 产品属性2
    ,loanp3 -- 产品属性3
    ,loanp4 -- 产品属性4
    ,loanp5 -- 产品属性5
    ,loanp6 -- 产品属性6
    ,loanp7 -- 产品属性7
    ,loanp8 -- 产品属性8
    ,loanp9 -- 产品属性9
    ,loanpa -- 产品属性10
    ,trantp -- 交易方式(tr:转账，cs:现金)
    ,crcycd -- 币种代码
    ,custcd -- 客户编号
    ,status -- 交易状态(0:未处理1：处理成功2：处理失败3：差错处理中4：差错处理完成)
    ,serino -- 序号
    ,bathid -- 批次号
    ,evetdn -- 交易方向add增加，minus减少
    ,trprcd -- 余额类型
    ,tranam -- 交易金额
    ,centcd -- 责任中心
    ,prsncd -- 员工编号
    ,prlncd -- 产品线
    ,acctno -- 账户
    ,assis0 -- 辅助核算0（自定义）
    ,assis1 -- 辅助核算1（自定义）
    ,assis2 -- 辅助核算2（自定义）
    ,assis3 -- 辅助核算3（自定义）
    ,assis4 -- 辅助核算4（自定义）
    ,assis5 -- 辅助核算5（自定义）
    ,assis6 -- 辅助核算6（自定义）
    ,assis7 -- 辅助核算7（自定义）
    ,assis8 -- 辅助核算8（自定义）
    ,assis9 -- 辅助核算9（自定义）
    ,numex0 -- 金额1
    ,numex1 -- 金额2
    ,numex2 -- 金额3
    ,numex3 -- 金额4
    ,numex4 -- 金额5
    ,numex5 -- 金额6
    ,numex6 -- 金额7
    ,numex7 -- 金额8
    ,numex8 -- 金额9
    ,numex9 -- 金额10
    ,numexa -- 金额11
    ,numexb -- 金额12
    ,numexc -- 金额13
    ,numexd -- 金额14
    ,numexe -- 金额15
    ,numexf -- 金额16
    ,numexg -- 金额17
    ,numexh -- 金额18
    ,numexi -- 金额19
    ,numexj -- 金额20
    ,chrex0 -- 字符串1
    ,chrex1 -- 字符串2
    ,chrex2 -- 字符串3
    ,chrex3 -- 字符串4
    ,chrex4 -- 字符串5
    ,chrex5 -- 字符串6
    ,chrex6 -- 字符串7
    ,chrex7 -- 字符串8
    ,chrex8 -- 字符串9
    ,chrex9 -- 字符串10
    ,chrexa -- 字符串11
    ,chrexb -- 字符串12
    ,chrexc -- 字符串13
    ,chrexd -- 字符串14
    ,chrexe -- 字符串15
    ,chrexf -- 字符串16
    ,chrexg -- 字符串17
    ,chrexh -- 字符串18
    ,chrexi -- 字符串19
    ,chrexj -- 字符串20
    ,datex0 -- 日期1
    ,datex1 -- 日期2
    ,datex2 -- 日期3
    ,datex3 -- 日期4
    ,datex4 -- 日期5
    ,tranti -- 系统时间
    ,nume21 -- 金额21
    ,nume22 -- 金额22
    ,nume23 -- 金额23
    ,nume24 -- 金额24
    ,nume25 -- 金额25
    ,nume26 -- 金额26
    ,nume27 -- 金额27
    ,nume28 -- 金额28
    ,nume29 -- 金额29
    ,nume30 -- 金额30
    ,nume31 -- 金额31
    ,nume32 -- 金额32
    ,nume33 -- 金额33
    ,nume34 -- 金额34
    ,nume35 -- 金额35
    ,nume36 -- 金额36
    ,nume37 -- 金额37
    ,nume38 -- 金额38
    ,nume39 -- 金额39
    ,nume40 -- 金额40
    ,nume41 -- 金额41
    ,nume42 -- 金额42
    ,nume43 -- 金额43
    ,nume44 -- 金额44
    ,nume45 -- 金额45
    ,nume46 -- 金额46
    ,nume47 -- 金额47
    ,nume48 -- 金额48
    ,nume49 -- 金额49
    ,nume50 -- 金额50
    ,strkst -- 冲正标识（0：正常业务1：冲正业务）
    ,strkdt -- 被冲正业务交易日期
    ,strksq -- 被冲正业务交易流水
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,systid -- 交易来源系统编号
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,bsnssq -- 业务流水
    ,tranbr -- 交易机构编号
    ,acctbr -- 贷款机构
    ,prcscd -- 处理码
    ,prodcd -- 产品编号
    ,loanp1 -- 产品属性1
    ,loanp2 -- 产品属性2
    ,loanp3 -- 产品属性3
    ,loanp4 -- 产品属性4
    ,loanp5 -- 产品属性5
    ,loanp6 -- 产品属性6
    ,loanp7 -- 产品属性7
    ,loanp8 -- 产品属性8
    ,loanp9 -- 产品属性9
    ,loanpa -- 产品属性10
    ,trantp -- 交易方式(tr:转账，cs:现金)
    ,crcycd -- 币种代码
    ,custcd -- 客户编号
    ,status -- 交易状态(0:未处理1：处理成功2：处理失败3：差错处理中4：差错处理完成)
    ,serino -- 序号
    ,bathid -- 批次号
    ,evetdn -- 交易方向add增加，minus减少
    ,trprcd -- 余额类型
    ,tranam -- 交易金额
    ,centcd -- 责任中心
    ,prsncd -- 员工编号
    ,prlncd -- 产品线
    ,acctno -- 账户
    ,assis0 -- 辅助核算0（自定义）
    ,assis1 -- 辅助核算1（自定义）
    ,assis2 -- 辅助核算2（自定义）
    ,assis3 -- 辅助核算3（自定义）
    ,assis4 -- 辅助核算4（自定义）
    ,assis5 -- 辅助核算5（自定义）
    ,assis6 -- 辅助核算6（自定义）
    ,assis7 -- 辅助核算7（自定义）
    ,assis8 -- 辅助核算8（自定义）
    ,assis9 -- 辅助核算9（自定义）
    ,numex0 -- 金额1
    ,numex1 -- 金额2
    ,numex2 -- 金额3
    ,numex3 -- 金额4
    ,numex4 -- 金额5
    ,numex5 -- 金额6
    ,numex6 -- 金额7
    ,numex7 -- 金额8
    ,numex8 -- 金额9
    ,numex9 -- 金额10
    ,numexa -- 金额11
    ,numexb -- 金额12
    ,numexc -- 金额13
    ,numexd -- 金额14
    ,numexe -- 金额15
    ,numexf -- 金额16
    ,numexg -- 金额17
    ,numexh -- 金额18
    ,numexi -- 金额19
    ,numexj -- 金额20
    ,chrex0 -- 字符串1
    ,chrex1 -- 字符串2
    ,chrex2 -- 字符串3
    ,chrex3 -- 字符串4
    ,chrex4 -- 字符串5
    ,chrex5 -- 字符串6
    ,chrex6 -- 字符串7
    ,chrex7 -- 字符串8
    ,chrex8 -- 字符串9
    ,chrex9 -- 字符串10
    ,chrexa -- 字符串11
    ,chrexb -- 字符串12
    ,chrexc -- 字符串13
    ,chrexd -- 字符串14
    ,chrexe -- 字符串15
    ,chrexf -- 字符串16
    ,chrexg -- 字符串17
    ,chrexh -- 字符串18
    ,chrexi -- 字符串19
    ,chrexj -- 字符串20
    ,datex0 -- 日期1
    ,datex1 -- 日期2
    ,datex2 -- 日期3
    ,datex3 -- 日期4
    ,datex4 -- 日期5
    ,tranti -- 系统时间
    ,nume21 -- 金额21
    ,nume22 -- 金额22
    ,nume23 -- 金额23
    ,nume24 -- 金额24
    ,nume25 -- 金额25
    ,nume26 -- 金额26
    ,nume27 -- 金额27
    ,nume28 -- 金额28
    ,nume29 -- 金额29
    ,nume30 -- 金额30
    ,nume31 -- 金额31
    ,nume32 -- 金额32
    ,nume33 -- 金额33
    ,nume34 -- 金额34
    ,nume35 -- 金额35
    ,nume36 -- 金额36
    ,nume37 -- 金额37
    ,nume38 -- 金额38
    ,nume39 -- 金额39
    ,nume40 -- 金额40
    ,nume41 -- 金额41
    ,nume42 -- 金额42
    ,nume43 -- 金额43
    ,nume44 -- 金额44
    ,nume45 -- 金额45
    ,nume46 -- 金额46
    ,nume47 -- 金额47
    ,nume48 -- 金额48
    ,nume49 -- 金额49
    ,nume50 -- 金额50
    ,strkst -- 冲正标识（0：正常业务1：冲正业务）
    ,strkdt -- 被冲正业务交易日期
    ,strksq -- 被冲正业务交易流水
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_loan_busi_h
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_loan_busi_h exchange partition p_${batch_date} with table ${iol_schema}.tgls_loan_busi_h_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_loan_busi_h to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_loan_busi_h_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_loan_busi_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);