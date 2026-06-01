/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_debttransfer_contract
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
create table ${iol_schema}.icms_ap_debttransfer_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_debttransfer_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_debttransfer_contract_op purge;
drop table ${iol_schema}.icms_ap_debttransfer_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_debttransfer_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_debttransfer_contract where 0=1;

create table ${iol_schema}.icms_ap_debttransfer_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_debttransfer_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_debttransfer_contract_cl(
            debttransferno -- 记录编号
            ,tmsp -- 时间戳
            ,fileno -- 影像平台编号
            ,guarantyid -- 抵债资产编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,buyer -- 买受人
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标志
            ,planno -- 处置内容编号
            ,remark -- 备注
            ,guarantyname -- 抵债资产名称
            ,inputorgid -- 登记机构
            ,contractno -- 协议编号
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,evalvalue -- 评估价值
            ,guarantysum -- 抵债金额
            ,signdate -- 转让协议签订日期
            ,transferprice -- 转让价格
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_debttransfer_contract_op(
            debttransferno -- 记录编号
            ,tmsp -- 时间戳
            ,fileno -- 影像平台编号
            ,guarantyid -- 抵债资产编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,buyer -- 买受人
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标志
            ,planno -- 处置内容编号
            ,remark -- 备注
            ,guarantyname -- 抵债资产名称
            ,inputorgid -- 登记机构
            ,contractno -- 协议编号
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,evalvalue -- 评估价值
            ,guarantysum -- 抵债金额
            ,signdate -- 转让协议签订日期
            ,transferprice -- 转让价格
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.debttransferno, o.debttransferno) as debttransferno -- 记录编号
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.guarantyid, o.guarantyid) as guarantyid -- 抵债资产编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.buyer, o.buyer) as buyer -- 买受人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.planno, o.planno) as planno -- 处置内容编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.guarantyname, o.guarantyname) as guarantyname -- 抵债资产名称
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.contractno, o.contractno) as contractno -- 协议编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.evalvalue, o.evalvalue) as evalvalue -- 评估价值
    ,nvl(n.guarantysum, o.guarantysum) as guarantysum -- 抵债金额
    ,nvl(n.signdate, o.signdate) as signdate -- 转让协议签订日期
    ,nvl(n.transferprice, o.transferprice) as transferprice -- 转让价格
    ,case when
            n.debttransferno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.debttransferno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.debttransferno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_debttransfer_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_debttransfer_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.debttransferno = n.debttransferno
where (
        o.debttransferno is null
    )
    or (
        n.debttransferno is null
    )
    or (
        o.tmsp <> n.tmsp
        or o.fileno <> n.fileno
        or o.guarantyid <> n.guarantyid
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.buyer <> n.buyer
        or o.inputdate <> n.inputdate
        or o.deleteflag <> n.deleteflag
        or o.planno <> n.planno
        or o.remark <> n.remark
        or o.guarantyname <> n.guarantyname
        or o.inputorgid <> n.inputorgid
        or o.contractno <> n.contractno
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.evalvalue <> n.evalvalue
        or o.guarantysum <> n.guarantysum
        or o.signdate <> n.signdate
        or o.transferprice <> n.transferprice
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_debttransfer_contract_cl(
            debttransferno -- 记录编号
            ,tmsp -- 时间戳
            ,fileno -- 影像平台编号
            ,guarantyid -- 抵债资产编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,buyer -- 买受人
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标志
            ,planno -- 处置内容编号
            ,remark -- 备注
            ,guarantyname -- 抵债资产名称
            ,inputorgid -- 登记机构
            ,contractno -- 协议编号
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,evalvalue -- 评估价值
            ,guarantysum -- 抵债金额
            ,signdate -- 转让协议签订日期
            ,transferprice -- 转让价格
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_debttransfer_contract_op(
            debttransferno -- 记录编号
            ,tmsp -- 时间戳
            ,fileno -- 影像平台编号
            ,guarantyid -- 抵债资产编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,buyer -- 买受人
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标志
            ,planno -- 处置内容编号
            ,remark -- 备注
            ,guarantyname -- 抵债资产名称
            ,inputorgid -- 登记机构
            ,contractno -- 协议编号
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,evalvalue -- 评估价值
            ,guarantysum -- 抵债金额
            ,signdate -- 转让协议签订日期
            ,transferprice -- 转让价格
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.debttransferno -- 记录编号
    ,o.tmsp -- 时间戳
    ,o.fileno -- 影像平台编号
    ,o.guarantyid -- 抵债资产编号
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.buyer -- 买受人
    ,o.inputdate -- 登记日期
    ,o.deleteflag -- 删除标志
    ,o.planno -- 处置内容编号
    ,o.remark -- 备注
    ,o.guarantyname -- 抵债资产名称
    ,o.inputorgid -- 登记机构
    ,o.contractno -- 协议编号
    ,o.inputuserid -- 登记人
    ,o.updatedate -- 更新日期
    ,o.evalvalue -- 评估价值
    ,o.guarantysum -- 抵债金额
    ,o.signdate -- 转让协议签订日期
    ,o.transferprice -- 转让价格
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
from ${iol_schema}.icms_ap_debttransfer_contract_bk o
    left join ${iol_schema}.icms_ap_debttransfer_contract_op n
        on
            o.debttransferno = n.debttransferno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_debttransfer_contract_cl d
        on
            o.debttransferno = d.debttransferno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_debttransfer_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_debttransfer_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_debttransfer_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_debttransfer_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_debttransfer_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_debttransfer_contract_cl;
alter table ${iol_schema}.icms_ap_debttransfer_contract exchange partition p_20991231 with table ${iol_schema}.icms_ap_debttransfer_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_debttransfer_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_debttransfer_contract_op purge;
drop table ${iol_schema}.icms_ap_debttransfer_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_debttransfer_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_debttransfer_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
