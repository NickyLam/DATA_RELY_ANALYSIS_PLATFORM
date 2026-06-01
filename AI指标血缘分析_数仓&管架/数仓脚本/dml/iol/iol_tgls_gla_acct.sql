/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gla_acct
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
create table ${iol_schema}.tgls_gla_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_gla_acct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gla_acct_op purge;
drop table ${iol_schema}.tgls_gla_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_acct where 0=1;

create table ${iol_schema}.tgls_gla_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gla_acct_cl(
            acctcd -- 账户表唯一标识
            ,acctna -- 名称
            ,systid -- 系统识别号(01-总账02-核心03-财务)
            ,brchno -- 核算机构编号
            ,crcycd -- 币种
            ,itemcd -- 核算科目编号
            ,acctcl -- 账户类别(1手工账户2基准账户3专用账户)
            ,subscd -- 子目号
            ,openbr -- 开户机构编号
            ,opendt -- 开户日期
            ,optrsq -- 开户流水号
            ,lstrdt -- 最后交易日期
            ,lstrsq -- 最后交易流水
            ,closdt -- 销户日期
            ,cltrsq -- 销户流水号
            ,ioflag -- 表内外标志（i表内o表外）
            ,blncdn -- 联机科目余额方向
            ,onlnbl -- 联机余额
            ,lastdn -- 上日科目余额方向
            ,lastbl -- 上日余额
            ,lastdt -- 上日余额日期
            ,acmlbl -- 积数
            ,acmldt -- 积数日期
            ,acctst -- 账户状态(0-关闭1-正常)
            ,drhdbk -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
            ,crhdbk -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
            ,openus -- 开户柜员
            ,closus -- 销户柜员
            ,pmodtg -- 透支标志（0：不允许，1：允许）
            ,stacid -- 账套标识
            ,centcd -- 责任中心
            ,prsncd -- 员工编号
            ,custcd -- 客户编号
            ,prducd -- 产品编号
            ,prlncd -- 产品线
            ,acctno -- 账户-多维
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gla_acct_op(
            acctcd -- 账户表唯一标识
            ,acctna -- 名称
            ,systid -- 系统识别号(01-总账02-核心03-财务)
            ,brchno -- 核算机构编号
            ,crcycd -- 币种
            ,itemcd -- 核算科目编号
            ,acctcl -- 账户类别(1手工账户2基准账户3专用账户)
            ,subscd -- 子目号
            ,openbr -- 开户机构编号
            ,opendt -- 开户日期
            ,optrsq -- 开户流水号
            ,lstrdt -- 最后交易日期
            ,lstrsq -- 最后交易流水
            ,closdt -- 销户日期
            ,cltrsq -- 销户流水号
            ,ioflag -- 表内外标志（i表内o表外）
            ,blncdn -- 联机科目余额方向
            ,onlnbl -- 联机余额
            ,lastdn -- 上日科目余额方向
            ,lastbl -- 上日余额
            ,lastdt -- 上日余额日期
            ,acmlbl -- 积数
            ,acmldt -- 积数日期
            ,acctst -- 账户状态(0-关闭1-正常)
            ,drhdbk -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
            ,crhdbk -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
            ,openus -- 开户柜员
            ,closus -- 销户柜员
            ,pmodtg -- 透支标志（0：不允许，1：允许）
            ,stacid -- 账套标识
            ,centcd -- 责任中心
            ,prsncd -- 员工编号
            ,custcd -- 客户编号
            ,prducd -- 产品编号
            ,prlncd -- 产品线
            ,acctno -- 账户-多维
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acctcd, o.acctcd) as acctcd -- 账户表唯一标识
    ,nvl(n.acctna, o.acctna) as acctna -- 名称
    ,nvl(n.systid, o.systid) as systid -- 系统识别号(01-总账02-核心03-财务)
    ,nvl(n.brchno, o.brchno) as brchno -- 核算机构编号
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 核算科目编号
    ,nvl(n.acctcl, o.acctcl) as acctcl -- 账户类别(1手工账户2基准账户3专用账户)
    ,nvl(n.subscd, o.subscd) as subscd -- 子目号
    ,nvl(n.openbr, o.openbr) as openbr -- 开户机构编号
    ,nvl(n.opendt, o.opendt) as opendt -- 开户日期
    ,nvl(n.optrsq, o.optrsq) as optrsq -- 开户流水号
    ,nvl(n.lstrdt, o.lstrdt) as lstrdt -- 最后交易日期
    ,nvl(n.lstrsq, o.lstrsq) as lstrsq -- 最后交易流水
    ,nvl(n.closdt, o.closdt) as closdt -- 销户日期
    ,nvl(n.cltrsq, o.cltrsq) as cltrsq -- 销户流水号
    ,nvl(n.ioflag, o.ioflag) as ioflag -- 表内外标志（i表内o表外）
    ,nvl(n.blncdn, o.blncdn) as blncdn -- 联机科目余额方向
    ,nvl(n.onlnbl, o.onlnbl) as onlnbl -- 联机余额
    ,nvl(n.lastdn, o.lastdn) as lastdn -- 上日科目余额方向
    ,nvl(n.lastbl, o.lastbl) as lastbl -- 上日余额
    ,nvl(n.lastdt, o.lastdt) as lastdt -- 上日余额日期
    ,nvl(n.acmlbl, o.acmlbl) as acmlbl -- 积数
    ,nvl(n.acmldt, o.acmldt) as acmldt -- 积数日期
    ,nvl(n.acctst, o.acctst) as acctst -- 账户状态(0-关闭1-正常)
    ,nvl(n.drhdbk, o.drhdbk) as drhdbk -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,nvl(n.crhdbk, o.crhdbk) as crhdbk -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,nvl(n.openus, o.openus) as openus -- 开户柜员
    ,nvl(n.closus, o.closus) as closus -- 销户柜员
    ,nvl(n.pmodtg, o.pmodtg) as pmodtg -- 透支标志（0：不允许，1：允许）
    ,nvl(n.stacid, o.stacid) as stacid -- 账套标识
    ,nvl(n.centcd, o.centcd) as centcd -- 责任中心
    ,nvl(n.prsncd, o.prsncd) as prsncd -- 员工编号
    ,nvl(n.custcd, o.custcd) as custcd -- 客户编号
    ,nvl(n.prducd, o.prducd) as prducd -- 产品编号
    ,nvl(n.prlncd, o.prlncd) as prlncd -- 产品线
    ,nvl(n.acctno, o.acctno) as acctno -- 账户-多维
    ,nvl(n.assis0, o.assis0) as assis0 -- 辅助核算0（自定义）
    ,nvl(n.assis1, o.assis1) as assis1 -- 辅助核算1（自定义）
    ,nvl(n.assis2, o.assis2) as assis2 -- 辅助核算2（自定义）
    ,nvl(n.assis3, o.assis3) as assis3 -- 辅助核算3（自定义）
    ,nvl(n.assis4, o.assis4) as assis4 -- 辅助核算4（自定义）
    ,nvl(n.assis5, o.assis5) as assis5 -- 辅助核算5（自定义）
    ,nvl(n.assis6, o.assis6) as assis6 -- 辅助核算6（自定义）
    ,nvl(n.assis7, o.assis7) as assis7 -- 辅助核算7（自定义）
    ,nvl(n.assis8, o.assis8) as assis8 -- 辅助核算8（自定义）
    ,nvl(n.assis9, o.assis9) as assis9 -- 辅助核算9（自定义）
    ,case when
            n.acctcd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acctcd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acctcd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_gla_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_gla_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acctcd = n.acctcd
where (
        o.acctcd is null
    )
    or (
        n.acctcd is null
    )
    or (
        o.acctna <> n.acctna
        or o.systid <> n.systid
        or o.brchno <> n.brchno
        or o.crcycd <> n.crcycd
        or o.itemcd <> n.itemcd
        or o.acctcl <> n.acctcl
        or o.subscd <> n.subscd
        or o.openbr <> n.openbr
        or o.opendt <> n.opendt
        or o.optrsq <> n.optrsq
        or o.lstrdt <> n.lstrdt
        or o.lstrsq <> n.lstrsq
        or o.closdt <> n.closdt
        or o.cltrsq <> n.cltrsq
        or o.ioflag <> n.ioflag
        or o.blncdn <> n.blncdn
        or o.onlnbl <> n.onlnbl
        or o.lastdn <> n.lastdn
        or o.lastbl <> n.lastbl
        or o.lastdt <> n.lastdt
        or o.acmlbl <> n.acmlbl
        or o.acmldt <> n.acmldt
        or o.acctst <> n.acctst
        or o.drhdbk <> n.drhdbk
        or o.crhdbk <> n.crhdbk
        or o.openus <> n.openus
        or o.closus <> n.closus
        or o.pmodtg <> n.pmodtg
        or o.stacid <> n.stacid
        or o.centcd <> n.centcd
        or o.prsncd <> n.prsncd
        or o.custcd <> n.custcd
        or o.prducd <> n.prducd
        or o.prlncd <> n.prlncd
        or o.acctno <> n.acctno
        or o.assis0 <> n.assis0
        or o.assis1 <> n.assis1
        or o.assis2 <> n.assis2
        or o.assis3 <> n.assis3
        or o.assis4 <> n.assis4
        or o.assis5 <> n.assis5
        or o.assis6 <> n.assis6
        or o.assis7 <> n.assis7
        or o.assis8 <> n.assis8
        or o.assis9 <> n.assis9
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gla_acct_cl(
            acctcd -- 账户表唯一标识
            ,acctna -- 名称
            ,systid -- 系统识别号(01-总账02-核心03-财务)
            ,brchno -- 核算机构编号
            ,crcycd -- 币种
            ,itemcd -- 核算科目编号
            ,acctcl -- 账户类别(1手工账户2基准账户3专用账户)
            ,subscd -- 子目号
            ,openbr -- 开户机构编号
            ,opendt -- 开户日期
            ,optrsq -- 开户流水号
            ,lstrdt -- 最后交易日期
            ,lstrsq -- 最后交易流水
            ,closdt -- 销户日期
            ,cltrsq -- 销户流水号
            ,ioflag -- 表内外标志（i表内o表外）
            ,blncdn -- 联机科目余额方向
            ,onlnbl -- 联机余额
            ,lastdn -- 上日科目余额方向
            ,lastbl -- 上日余额
            ,lastdt -- 上日余额日期
            ,acmlbl -- 积数
            ,acmldt -- 积数日期
            ,acctst -- 账户状态(0-关闭1-正常)
            ,drhdbk -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
            ,crhdbk -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
            ,openus -- 开户柜员
            ,closus -- 销户柜员
            ,pmodtg -- 透支标志（0：不允许，1：允许）
            ,stacid -- 账套标识
            ,centcd -- 责任中心
            ,prsncd -- 员工编号
            ,custcd -- 客户编号
            ,prducd -- 产品编号
            ,prlncd -- 产品线
            ,acctno -- 账户-多维
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gla_acct_op(
            acctcd -- 账户表唯一标识
            ,acctna -- 名称
            ,systid -- 系统识别号(01-总账02-核心03-财务)
            ,brchno -- 核算机构编号
            ,crcycd -- 币种
            ,itemcd -- 核算科目编号
            ,acctcl -- 账户类别(1手工账户2基准账户3专用账户)
            ,subscd -- 子目号
            ,openbr -- 开户机构编号
            ,opendt -- 开户日期
            ,optrsq -- 开户流水号
            ,lstrdt -- 最后交易日期
            ,lstrsq -- 最后交易流水
            ,closdt -- 销户日期
            ,cltrsq -- 销户流水号
            ,ioflag -- 表内外标志（i表内o表外）
            ,blncdn -- 联机科目余额方向
            ,onlnbl -- 联机余额
            ,lastdn -- 上日科目余额方向
            ,lastbl -- 上日余额
            ,lastdt -- 上日余额日期
            ,acmlbl -- 积数
            ,acmldt -- 积数日期
            ,acctst -- 账户状态(0-关闭1-正常)
            ,drhdbk -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
            ,crhdbk -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
            ,openus -- 开户柜员
            ,closus -- 销户柜员
            ,pmodtg -- 透支标志（0：不允许，1：允许）
            ,stacid -- 账套标识
            ,centcd -- 责任中心
            ,prsncd -- 员工编号
            ,custcd -- 客户编号
            ,prducd -- 产品编号
            ,prlncd -- 产品线
            ,acctno -- 账户-多维
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acctcd -- 账户表唯一标识
    ,o.acctna -- 名称
    ,o.systid -- 系统识别号(01-总账02-核心03-财务)
    ,o.brchno -- 核算机构编号
    ,o.crcycd -- 币种
    ,o.itemcd -- 核算科目编号
    ,o.acctcl -- 账户类别(1手工账户2基准账户3专用账户)
    ,o.subscd -- 子目号
    ,o.openbr -- 开户机构编号
    ,o.opendt -- 开户日期
    ,o.optrsq -- 开户流水号
    ,o.lstrdt -- 最后交易日期
    ,o.lstrsq -- 最后交易流水
    ,o.closdt -- 销户日期
    ,o.cltrsq -- 销户流水号
    ,o.ioflag -- 表内外标志（i表内o表外）
    ,o.blncdn -- 联机科目余额方向
    ,o.onlnbl -- 联机余额
    ,o.lastdn -- 上日科目余额方向
    ,o.lastbl -- 上日余额
    ,o.lastdt -- 上日余额日期
    ,o.acmlbl -- 积数
    ,o.acmldt -- 积数日期
    ,o.acctst -- 账户状态(0-关闭1-正常)
    ,o.drhdbk -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,o.crhdbk -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,o.openus -- 开户柜员
    ,o.closus -- 销户柜员
    ,o.pmodtg -- 透支标志（0：不允许，1：允许）
    ,o.stacid -- 账套标识
    ,o.centcd -- 责任中心
    ,o.prsncd -- 员工编号
    ,o.custcd -- 客户编号
    ,o.prducd -- 产品编号
    ,o.prlncd -- 产品线
    ,o.acctno -- 账户-多维
    ,o.assis0 -- 辅助核算0（自定义）
    ,o.assis1 -- 辅助核算1（自定义）
    ,o.assis2 -- 辅助核算2（自定义）
    ,o.assis3 -- 辅助核算3（自定义）
    ,o.assis4 -- 辅助核算4（自定义）
    ,o.assis5 -- 辅助核算5（自定义）
    ,o.assis6 -- 辅助核算6（自定义）
    ,o.assis7 -- 辅助核算7（自定义）
    ,o.assis8 -- 辅助核算8（自定义）
    ,o.assis9 -- 辅助核算9（自定义）
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
from ${iol_schema}.tgls_gla_acct_bk o
    left join ${iol_schema}.tgls_gla_acct_op n
        on
            o.acctcd = n.acctcd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_gla_acct_cl d
        on
            o.acctcd = d.acctcd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_gla_acct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_gla_acct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_gla_acct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_gla_acct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_gla_acct exchange partition p_${batch_date} with table ${iol_schema}.tgls_gla_acct_cl;
alter table ${iol_schema}.tgls_gla_acct exchange partition p_20991231 with table ${iol_schema}.tgls_gla_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gla_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gla_acct_op purge;
drop table ${iol_schema}.tgls_gla_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_gla_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gla_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
