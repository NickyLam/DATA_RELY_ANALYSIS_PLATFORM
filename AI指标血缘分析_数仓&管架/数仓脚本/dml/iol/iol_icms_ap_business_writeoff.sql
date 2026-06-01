/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_business_writeoff
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
create table ${iol_schema}.icms_ap_business_writeoff_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_business_writeoff
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_business_writeoff_op purge;
drop table ${iol_schema}.icms_ap_business_writeoff_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_business_writeoff_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_business_writeoff where 0=1;

create table ${iol_schema}.icms_ap_business_writeoff_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_business_writeoff where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_business_writeoff_cl(
            writeoffno -- 入账单编号
            ,onarrears -- 已核销表内息
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,inputuserid -- 登记人
            ,finreceivables -- 已核销财务应收款
            ,contractno -- 合同流水号
            ,tmsp -- 时间戳
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,customerid -- 借款人编号
            ,duebillno -- 借据流水号
            ,deleteflag -- 删除标志
            ,principal -- 已核销本金金额
            ,offarrears -- 已核销表外息
            ,programno -- 方案编号
            ,updateuserid -- 更新人
            ,maturity -- 到期日
            ,currency -- 币种
            ,customername -- 借款人名称
            ,remark -- 备注
            ,putoutdate -- 发放日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_business_writeoff_op(
            writeoffno -- 入账单编号
            ,onarrears -- 已核销表内息
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,inputuserid -- 登记人
            ,finreceivables -- 已核销财务应收款
            ,contractno -- 合同流水号
            ,tmsp -- 时间戳
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,customerid -- 借款人编号
            ,duebillno -- 借据流水号
            ,deleteflag -- 删除标志
            ,principal -- 已核销本金金额
            ,offarrears -- 已核销表外息
            ,programno -- 方案编号
            ,updateuserid -- 更新人
            ,maturity -- 到期日
            ,currency -- 币种
            ,customername -- 借款人名称
            ,remark -- 备注
            ,putoutdate -- 发放日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.writeoffno, o.writeoffno) as writeoffno -- 入账单编号
    ,nvl(n.onarrears, o.onarrears) as onarrears -- 已核销表内息
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.finreceivables, o.finreceivables) as finreceivables -- 已核销财务应收款
    ,nvl(n.contractno, o.contractno) as contractno -- 合同流水号
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.customerid, o.customerid) as customerid -- 借款人编号
    ,nvl(n.duebillno, o.duebillno) as duebillno -- 借据流水号
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.principal, o.principal) as principal -- 已核销本金金额
    ,nvl(n.offarrears, o.offarrears) as offarrears -- 已核销表外息
    ,nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.maturity, o.maturity) as maturity -- 到期日
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.customername, o.customername) as customername -- 借款人名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 发放日
    ,case when
            n.writeoffno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.writeoffno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.writeoffno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_business_writeoff_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_business_writeoff where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.writeoffno = n.writeoffno
where (
        o.writeoffno is null
    )
    or (
        n.writeoffno is null
    )
    or (
        o.onarrears <> n.onarrears
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.inputuserid <> n.inputuserid
        or o.finreceivables <> n.finreceivables
        or o.contractno <> n.contractno
        or o.tmsp <> n.tmsp
        or o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
        or o.customerid <> n.customerid
        or o.duebillno <> n.duebillno
        or o.deleteflag <> n.deleteflag
        or o.principal <> n.principal
        or o.offarrears <> n.offarrears
        or o.programno <> n.programno
        or o.updateuserid <> n.updateuserid
        or o.maturity <> n.maturity
        or o.currency <> n.currency
        or o.customername <> n.customername
        or o.remark <> n.remark
        or o.putoutdate <> n.putoutdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_business_writeoff_cl(
            writeoffno -- 入账单编号
            ,onarrears -- 已核销表内息
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,inputuserid -- 登记人
            ,finreceivables -- 已核销财务应收款
            ,contractno -- 合同流水号
            ,tmsp -- 时间戳
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,customerid -- 借款人编号
            ,duebillno -- 借据流水号
            ,deleteflag -- 删除标志
            ,principal -- 已核销本金金额
            ,offarrears -- 已核销表外息
            ,programno -- 方案编号
            ,updateuserid -- 更新人
            ,maturity -- 到期日
            ,currency -- 币种
            ,customername -- 借款人名称
            ,remark -- 备注
            ,putoutdate -- 发放日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_business_writeoff_op(
            writeoffno -- 入账单编号
            ,onarrears -- 已核销表内息
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,inputuserid -- 登记人
            ,finreceivables -- 已核销财务应收款
            ,contractno -- 合同流水号
            ,tmsp -- 时间戳
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,customerid -- 借款人编号
            ,duebillno -- 借据流水号
            ,deleteflag -- 删除标志
            ,principal -- 已核销本金金额
            ,offarrears -- 已核销表外息
            ,programno -- 方案编号
            ,updateuserid -- 更新人
            ,maturity -- 到期日
            ,currency -- 币种
            ,customername -- 借款人名称
            ,remark -- 备注
            ,putoutdate -- 发放日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.writeoffno -- 入账单编号
    ,o.onarrears -- 已核销表内息
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.inputuserid -- 登记人
    ,o.finreceivables -- 已核销财务应收款
    ,o.contractno -- 合同流水号
    ,o.tmsp -- 时间戳
    ,o.inputorgid -- 登记机构
    ,o.updatedate -- 更新日期
    ,o.customerid -- 借款人编号
    ,o.duebillno -- 借据流水号
    ,o.deleteflag -- 删除标志
    ,o.principal -- 已核销本金金额
    ,o.offarrears -- 已核销表外息
    ,o.programno -- 方案编号
    ,o.updateuserid -- 更新人
    ,o.maturity -- 到期日
    ,o.currency -- 币种
    ,o.customername -- 借款人名称
    ,o.remark -- 备注
    ,o.putoutdate -- 发放日
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
from ${iol_schema}.icms_ap_business_writeoff_bk o
    left join ${iol_schema}.icms_ap_business_writeoff_op n
        on
            o.writeoffno = n.writeoffno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_business_writeoff_cl d
        on
            o.writeoffno = d.writeoffno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_business_writeoff;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_business_writeoff') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_business_writeoff drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_business_writeoff add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_business_writeoff exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_business_writeoff_cl;
alter table ${iol_schema}.icms_ap_business_writeoff exchange partition p_20991231 with table ${iol_schema}.icms_ap_business_writeoff_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_business_writeoff to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_business_writeoff_op purge;
drop table ${iol_schema}.icms_ap_business_writeoff_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_business_writeoff_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_business_writeoff',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
