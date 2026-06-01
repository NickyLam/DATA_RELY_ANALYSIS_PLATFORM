/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a60mopj_batch_acct_detail
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
drop table ${iol_schema}.mpcs_a60mopj_batch_acct_detail_ex purge;
alter table ${iol_schema}.mpcs_a60mopj_batch_acct_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a60mopj_batch_acct_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a60mopj_batch_acct_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60mopj_batch_acct_detail where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a60mopj_batch_acct_detail_ex(
    summsq -- 批扣流水
    ,bachdt -- 批次日期
    ,bachsq -- 批次流水
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,filetp -- 文件属性
    ,prodcd -- 产品代码
    ,inacct -- 代理账户
    ,trxamt -- 开户金额
    ,dcmttp -- 凭证类型
    ,ccynbr -- 币种
    ,ccyflg -- 钞汇标志
    ,acctna -- 客户名
    ,idtftp -- 证件类型
    ,idtfno -- 证件号码
    ,savecd -- 储种
    ,offtel -- 办公电话
    ,homtel -- 家庭电话
    ,mobtel -- 移动电话
    ,areacd -- 地区代码
    ,posicd -- 邮编
    ,addres -- 地址
    ,sex -- 性别
    ,trxam1 -- 保留金额1
    ,trxam2 -- 保留金额2
    ,trxam3 -- 保留金额3
    ,opt1 -- 备用1
    ,opt2 -- 备用2
    ,opt3 -- 备用3
    ,mmtext -- 摘要
    ,prttxt -- 打印摘要
    ,agidtp -- 代理人证件类型
    ,agidno -- 代理人证件号
    ,agcuna -- 代理人名
    ,acctno -- 账号
    ,rtrxam -- 交易金额
    ,hostsq -- 主机交易流水号
    ,hostdt -- 主机交易日期
    ,acctcd -- 响应码
    ,accmsg -- 响应信息
    ,rspcod -- 响应码	cmd9999 失败 | cmd0000成功
    ,rspmsg -- 响应信息
    ,branch -- 经办网点
    ,tlrnbr -- 经办柜员
    ,idtfdt -- 
    ,isopms -- 
    ,custno -- 
    ,cutycd -- 国籍
    ,ocptid -- 职业
    ,atchus -- 客户经理
    ,daylimit -- 日累计限额
    ,txntimeslimit -- 日笔数限额
    ,yearlimit -- 年累计限额
    ,limitsigncd -- 限额签约返回码
    ,limitsignmsg -- 限额签约返回信息
    ,openflag -- 
    ,bipcustno -- 
    ,errmsg -- 
    ,compna -- 公司名称
    ,fromdate -- 证件开始日期
    ,ocptdt -- 其他职业
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    summsq -- 批扣流水
    ,bachdt -- 批次日期
    ,bachsq -- 批次流水
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,filetp -- 文件属性
    ,prodcd -- 产品代码
    ,inacct -- 代理账户
    ,trxamt -- 开户金额
    ,dcmttp -- 凭证类型
    ,ccynbr -- 币种
    ,ccyflg -- 钞汇标志
    ,acctna -- 客户名
    ,idtftp -- 证件类型
    ,idtfno -- 证件号码
    ,savecd -- 储种
    ,offtel -- 办公电话
    ,homtel -- 家庭电话
    ,mobtel -- 移动电话
    ,areacd -- 地区代码
    ,posicd -- 邮编
    ,addres -- 地址
    ,sex -- 性别
    ,trxam1 -- 保留金额1
    ,trxam2 -- 保留金额2
    ,trxam3 -- 保留金额3
    ,opt1 -- 备用1
    ,opt2 -- 备用2
    ,opt3 -- 备用3
    ,mmtext -- 摘要
    ,prttxt -- 打印摘要
    ,agidtp -- 代理人证件类型
    ,agidno -- 代理人证件号
    ,agcuna -- 代理人名
    ,acctno -- 账号
    ,rtrxam -- 交易金额
    ,hostsq -- 主机交易流水号
    ,hostdt -- 主机交易日期
    ,acctcd -- 响应码
    ,accmsg -- 响应信息
    ,rspcod -- 响应码	cmd9999 失败 | cmd0000成功
    ,rspmsg -- 响应信息
    ,branch -- 经办网点
    ,tlrnbr -- 经办柜员
    ,idtfdt -- 
    ,isopms -- 
    ,custno -- 
    ,cutycd -- 国籍
    ,ocptid -- 职业
    ,atchus -- 客户经理
    ,daylimit -- 日累计限额
    ,txntimeslimit -- 日笔数限额
    ,yearlimit -- 年累计限额
    ,limitsigncd -- 限额签约返回码
    ,limitsignmsg -- 限额签约返回信息
    ,openflag -- 
    ,bipcustno -- 
    ,errmsg -- 
    ,compna -- 公司名称
    ,fromdate -- 证件开始日期
    ,ocptdt -- 其他职业
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a60mopj_batch_acct_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a60mopj_batch_acct_detail exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a60mopj_batch_acct_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a60mopj_batch_acct_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a60mopj_batch_acct_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a60mopj_batch_acct_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);