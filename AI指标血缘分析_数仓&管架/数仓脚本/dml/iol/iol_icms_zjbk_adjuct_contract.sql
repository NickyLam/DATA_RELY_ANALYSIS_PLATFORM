/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zjbk_adjuct_contract
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
create table ${iol_schema}.icms_zjbk_adjuct_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_zjbk_adjuct_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_adjuct_contract_op purge;
drop table ${iol_schema}.icms_zjbk_adjuct_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_adjuct_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_adjuct_contract where 0=1;

create table ${iol_schema}.icms_zjbk_adjuct_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_adjuct_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_adjuct_contract_cl(
            serialno -- 流水号
            ,batnum -- 批次号
            ,crdtid -- 授信编号
            ,crdtchn -- 授信渠道
            ,oldcrdtestimatlmt -- 调整前授信预估额度
            ,oldcrdtdayrate -- 调整前授信日利率
            ,oldcrdtyearrate -- 调整前授信年利率
            ,newcrdtestimatlmt -- 调整后授信预估额度
            ,newcrdtdayrate -- 调整后授信日利率
            ,newcrdtyearrate -- 调整后授信年利率
            ,crdtadjtyp -- 授信调整类型
            ,platfspecdataprd -- 平台特色数据产品
            ,reqid -- 请求ID
            ,rspopinion -- 审批意见
            ,rejectreason -- 拒绝意见
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_adjuct_contract_op(
            serialno -- 流水号
            ,batnum -- 批次号
            ,crdtid -- 授信编号
            ,crdtchn -- 授信渠道
            ,oldcrdtestimatlmt -- 调整前授信预估额度
            ,oldcrdtdayrate -- 调整前授信日利率
            ,oldcrdtyearrate -- 调整前授信年利率
            ,newcrdtestimatlmt -- 调整后授信预估额度
            ,newcrdtdayrate -- 调整后授信日利率
            ,newcrdtyearrate -- 调整后授信年利率
            ,crdtadjtyp -- 授信调整类型
            ,platfspecdataprd -- 平台特色数据产品
            ,reqid -- 请求ID
            ,rspopinion -- 审批意见
            ,rejectreason -- 拒绝意见
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.batnum, o.batnum) as batnum -- 批次号
    ,nvl(n.crdtid, o.crdtid) as crdtid -- 授信编号
    ,nvl(n.crdtchn, o.crdtchn) as crdtchn -- 授信渠道
    ,nvl(n.oldcrdtestimatlmt, o.oldcrdtestimatlmt) as oldcrdtestimatlmt -- 调整前授信预估额度
    ,nvl(n.oldcrdtdayrate, o.oldcrdtdayrate) as oldcrdtdayrate -- 调整前授信日利率
    ,nvl(n.oldcrdtyearrate, o.oldcrdtyearrate) as oldcrdtyearrate -- 调整前授信年利率
    ,nvl(n.newcrdtestimatlmt, o.newcrdtestimatlmt) as newcrdtestimatlmt -- 调整后授信预估额度
    ,nvl(n.newcrdtdayrate, o.newcrdtdayrate) as newcrdtdayrate -- 调整后授信日利率
    ,nvl(n.newcrdtyearrate, o.newcrdtyearrate) as newcrdtyearrate -- 调整后授信年利率
    ,nvl(n.crdtadjtyp, o.crdtadjtyp) as crdtadjtyp -- 授信调整类型
    ,nvl(n.platfspecdataprd, o.platfspecdataprd) as platfspecdataprd -- 平台特色数据产品
    ,nvl(n.reqid, o.reqid) as reqid -- 请求ID
    ,nvl(n.rspopinion, o.rspopinion) as rspopinion -- 审批意见
    ,nvl(n.rejectreason, o.rejectreason) as rejectreason -- 拒绝意见
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 录入人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 录入机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,case when
            n.batnum is null
            and n.crdtid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batnum is null
            and n.crdtid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batnum is null
            and n.crdtid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_zjbk_adjuct_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_zjbk_adjuct_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batnum = n.batnum
            and o.crdtid = n.crdtid
where (
        o.batnum is null
        and o.crdtid is null
    )
    or (
        n.batnum is null
        and n.crdtid is null
    )
    or (
        o.serialno <> n.serialno
        or o.crdtchn <> n.crdtchn
        or o.oldcrdtestimatlmt <> n.oldcrdtestimatlmt
        or o.oldcrdtdayrate <> n.oldcrdtdayrate
        or o.oldcrdtyearrate <> n.oldcrdtyearrate
        or o.newcrdtestimatlmt <> n.newcrdtestimatlmt
        or o.newcrdtdayrate <> n.newcrdtdayrate
        or o.newcrdtyearrate <> n.newcrdtyearrate
        or o.crdtadjtyp <> n.crdtadjtyp
        or o.platfspecdataprd <> n.platfspecdataprd
        or o.reqid <> n.reqid
        or o.rspopinion <> n.rspopinion
        or o.rejectreason <> n.rejectreason
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_adjuct_contract_cl(
            serialno -- 流水号
            ,batnum -- 批次号
            ,crdtid -- 授信编号
            ,crdtchn -- 授信渠道
            ,oldcrdtestimatlmt -- 调整前授信预估额度
            ,oldcrdtdayrate -- 调整前授信日利率
            ,oldcrdtyearrate -- 调整前授信年利率
            ,newcrdtestimatlmt -- 调整后授信预估额度
            ,newcrdtdayrate -- 调整后授信日利率
            ,newcrdtyearrate -- 调整后授信年利率
            ,crdtadjtyp -- 授信调整类型
            ,platfspecdataprd -- 平台特色数据产品
            ,reqid -- 请求ID
            ,rspopinion -- 审批意见
            ,rejectreason -- 拒绝意见
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_adjuct_contract_op(
            serialno -- 流水号
            ,batnum -- 批次号
            ,crdtid -- 授信编号
            ,crdtchn -- 授信渠道
            ,oldcrdtestimatlmt -- 调整前授信预估额度
            ,oldcrdtdayrate -- 调整前授信日利率
            ,oldcrdtyearrate -- 调整前授信年利率
            ,newcrdtestimatlmt -- 调整后授信预估额度
            ,newcrdtdayrate -- 调整后授信日利率
            ,newcrdtyearrate -- 调整后授信年利率
            ,crdtadjtyp -- 授信调整类型
            ,platfspecdataprd -- 平台特色数据产品
            ,reqid -- 请求ID
            ,rspopinion -- 审批意见
            ,rejectreason -- 拒绝意见
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.batnum -- 批次号
    ,o.crdtid -- 授信编号
    ,o.crdtchn -- 授信渠道
    ,o.oldcrdtestimatlmt -- 调整前授信预估额度
    ,o.oldcrdtdayrate -- 调整前授信日利率
    ,o.oldcrdtyearrate -- 调整前授信年利率
    ,o.newcrdtestimatlmt -- 调整后授信预估额度
    ,o.newcrdtdayrate -- 调整后授信日利率
    ,o.newcrdtyearrate -- 调整后授信年利率
    ,o.crdtadjtyp -- 授信调整类型
    ,o.platfspecdataprd -- 平台特色数据产品
    ,o.reqid -- 请求ID
    ,o.rspopinion -- 审批意见
    ,o.rejectreason -- 拒绝意见
    ,o.inputuserid -- 录入人
    ,o.inputorgid -- 录入机构
    ,o.inputdate -- 录入日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
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
from ${iol_schema}.icms_zjbk_adjuct_contract_bk o
    left join ${iol_schema}.icms_zjbk_adjuct_contract_op n
        on
            o.batnum = n.batnum
            and o.crdtid = n.crdtid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_zjbk_adjuct_contract_cl d
        on
            o.batnum = d.batnum
            and o.crdtid = d.crdtid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_zjbk_adjuct_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_zjbk_adjuct_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_zjbk_adjuct_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_zjbk_adjuct_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_zjbk_adjuct_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_zjbk_adjuct_contract_cl;
alter table ${iol_schema}.icms_zjbk_adjuct_contract exchange partition p_20991231 with table ${iol_schema}.icms_zjbk_adjuct_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_zjbk_adjuct_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_adjuct_contract_op purge;
drop table ${iol_schema}.icms_zjbk_adjuct_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_zjbk_adjuct_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_zjbk_adjuct_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
