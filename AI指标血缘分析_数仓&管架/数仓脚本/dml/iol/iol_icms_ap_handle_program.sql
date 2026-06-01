/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_handle_program
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
create table ${iol_schema}.icms_ap_handle_program_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_handle_program
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_handle_program_op purge;
drop table ${iol_schema}.icms_ap_handle_program_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_handle_program_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_handle_program where 0=1;

create table ${iol_schema}.icms_ap_handle_program_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_handle_program where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_handle_program_cl(
            programno -- 方案编号
            ,programname -- 方案名称
            ,tmsp -- 
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,deleteflag -- 删除标志
            ,fileno -- 
            ,programkind -- 
            ,assetkind -- 
            ,mainhandletype -- 
            ,handletype -- 
            ,overapproveflag -- 
            ,approveno -- 
            ,approveinputdate -- 
            ,approveuserid -- 
            ,approveorgid -- 
            ,approvestatus -- 审批状态
            ,handleamount -- 处置金额（元）
            ,paybalance -- 
            ,reliefbalance -- 
            ,reliefsum -- 
            ,payonbalinterest -- 
            ,payoutbalinterest -- 
            ,reliefonbalinterest -- 
            ,reliefoutbalinterest -- 
            ,prereliefbalance -- 
            ,preondebitinterest -- 
            ,preoutdebitinterest -- 
            ,branchbank -- 分支行
            ,certtype -- 
            ,certid -- 借款人证件号码
            ,thridcustomer -- 方案涉及第三人
            ,customername -- 方案涉及借款人
            ,customerid -- 方案涉及借款人
            ,riskassetlist -- 风险资产清单
            ,approvecontent -- 
            ,remark -- 备注STRI
            ,summarize -- 方案综述
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_handle_program_op(
            programno -- 方案编号
            ,programname -- 方案名称
            ,tmsp -- 
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,deleteflag -- 删除标志
            ,fileno -- 
            ,programkind -- 
            ,assetkind -- 
            ,mainhandletype -- 
            ,handletype -- 
            ,overapproveflag -- 
            ,approveno -- 
            ,approveinputdate -- 
            ,approveuserid -- 
            ,approveorgid -- 
            ,approvestatus -- 审批状态
            ,handleamount -- 处置金额（元）
            ,paybalance -- 
            ,reliefbalance -- 
            ,reliefsum -- 
            ,payonbalinterest -- 
            ,payoutbalinterest -- 
            ,reliefonbalinterest -- 
            ,reliefoutbalinterest -- 
            ,prereliefbalance -- 
            ,preondebitinterest -- 
            ,preoutdebitinterest -- 
            ,branchbank -- 分支行
            ,certtype -- 
            ,certid -- 借款人证件号码
            ,thridcustomer -- 方案涉及第三人
            ,customername -- 方案涉及借款人
            ,customerid -- 方案涉及借款人
            ,riskassetlist -- 风险资产清单
            ,approvecontent -- 
            ,remark -- 备注STRI
            ,summarize -- 方案综述
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.programname, o.programname) as programname -- 方案名称
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.fileno, o.fileno) as fileno -- 
    ,nvl(n.programkind, o.programkind) as programkind -- 
    ,nvl(n.assetkind, o.assetkind) as assetkind -- 
    ,nvl(n.mainhandletype, o.mainhandletype) as mainhandletype -- 
    ,nvl(n.handletype, o.handletype) as handletype -- 
    ,nvl(n.overapproveflag, o.overapproveflag) as overapproveflag -- 
    ,nvl(n.approveno, o.approveno) as approveno -- 
    ,nvl(n.approveinputdate, o.approveinputdate) as approveinputdate -- 
    ,nvl(n.approveuserid, o.approveuserid) as approveuserid -- 
    ,nvl(n.approveorgid, o.approveorgid) as approveorgid -- 
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.handleamount, o.handleamount) as handleamount -- 处置金额（元）
    ,nvl(n.paybalance, o.paybalance) as paybalance -- 
    ,nvl(n.reliefbalance, o.reliefbalance) as reliefbalance -- 
    ,nvl(n.reliefsum, o.reliefsum) as reliefsum -- 
    ,nvl(n.payonbalinterest, o.payonbalinterest) as payonbalinterest -- 
    ,nvl(n.payoutbalinterest, o.payoutbalinterest) as payoutbalinterest -- 
    ,nvl(n.reliefonbalinterest, o.reliefonbalinterest) as reliefonbalinterest -- 
    ,nvl(n.reliefoutbalinterest, o.reliefoutbalinterest) as reliefoutbalinterest -- 
    ,nvl(n.prereliefbalance, o.prereliefbalance) as prereliefbalance -- 
    ,nvl(n.preondebitinterest, o.preondebitinterest) as preondebitinterest -- 
    ,nvl(n.preoutdebitinterest, o.preoutdebitinterest) as preoutdebitinterest -- 
    ,nvl(n.branchbank, o.branchbank) as branchbank -- 分支行
    ,nvl(n.certtype, o.certtype) as certtype -- 
    ,nvl(n.certid, o.certid) as certid -- 借款人证件号码
    ,nvl(n.thridcustomer, o.thridcustomer) as thridcustomer -- 方案涉及第三人
    ,nvl(n.customername, o.customername) as customername -- 方案涉及借款人
    ,nvl(n.customerid, o.customerid) as customerid -- 方案涉及借款人
    ,nvl(n.riskassetlist, o.riskassetlist) as riskassetlist -- 风险资产清单
    ,nvl(n.approvecontent, o.approvecontent) as approvecontent -- 
    ,nvl(n.remark, o.remark) as remark -- 备注STRI
    ,nvl(n.summarize, o.summarize) as summarize -- 方案综述
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,case when
            n.programno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.programno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.programno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_handle_program_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_handle_program where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.programno = n.programno
