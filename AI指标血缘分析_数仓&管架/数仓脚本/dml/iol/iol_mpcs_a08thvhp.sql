/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08thvhp
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
drop table ${iol_schema}.mpcs_a08thvhp_ex purge;
alter table ${iol_schema}.mpcs_a08thvhp add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a08thvhp truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a08thvhp_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08thvhp where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a08thvhp_ex(
    mainseq -- 
    ,transdt -- 
    ,cshpbillnb -- 
    ,cshpbilldate -- 
    ,payacct -- 
    ,payname -- 
    ,magebrn -- 办理机构
    ,cshpbilltype -- 
    ,ccynbr -- 
    ,cshpbillamt -- 
    ,cshpbillsign -- 
    ,cshpcashbkno -- 兑付行号
    ,inconame -- 
    ,incoacct -- 
    ,infocode -- 
    ,info -- 
    ,billst -- 
    ,msgsrc -- 
    ,chngna -- 兑付行名
    ,cshplastopenbkno -- 
    ,cshplastacct -- 
    ,cshplastname -- 
    ,operdt -- 
    ,opersq -- 
    ,oprtlr -- 
    ,chktlr -- 
    ,clenus -- 
    ,auttlr -- 
    ,prttlr -- 
    ,prtcnt -- 
    ,incodt -- 
    ,chngam -- 
    ,refdid -- 
    ,consigndt -- 
    ,respcd -- 
    ,lostdt -- 
    ,unlsdt -- 
    ,lostlr -- 
    ,ulstlr -- 
    ,idtftp1 -- 
    ,idtfno1 -- 
    ,operna1 -- 
    ,losttm -- 
    ,lostad -- 
    ,linkad1 -- 
    ,linktl1 -- 
    ,lostrs1 -- 
    ,idtftp2 -- 
    ,idtfno2 -- 
    ,operna2 -- 
    ,linkad2 -- 
    ,linktl2 -- 
    ,lostrs2 -- 
    ,provtp -- 
    ,provno -- 
    ,reason -- 
    ,execut -- 
    ,execpe -- 
    ,certtp -- 
    ,certno -- 
    ,provtp2 -- 
    ,provno2 -- 
    ,reason2 -- 
    ,execut2 -- 
    ,execpe2 -- 
    ,certtp2 -- 
    ,certno2 -- 
    ,signbilltype -- 
    ,flag3 -- 
    ,feeamt -- 
    ,feeamt1 -- 
    ,feeamt2 -- 
    ,bookdt -- 
    ,booknb -- 
    ,payopenbrn -- 申请人开户机构号
    ,payopenbrnnm -- 申请人开户机构名称
    ,incobrn -- 收款行号
    ,incobrnnm -- 收款行名
    ,idtftp3 -- 兑付申请人证据类型
    ,idtfno3 -- 兑付申请人证据号
    ,oprtlr3 -- 兑付操作柜员
    ,reason3 -- 未用退回原因
    ,paytype -- 1转账入账2 支取现金
    ,paybrnno -- 签发行行号
    ,paybrnname -- 签发行行名
    ,reason4 -- 挂账原因
    ,hpstatus -- 账务处理状态 4-已挂账 6-已维护入账  7-已直接入账
    ,paytp -- 支付方式
    ,bkcode -- 凭证类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    mainseq -- 
    ,transdt -- 
    ,cshpbillnb -- 
    ,cshpbilldate -- 
    ,payacct -- 
    ,payname -- 
    ,magebrn -- 办理机构
    ,cshpbilltype -- 
    ,ccynbr -- 
    ,cshpbillamt -- 
    ,cshpbillsign -- 
    ,cshpcashbkno -- 兑付行号
    ,inconame -- 
    ,incoacct -- 
    ,infocode -- 
    ,info -- 
    ,billst -- 
    ,msgsrc -- 
    ,chngna -- 兑付行名
    ,cshplastopenbkno -- 
    ,cshplastacct -- 
    ,cshplastname -- 
    ,operdt -- 
    ,opersq -- 
    ,oprtlr -- 
    ,chktlr -- 
    ,clenus -- 
    ,auttlr -- 
    ,prttlr -- 
    ,prtcnt -- 
    ,incodt -- 
    ,chngam -- 
    ,refdid -- 
    ,consigndt -- 
    ,respcd -- 
    ,lostdt -- 
    ,unlsdt -- 
    ,lostlr -- 
    ,ulstlr -- 
    ,idtftp1 -- 
    ,idtfno1 -- 
    ,operna1 -- 
    ,losttm -- 
    ,lostad -- 
    ,linkad1 -- 
    ,linktl1 -- 
    ,lostrs1 -- 
    ,idtftp2 -- 
    ,idtfno2 -- 
    ,operna2 -- 
    ,linkad2 -- 
    ,linktl2 -- 
    ,lostrs2 -- 
    ,provtp -- 
    ,provno -- 
    ,reason -- 
    ,execut -- 
    ,execpe -- 
    ,certtp -- 
    ,certno -- 
    ,provtp2 -- 
    ,provno2 -- 
    ,reason2 -- 
    ,execut2 -- 
    ,execpe2 -- 
    ,certtp2 -- 
    ,certno2 -- 
    ,signbilltype -- 
    ,flag3 -- 
    ,feeamt -- 
    ,feeamt1 -- 
    ,feeamt2 -- 
    ,bookdt -- 
    ,booknb -- 
    ,payopenbrn -- 申请人开户机构号
    ,payopenbrnnm -- 申请人开户机构名称
    ,incobrn -- 收款行号
    ,incobrnnm -- 收款行名
    ,idtftp3 -- 兑付申请人证据类型
    ,idtfno3 -- 兑付申请人证据号
    ,oprtlr3 -- 兑付操作柜员
    ,reason3 -- 未用退回原因
    ,paytype -- 1转账入账2 支取现金
    ,paybrnno -- 签发行行号
    ,paybrnname -- 签发行行名
    ,reason4 -- 挂账原因
    ,hpstatus -- 账务处理状态 4-已挂账 6-已维护入账  7-已直接入账
    ,paytp -- 支付方式
    ,bkcode -- 凭证类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a08thvhp
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a08thvhp exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a08thvhp_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08thvhp to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a08thvhp_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08thvhp',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);