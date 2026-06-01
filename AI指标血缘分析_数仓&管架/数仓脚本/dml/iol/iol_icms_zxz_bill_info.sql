/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zxz_bill_info
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
create table ${iol_schema}.icms_zxz_bill_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_zxz_bill_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zxz_bill_info_op purge;
drop table ${iol_schema}.icms_zxz_bill_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_bill_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zxz_bill_info where 0=1;

create table ${iol_schema}.icms_zxz_bill_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zxz_bill_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zxz_bill_info_cl(
            packageno -- 批次包编号
            ,billno -- 借据号
            ,cla -- 贷款质量(五级分类)
            ,loanbalance -- 贷款余额
            ,inpoolflag -- 总行入池标识
            ,cusname -- 客户名称
            ,billenddate -- 借据失效日期
            ,businessesflag -- 客户类型
            ,lastyearbussum -- 上年末营业收入
            ,loanenddate -- 贷款到期日
            ,workersnum -- 企业人数
            ,cusmanager -- 客户经理
            ,certcode -- 客户证件号码
            ,loanusetype -- 贷款用途
            ,indivcomfld -- 所属行业
            ,mainbrid -- 机构名称
            ,accountstatus -- 借据状态
            ,loanstartdate -- 贷款发放日
            ,comptypedetail -- 贷款划型细项
            ,loanamount -- 贷款金额
            ,comptype -- 贷款划型
            ,compsize -- 企业规模
            ,realityiry -- 贷款利率
            ,zxzflag -- 支小再状态
            ,totalassets -- 资产总额(万元)
            ,packagename -- 批次包的名称
            ,assuremeansmain -- 主担保方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zxz_bill_info_op(
            packageno -- 批次包编号
            ,billno -- 借据号
            ,cla -- 贷款质量(五级分类)
            ,loanbalance -- 贷款余额
            ,inpoolflag -- 总行入池标识
            ,cusname -- 客户名称
            ,billenddate -- 借据失效日期
            ,businessesflag -- 客户类型
            ,lastyearbussum -- 上年末营业收入
            ,loanenddate -- 贷款到期日
            ,workersnum -- 企业人数
            ,cusmanager -- 客户经理
            ,certcode -- 客户证件号码
            ,loanusetype -- 贷款用途
            ,indivcomfld -- 所属行业
            ,mainbrid -- 机构名称
            ,accountstatus -- 借据状态
            ,loanstartdate -- 贷款发放日
            ,comptypedetail -- 贷款划型细项
            ,loanamount -- 贷款金额
            ,comptype -- 贷款划型
            ,compsize -- 企业规模
            ,realityiry -- 贷款利率
            ,zxzflag -- 支小再状态
            ,totalassets -- 资产总额(万元)
            ,packagename -- 批次包的名称
            ,assuremeansmain -- 主担保方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.packageno, o.packageno) as packageno -- 批次包编号
    ,nvl(n.billno, o.billno) as billno -- 借据号
    ,nvl(n.cla, o.cla) as cla -- 贷款质量(五级分类)
    ,nvl(n.loanbalance, o.loanbalance) as loanbalance -- 贷款余额
    ,nvl(n.inpoolflag, o.inpoolflag) as inpoolflag -- 总行入池标识
    ,nvl(n.cusname, o.cusname) as cusname -- 客户名称
    ,nvl(n.billenddate, o.billenddate) as billenddate -- 借据失效日期
    ,nvl(n.businessesflag, o.businessesflag) as businessesflag -- 客户类型
    ,nvl(n.lastyearbussum, o.lastyearbussum) as lastyearbussum -- 上年末营业收入
    ,nvl(n.loanenddate, o.loanenddate) as loanenddate -- 贷款到期日
    ,nvl(n.workersnum, o.workersnum) as workersnum -- 企业人数
    ,nvl(n.cusmanager, o.cusmanager) as cusmanager -- 客户经理
    ,nvl(n.certcode, o.certcode) as certcode -- 客户证件号码
    ,nvl(n.loanusetype, o.loanusetype) as loanusetype -- 贷款用途
    ,nvl(n.indivcomfld, o.indivcomfld) as indivcomfld -- 所属行业
    ,nvl(n.mainbrid, o.mainbrid) as mainbrid -- 机构名称
    ,nvl(n.accountstatus, o.accountstatus) as accountstatus -- 借据状态
    ,nvl(n.loanstartdate, o.loanstartdate) as loanstartdate -- 贷款发放日
    ,nvl(n.comptypedetail, o.comptypedetail) as comptypedetail -- 贷款划型细项
    ,nvl(n.loanamount, o.loanamount) as loanamount -- 贷款金额
    ,nvl(n.comptype, o.comptype) as comptype -- 贷款划型
    ,nvl(n.compsize, o.compsize) as compsize -- 企业规模
    ,nvl(n.realityiry, o.realityiry) as realityiry -- 贷款利率
    ,nvl(n.zxzflag, o.zxzflag) as zxzflag -- 支小再状态
    ,nvl(n.totalassets, o.totalassets) as totalassets -- 资产总额(万元)
    ,nvl(n.packagename, o.packagename) as packagename -- 批次包的名称
    ,nvl(n.assuremeansmain, o.assuremeansmain) as assuremeansmain -- 主担保方式
    ,case when
            n.packageno is null
            and n.billno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.packageno is null
            and n.billno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.packageno is null
            and n.billno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_zxz_bill_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_zxz_bill_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.packageno = n.packageno
            and o.billno = n.billno
where (
        o.packageno is null
        and o.billno is null
    )
    or (
        n.packageno is null
        and n.billno is null
    )
    or (
        o.cla <> n.cla
        or o.loanbalance <> n.loanbalance
        or o.inpoolflag <> n.inpoolflag
        or o.cusname <> n.cusname
        or o.billenddate <> n.billenddate
        or o.businessesflag <> n.businessesflag
        or o.lastyearbussum <> n.lastyearbussum
        or o.loanenddate <> n.loanenddate
        or o.workersnum <> n.workersnum
        or o.cusmanager <> n.cusmanager
        or o.certcode <> n.certcode
        or o.loanusetype <> n.loanusetype
        or o.indivcomfld <> n.indivcomfld
        or o.mainbrid <> n.mainbrid
        or o.accountstatus <> n.accountstatus
        or o.loanstartdate <> n.loanstartdate
        or o.comptypedetail <> n.comptypedetail
        or o.loanamount <> n.loanamount
        or o.comptype <> n.comptype
        or o.compsize <> n.compsize
        or o.realityiry <> n.realityiry
        or o.zxzflag <> n.zxzflag
        or o.totalassets <> n.totalassets
        or o.packagename <> n.packagename
        or o.assuremeansmain <> n.assuremeansmain
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zxz_bill_info_cl(
            packageno -- 批次包编号
            ,billno -- 借据号
            ,cla -- 贷款质量(五级分类)
            ,loanbalance -- 贷款余额
            ,inpoolflag -- 总行入池标识
            ,cusname -- 客户名称
            ,billenddate -- 借据失效日期
            ,businessesflag -- 客户类型
            ,lastyearbussum -- 上年末营业收入
            ,loanenddate -- 贷款到期日
            ,workersnum -- 企业人数
            ,cusmanager -- 客户经理
            ,certcode -- 客户证件号码
            ,loanusetype -- 贷款用途
            ,indivcomfld -- 所属行业
            ,mainbrid -- 机构名称
            ,accountstatus -- 借据状态
            ,loanstartdate -- 贷款发放日
            ,comptypedetail -- 贷款划型细项
            ,loanamount -- 贷款金额
            ,comptype -- 贷款划型
            ,compsize -- 企业规模
            ,realityiry -- 贷款利率
            ,zxzflag -- 支小再状态
            ,totalassets -- 资产总额(万元)
            ,packagename -- 批次包的名称
            ,assuremeansmain -- 主担保方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zxz_bill_info_op(
            packageno -- 批次包编号
            ,billno -- 借据号
            ,cla -- 贷款质量(五级分类)
            ,loanbalance -- 贷款余额
            ,inpoolflag -- 总行入池标识
            ,cusname -- 客户名称
            ,billenddate -- 借据失效日期
            ,businessesflag -- 客户类型
            ,lastyearbussum -- 上年末营业收入
            ,loanenddate -- 贷款到期日
            ,workersnum -- 企业人数
            ,cusmanager -- 客户经理
            ,certcode -- 客户证件号码
            ,loanusetype -- 贷款用途
            ,indivcomfld -- 所属行业
            ,mainbrid -- 机构名称
            ,accountstatus -- 借据状态
            ,loanstartdate -- 贷款发放日
            ,comptypedetail -- 贷款划型细项
            ,loanamount -- 贷款金额
            ,comptype -- 贷款划型
            ,compsize -- 企业规模
            ,realityiry -- 贷款利率
            ,zxzflag -- 支小再状态
            ,totalassets -- 资产总额(万元)
            ,packagename -- 批次包的名称
            ,assuremeansmain -- 主担保方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.packageno -- 批次包编号
    ,o.billno -- 借据号
    ,o.cla -- 贷款质量(五级分类)
    ,o.loanbalance -- 贷款余额
    ,o.inpoolflag -- 总行入池标识
    ,o.cusname -- 客户名称
    ,o.billenddate -- 借据失效日期
    ,o.businessesflag -- 客户类型
    ,o.lastyearbussum -- 上年末营业收入
    ,o.loanenddate -- 贷款到期日
    ,o.workersnum -- 企业人数
    ,o.cusmanager -- 客户经理
    ,o.certcode -- 客户证件号码
    ,o.loanusetype -- 贷款用途
    ,o.indivcomfld -- 所属行业
    ,o.mainbrid -- 机构名称
    ,o.accountstatus -- 借据状态
    ,o.loanstartdate -- 贷款发放日
    ,o.comptypedetail -- 贷款划型细项
    ,o.loanamount -- 贷款金额
    ,o.comptype -- 贷款划型
    ,o.compsize -- 企业规模
    ,o.realityiry -- 贷款利率
    ,o.zxzflag -- 支小再状态
    ,o.totalassets -- 资产总额(万元)
    ,o.packagename -- 批次包的名称
    ,o.assuremeansmain -- 主担保方式
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
from ${iol_schema}.icms_zxz_bill_info_bk o
    left join ${iol_schema}.icms_zxz_bill_info_op n
        on
            o.packageno = n.packageno
            and o.billno = n.billno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_zxz_bill_info_cl d
        on
            o.packageno = d.packageno
            and o.billno = d.billno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_zxz_bill_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_zxz_bill_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_zxz_bill_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_zxz_bill_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_zxz_bill_info exchange partition p_${batch_date} with table ${iol_schema}.icms_zxz_bill_info_cl;
alter table ${iol_schema}.icms_zxz_bill_info exchange partition p_20991231 with table ${iol_schema}.icms_zxz_bill_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_zxz_bill_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zxz_bill_info_op purge;
drop table ${iol_schema}.icms_zxz_bill_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_zxz_bill_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_zxz_bill_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