where (
        o.programno is null
    )
    or (
        n.programno is null
    )
    or (
        o.programname <> n.programname
        or o.tmsp <> n.tmsp
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.deleteflag <> n.deleteflag
        or o.fileno <> n.fileno
        or o.programkind <> n.programkind
        or o.assetkind <> n.assetkind
        or o.mainhandletype <> n.mainhandletype
        or o.handletype <> n.handletype
        or o.overapproveflag <> n.overapproveflag
        or o.approveno <> n.approveno
        or o.approveinputdate <> n.approveinputdate
        or o.approveuserid <> n.approveuserid
        or o.approveorgid <> n.approveorgid
        or o.approvestatus <> n.approvestatus
        or o.handleamount <> n.handleamount
        or o.paybalance <> n.paybalance
        or o.reliefbalance <> n.reliefbalance
        or o.reliefsum <> n.reliefsum
        or o.payonbalinterest <> n.payonbalinterest
        or o.payoutbalinterest <> n.payoutbalinterest
        or o.reliefonbalinterest <> n.reliefonbalinterest
        or o.reliefoutbalinterest <> n.reliefoutbalinterest
        or o.prereliefbalance <> n.prereliefbalance
        or o.preondebitinterest <> n.preondebitinterest
        or o.preoutdebitinterest <> n.preoutdebitinterest
        or o.branchbank <> n.branchbank
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.thridcustomer <> n.thridcustomer
        or o.customername <> n.customername
        or o.customerid <> n.customerid
        or o.riskassetlist <> n.riskassetlist
        or o.approvecontent <> n.approvecontent
        or o.remark <> n.remark
        or o.summarize <> n.summarize
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_handle_program_cl(
            programno -- 方案编号
            ,programname -- 方案名称
            ,tmsp -- 
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,deleteflag -- 删除标志
            ,fileno -- 
            ,programkind -- 
            ,assetkind -- 
            ,mainhandletype -- 
            ,handletype -- 
            ,overapproveflag -- 
            ,approveno -- 
            ,approveinputdate -- 
            ,approveuserid -- 
            ,approveorgid -- 
            ,approvestatus -- 审批状态
            ,handleamount -- 处置金额（元）
            ,paybalance -- 
            ,reliefbalance -- 
            ,reliefsum -- 
            ,payonbalinterest -- 
            ,payoutbalinterest -- 
            ,reliefonbalinterest -- 
            ,reliefoutbalinterest -- 
            ,prereliefbalance -- 
            ,preondebitinterest -- 
            ,preoutdebitinterest -- 
            ,branchbank -- 分支行
            ,certtype -- 
            ,certid -- 借款人证件号码
            ,thridcustomer -- 方案涉及第三人
            ,customername -- 方案涉及借款人
            ,customerid -- 方案涉及借款人
            ,riskassetlist -- 风险资产清单
            ,approvecontent -- 
            ,remark -- 备注STRI
            ,summarize -- 方案综述
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_handle_program_op(
            programno -- 方案编号
            ,programname -- 方案名称
            ,tmsp -- 
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,deleteflag -- 删除标志
            ,fileno -- 
            ,programkind -- 
            ,assetkind -- 
            ,mainhandletype -- 
            ,handletype -- 
            ,overapproveflag -- 
            ,approveno -- 
            ,approveinputdate -- 
            ,approveuserid -- 
            ,approveorgid -- 
            ,approvestatus -- 审批状态
            ,handleamount -- 处置金额（元）
            ,paybalance -- 
            ,reliefbalance -- 
            ,reliefsum -- 
            ,payonbalinterest -- 
            ,payoutbalinterest -- 
            ,reliefonbalinterest -- 
            ,reliefoutbalinterest -- 
            ,prereliefbalance -- 
            ,preondebitinterest -- 
            ,preoutdebitinterest -- 
            ,branchbank -- 分支行
            ,certtype -- 
            ,certid -- 借款人证件号码
            ,thridcustomer -- 方案涉及第三人
            ,customername -- 方案涉及借款人
            ,customerid -- 方案涉及借款人
            ,riskassetlist -- 风险资产清单
            ,approvecontent -- 
            ,remark -- 备注STRI
            ,summarize -- 方案综述
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.programno -- 方案编号
    ,o.programname -- 方案名称
    ,o.tmsp -- 
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.deleteflag -- 删除标志
    ,o.fileno -- 
    ,o.programkind -- 
    ,o.assetkind -- 
    ,o.mainhandletype -- 
    ,o.handletype -- 
    ,o.overapproveflag -- 
    ,o.approveno -- 
    ,o.approveinputdate -- 
    ,o.approveuserid -- 
    ,o.approveorgid -- 
    ,o.approvestatus -- 审批状态
    ,o.handleamount -- 处置金额（元）
    ,o.paybalance -- 
    ,o.reliefbalance -- 
    ,o.reliefsum -- 
    ,o.payonbalinterest -- 
    ,o.payoutbalinterest -- 
    ,o.reliefonbalinterest -- 
    ,o.reliefoutbalinterest -- 
    ,o.prereliefbalance -- 
    ,o.preondebitinterest -- 
    ,o.preoutdebitinterest -- 
    ,o.branchbank -- 分支行
    ,o.certtype -- 
    ,o.certid -- 借款人证件号码
    ,o.thridcustomer -- 方案涉及第三人
    ,o.customername -- 方案涉及借款人
    ,o.customerid -- 方案涉及借款人
    ,o.riskassetlist -- 风险资产清单
    ,o.approvecontent -- 
    ,o.remark -- 备注STRI
    ,o.summarize -- 方案综述
    ,o.migtflag -- 
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
from ${iol_schema}.icms_ap_handle_program_bk o
    left join ${iol_schema}.icms_ap_handle_program_op n
        on
            o.programno = n.programno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_handle_program_cl d
        on
            o.programno = d.programno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_handle_program;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_handle_program') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_handle_program drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_handle_program add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_handle_program exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_handle_program_cl;
alter table ${iol_schema}.icms_ap_handle_program exchange partition p_20991231 with table ${iol_schema}.icms_ap_handle_program_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_handle_program to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_handle_program_op purge;
drop table ${iol_schema}.icms_ap_handle_program_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_handle_program_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_handle_program',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
