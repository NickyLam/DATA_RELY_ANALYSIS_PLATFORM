/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_guaranty_verify
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
create table ${iol_schema}.icms_ap_guaranty_verify_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_guaranty_verify
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_guaranty_verify_op purge;
drop table ${iol_schema}.icms_ap_guaranty_verify_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_guaranty_verify_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_guaranty_verify where 0=1;

create table ${iol_schema}.icms_ap_guaranty_verify_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_guaranty_verify where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_guaranty_verify_cl(
            recordno -- 记录编号
            ,verifier -- 抵债资产核实人
            ,inputuserid -- 登记人
            ,plandetailno -- 收取抵债资产明细编号
            ,deleteflag -- 删除标识
            ,buildingdate -- 建成日期
            ,image -- 相关影像资料
            ,rightid -- 权证号
            ,landtype -- 用地性质
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,scale -- 面积
            ,buildingstructure -- 建筑结构
            ,updateorgid -- 更新机构
            ,treatystatus -- 协议抵债日资产状态
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,location -- 抵债资产地址
            ,decisionstatus -- 裁定抵债日资产状态
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_guaranty_verify_op(
            recordno -- 记录编号
            ,verifier -- 抵债资产核实人
            ,inputuserid -- 登记人
            ,plandetailno -- 收取抵债资产明细编号
            ,deleteflag -- 删除标识
            ,buildingdate -- 建成日期
            ,image -- 相关影像资料
            ,rightid -- 权证号
            ,landtype -- 用地性质
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,scale -- 面积
            ,buildingstructure -- 建筑结构
            ,updateorgid -- 更新机构
            ,treatystatus -- 协议抵债日资产状态
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,location -- 抵债资产地址
            ,decisionstatus -- 裁定抵债日资产状态
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.recordno, o.recordno) as recordno -- 记录编号
    ,nvl(n.verifier, o.verifier) as verifier -- 抵债资产核实人
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.plandetailno, o.plandetailno) as plandetailno -- 收取抵债资产明细编号
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标识
    ,nvl(n.buildingdate, o.buildingdate) as buildingdate -- 建成日期
    ,nvl(n.image, o.image) as image -- 相关影像资料
    ,nvl(n.rightid, o.rightid) as rightid -- 权证号
    ,nvl(n.landtype, o.landtype) as landtype -- 用地性质
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.scale, o.scale) as scale -- 面积
    ,nvl(n.buildingstructure, o.buildingstructure) as buildingstructure -- 建筑结构
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.treatystatus, o.treatystatus) as treatystatus -- 协议抵债日资产状态
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.location, o.location) as location -- 抵债资产地址
    ,nvl(n.decisionstatus, o.decisionstatus) as decisionstatus -- 裁定抵债日资产状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.recordno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.recordno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.recordno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_guaranty_verify_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_guaranty_verify where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.recordno = n.recordno
where (
        o.recordno is null
    )
    or (
        n.recordno is null
    )
    or (
        o.verifier <> n.verifier
        or o.inputuserid <> n.inputuserid
        or o.plandetailno <> n.plandetailno
        or o.deleteflag <> n.deleteflag
        or o.buildingdate <> n.buildingdate
        or o.image <> n.image
        or o.rightid <> n.rightid
        or o.landtype <> n.landtype
        or o.inputorgid <> n.inputorgid
        or o.updateuserid <> n.updateuserid
        or o.scale <> n.scale
        or o.buildingstructure <> n.buildingstructure
        or o.updateorgid <> n.updateorgid
        or o.treatystatus <> n.treatystatus
        or o.updatedate <> n.updatedate
        or o.inputdate <> n.inputdate
        or o.location <> n.location
        or o.decisionstatus <> n.decisionstatus
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_guaranty_verify_cl(
            recordno -- 记录编号
            ,verifier -- 抵债资产核实人
            ,inputuserid -- 登记人
            ,plandetailno -- 收取抵债资产明细编号
            ,deleteflag -- 删除标识
            ,buildingdate -- 建成日期
            ,image -- 相关影像资料
            ,rightid -- 权证号
            ,landtype -- 用地性质
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,scale -- 面积
            ,buildingstructure -- 建筑结构
            ,updateorgid -- 更新机构
            ,treatystatus -- 协议抵债日资产状态
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,location -- 抵债资产地址
            ,decisionstatus -- 裁定抵债日资产状态
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_guaranty_verify_op(
            recordno -- 记录编号
            ,verifier -- 抵债资产核实人
            ,inputuserid -- 登记人
            ,plandetailno -- 收取抵债资产明细编号
            ,deleteflag -- 删除标识
            ,buildingdate -- 建成日期
            ,image -- 相关影像资料
            ,rightid -- 权证号
            ,landtype -- 用地性质
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,scale -- 面积
            ,buildingstructure -- 建筑结构
            ,updateorgid -- 更新机构
            ,treatystatus -- 协议抵债日资产状态
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,location -- 抵债资产地址
            ,decisionstatus -- 裁定抵债日资产状态
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.recordno -- 记录编号
    ,o.verifier -- 抵债资产核实人
    ,o.inputuserid -- 登记人
    ,o.plandetailno -- 收取抵债资产明细编号
    ,o.deleteflag -- 删除标识
    ,o.buildingdate -- 建成日期
    ,o.image -- 相关影像资料
    ,o.rightid -- 权证号
    ,o.landtype -- 用地性质
    ,o.inputorgid -- 登记机构
    ,o.updateuserid -- 更新人
    ,o.scale -- 面积
    ,o.buildingstructure -- 建筑结构
    ,o.updateorgid -- 更新机构
    ,o.treatystatus -- 协议抵债日资产状态
    ,o.updatedate -- 更新日期
    ,o.inputdate -- 登记日期
    ,o.location -- 抵债资产地址
    ,o.decisionstatus -- 裁定抵债日资产状态
    ,o.remark -- 备注
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
from ${iol_schema}.icms_ap_guaranty_verify_bk o
    left join ${iol_schema}.icms_ap_guaranty_verify_op n
        on
            o.recordno = n.recordno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_guaranty_verify_cl d
        on
            o.recordno = d.recordno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_guaranty_verify;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_guaranty_verify') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_guaranty_verify drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_guaranty_verify add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_guaranty_verify exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_guaranty_verify_cl;
alter table ${iol_schema}.icms_ap_guaranty_verify exchange partition p_20991231 with table ${iol_schema}.icms_ap_guaranty_verify_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_guaranty_verify to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_guaranty_verify_op purge;
drop table ${iol_schema}.icms_ap_guaranty_verify_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_guaranty_verify_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_guaranty_verify',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
