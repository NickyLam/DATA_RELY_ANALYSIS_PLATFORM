/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_contract_info
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
create table ${iol_schema}.icms_contract_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_contract_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_contract_info_op purge;
drop table ${iol_schema}.icms_contract_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_contract_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_contract_info where 0=1;

create table ${iol_schema}.icms_contract_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_contract_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_contract_info_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,contractcurrency -- 合同币种
            ,remark -- 备注
            ,purchaserid -- 买方代码
            ,bargainorname -- 卖方名称
            ,inputdate -- 登记日期
            ,contractsum -- 合同金额
            ,paymethod -- 付款方式
            ,begindate -- 合同生效日
            ,bargainorid -- 卖方代码
            ,enddate -- 合同到期日
            ,contractdescribe -- 货物名称
            ,inputuserid -- 登记人
            ,purchasername -- 买方名称
            ,invoiceno -- 增值税发票号码
            ,contractno -- 贸易合同号
            ,signdate -- 合同签订日
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_contract_info_op(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,contractcurrency -- 合同币种
            ,remark -- 备注
            ,purchaserid -- 买方代码
            ,bargainorname -- 卖方名称
            ,inputdate -- 登记日期
            ,contractsum -- 合同金额
            ,paymethod -- 付款方式
            ,begindate -- 合同生效日
            ,bargainorid -- 卖方代码
            ,enddate -- 合同到期日
            ,contractdescribe -- 货物名称
            ,inputuserid -- 登记人
            ,purchasername -- 买方名称
            ,invoiceno -- 增值税发票号码
            ,contractno -- 贸易合同号
            ,signdate -- 合同签订日
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.contractcurrency, o.contractcurrency) as contractcurrency -- 合同币种
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.purchaserid, o.purchaserid) as purchaserid -- 买方代码
    ,nvl(n.bargainorname, o.bargainorname) as bargainorname -- 卖方名称
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.contractsum, o.contractsum) as contractsum -- 合同金额
    ,nvl(n.paymethod, o.paymethod) as paymethod -- 付款方式
    ,nvl(n.begindate, o.begindate) as begindate -- 合同生效日
    ,nvl(n.bargainorid, o.bargainorid) as bargainorid -- 卖方代码
    ,nvl(n.enddate, o.enddate) as enddate -- 合同到期日
    ,nvl(n.contractdescribe, o.contractdescribe) as contractdescribe -- 货物名称
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.purchasername, o.purchasername) as purchasername -- 买方名称
    ,nvl(n.invoiceno, o.invoiceno) as invoiceno -- 增值税发票号码
    ,nvl(n.contractno, o.contractno) as contractno -- 贸易合同号
    ,nvl(n.signdate, o.signdate) as signdate -- 合同签订日
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_contract_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_contract_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
where (
        o.serialno is null
        and o.objecttype is null
        and o.objectno is null
    )
    or (
        n.serialno is null
        and n.objecttype is null
        and n.objectno is null
    )
    or (
        o.contractcurrency <> n.contractcurrency
        or o.remark <> n.remark
        or o.purchaserid <> n.purchaserid
        or o.bargainorname <> n.bargainorname
        or o.inputdate <> n.inputdate
        or o.contractsum <> n.contractsum
        or o.paymethod <> n.paymethod
        or o.begindate <> n.begindate
        or o.bargainorid <> n.bargainorid
        or o.enddate <> n.enddate
        or o.contractdescribe <> n.contractdescribe
        or o.inputuserid <> n.inputuserid
        or o.purchasername <> n.purchasername
        or o.invoiceno <> n.invoiceno
        or o.contractno <> n.contractno
        or o.signdate <> n.signdate
        or o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_contract_info_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,contractcurrency -- 合同币种
            ,remark -- 备注
            ,purchaserid -- 买方代码
            ,bargainorname -- 卖方名称
            ,inputdate -- 登记日期
            ,contractsum -- 合同金额
            ,paymethod -- 付款方式
            ,begindate -- 合同生效日
            ,bargainorid -- 卖方代码
            ,enddate -- 合同到期日
            ,contractdescribe -- 货物名称
            ,inputuserid -- 登记人
            ,purchasername -- 买方名称
            ,invoiceno -- 增值税发票号码
            ,contractno -- 贸易合同号
            ,signdate -- 合同签订日
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_contract_info_op(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,contractcurrency -- 合同币种
            ,remark -- 备注
            ,purchaserid -- 买方代码
            ,bargainorname -- 卖方名称
            ,inputdate -- 登记日期
            ,contractsum -- 合同金额
            ,paymethod -- 付款方式
            ,begindate -- 合同生效日
            ,bargainorid -- 卖方代码
            ,enddate -- 合同到期日
            ,contractdescribe -- 货物名称
            ,inputuserid -- 登记人
            ,purchasername -- 买方名称
            ,invoiceno -- 增值税发票号码
            ,contractno -- 贸易合同号
            ,signdate -- 合同签订日
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objecttype -- 对象类型
    ,o.objectno -- 对象编号
    ,o.contractcurrency -- 合同币种
    ,o.remark -- 备注
    ,o.purchaserid -- 买方代码
    ,o.bargainorname -- 卖方名称
    ,o.inputdate -- 登记日期
    ,o.contractsum -- 合同金额
    ,o.paymethod -- 付款方式
    ,o.begindate -- 合同生效日
    ,o.bargainorid -- 卖方代码
    ,o.enddate -- 合同到期日
    ,o.contractdescribe -- 货物名称
    ,o.inputuserid -- 登记人
    ,o.purchasername -- 买方名称
    ,o.invoiceno -- 增值税发票号码
    ,o.contractno -- 贸易合同号
    ,o.signdate -- 合同签订日
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
from ${iol_schema}.icms_contract_info_bk o
    left join ${iol_schema}.icms_contract_info_op n
        on
            o.serialno = n.serialno
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_contract_info_cl d
        on
            o.serialno = d.serialno
            and o.objecttype = d.objecttype
            and o.objectno = d.objectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_contract_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_contract_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_contract_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_contract_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_contract_info exchange partition p_${batch_date} with table ${iol_schema}.icms_contract_info_cl;
alter table ${iol_schema}.icms_contract_info exchange partition p_20991231 with table ${iol_schema}.icms_contract_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_contract_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_contract_info_op purge;
drop table ${iol_schema}.icms_contract_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_contract_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_contract_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
