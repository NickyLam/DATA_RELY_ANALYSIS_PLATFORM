/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_case_program
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
create table ${iol_schema}.icms_ap_case_program_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_case_program
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_case_program_op purge;
drop table ${iol_schema}.icms_ap_case_program_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_case_program_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_case_program where 0=1;

create table ${iol_schema}.icms_ap_case_program_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_case_program where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_case_program_cl(
            programno -- 方案编号
            ,inputdate -- 登记日期
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,agencytype -- 代理类型
            ,agencostsum -- 代理费用总额
            ,bankposition -- 我行地位
            ,methodtype -- 方案类型
            ,tmsp -- 时间戳
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,fileno -- 影像平台编号
            ,agencostpaydesc -- 代理费用支付说明
            ,caseno -- 案件项目编号
            ,agencyteam -- 代理团队
            ,agencostpayway -- 代理费用支付方式
            ,acceptunitname -- 受理单位名称
            ,lawfirmdesc -- 拟聘律师事务所简要情况
            ,lawfirmid -- 律所编号
            ,programserno -- 方案流水号
            ,deleteflag -- 删除标识
            ,lawfirmname -- 律所名称
            ,programname -- 方案名称
            ,lawyername -- 代理律师
            ,updateuserid -- 更新人编号
            ,casename -- 案件项目名称
            ,casedesc -- 案例情况详细说明及疑难点
            ,suitrequest -- 诉讼请求
            ,suitthink -- 诉讼思路
            ,caseprogramstage -- 程序阶段
            ,inputorgid -- 登记机构名称编号
            ,updateorgid -- 更新机构
            ,acceptunitid -- 受理单位编号
            ,selectiontime -- 选聘时间
            ,reportflag -- 是否上报总行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_case_program_op(
            programno -- 方案编号
            ,inputdate -- 登记日期
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,agencytype -- 代理类型
            ,agencostsum -- 代理费用总额
            ,bankposition -- 我行地位
            ,methodtype -- 方案类型
            ,tmsp -- 时间戳
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,fileno -- 影像平台编号
            ,agencostpaydesc -- 代理费用支付说明
            ,caseno -- 案件项目编号
            ,agencyteam -- 代理团队
            ,agencostpayway -- 代理费用支付方式
            ,acceptunitname -- 受理单位名称
            ,lawfirmdesc -- 拟聘律师事务所简要情况
            ,lawfirmid -- 律所编号
            ,programserno -- 方案流水号
            ,deleteflag -- 删除标识
            ,lawfirmname -- 律所名称
            ,programname -- 方案名称
            ,lawyername -- 代理律师
            ,updateuserid -- 更新人编号
            ,casename -- 案件项目名称
            ,casedesc -- 案例情况详细说明及疑难点
            ,suitrequest -- 诉讼请求
            ,suitthink -- 诉讼思路
            ,caseprogramstage -- 程序阶段
            ,inputorgid -- 登记机构名称编号
            ,updateorgid -- 更新机构
            ,acceptunitid -- 受理单位编号
            ,selectiontime -- 选聘时间
            ,reportflag -- 是否上报总行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.agencytype, o.agencytype) as agencytype -- 代理类型
    ,nvl(n.agencostsum, o.agencostsum) as agencostsum -- 代理费用总额
    ,nvl(n.bankposition, o.bankposition) as bankposition -- 我行地位
    ,nvl(n.methodtype, o.methodtype) as methodtype -- 方案类型
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.agencostpaydesc, o.agencostpaydesc) as agencostpaydesc -- 代理费用支付说明
    ,nvl(n.caseno, o.caseno) as caseno -- 案件项目编号
    ,nvl(n.agencyteam, o.agencyteam) as agencyteam -- 代理团队
    ,nvl(n.agencostpayway, o.agencostpayway) as agencostpayway -- 代理费用支付方式
    ,nvl(n.acceptunitname, o.acceptunitname) as acceptunitname -- 受理单位名称
    ,nvl(n.lawfirmdesc, o.lawfirmdesc) as lawfirmdesc -- 拟聘律师事务所简要情况
    ,nvl(n.lawfirmid, o.lawfirmid) as lawfirmid -- 律所编号
    ,nvl(n.programserno, o.programserno) as programserno -- 方案流水号
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标识
    ,nvl(n.lawfirmname, o.lawfirmname) as lawfirmname -- 律所名称
    ,nvl(n.programname, o.programname) as programname -- 方案名称
    ,nvl(n.lawyername, o.lawyername) as lawyername -- 代理律师
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.casename, o.casename) as casename -- 案件项目名称
    ,nvl(n.casedesc, o.casedesc) as casedesc -- 案例情况详细说明及疑难点
    ,nvl(n.suitrequest, o.suitrequest) as suitrequest -- 诉讼请求
    ,nvl(n.suitthink, o.suitthink) as suitthink -- 诉讼思路
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 程序阶段
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构名称编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.acceptunitid, o.acceptunitid) as acceptunitid -- 受理单位编号
    ,nvl(n.selectiontime, o.selectiontime) as selectiontime -- 选聘时间
    ,nvl(n.reportflag, o.reportflag) as reportflag -- 是否上报总行
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
from (select * from ${iol_schema}.icms_ap_case_program_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_case_program where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.programno = n.programno
where (
        o.programno is null
    )
    or (
        n.programno is null
    )
    or (
        o.inputdate <> n.inputdate
        or o.approvestatus <> n.approvestatus
        or o.remark <> n.remark
        or o.agencytype <> n.agencytype
        or o.agencostsum <> n.agencostsum
        or o.bankposition <> n.bankposition
        or o.methodtype <> n.methodtype
        or o.tmsp <> n.tmsp
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.fileno <> n.fileno
        or o.agencostpaydesc <> n.agencostpaydesc
        or o.caseno <> n.caseno
        or o.agencyteam <> n.agencyteam
        or o.agencostpayway <> n.agencostpayway
        or o.acceptunitname <> n.acceptunitname
        or o.lawfirmdesc <> n.lawfirmdesc
        or o.lawfirmid <> n.lawfirmid
        or o.programserno <> n.programserno
        or o.deleteflag <> n.deleteflag
        or o.lawfirmname <> n.lawfirmname
        or o.programname <> n.programname
        or o.lawyername <> n.lawyername
        or o.updateuserid <> n.updateuserid
        or o.casename <> n.casename
        or o.casedesc <> n.casedesc
        or o.suitrequest <> n.suitrequest
        or o.suitthink <> n.suitthink
        or o.caseprogramstage <> n.caseprogramstage
        or o.inputorgid <> n.inputorgid
        or o.updateorgid <> n.updateorgid
        or o.acceptunitid <> n.acceptunitid
        or o.selectiontime <> n.selectiontime
        or o.reportflag <> n.reportflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_case_program_cl(
            programno -- 方案编号
            ,inputdate -- 登记日期
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,agencytype -- 代理类型
            ,agencostsum -- 代理费用总额
            ,bankposition -- 我行地位
            ,methodtype -- 方案类型
            ,tmsp -- 时间戳
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,fileno -- 影像平台编号
            ,agencostpaydesc -- 代理费用支付说明
            ,caseno -- 案件项目编号
            ,agencyteam -- 代理团队
            ,agencostpayway -- 代理费用支付方式
            ,acceptunitname -- 受理单位名称
            ,lawfirmdesc -- 拟聘律师事务所简要情况
            ,lawfirmid -- 律所编号
            ,programserno -- 方案流水号
            ,deleteflag -- 删除标识
            ,lawfirmname -- 律所名称
            ,programname -- 方案名称
            ,lawyername -- 代理律师
            ,updateuserid -- 更新人编号
            ,casename -- 案件项目名称
            ,casedesc -- 案例情况详细说明及疑难点
            ,suitrequest -- 诉讼请求
            ,suitthink -- 诉讼思路
            ,caseprogramstage -- 程序阶段
            ,inputorgid -- 登记机构名称编号
            ,updateorgid -- 更新机构
            ,acceptunitid -- 受理单位编号
            ,selectiontime -- 选聘时间
            ,reportflag -- 是否上报总行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_case_program_op(
            programno -- 方案编号
            ,inputdate -- 登记日期
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,agencytype -- 代理类型
            ,agencostsum -- 代理费用总额
            ,bankposition -- 我行地位
            ,methodtype -- 方案类型
            ,tmsp -- 时间戳
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,fileno -- 影像平台编号
            ,agencostpaydesc -- 代理费用支付说明
            ,caseno -- 案件项目编号
            ,agencyteam -- 代理团队
            ,agencostpayway -- 代理费用支付方式
            ,acceptunitname -- 受理单位名称
            ,lawfirmdesc -- 拟聘律师事务所简要情况
            ,lawfirmid -- 律所编号
            ,programserno -- 方案流水号
            ,deleteflag -- 删除标识
            ,lawfirmname -- 律所名称
            ,programname -- 方案名称
            ,lawyername -- 代理律师
            ,updateuserid -- 更新人编号
            ,casename -- 案件项目名称
            ,casedesc -- 案例情况详细说明及疑难点
            ,suitrequest -- 诉讼请求
            ,suitthink -- 诉讼思路
            ,caseprogramstage -- 程序阶段
            ,inputorgid -- 登记机构名称编号
            ,updateorgid -- 更新机构
            ,acceptunitid -- 受理单位编号
            ,selectiontime -- 选聘时间
            ,reportflag -- 是否上报总行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.programno -- 方案编号
    ,o.inputdate -- 登记日期
    ,o.approvestatus -- 审批状态
    ,o.remark -- 备注
    ,o.agencytype -- 代理类型
    ,o.agencostsum -- 代理费用总额
    ,o.bankposition -- 我行地位
    ,o.methodtype -- 方案类型
    ,o.tmsp -- 时间戳
    ,o.inputuserid -- 登记人编号
    ,o.updatedate -- 更新日期
    ,o.fileno -- 影像平台编号
    ,o.agencostpaydesc -- 代理费用支付说明
    ,o.caseno -- 案件项目编号
    ,o.agencyteam -- 代理团队
    ,o.agencostpayway -- 代理费用支付方式
    ,o.acceptunitname -- 受理单位名称
    ,o.lawfirmdesc -- 拟聘律师事务所简要情况
    ,o.lawfirmid -- 律所编号
    ,o.programserno -- 方案流水号
    ,o.deleteflag -- 删除标识
    ,o.lawfirmname -- 律所名称
    ,o.programname -- 方案名称
    ,o.lawyername -- 代理律师
    ,o.updateuserid -- 更新人编号
    ,o.casename -- 案件项目名称
    ,o.casedesc -- 案例情况详细说明及疑难点
    ,o.suitrequest -- 诉讼请求
    ,o.suitthink -- 诉讼思路
    ,o.caseprogramstage -- 程序阶段
    ,o.inputorgid -- 登记机构名称编号
    ,o.updateorgid -- 更新机构
    ,o.acceptunitid -- 受理单位编号
    ,o.selectiontime -- 选聘时间
    ,o.reportflag -- 是否上报总行
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
from ${iol_schema}.icms_ap_case_program_bk o
    left join ${iol_schema}.icms_ap_case_program_op n
        on
            o.programno = n.programno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_case_program_cl d
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
--truncate table ${iol_schema}.icms_ap_case_program;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_case_program') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_case_program drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_case_program add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_case_program exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_case_program_cl;
alter table ${iol_schema}.icms_ap_case_program exchange partition p_20991231 with table ${iol_schema}.icms_ap_case_program_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_case_program to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_case_program_op purge;
drop table ${iol_schema}.icms_ap_case_program_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_case_program_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_case_program',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
