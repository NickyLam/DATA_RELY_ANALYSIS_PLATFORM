/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_afterloan_creditcardcondition
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
create table ${iol_schema}.icms_afterloan_creditcardcondition_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_afterloan_creditcardcondition
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_creditcardcondition_op purge;
drop table ${iol_schema}.icms_afterloan_creditcardcondition_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_creditcardcondition_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_creditcardcondition where 0=1;

create table ${iol_schema}.icms_afterloan_creditcardcondition_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_creditcardcondition where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_creditcardcondition_cl(
            serialno -- 流水号
            ,inputuserid -- 登记人
            ,creditcardnum -- 信用卡张数
            ,reportno -- 报告编号
            ,overduebalance -- 逾期金额
            ,inputorgid -- 登记机构
            ,change1 -- 与前期相比变化
            ,inputdate -- 登记日期
            ,creditcardchange -- 信用卡变化数
            ,usedcreditsum -- 实际使用额度
            ,customername -- 信用卡用户名称
            ,updatedate -- 更新日期
            ,querydate -- 查询日期
            ,creditsum -- 信用卡总额度
            ,userate -- 信用卡使用占比
            ,orgsumcheck -- 信用卡银行变化数
            ,mfcustomerid -- 核心客户号
            ,migtflag -- 
            ,orgsum -- 信用卡银行数
            ,customerid -- 客户编号
            ,change2 -- 与前期相比变化
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_creditcardcondition_op(
            serialno -- 流水号
            ,inputuserid -- 登记人
            ,creditcardnum -- 信用卡张数
            ,reportno -- 报告编号
            ,overduebalance -- 逾期金额
            ,inputorgid -- 登记机构
            ,change1 -- 与前期相比变化
            ,inputdate -- 登记日期
            ,creditcardchange -- 信用卡变化数
            ,usedcreditsum -- 实际使用额度
            ,customername -- 信用卡用户名称
            ,updatedate -- 更新日期
            ,querydate -- 查询日期
            ,creditsum -- 信用卡总额度
            ,userate -- 信用卡使用占比
            ,orgsumcheck -- 信用卡银行变化数
            ,mfcustomerid -- 核心客户号
            ,migtflag -- 
            ,orgsum -- 信用卡银行数
            ,customerid -- 客户编号
            ,change2 -- 与前期相比变化
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.creditcardnum, o.creditcardnum) as creditcardnum -- 信用卡张数
    ,nvl(n.reportno, o.reportno) as reportno -- 报告编号
    ,nvl(n.overduebalance, o.overduebalance) as overduebalance -- 逾期金额
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.change1, o.change1) as change1 -- 与前期相比变化
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.creditcardchange, o.creditcardchange) as creditcardchange -- 信用卡变化数
    ,nvl(n.usedcreditsum, o.usedcreditsum) as usedcreditsum -- 实际使用额度
    ,nvl(n.customername, o.customername) as customername -- 信用卡用户名称
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.querydate, o.querydate) as querydate -- 查询日期
    ,nvl(n.creditsum, o.creditsum) as creditsum -- 信用卡总额度
    ,nvl(n.userate, o.userate) as userate -- 信用卡使用占比
    ,nvl(n.orgsumcheck, o.orgsumcheck) as orgsumcheck -- 信用卡银行变化数
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.orgsum, o.orgsum) as orgsum -- 信用卡银行数
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.change2, o.change2) as change2 -- 与前期相比变化
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
from (select * from ${iol_schema}.icms_afterloan_creditcardcondition_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_afterloan_creditcardcondition where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.inputuserid <> n.inputuserid
        or o.creditcardnum <> n.creditcardnum
        or o.reportno <> n.reportno
        or o.overduebalance <> n.overduebalance
        or o.inputorgid <> n.inputorgid
        or o.change1 <> n.change1
        or o.inputdate <> n.inputdate
        or o.creditcardchange <> n.creditcardchange
        or o.usedcreditsum <> n.usedcreditsum
        or o.customername <> n.customername
        or o.updatedate <> n.updatedate
        or o.querydate <> n.querydate
        or o.creditsum <> n.creditsum
        or o.userate <> n.userate
        or o.orgsumcheck <> n.orgsumcheck
        or o.mfcustomerid <> n.mfcustomerid
        or o.migtflag <> n.migtflag
        or o.orgsum <> n.orgsum
        or o.customerid <> n.customerid
        or o.change2 <> n.change2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_creditcardcondition_cl(
            serialno -- 流水号
            ,inputuserid -- 登记人
            ,creditcardnum -- 信用卡张数
            ,reportno -- 报告编号
            ,overduebalance -- 逾期金额
            ,inputorgid -- 登记机构
            ,change1 -- 与前期相比变化
            ,inputdate -- 登记日期
            ,creditcardchange -- 信用卡变化数
            ,usedcreditsum -- 实际使用额度
            ,customername -- 信用卡用户名称
            ,updatedate -- 更新日期
            ,querydate -- 查询日期
            ,creditsum -- 信用卡总额度
            ,userate -- 信用卡使用占比
            ,orgsumcheck -- 信用卡银行变化数
            ,mfcustomerid -- 核心客户号
            ,migtflag -- 
            ,orgsum -- 信用卡银行数
            ,customerid -- 客户编号
            ,change2 -- 与前期相比变化
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_creditcardcondition_op(
            serialno -- 流水号
            ,inputuserid -- 登记人
            ,creditcardnum -- 信用卡张数
            ,reportno -- 报告编号
            ,overduebalance -- 逾期金额
            ,inputorgid -- 登记机构
            ,change1 -- 与前期相比变化
            ,inputdate -- 登记日期
            ,creditcardchange -- 信用卡变化数
            ,usedcreditsum -- 实际使用额度
            ,customername -- 信用卡用户名称
            ,updatedate -- 更新日期
            ,querydate -- 查询日期
            ,creditsum -- 信用卡总额度
            ,userate -- 信用卡使用占比
            ,orgsumcheck -- 信用卡银行变化数
            ,mfcustomerid -- 核心客户号
            ,migtflag -- 
            ,orgsum -- 信用卡银行数
            ,customerid -- 客户编号
            ,change2 -- 与前期相比变化
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.inputuserid -- 登记人
    ,o.creditcardnum -- 信用卡张数
    ,o.reportno -- 报告编号
    ,o.overduebalance -- 逾期金额
    ,o.inputorgid -- 登记机构
    ,o.change1 -- 与前期相比变化
    ,o.inputdate -- 登记日期
    ,o.creditcardchange -- 信用卡变化数
    ,o.usedcreditsum -- 实际使用额度
    ,o.customername -- 信用卡用户名称
    ,o.updatedate -- 更新日期
    ,o.querydate -- 查询日期
    ,o.creditsum -- 信用卡总额度
    ,o.userate -- 信用卡使用占比
    ,o.orgsumcheck -- 信用卡银行变化数
    ,o.mfcustomerid -- 核心客户号
    ,o.migtflag -- 
    ,o.orgsum -- 信用卡银行数
    ,o.customerid -- 客户编号
    ,o.change2 -- 与前期相比变化
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
from ${iol_schema}.icms_afterloan_creditcardcondition_bk o
    left join ${iol_schema}.icms_afterloan_creditcardcondition_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_afterloan_creditcardcondition_cl d
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
--truncate table ${iol_schema}.icms_afterloan_creditcardcondition;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_afterloan_creditcardcondition') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_afterloan_creditcardcondition drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_afterloan_creditcardcondition add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_afterloan_creditcardcondition exchange partition p_${batch_date} with table ${iol_schema}.icms_afterloan_creditcardcondition_cl;
alter table ${iol_schema}.icms_afterloan_creditcardcondition exchange partition p_20991231 with table ${iol_schema}.icms_afterloan_creditcardcondition_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_afterloan_creditcardcondition to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_creditcardcondition_op purge;
drop table ${iol_schema}.icms_afterloan_creditcardcondition_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_afterloan_creditcardcondition_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_afterloan_creditcardcondition',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
