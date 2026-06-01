/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_asset_transfer_apply
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
create table ${iol_schema}.icms_ap_asset_transfer_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_asset_transfer_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_asset_transfer_apply_op purge;
drop table ${iol_schema}.icms_ap_asset_transfer_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_asset_transfer_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_asset_transfer_apply where 0=1;

create table ${iol_schema}.icms_ap_asset_transfer_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_asset_transfer_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_asset_transfer_apply_cl(
            serialno -- 流水号
            ,customername -- 客户名称
            ,updateuserid -- 更新人
            ,customersum -- 涉及客户数量
            ,allbusinesssum -- 总授信金额
            ,customertype -- 客户类型
            ,allbdbusinesssum -- 总借据金额
            ,applytype -- 申请类型
            ,handinreason -- 移交原因
            ,inputuserid -- 登记人
            ,transfertype -- 转移状态01人工移入02人工移出)
            ,approvestatus -- 流程状态
            ,handoutreason -- 逆移交原因
            ,groupid -- 集团编号
            ,assetinreason -- 认定原因
            ,allbalance -- 总借据余额
            ,assetno -- 风险资产编号
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,assetoutreason -- 恢复原因
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,customerlevel -- 最低客户评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_asset_transfer_apply_op(
            serialno -- 流水号
            ,customername -- 客户名称
            ,updateuserid -- 更新人
            ,customersum -- 涉及客户数量
            ,allbusinesssum -- 总授信金额
            ,customertype -- 客户类型
            ,allbdbusinesssum -- 总借据金额
            ,applytype -- 申请类型
            ,handinreason -- 移交原因
            ,inputuserid -- 登记人
            ,transfertype -- 转移状态01人工移入02人工移出)
            ,approvestatus -- 流程状态
            ,handoutreason -- 逆移交原因
            ,groupid -- 集团编号
            ,assetinreason -- 认定原因
            ,allbalance -- 总借据余额
            ,assetno -- 风险资产编号
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,assetoutreason -- 恢复原因
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,customerlevel -- 最低客户评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.customersum, o.customersum) as customersum -- 涉及客户数量
    ,nvl(n.allbusinesssum, o.allbusinesssum) as allbusinesssum -- 总授信金额
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.allbdbusinesssum, o.allbdbusinesssum) as allbdbusinesssum -- 总借据金额
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型
    ,nvl(n.handinreason, o.handinreason) as handinreason -- 移交原因
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.transfertype, o.transfertype) as transfertype -- 转移状态01人工移入02人工移出)
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 流程状态
    ,nvl(n.handoutreason, o.handoutreason) as handoutreason -- 逆移交原因
    ,nvl(n.groupid, o.groupid) as groupid -- 集团编号
    ,nvl(n.assetinreason, o.assetinreason) as assetinreason -- 认定原因
    ,nvl(n.allbalance, o.allbalance) as allbalance -- 总借据余额
    ,nvl(n.assetno, o.assetno) as assetno -- 风险资产编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.assetoutreason, o.assetoutreason) as assetoutreason -- 恢复原因
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.customerlevel, o.customerlevel) as customerlevel -- 最低客户评级
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
from (select * from ${iol_schema}.icms_ap_asset_transfer_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_asset_transfer_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.customername <> n.customername
        or o.updateuserid <> n.updateuserid
        or o.customersum <> n.customersum
        or o.allbusinesssum <> n.allbusinesssum
        or o.customertype <> n.customertype
        or o.allbdbusinesssum <> n.allbdbusinesssum
        or o.applytype <> n.applytype
        or o.handinreason <> n.handinreason
        or o.inputuserid <> n.inputuserid
        or o.transfertype <> n.transfertype
        or o.approvestatus <> n.approvestatus
        or o.handoutreason <> n.handoutreason
        or o.groupid <> n.groupid
        or o.assetinreason <> n.assetinreason
        or o.allbalance <> n.allbalance
        or o.assetno <> n.assetno
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.assetoutreason <> n.assetoutreason
        or o.inputdate <> n.inputdate
        or o.inputorgid <> n.inputorgid
        or o.customerlevel <> n.customerlevel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_asset_transfer_apply_cl(
            serialno -- 流水号
            ,customername -- 客户名称
            ,updateuserid -- 更新人
            ,customersum -- 涉及客户数量
            ,allbusinesssum -- 总授信金额
            ,customertype -- 客户类型
            ,allbdbusinesssum -- 总借据金额
            ,applytype -- 申请类型
            ,handinreason -- 移交原因
            ,inputuserid -- 登记人
            ,transfertype -- 转移状态01人工移入02人工移出)
            ,approvestatus -- 流程状态
            ,handoutreason -- 逆移交原因
            ,groupid -- 集团编号
            ,assetinreason -- 认定原因
            ,allbalance -- 总借据余额
            ,assetno -- 风险资产编号
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,assetoutreason -- 恢复原因
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,customerlevel -- 最低客户评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_asset_transfer_apply_op(
            serialno -- 流水号
            ,customername -- 客户名称
            ,updateuserid -- 更新人
            ,customersum -- 涉及客户数量
            ,allbusinesssum -- 总授信金额
            ,customertype -- 客户类型
            ,allbdbusinesssum -- 总借据金额
            ,applytype -- 申请类型
            ,handinreason -- 移交原因
            ,inputuserid -- 登记人
            ,transfertype -- 转移状态01人工移入02人工移出)
            ,approvestatus -- 流程状态
            ,handoutreason -- 逆移交原因
            ,groupid -- 集团编号
            ,assetinreason -- 认定原因
            ,allbalance -- 总借据余额
            ,assetno -- 风险资产编号
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,assetoutreason -- 恢复原因
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,customerlevel -- 最低客户评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.customername -- 客户名称
    ,o.updateuserid -- 更新人
    ,o.customersum -- 涉及客户数量
    ,o.allbusinesssum -- 总授信金额
    ,o.customertype -- 客户类型
    ,o.allbdbusinesssum -- 总借据金额
    ,o.applytype -- 申请类型
    ,o.handinreason -- 移交原因
    ,o.inputuserid -- 登记人
    ,o.transfertype -- 转移状态01人工移入02人工移出)
    ,o.approvestatus -- 流程状态
    ,o.handoutreason -- 逆移交原因
    ,o.groupid -- 集团编号
    ,o.assetinreason -- 认定原因
    ,o.allbalance -- 总借据余额
    ,o.assetno -- 风险资产编号
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.assetoutreason -- 恢复原因
    ,o.inputdate -- 登记日期
    ,o.inputorgid -- 登记机构
    ,o.customerlevel -- 最低客户评级
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
from ${iol_schema}.icms_ap_asset_transfer_apply_bk o
    left join ${iol_schema}.icms_ap_asset_transfer_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_asset_transfer_apply_cl d
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
--truncate table ${iol_schema}.icms_ap_asset_transfer_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_asset_transfer_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_asset_transfer_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_asset_transfer_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_asset_transfer_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_asset_transfer_apply_cl;
alter table ${iol_schema}.icms_ap_asset_transfer_apply exchange partition p_20991231 with table ${iol_schema}.icms_ap_asset_transfer_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_asset_transfer_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_asset_transfer_apply_op purge;
drop table ${iol_schema}.icms_ap_asset_transfer_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_asset_transfer_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_asset_transfer_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
