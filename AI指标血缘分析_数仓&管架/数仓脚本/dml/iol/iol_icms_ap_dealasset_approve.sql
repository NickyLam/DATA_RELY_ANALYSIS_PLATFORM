/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_dealasset_approve
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
create table ${iol_schema}.icms_ap_dealasset_approve_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_dealasset_approve
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_dealasset_approve_op purge;
drop table ${iol_schema}.icms_ap_dealasset_approve_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_dealasset_approve_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_dealasset_approve where 0=1;

create table ${iol_schema}.icms_ap_dealasset_approve_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_dealasset_approve where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_dealasset_approve_cl(
            serialno -- 流水号
            ,assetsource -- 抵债资产来源
            ,landtype -- 用地性质
            ,guarantyrightname -- 抵债资产权证名称
            ,buildingdate -- 建成日期
            ,programname -- 方案名称
            ,evalorgid -- 评估机构
            ,guarantylocation -- 抵债资产地址
            ,totalbalance -- 合同余额合计
            ,inputorgid -- 登记机构
            ,approvereport -- 抵债资产处置审批书
            ,ownertax -- 买方应承担税费
            ,updatedate -- 更新日期
            ,guarantyscale -- 抵债资产面积
            ,evalvalue -- 评估价值
            ,updateorgid -- 更新机构
            ,assetspayway -- 抵债方式
            ,guarantytype -- 抵债物类型
            ,banktax -- 我行过户应承担税费
            ,ownername -- 抵债资产所有权人名称
            ,deleteflag -- 删除标识
            ,programno -- 方案编号
            ,ownerid -- 抵债资产所有权人
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,approveno -- 批复编号
            ,inputdate -- 登记日期
            ,guarantyname -- 抵债资产名称
            ,guarantyrightid -- 抵债资产权证号
            ,handletype -- 处置类型
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,guarantyid -- 抵债资产编号
            ,buildingstructure -- 建筑结构
            ,applyreport -- 抵债资产处置申请报告
            ,guarantycondition -- 抵债资产现状
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_dealasset_approve_op(
            serialno -- 流水号
            ,assetsource -- 抵债资产来源
            ,landtype -- 用地性质
            ,guarantyrightname -- 抵债资产权证名称
            ,buildingdate -- 建成日期
            ,programname -- 方案名称
            ,evalorgid -- 评估机构
            ,guarantylocation -- 抵债资产地址
            ,totalbalance -- 合同余额合计
            ,inputorgid -- 登记机构
            ,approvereport -- 抵债资产处置审批书
            ,ownertax -- 买方应承担税费
            ,updatedate -- 更新日期
            ,guarantyscale -- 抵债资产面积
            ,evalvalue -- 评估价值
            ,updateorgid -- 更新机构
            ,assetspayway -- 抵债方式
            ,guarantytype -- 抵债物类型
            ,banktax -- 我行过户应承担税费
            ,ownername -- 抵债资产所有权人名称
            ,deleteflag -- 删除标识
            ,programno -- 方案编号
            ,ownerid -- 抵债资产所有权人
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,approveno -- 批复编号
            ,inputdate -- 登记日期
            ,guarantyname -- 抵债资产名称
            ,guarantyrightid -- 抵债资产权证号
            ,handletype -- 处置类型
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,guarantyid -- 抵债资产编号
            ,buildingstructure -- 建筑结构
            ,applyreport -- 抵债资产处置申请报告
            ,guarantycondition -- 抵债资产现状
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.assetsource, o.assetsource) as assetsource -- 抵债资产来源
    ,nvl(n.landtype, o.landtype) as landtype -- 用地性质
    ,nvl(n.guarantyrightname, o.guarantyrightname) as guarantyrightname -- 抵债资产权证名称
    ,nvl(n.buildingdate, o.buildingdate) as buildingdate -- 建成日期
    ,nvl(n.programname, o.programname) as programname -- 方案名称
    ,nvl(n.evalorgid, o.evalorgid) as evalorgid -- 评估机构
    ,nvl(n.guarantylocation, o.guarantylocation) as guarantylocation -- 抵债资产地址
    ,nvl(n.totalbalance, o.totalbalance) as totalbalance -- 合同余额合计
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.approvereport, o.approvereport) as approvereport -- 抵债资产处置审批书
    ,nvl(n.ownertax, o.ownertax) as ownertax -- 买方应承担税费
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.guarantyscale, o.guarantyscale) as guarantyscale -- 抵债资产面积
    ,nvl(n.evalvalue, o.evalvalue) as evalvalue -- 评估价值
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.assetspayway, o.assetspayway) as assetspayway -- 抵债方式
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 抵债物类型
    ,nvl(n.banktax, o.banktax) as banktax -- 我行过户应承担税费
    ,nvl(n.ownername, o.ownername) as ownername -- 抵债资产所有权人名称
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标识
    ,nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.ownerid, o.ownerid) as ownerid -- 抵债资产所有权人
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.approveno, o.approveno) as approveno -- 批复编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.guarantyname, o.guarantyname) as guarantyname -- 抵债资产名称
    ,nvl(n.guarantyrightid, o.guarantyrightid) as guarantyrightid -- 抵债资产权证号
    ,nvl(n.handletype, o.handletype) as handletype -- 处置类型
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.guarantyid, o.guarantyid) as guarantyid -- 抵债资产编号
    ,nvl(n.buildingstructure, o.buildingstructure) as buildingstructure -- 建筑结构
    ,nvl(n.applyreport, o.applyreport) as applyreport -- 抵债资产处置申请报告
    ,nvl(n.guarantycondition, o.guarantycondition) as guarantycondition -- 抵债资产现状
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
from (select * from ${iol_schema}.icms_ap_dealasset_approve_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_dealasset_approve where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.assetsource <> n.assetsource
        or o.landtype <> n.landtype
        or o.guarantyrightname <> n.guarantyrightname
        or o.buildingdate <> n.buildingdate
        or o.programname <> n.programname
        or o.evalorgid <> n.evalorgid
        or o.guarantylocation <> n.guarantylocation
        or o.totalbalance <> n.totalbalance
        or o.inputorgid <> n.inputorgid
        or o.approvereport <> n.approvereport
        or o.ownertax <> n.ownertax
        or o.updatedate <> n.updatedate
        or o.guarantyscale <> n.guarantyscale
        or o.evalvalue <> n.evalvalue
        or o.updateorgid <> n.updateorgid
        or o.assetspayway <> n.assetspayway
        or o.guarantytype <> n.guarantytype
        or o.banktax <> n.banktax
        or o.ownername <> n.ownername
        or o.deleteflag <> n.deleteflag
        or o.programno <> n.programno
        or o.ownerid <> n.ownerid
        or o.inputuserid <> n.inputuserid
        or o.updateuserid <> n.updateuserid
        or o.approveno <> n.approveno
        or o.inputdate <> n.inputdate
        or o.guarantyname <> n.guarantyname
        or o.guarantyrightid <> n.guarantyrightid
        or o.handletype <> n.handletype
        or o.approvestatus <> n.approvestatus
        or o.remark <> n.remark
        or o.guarantyid <> n.guarantyid
        or o.buildingstructure <> n.buildingstructure
        or o.applyreport <> n.applyreport
        or o.guarantycondition <> n.guarantycondition
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_dealasset_approve_cl(
            serialno -- 流水号
            ,assetsource -- 抵债资产来源
            ,landtype -- 用地性质
            ,guarantyrightname -- 抵债资产权证名称
            ,buildingdate -- 建成日期
            ,programname -- 方案名称
            ,evalorgid -- 评估机构
            ,guarantylocation -- 抵债资产地址
            ,totalbalance -- 合同余额合计
            ,inputorgid -- 登记机构
            ,approvereport -- 抵债资产处置审批书
            ,ownertax -- 买方应承担税费
            ,updatedate -- 更新日期
            ,guarantyscale -- 抵债资产面积
            ,evalvalue -- 评估价值
            ,updateorgid -- 更新机构
            ,assetspayway -- 抵债方式
            ,guarantytype -- 抵债物类型
            ,banktax -- 我行过户应承担税费
            ,ownername -- 抵债资产所有权人名称
            ,deleteflag -- 删除标识
            ,programno -- 方案编号
            ,ownerid -- 抵债资产所有权人
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,approveno -- 批复编号
            ,inputdate -- 登记日期
            ,guarantyname -- 抵债资产名称
            ,guarantyrightid -- 抵债资产权证号
            ,handletype -- 处置类型
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,guarantyid -- 抵债资产编号
            ,buildingstructure -- 建筑结构
            ,applyreport -- 抵债资产处置申请报告
            ,guarantycondition -- 抵债资产现状
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_dealasset_approve_op(
            serialno -- 流水号
            ,assetsource -- 抵债资产来源
            ,landtype -- 用地性质
            ,guarantyrightname -- 抵债资产权证名称
            ,buildingdate -- 建成日期
            ,programname -- 方案名称
            ,evalorgid -- 评估机构
            ,guarantylocation -- 抵债资产地址
            ,totalbalance -- 合同余额合计
            ,inputorgid -- 登记机构
            ,approvereport -- 抵债资产处置审批书
            ,ownertax -- 买方应承担税费
            ,updatedate -- 更新日期
            ,guarantyscale -- 抵债资产面积
            ,evalvalue -- 评估价值
            ,updateorgid -- 更新机构
            ,assetspayway -- 抵债方式
            ,guarantytype -- 抵债物类型
            ,banktax -- 我行过户应承担税费
            ,ownername -- 抵债资产所有权人名称
            ,deleteflag -- 删除标识
            ,programno -- 方案编号
            ,ownerid -- 抵债资产所有权人
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,approveno -- 批复编号
            ,inputdate -- 登记日期
            ,guarantyname -- 抵债资产名称
            ,guarantyrightid -- 抵债资产权证号
            ,handletype -- 处置类型
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,guarantyid -- 抵债资产编号
            ,buildingstructure -- 建筑结构
            ,applyreport -- 抵债资产处置申请报告
            ,guarantycondition -- 抵债资产现状
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.assetsource -- 抵债资产来源
    ,o.landtype -- 用地性质
    ,o.guarantyrightname -- 抵债资产权证名称
    ,o.buildingdate -- 建成日期
    ,o.programname -- 方案名称
    ,o.evalorgid -- 评估机构
    ,o.guarantylocation -- 抵债资产地址
    ,o.totalbalance -- 合同余额合计
    ,o.inputorgid -- 登记机构
    ,o.approvereport -- 抵债资产处置审批书
    ,o.ownertax -- 买方应承担税费
    ,o.updatedate -- 更新日期
    ,o.guarantyscale -- 抵债资产面积
    ,o.evalvalue -- 评估价值
    ,o.updateorgid -- 更新机构
    ,o.assetspayway -- 抵债方式
    ,o.guarantytype -- 抵债物类型
    ,o.banktax -- 我行过户应承担税费
    ,o.ownername -- 抵债资产所有权人名称
    ,o.deleteflag -- 删除标识
    ,o.programno -- 方案编号
    ,o.ownerid -- 抵债资产所有权人
    ,o.inputuserid -- 登记人
    ,o.updateuserid -- 更新人
    ,o.approveno -- 批复编号
    ,o.inputdate -- 登记日期
    ,o.guarantyname -- 抵债资产名称
    ,o.guarantyrightid -- 抵债资产权证号
    ,o.handletype -- 处置类型
    ,o.approvestatus -- 审批状态
    ,o.remark -- 备注
    ,o.guarantyid -- 抵债资产编号
    ,o.buildingstructure -- 建筑结构
    ,o.applyreport -- 抵债资产处置申请报告
    ,o.guarantycondition -- 抵债资产现状
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
from ${iol_schema}.icms_ap_dealasset_approve_bk o
    left join ${iol_schema}.icms_ap_dealasset_approve_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_dealasset_approve_cl d
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
--truncate table ${iol_schema}.icms_ap_dealasset_approve;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_dealasset_approve') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_dealasset_approve drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_dealasset_approve add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_dealasset_approve exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_dealasset_approve_cl;
alter table ${iol_schema}.icms_ap_dealasset_approve exchange partition p_20991231 with table ${iol_schema}.icms_ap_dealasset_approve_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_dealasset_approve to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_dealasset_approve_op purge;
drop table ${iol_schema}.icms_ap_dealasset_approve_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_dealasset_approve_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_dealasset_approve',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
