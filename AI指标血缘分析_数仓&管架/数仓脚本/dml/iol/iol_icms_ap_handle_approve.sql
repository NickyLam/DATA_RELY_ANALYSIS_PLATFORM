/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_handle_approve
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
create table ${iol_schema}.icms_ap_handle_approve_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_handle_approve
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_handle_approve_op purge;
drop table ${iol_schema}.icms_ap_handle_approve_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_handle_approve_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_handle_approve where 0=1;

create table ${iol_schema}.icms_ap_handle_approve_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_handle_approve where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_handle_approve_cl(
            serialno -- 流水号
            ,programno -- 方案编号
            ,riskassetlist -- 风险资产清单
            ,programname -- 方案名称
            ,deleteflag -- 删除标识
            ,approveinputdate -- 批复录入日期
            ,approveuserid -- 批复录入人
            ,approveorgid -- 批复机构
            ,customerid -- 方案涉及借款人编号
            ,certid -- 借款人证件号码
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,branchbank -- 分支行
            ,remark -- 备注
            ,summarize -- 方案综述
            ,approvecontent -- 批复内容
            ,approvestatus -- 审批状态
            ,certtype -- 借款人证件类型
            ,handletype -- 处置类型
            ,inputuserid -- 登记人
            ,customername -- 方案涉及借款人名称
            ,planno -- 处置编号
            ,updateuserid -- 更新人
            ,approveserialno -- 详细批复编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_handle_approve_op(
            serialno -- 流水号
            ,programno -- 方案编号
            ,riskassetlist -- 风险资产清单
            ,programname -- 方案名称
            ,deleteflag -- 删除标识
            ,approveinputdate -- 批复录入日期
            ,approveuserid -- 批复录入人
            ,approveorgid -- 批复机构
            ,customerid -- 方案涉及借款人编号
            ,certid -- 借款人证件号码
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,branchbank -- 分支行
            ,remark -- 备注
            ,summarize -- 方案综述
            ,approvecontent -- 批复内容
            ,approvestatus -- 审批状态
            ,certtype -- 借款人证件类型
            ,handletype -- 处置类型
            ,inputuserid -- 登记人
            ,customername -- 方案涉及借款人名称
            ,planno -- 处置编号
            ,updateuserid -- 更新人
            ,approveserialno -- 详细批复编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.riskassetlist, o.riskassetlist) as riskassetlist -- 风险资产清单
    ,nvl(n.programname, o.programname) as programname -- 方案名称
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标识
    ,nvl(n.approveinputdate, o.approveinputdate) as approveinputdate -- 批复录入日期
    ,nvl(n.approveuserid, o.approveuserid) as approveuserid -- 批复录入人
    ,nvl(n.approveorgid, o.approveorgid) as approveorgid -- 批复机构
    ,nvl(n.customerid, o.customerid) as customerid -- 方案涉及借款人编号
    ,nvl(n.certid, o.certid) as certid -- 借款人证件号码
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.branchbank, o.branchbank) as branchbank -- 分支行
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.summarize, o.summarize) as summarize -- 方案综述
    ,nvl(n.approvecontent, o.approvecontent) as approvecontent -- 批复内容
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.certtype, o.certtype) as certtype -- 借款人证件类型
    ,nvl(n.handletype, o.handletype) as handletype -- 处置类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.customername, o.customername) as customername -- 方案涉及借款人名称
    ,nvl(n.planno, o.planno) as planno -- 处置编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.approveserialno, o.approveserialno) as approveserialno -- 详细批复编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_handle_approve_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_handle_approve where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.programno <> n.programno
        or o.riskassetlist <> n.riskassetlist
        or o.programname <> n.programname
        or o.deleteflag <> n.deleteflag
        or o.approveinputdate <> n.approveinputdate
        or o.approveuserid <> n.approveuserid
        or o.approveorgid <> n.approveorgid
        or o.customerid <> n.customerid
        or o.certid <> n.certid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.branchbank <> n.branchbank
        or o.remark <> n.remark
        or o.summarize <> n.summarize
        or o.approvecontent <> n.approvecontent
        or o.approvestatus <> n.approvestatus
        or o.certtype <> n.certtype
        or o.handletype <> n.handletype
        or o.inputuserid <> n.inputuserid
        or o.customername <> n.customername
        or o.planno <> n.planno
        or o.updateuserid <> n.updateuserid
        or o.approveserialno <> n.approveserialno
        or o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_handle_approve_cl(
            serialno -- 流水号
            ,programno -- 方案编号
            ,riskassetlist -- 风险资产清单
            ,programname -- 方案名称
            ,deleteflag -- 删除标识
            ,approveinputdate -- 批复录入日期
            ,approveuserid -- 批复录入人
            ,approveorgid -- 批复机构
            ,customerid -- 方案涉及借款人编号
            ,certid -- 借款人证件号码
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,branchbank -- 分支行
            ,remark -- 备注
            ,summarize -- 方案综述
            ,approvecontent -- 批复内容
            ,approvestatus -- 审批状态
            ,certtype -- 借款人证件类型
            ,handletype -- 处置类型
            ,inputuserid -- 登记人
            ,customername -- 方案涉及借款人名称
            ,planno -- 处置编号
            ,updateuserid -- 更新人
            ,approveserialno -- 详细批复编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_handle_approve_op(
            serialno -- 流水号
            ,programno -- 方案编号
            ,riskassetlist -- 风险资产清单
            ,programname -- 方案名称
            ,deleteflag -- 删除标识
            ,approveinputdate -- 批复录入日期
            ,approveuserid -- 批复录入人
            ,approveorgid -- 批复机构
            ,customerid -- 方案涉及借款人编号
            ,certid -- 借款人证件号码
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,branchbank -- 分支行
            ,remark -- 备注
            ,summarize -- 方案综述
            ,approvecontent -- 批复内容
            ,approvestatus -- 审批状态
            ,certtype -- 借款人证件类型
            ,handletype -- 处置类型
            ,inputuserid -- 登记人
            ,customername -- 方案涉及借款人名称
            ,planno -- 处置编号
            ,updateuserid -- 更新人
            ,approveserialno -- 详细批复编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.programno -- 方案编号
    ,o.riskassetlist -- 风险资产清单
    ,o.programname -- 方案名称
    ,o.deleteflag -- 删除标识
    ,o.approveinputdate -- 批复录入日期
    ,o.approveuserid -- 批复录入人
    ,o.approveorgid -- 批复机构
    ,o.customerid -- 方案涉及借款人编号
    ,o.certid -- 借款人证件号码
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.branchbank -- 分支行
    ,o.remark -- 备注
    ,o.summarize -- 方案综述
    ,o.approvecontent -- 批复内容
    ,o.approvestatus -- 审批状态
    ,o.certtype -- 借款人证件类型
    ,o.handletype -- 处置类型
    ,o.inputuserid -- 登记人
    ,o.customername -- 方案涉及借款人名称
    ,o.planno -- 处置编号
    ,o.updateuserid -- 更新人
    ,o.approveserialno -- 详细批复编号
    ,o.inputorgid -- 登记机构
    ,o.updatedate -- 更新日期
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
from ${iol_schema}.icms_ap_handle_approve_bk o
    left join ${iol_schema}.icms_ap_handle_approve_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_handle_approve_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_handle_approve;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_handle_approve') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_handle_approve drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_handle_approve add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_handle_approve exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_handle_approve_cl;
alter table ${iol_schema}.icms_ap_handle_approve exchange partition p_20991231 with table ${iol_schema}.icms_ap_handle_approve_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_handle_approve to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_handle_approve_op purge;
drop table ${iol_schema}.icms_ap_handle_approve_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_handle_approve_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_handle_approve',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
