/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gab_vchr
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
create table ${iol_schema}.tgls_gab_vchr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_gab_vchr
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gab_vchr_op purge;
drop table ${iol_schema}.tgls_gab_vchr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_vchr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gab_vchr where 0=1;

create table ${iol_schema}.tgls_gab_vchr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gab_vchr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gab_vchr_cl(
            stacid -- 账套
            ,sourdt -- 交易日期
            ,soursq -- 交易流水
            ,vchrsq -- 传票流水
            ,tranbr -- 交易机构编号
            ,acctbr -- 账务机构编号
            ,itemcd -- 科目编号
            ,crcycd -- 币种代码
            ,centcd -- 责任中心辅助核算
            ,prsncd -- 职员辅助核算
            ,custcd -- 客户辅助核算
            ,prducd -- 产品辅助核算
            ,prlncd -- 产品线辅助核算
            ,acctno -- 账户辅助核算
            ,trantp -- 交易类型（tr,cs）
            ,amntcd -- 借贷方向（d:借(收)c:贷(付)）
            ,tranam -- 交易金额
            ,trannm -- 交易笔数
            ,smrytx -- 摘要
            ,exchcn -- 中间价
            ,exchus -- 折算汇率
            ,usercd -- 用户代码
            ,toitem -- 对方科目编号
            ,transt -- 处理状态（1已处理0未处理）
            ,assis0 -- 渠道编号
            ,assis1 -- 产品编号
            ,assis2 -- 辅助核算2
            ,assis3 -- 辅助核算3
            ,assis4 -- 辅助核算4
            ,assis5 -- 辅助核算5
            ,assis6 -- 辅助核算6
            ,assis7 -- 辅助核算7
            ,assis8 -- 辅助核算8
            ,assis9 -- 辅助核算9
            ,trandt -- 维护日期
            ,transq -- 维护流水
            ,acctdt -- 账务会计日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gab_vchr_op(
            stacid -- 账套
            ,sourdt -- 交易日期
            ,soursq -- 交易流水
            ,vchrsq -- 传票流水
            ,tranbr -- 交易机构编号
            ,acctbr -- 账务机构编号
            ,itemcd -- 科目编号
            ,crcycd -- 币种代码
            ,centcd -- 责任中心辅助核算
            ,prsncd -- 职员辅助核算
            ,custcd -- 客户辅助核算
            ,prducd -- 产品辅助核算
            ,prlncd -- 产品线辅助核算
            ,acctno -- 账户辅助核算
            ,trantp -- 交易类型（tr,cs）
            ,amntcd -- 借贷方向（d:借(收)c:贷(付)）
            ,tranam -- 交易金额
            ,trannm -- 交易笔数
            ,smrytx -- 摘要
            ,exchcn -- 中间价
            ,exchus -- 折算汇率
            ,usercd -- 用户代码
            ,toitem -- 对方科目编号
            ,transt -- 处理状态（1已处理0未处理）
            ,assis0 -- 渠道编号
            ,assis1 -- 产品编号
            ,assis2 -- 辅助核算2
            ,assis3 -- 辅助核算3
            ,assis4 -- 辅助核算4
            ,assis5 -- 辅助核算5
            ,assis6 -- 辅助核算6
            ,assis7 -- 辅助核算7
            ,assis8 -- 辅助核算8
            ,assis9 -- 辅助核算9
            ,trandt -- 维护日期
            ,transq -- 维护流水
            ,acctdt -- 账务会计日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.sourdt, o.sourdt) as sourdt -- 交易日期
    ,nvl(n.soursq, o.soursq) as soursq -- 交易流水
    ,nvl(n.vchrsq, o.vchrsq) as vchrsq -- 传票流水
    ,nvl(n.tranbr, o.tranbr) as tranbr -- 交易机构编号
    ,nvl(n.acctbr, o.acctbr) as acctbr -- 账务机构编号
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 科目编号
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种代码
    ,nvl(n.centcd, o.centcd) as centcd -- 责任中心辅助核算
    ,nvl(n.prsncd, o.prsncd) as prsncd -- 职员辅助核算
    ,nvl(n.custcd, o.custcd) as custcd -- 客户辅助核算
    ,nvl(n.prducd, o.prducd) as prducd -- 产品辅助核算
    ,nvl(n.prlncd, o.prlncd) as prlncd -- 产品线辅助核算
    ,nvl(n.acctno, o.acctno) as acctno -- 账户辅助核算
    ,nvl(n.trantp, o.trantp) as trantp -- 交易类型（tr,cs）
    ,nvl(n.amntcd, o.amntcd) as amntcd -- 借贷方向（d:借(收)c:贷(付)）
    ,nvl(n.tranam, o.tranam) as tranam -- 交易金额
    ,nvl(n.trannm, o.trannm) as trannm -- 交易笔数
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 摘要
    ,nvl(n.exchcn, o.exchcn) as exchcn -- 中间价
    ,nvl(n.exchus, o.exchus) as exchus -- 折算汇率
    ,nvl(n.usercd, o.usercd) as usercd -- 用户代码
    ,nvl(n.toitem, o.toitem) as toitem -- 对方科目编号
    ,nvl(n.transt, o.transt) as transt -- 处理状态（1已处理0未处理）
    ,nvl(n.assis0, o.assis0) as assis0 -- 渠道编号
    ,nvl(n.assis1, o.assis1) as assis1 -- 产品编号
    ,nvl(n.assis2, o.assis2) as assis2 -- 辅助核算2
    ,nvl(n.assis3, o.assis3) as assis3 -- 辅助核算3
    ,nvl(n.assis4, o.assis4) as assis4 -- 辅助核算4
    ,nvl(n.assis5, o.assis5) as assis5 -- 辅助核算5
    ,nvl(n.assis6, o.assis6) as assis6 -- 辅助核算6
    ,nvl(n.assis7, o.assis7) as assis7 -- 辅助核算7
    ,nvl(n.assis8, o.assis8) as assis8 -- 辅助核算8
    ,nvl(n.assis9, o.assis9) as assis9 -- 辅助核算9
    ,nvl(n.trandt, o.trandt) as trandt -- 维护日期
    ,nvl(n.transq, o.transq) as transq -- 维护流水
    ,nvl(n.acctdt, o.acctdt) as acctdt -- 账务会计日期
    ,case when
            n.stacid is null
            and n.sourdt is null
            and n.soursq is null
            and n.vchrsq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.sourdt is null
            and n.soursq is null
            and n.vchrsq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.sourdt is null
            and n.soursq is null
            and n.vchrsq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_gab_vchr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_gab_vchr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.sourdt = n.sourdt
            and o.soursq = n.soursq
            and o.vchrsq = n.vchrsq
where (
        o.stacid is null
        and o.sourdt is null
        and o.soursq is null
        and o.vchrsq is null
    )
    or (
        n.stacid is null
        and n.sourdt is null
        and n.soursq is null
        and n.vchrsq is null
    )
    or (
        o.tranbr <> n.tranbr
        or o.acctbr <> n.acctbr
        or o.itemcd <> n.itemcd
        or o.crcycd <> n.crcycd
        or o.centcd <> n.centcd
        or o.prsncd <> n.prsncd
        or o.custcd <> n.custcd
        or o.prducd <> n.prducd
        or o.prlncd <> n.prlncd
        or o.acctno <> n.acctno
        or o.trantp <> n.trantp
        or o.amntcd <> n.amntcd
        or o.tranam <> n.tranam
        or o.trannm <> n.trannm
        or o.smrytx <> n.smrytx
        or o.exchcn <> n.exchcn
        or o.exchus <> n.exchus
        or o.usercd <> n.usercd
        or o.toitem <> n.toitem
        or o.transt <> n.transt
        or o.assis0 <> n.assis0
        or o.assis1 <> n.assis1
        or o.assis2 <> n.assis2
        or o.assis3 <> n.assis3
        or o.assis4 <> n.assis4
        or o.assis5 <> n.assis5
        or o.assis6 <> n.assis6
        or o.assis7 <> n.assis7
        or o.assis8 <> n.assis8
        or o.assis9 <> n.assis9
        or o.trandt <> n.trandt
        or o.transq <> n.transq
        or o.acctdt <> n.acctdt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gab_vchr_cl(
            stacid -- 账套
            ,sourdt -- 交易日期
            ,soursq -- 交易流水
            ,vchrsq -- 传票流水
            ,tranbr -- 交易机构编号
            ,acctbr -- 账务机构编号
            ,itemcd -- 科目编号
            ,crcycd -- 币种代码
            ,centcd -- 责任中心辅助核算
            ,prsncd -- 职员辅助核算
            ,custcd -- 客户辅助核算
            ,prducd -- 产品辅助核算
            ,prlncd -- 产品线辅助核算
            ,acctno -- 账户辅助核算
            ,trantp -- 交易类型（tr,cs）
            ,amntcd -- 借贷方向（d:借(收)c:贷(付)）
            ,tranam -- 交易金额
            ,trannm -- 交易笔数
            ,smrytx -- 摘要
            ,exchcn -- 中间价
            ,exchus -- 折算汇率
            ,usercd -- 用户代码
            ,toitem -- 对方科目编号
            ,transt -- 处理状态（1已处理0未处理）
            ,assis0 -- 渠道编号
            ,assis1 -- 产品编号
            ,assis2 -- 辅助核算2
            ,assis3 -- 辅助核算3
            ,assis4 -- 辅助核算4
            ,assis5 -- 辅助核算5
            ,assis6 -- 辅助核算6
            ,assis7 -- 辅助核算7
            ,assis8 -- 辅助核算8
            ,assis9 -- 辅助核算9
            ,trandt -- 维护日期
            ,transq -- 维护流水
            ,acctdt -- 账务会计日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gab_vchr_op(
            stacid -- 账套
            ,sourdt -- 交易日期
            ,soursq -- 交易流水
            ,vchrsq -- 传票流水
            ,tranbr -- 交易机构编号
            ,acctbr -- 账务机构编号
            ,itemcd -- 科目编号
            ,crcycd -- 币种代码
            ,centcd -- 责任中心辅助核算
            ,prsncd -- 职员辅助核算
            ,custcd -- 客户辅助核算
            ,prducd -- 产品辅助核算
            ,prlncd -- 产品线辅助核算
            ,acctno -- 账户辅助核算
            ,trantp -- 交易类型（tr,cs）
            ,amntcd -- 借贷方向（d:借(收)c:贷(付)）
            ,tranam -- 交易金额
            ,trannm -- 交易笔数
            ,smrytx -- 摘要
            ,exchcn -- 中间价
            ,exchus -- 折算汇率
            ,usercd -- 用户代码
            ,toitem -- 对方科目编号
            ,transt -- 处理状态（1已处理0未处理）
            ,assis0 -- 渠道编号
            ,assis1 -- 产品编号
            ,assis2 -- 辅助核算2
            ,assis3 -- 辅助核算3
            ,assis4 -- 辅助核算4
            ,assis5 -- 辅助核算5
            ,assis6 -- 辅助核算6
            ,assis7 -- 辅助核算7
            ,assis8 -- 辅助核算8
            ,assis9 -- 辅助核算9
            ,trandt -- 维护日期
            ,transq -- 维护流水
            ,acctdt -- 账务会计日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.sourdt -- 交易日期
    ,o.soursq -- 交易流水
    ,o.vchrsq -- 传票流水
    ,o.tranbr -- 交易机构编号
    ,o.acctbr -- 账务机构编号
    ,o.itemcd -- 科目编号
    ,o.crcycd -- 币种代码
    ,o.centcd -- 责任中心辅助核算
    ,o.prsncd -- 职员辅助核算
    ,o.custcd -- 客户辅助核算
    ,o.prducd -- 产品辅助核算
    ,o.prlncd -- 产品线辅助核算
    ,o.acctno -- 账户辅助核算
    ,o.trantp -- 交易类型（tr,cs）
    ,o.amntcd -- 借贷方向（d:借(收)c:贷(付)）
    ,o.tranam -- 交易金额
    ,o.trannm -- 交易笔数
    ,o.smrytx -- 摘要
    ,o.exchcn -- 中间价
    ,o.exchus -- 折算汇率
    ,o.usercd -- 用户代码
    ,o.toitem -- 对方科目编号
    ,o.transt -- 处理状态（1已处理0未处理）
    ,o.assis0 -- 渠道编号
    ,o.assis1 -- 产品编号
    ,o.assis2 -- 辅助核算2
    ,o.assis3 -- 辅助核算3
    ,o.assis4 -- 辅助核算4
    ,o.assis5 -- 辅助核算5
    ,o.assis6 -- 辅助核算6
    ,o.assis7 -- 辅助核算7
    ,o.assis8 -- 辅助核算8
    ,o.assis9 -- 辅助核算9
    ,o.trandt -- 维护日期
    ,o.transq -- 维护流水
    ,o.acctdt -- 账务会计日期
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
from ${iol_schema}.tgls_gab_vchr_bk o
    left join ${iol_schema}.tgls_gab_vchr_op n
        on
            o.stacid = n.stacid
            and o.sourdt = n.sourdt
            and o.soursq = n.soursq
            and o.vchrsq = n.vchrsq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_gab_vchr_cl d
        on
            o.stacid = d.stacid
            and o.sourdt = d.sourdt
            and o.soursq = d.soursq
            and o.vchrsq = d.vchrsq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_gab_vchr;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_gab_vchr') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_gab_vchr drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_gab_vchr add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_gab_vchr exchange partition p_${batch_date} with table ${iol_schema}.tgls_gab_vchr_cl;
alter table ${iol_schema}.tgls_gab_vchr exchange partition p_20991231 with table ${iol_schema}.tgls_gab_vchr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gab_vchr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gab_vchr_op purge;
drop table ${iol_schema}.tgls_gab_vchr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_gab_vchr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gab_vchr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
