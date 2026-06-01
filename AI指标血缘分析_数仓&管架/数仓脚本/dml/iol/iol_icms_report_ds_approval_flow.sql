/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_report_ds_approval_flow
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
create table ${iol_schema}.icms_report_ds_approval_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_report_ds_approval_flow
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_report_ds_approval_flow_op purge;
drop table ${iol_schema}.icms_report_ds_approval_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_report_ds_approval_flow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_report_ds_approval_flow where 0=1;

create table ${iol_schema}.icms_report_ds_approval_flow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_report_ds_approval_flow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_report_ds_approval_flow_cl(
            partitiondate -- 分区日期
            ,bizno -- 流水号
            ,bankno -- 银行号
            ,custscore -- 客户评分
            ,finalret -- 最终审批结果
            ,oursapprovalret -- 合作行审批结果
            ,codeblock -- 拒绝码
            ,isfirst -- 是否首借
            ,outerret -- 合作行机房审批结果
            ,pszret -- psz区审批结果
            ,biznbr -- 流水nbr
            ,rstuserfield1 -- 是否使用审批额度
            ,rstuserfield2 -- 备用字段2
            ,rstuserfield3 -- 备用字段3
            ,rstuserfield4 -- 备用字段4
            ,rstuserfield5 -- 备用字段5
            ,rstuserfield6 -- 审批额度
            ,rstuserfield7 -- 建议额度
            ,rstuserfield8 -- 备用字段8
            ,rstuserfield9 -- 备用字段9
            ,rstuserfield10 -- 备用字段10
            ,rstuserfield11 -- 是否同意签约
            ,rstuserfield12 -- 是否同意放款
            ,rstuserfield13 -- 用途类型
            ,rstuserfield14 -- 客户号
            ,rstuserfield15 -- 送审时方案
            ,rstuserfield16 -- 审批额度到期日
            ,rstuserfield17 -- 备用字段17
            ,rstuserfield18 -- 备用字段18
            ,rstuserfield19 -- 备用字段19
            ,rstuserfield20 -- 备用字段20
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_report_ds_approval_flow_op(
            partitiondate -- 分区日期
            ,bizno -- 流水号
            ,bankno -- 银行号
            ,custscore -- 客户评分
            ,finalret -- 最终审批结果
            ,oursapprovalret -- 合作行审批结果
            ,codeblock -- 拒绝码
            ,isfirst -- 是否首借
            ,outerret -- 合作行机房审批结果
            ,pszret -- psz区审批结果
            ,biznbr -- 流水nbr
            ,rstuserfield1 -- 是否使用审批额度
            ,rstuserfield2 -- 备用字段2
            ,rstuserfield3 -- 备用字段3
            ,rstuserfield4 -- 备用字段4
            ,rstuserfield5 -- 备用字段5
            ,rstuserfield6 -- 审批额度
            ,rstuserfield7 -- 建议额度
            ,rstuserfield8 -- 备用字段8
            ,rstuserfield9 -- 备用字段9
            ,rstuserfield10 -- 备用字段10
            ,rstuserfield11 -- 是否同意签约
            ,rstuserfield12 -- 是否同意放款
            ,rstuserfield13 -- 用途类型
            ,rstuserfield14 -- 客户号
            ,rstuserfield15 -- 送审时方案
            ,rstuserfield16 -- 审批额度到期日
            ,rstuserfield17 -- 备用字段17
            ,rstuserfield18 -- 备用字段18
            ,rstuserfield19 -- 备用字段19
            ,rstuserfield20 -- 备用字段20
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.partitiondate, o.partitiondate) as partitiondate -- 分区日期
    ,nvl(n.bizno, o.bizno) as bizno -- 流水号
    ,nvl(n.bankno, o.bankno) as bankno -- 银行号
    ,nvl(n.custscore, o.custscore) as custscore -- 客户评分
    ,nvl(n.finalret, o.finalret) as finalret -- 最终审批结果
    ,nvl(n.oursapprovalret, o.oursapprovalret) as oursapprovalret -- 合作行审批结果
    ,nvl(n.codeblock, o.codeblock) as codeblock -- 拒绝码
    ,nvl(n.isfirst, o.isfirst) as isfirst -- 是否首借
    ,nvl(n.outerret, o.outerret) as outerret -- 合作行机房审批结果
    ,nvl(n.pszret, o.pszret) as pszret -- psz区审批结果
    ,nvl(n.biznbr, o.biznbr) as biznbr -- 流水nbr
    ,nvl(n.rstuserfield1, o.rstuserfield1) as rstuserfield1 -- 是否使用审批额度
    ,nvl(n.rstuserfield2, o.rstuserfield2) as rstuserfield2 -- 备用字段2
    ,nvl(n.rstuserfield3, o.rstuserfield3) as rstuserfield3 -- 备用字段3
    ,nvl(n.rstuserfield4, o.rstuserfield4) as rstuserfield4 -- 备用字段4
    ,nvl(n.rstuserfield5, o.rstuserfield5) as rstuserfield5 -- 备用字段5
    ,nvl(n.rstuserfield6, o.rstuserfield6) as rstuserfield6 -- 审批额度
    ,nvl(n.rstuserfield7, o.rstuserfield7) as rstuserfield7 -- 建议额度
    ,nvl(n.rstuserfield8, o.rstuserfield8) as rstuserfield8 -- 备用字段8
    ,nvl(n.rstuserfield9, o.rstuserfield9) as rstuserfield9 -- 备用字段9
    ,nvl(n.rstuserfield10, o.rstuserfield10) as rstuserfield10 -- 备用字段10
    ,nvl(n.rstuserfield11, o.rstuserfield11) as rstuserfield11 -- 是否同意签约
    ,nvl(n.rstuserfield12, o.rstuserfield12) as rstuserfield12 -- 是否同意放款
    ,nvl(n.rstuserfield13, o.rstuserfield13) as rstuserfield13 -- 用途类型
    ,nvl(n.rstuserfield14, o.rstuserfield14) as rstuserfield14 -- 客户号
    ,nvl(n.rstuserfield15, o.rstuserfield15) as rstuserfield15 -- 送审时方案
    ,nvl(n.rstuserfield16, o.rstuserfield16) as rstuserfield16 -- 审批额度到期日
    ,nvl(n.rstuserfield17, o.rstuserfield17) as rstuserfield17 -- 备用字段17
    ,nvl(n.rstuserfield18, o.rstuserfield18) as rstuserfield18 -- 备用字段18
    ,nvl(n.rstuserfield19, o.rstuserfield19) as rstuserfield19 -- 备用字段19
    ,nvl(n.rstuserfield20, o.rstuserfield20) as rstuserfield20 -- 备用字段20
    ,case when
            n.bizno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bizno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bizno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_report_ds_approval_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_report_ds_approval_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bizno = n.bizno
where (
        o.bizno is null
    )
    or (
        n.bizno is null
    )
    or (
        o.partitiondate <> n.partitiondate
        or o.bankno <> n.bankno
        or o.custscore <> n.custscore
        or o.finalret <> n.finalret
        or o.oursapprovalret <> n.oursapprovalret
        or o.codeblock <> n.codeblock
        or o.isfirst <> n.isfirst
        or o.outerret <> n.outerret
        or o.pszret <> n.pszret
        or o.biznbr <> n.biznbr
        or o.rstuserfield1 <> n.rstuserfield1
        or o.rstuserfield2 <> n.rstuserfield2
        or o.rstuserfield3 <> n.rstuserfield3
        or o.rstuserfield4 <> n.rstuserfield4
        or o.rstuserfield5 <> n.rstuserfield5
        or o.rstuserfield6 <> n.rstuserfield6
        or o.rstuserfield7 <> n.rstuserfield7
        or o.rstuserfield8 <> n.rstuserfield8
        or o.rstuserfield9 <> n.rstuserfield9
        or o.rstuserfield10 <> n.rstuserfield10
        or o.rstuserfield11 <> n.rstuserfield11
        or o.rstuserfield12 <> n.rstuserfield12
        or o.rstuserfield13 <> n.rstuserfield13
        or o.rstuserfield14 <> n.rstuserfield14
        or o.rstuserfield15 <> n.rstuserfield15
        or o.rstuserfield16 <> n.rstuserfield16
        or o.rstuserfield17 <> n.rstuserfield17
        or o.rstuserfield18 <> n.rstuserfield18
        or o.rstuserfield19 <> n.rstuserfield19
        or o.rstuserfield20 <> n.rstuserfield20
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_report_ds_approval_flow_cl(
            partitiondate -- 分区日期
            ,bizno -- 流水号
            ,bankno -- 银行号
            ,custscore -- 客户评分
            ,finalret -- 最终审批结果
            ,oursapprovalret -- 合作行审批结果
            ,codeblock -- 拒绝码
            ,isfirst -- 是否首借
            ,outerret -- 合作行机房审批结果
            ,pszret -- psz区审批结果
            ,biznbr -- 流水nbr
            ,rstuserfield1 -- 是否使用审批额度
            ,rstuserfield2 -- 备用字段2
            ,rstuserfield3 -- 备用字段3
            ,rstuserfield4 -- 备用字段4
            ,rstuserfield5 -- 备用字段5
            ,rstuserfield6 -- 审批额度
            ,rstuserfield7 -- 建议额度
            ,rstuserfield8 -- 备用字段8
            ,rstuserfield9 -- 备用字段9
            ,rstuserfield10 -- 备用字段10
            ,rstuserfield11 -- 是否同意签约
            ,rstuserfield12 -- 是否同意放款
            ,rstuserfield13 -- 用途类型
            ,rstuserfield14 -- 客户号
            ,rstuserfield15 -- 送审时方案
            ,rstuserfield16 -- 审批额度到期日
            ,rstuserfield17 -- 备用字段17
            ,rstuserfield18 -- 备用字段18
            ,rstuserfield19 -- 备用字段19
            ,rstuserfield20 -- 备用字段20
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_report_ds_approval_flow_op(
            partitiondate -- 分区日期
            ,bizno -- 流水号
            ,bankno -- 银行号
            ,custscore -- 客户评分
            ,finalret -- 最终审批结果
            ,oursapprovalret -- 合作行审批结果
            ,codeblock -- 拒绝码
            ,isfirst -- 是否首借
            ,outerret -- 合作行机房审批结果
            ,pszret -- psz区审批结果
            ,biznbr -- 流水nbr
            ,rstuserfield1 -- 是否使用审批额度
            ,rstuserfield2 -- 备用字段2
            ,rstuserfield3 -- 备用字段3
            ,rstuserfield4 -- 备用字段4
            ,rstuserfield5 -- 备用字段5
            ,rstuserfield6 -- 审批额度
            ,rstuserfield7 -- 建议额度
            ,rstuserfield8 -- 备用字段8
            ,rstuserfield9 -- 备用字段9
            ,rstuserfield10 -- 备用字段10
            ,rstuserfield11 -- 是否同意签约
            ,rstuserfield12 -- 是否同意放款
            ,rstuserfield13 -- 用途类型
            ,rstuserfield14 -- 客户号
            ,rstuserfield15 -- 送审时方案
            ,rstuserfield16 -- 审批额度到期日
            ,rstuserfield17 -- 备用字段17
            ,rstuserfield18 -- 备用字段18
            ,rstuserfield19 -- 备用字段19
            ,rstuserfield20 -- 备用字段20
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.partitiondate -- 分区日期
    ,o.bizno -- 流水号
    ,o.bankno -- 银行号
    ,o.custscore -- 客户评分
    ,o.finalret -- 最终审批结果
    ,o.oursapprovalret -- 合作行审批结果
    ,o.codeblock -- 拒绝码
    ,o.isfirst -- 是否首借
    ,o.outerret -- 合作行机房审批结果
    ,o.pszret -- psz区审批结果
    ,o.biznbr -- 流水nbr
    ,o.rstuserfield1 -- 是否使用审批额度
    ,o.rstuserfield2 -- 备用字段2
    ,o.rstuserfield3 -- 备用字段3
    ,o.rstuserfield4 -- 备用字段4
    ,o.rstuserfield5 -- 备用字段5
    ,o.rstuserfield6 -- 审批额度
    ,o.rstuserfield7 -- 建议额度
    ,o.rstuserfield8 -- 备用字段8
    ,o.rstuserfield9 -- 备用字段9
    ,o.rstuserfield10 -- 备用字段10
    ,o.rstuserfield11 -- 是否同意签约
    ,o.rstuserfield12 -- 是否同意放款
    ,o.rstuserfield13 -- 用途类型
    ,o.rstuserfield14 -- 客户号
    ,o.rstuserfield15 -- 送审时方案
    ,o.rstuserfield16 -- 审批额度到期日
    ,o.rstuserfield17 -- 备用字段17
    ,o.rstuserfield18 -- 备用字段18
    ,o.rstuserfield19 -- 备用字段19
    ,o.rstuserfield20 -- 备用字段20
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
from ${iol_schema}.icms_report_ds_approval_flow_bk o
    left join ${iol_schema}.icms_report_ds_approval_flow_op n
        on
            o.bizno = n.bizno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_report_ds_approval_flow_cl d
        on
            o.bizno = d.bizno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_report_ds_approval_flow;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_report_ds_approval_flow') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_report_ds_approval_flow drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_report_ds_approval_flow add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_report_ds_approval_flow exchange partition p_${batch_date} with table ${iol_schema}.icms_report_ds_approval_flow_cl;
alter table ${iol_schema}.icms_report_ds_approval_flow exchange partition p_20991231 with table ${iol_schema}.icms_report_ds_approval_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_report_ds_approval_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_report_ds_approval_flow_op purge;
drop table ${iol_schema}.icms_report_ds_approval_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_report_ds_approval_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_report_ds_approval_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
