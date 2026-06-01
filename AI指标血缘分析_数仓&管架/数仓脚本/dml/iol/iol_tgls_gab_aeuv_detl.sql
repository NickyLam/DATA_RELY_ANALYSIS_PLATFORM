/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gab_aeuv_detl
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
create table ${iol_schema}.tgls_gab_aeuv_detl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_gab_aeuv_detl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gab_aeuv_detl_op purge;
drop table ${iol_schema}.tgls_gab_aeuv_detl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_aeuv_detl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gab_aeuv_detl where 0=1;

create table ${iol_schema}.tgls_gab_aeuv_detl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gab_aeuv_detl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gab_aeuv_detl_cl(
            stacid -- 账套标记
            ,aeuvid -- 分录标识
            ,dispsq -- 序号
            ,bsnsdt -- 审计日期
            ,bsnssq -- 业务流水号
            ,acctbr -- 账务机构编号
            ,itemcd -- 科目编号
            ,amntcd -- 借贷方向
            ,tranam -- 交易金额
            ,trannm -- 交易笔数
            ,smrytx -- 摘要
            ,exchcn -- 中间价
            ,exchus -- 折算汇率
            ,toacno -- 往来对方账号
            ,prlncd -- 业务条线
            ,assis0 -- 渠道编号
            ,assis1 -- 产品编号
            ,assis2 -- 辅助核算2（自定义）
            ,assis3 -- 辅助核算3（自定义）
            ,assis4 -- 辅助核算4（自定义）
            ,assis5 -- 辅助核算5（自定义）
            ,assis6 -- 辅助核算6（自定义）
            ,assis7 -- 辅助核算7（自定义）
            ,assis8 -- 辅助核算8（自定义）
            ,assis9 -- 辅助核算9（自定义）
            ,prducd -- 产品（辅助）
            ,custcd -- 往来单位（辅助）
            ,prsncd -- 职员（辅助）
            ,acctno -- 账户（辅助）
            ,centcd -- 部门（辅助）
            ,trandt -- 入账会计日期
            ,foldcn -- 折本位币
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gab_aeuv_detl_op(
            stacid -- 账套标记
            ,aeuvid -- 分录标识
            ,dispsq -- 序号
            ,bsnsdt -- 审计日期
            ,bsnssq -- 业务流水号
            ,acctbr -- 账务机构编号
            ,itemcd -- 科目编号
            ,amntcd -- 借贷方向
            ,tranam -- 交易金额
            ,trannm -- 交易笔数
            ,smrytx -- 摘要
            ,exchcn -- 中间价
            ,exchus -- 折算汇率
            ,toacno -- 往来对方账号
            ,prlncd -- 业务条线
            ,assis0 -- 渠道编号
            ,assis1 -- 产品编号
            ,assis2 -- 辅助核算2（自定义）
            ,assis3 -- 辅助核算3（自定义）
            ,assis4 -- 辅助核算4（自定义）
            ,assis5 -- 辅助核算5（自定义）
            ,assis6 -- 辅助核算6（自定义）
            ,assis7 -- 辅助核算7（自定义）
            ,assis8 -- 辅助核算8（自定义）
            ,assis9 -- 辅助核算9（自定义）
            ,prducd -- 产品（辅助）
            ,custcd -- 往来单位（辅助）
            ,prsncd -- 职员（辅助）
            ,acctno -- 账户（辅助）
            ,centcd -- 部门（辅助）
            ,trandt -- 入账会计日期
            ,foldcn -- 折本位币
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.aeuvid, o.aeuvid) as aeuvid -- 分录标识
    ,nvl(n.dispsq, o.dispsq) as dispsq -- 序号
    ,nvl(n.bsnsdt, o.bsnsdt) as bsnsdt -- 审计日期
    ,nvl(n.bsnssq, o.bsnssq) as bsnssq -- 业务流水号
    ,nvl(n.acctbr, o.acctbr) as acctbr -- 账务机构编号
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 科目编号
    ,nvl(n.amntcd, o.amntcd) as amntcd -- 借贷方向
    ,nvl(n.tranam, o.tranam) as tranam -- 交易金额
    ,nvl(n.trannm, o.trannm) as trannm -- 交易笔数
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 摘要
    ,nvl(n.exchcn, o.exchcn) as exchcn -- 中间价
    ,nvl(n.exchus, o.exchus) as exchus -- 折算汇率
    ,nvl(n.toacno, o.toacno) as toacno -- 往来对方账号
    ,nvl(n.prlncd, o.prlncd) as prlncd -- 业务条线
    ,nvl(n.assis0, o.assis0) as assis0 -- 渠道编号
    ,nvl(n.assis1, o.assis1) as assis1 -- 产品编号
    ,nvl(n.assis2, o.assis2) as assis2 -- 辅助核算2（自定义）
    ,nvl(n.assis3, o.assis3) as assis3 -- 辅助核算3（自定义）
    ,nvl(n.assis4, o.assis4) as assis4 -- 辅助核算4（自定义）
    ,nvl(n.assis5, o.assis5) as assis5 -- 辅助核算5（自定义）
    ,nvl(n.assis6, o.assis6) as assis6 -- 辅助核算6（自定义）
    ,nvl(n.assis7, o.assis7) as assis7 -- 辅助核算7（自定义）
    ,nvl(n.assis8, o.assis8) as assis8 -- 辅助核算8（自定义）
    ,nvl(n.assis9, o.assis9) as assis9 -- 辅助核算9（自定义）
    ,nvl(n.prducd, o.prducd) as prducd -- 产品（辅助）
    ,nvl(n.custcd, o.custcd) as custcd -- 往来单位（辅助）
    ,nvl(n.prsncd, o.prsncd) as prsncd -- 职员（辅助）
    ,nvl(n.acctno, o.acctno) as acctno -- 账户（辅助）
    ,nvl(n.centcd, o.centcd) as centcd -- 部门（辅助）
    ,nvl(n.trandt, o.trandt) as trandt -- 入账会计日期
    ,nvl(n.foldcn, o.foldcn) as foldcn -- 折本位币
    ,case when
            n.stacid is null
            and n.aeuvid is null
            and n.dispsq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.aeuvid is null
            and n.dispsq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.aeuvid is null
            and n.dispsq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_gab_aeuv_detl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_gab_aeuv_detl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.aeuvid = n.aeuvid
            and o.dispsq = n.dispsq
where (
        o.stacid is null
        and o.aeuvid is null
        and o.dispsq is null
    )
    or (
        n.stacid is null
        and n.aeuvid is null
        and n.dispsq is null
    )
    or (
        o.bsnsdt <> n.bsnsdt
        or o.bsnssq <> n.bsnssq
        or o.acctbr <> n.acctbr
        or o.itemcd <> n.itemcd
        or o.amntcd <> n.amntcd
        or o.tranam <> n.tranam
        or o.trannm <> n.trannm
        or o.smrytx <> n.smrytx
        or o.exchcn <> n.exchcn
        or o.exchus <> n.exchus
        or o.toacno <> n.toacno
        or o.prlncd <> n.prlncd
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
        or o.prducd <> n.prducd
        or o.custcd <> n.custcd
        or o.prsncd <> n.prsncd
        or o.acctno <> n.acctno
        or o.centcd <> n.centcd
        or o.trandt <> n.trandt
        or o.foldcn <> n.foldcn
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gab_aeuv_detl_cl(
            stacid -- 账套标记
            ,aeuvid -- 分录标识
            ,dispsq -- 序号
            ,bsnsdt -- 审计日期
            ,bsnssq -- 业务流水号
            ,acctbr -- 账务机构编号
            ,itemcd -- 科目编号
            ,amntcd -- 借贷方向
            ,tranam -- 交易金额
            ,trannm -- 交易笔数
            ,smrytx -- 摘要
            ,exchcn -- 中间价
            ,exchus -- 折算汇率
            ,toacno -- 往来对方账号
            ,prlncd -- 业务条线
            ,assis0 -- 渠道编号
            ,assis1 -- 产品编号
            ,assis2 -- 辅助核算2（自定义）
            ,assis3 -- 辅助核算3（自定义）
            ,assis4 -- 辅助核算4（自定义）
            ,assis5 -- 辅助核算5（自定义）
            ,assis6 -- 辅助核算6（自定义）
            ,assis7 -- 辅助核算7（自定义）
            ,assis8 -- 辅助核算8（自定义）
            ,assis9 -- 辅助核算9（自定义）
            ,prducd -- 产品（辅助）
            ,custcd -- 往来单位（辅助）
            ,prsncd -- 职员（辅助）
            ,acctno -- 账户（辅助）
            ,centcd -- 部门（辅助）
            ,trandt -- 入账会计日期
            ,foldcn -- 折本位币
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gab_aeuv_detl_op(
            stacid -- 账套标记
            ,aeuvid -- 分录标识
            ,dispsq -- 序号
            ,bsnsdt -- 审计日期
            ,bsnssq -- 业务流水号
            ,acctbr -- 账务机构编号
            ,itemcd -- 科目编号
            ,amntcd -- 借贷方向
            ,tranam -- 交易金额
            ,trannm -- 交易笔数
            ,smrytx -- 摘要
            ,exchcn -- 中间价
            ,exchus -- 折算汇率
            ,toacno -- 往来对方账号
            ,prlncd -- 业务条线
            ,assis0 -- 渠道编号
            ,assis1 -- 产品编号
            ,assis2 -- 辅助核算2（自定义）
            ,assis3 -- 辅助核算3（自定义）
            ,assis4 -- 辅助核算4（自定义）
            ,assis5 -- 辅助核算5（自定义）
            ,assis6 -- 辅助核算6（自定义）
            ,assis7 -- 辅助核算7（自定义）
            ,assis8 -- 辅助核算8（自定义）
            ,assis9 -- 辅助核算9（自定义）
            ,prducd -- 产品（辅助）
            ,custcd -- 往来单位（辅助）
            ,prsncd -- 职员（辅助）
            ,acctno -- 账户（辅助）
            ,centcd -- 部门（辅助）
            ,trandt -- 入账会计日期
            ,foldcn -- 折本位币
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.aeuvid -- 分录标识
    ,o.dispsq -- 序号
    ,o.bsnsdt -- 审计日期
    ,o.bsnssq -- 业务流水号
    ,o.acctbr -- 账务机构编号
    ,o.itemcd -- 科目编号
    ,o.amntcd -- 借贷方向
    ,o.tranam -- 交易金额
    ,o.trannm -- 交易笔数
    ,o.smrytx -- 摘要
    ,o.exchcn -- 中间价
    ,o.exchus -- 折算汇率
    ,o.toacno -- 往来对方账号
    ,o.prlncd -- 业务条线
    ,o.assis0 -- 渠道编号
    ,o.assis1 -- 产品编号
    ,o.assis2 -- 辅助核算2（自定义）
    ,o.assis3 -- 辅助核算3（自定义）
    ,o.assis4 -- 辅助核算4（自定义）
    ,o.assis5 -- 辅助核算5（自定义）
    ,o.assis6 -- 辅助核算6（自定义）
    ,o.assis7 -- 辅助核算7（自定义）
    ,o.assis8 -- 辅助核算8（自定义）
    ,o.assis9 -- 辅助核算9（自定义）
    ,o.prducd -- 产品（辅助）
    ,o.custcd -- 往来单位（辅助）
    ,o.prsncd -- 职员（辅助）
    ,o.acctno -- 账户（辅助）
    ,o.centcd -- 部门（辅助）
    ,o.trandt -- 入账会计日期
    ,o.foldcn -- 折本位币
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
from ${iol_schema}.tgls_gab_aeuv_detl_bk o
    left join ${iol_schema}.tgls_gab_aeuv_detl_op n
        on
            o.stacid = n.stacid
            and o.aeuvid = n.aeuvid
            and o.dispsq = n.dispsq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_gab_aeuv_detl_cl d
        on
            o.stacid = d.stacid
            and o.aeuvid = d.aeuvid
            and o.dispsq = d.dispsq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_gab_aeuv_detl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_gab_aeuv_detl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_gab_aeuv_detl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_gab_aeuv_detl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_gab_aeuv_detl exchange partition p_${batch_date} with table ${iol_schema}.tgls_gab_aeuv_detl_cl;
alter table ${iol_schema}.tgls_gab_aeuv_detl exchange partition p_20991231 with table ${iol_schema}.tgls_gab_aeuv_detl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gab_aeuv_detl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gab_aeuv_detl_op purge;
drop table ${iol_schema}.tgls_gab_aeuv_detl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_gab_aeuv_detl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gab_aeuv_detl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
