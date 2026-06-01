/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gab_tran
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
create table ${iol_schema}.tgls_gab_tran_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_gab_tran
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gab_tran_op purge;
drop table ${iol_schema}.tgls_gab_tran_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_tran_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gab_tran where 0=1;

create table ${iol_schema}.tgls_gab_tran_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gab_tran where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gab_tran_cl(
            stacid -- 帐套id
            ,trandt -- 交易日期
            ,transq -- 交易流水
            ,tranti -- 交易时间
            ,tranbr -- 交易机构编号
            ,usercd -- 用户代码
            ,acctbr -- 账务机构编号
            ,bsnsdt -- 业务日期
            ,bsnssq -- 业务流水
            ,entrsq -- 入账流水
            ,trantp -- 交易类型
            ,crcycd -- 币种
            ,dcmtno -- 凭证号码
            ,dcmttp -- 凭证类型
            ,prcscd -- 原交易处理码
            ,tranam -- 原值变动交易金额
            ,itemcd -- 总账科目编号
            ,psauus -- 授权柜员
            ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
            ,odtrdt -- 原交易日期（被冲正交易日期）
            ,odtrsq -- 原交易流水串（被冲正交流流水）
            ,acsrnm -- 附件张数
            ,remark -- 摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gab_tran_op(
            stacid -- 帐套id
            ,trandt -- 交易日期
            ,transq -- 交易流水
            ,tranti -- 交易时间
            ,tranbr -- 交易机构编号
            ,usercd -- 用户代码
            ,acctbr -- 账务机构编号
            ,bsnsdt -- 业务日期
            ,bsnssq -- 业务流水
            ,entrsq -- 入账流水
            ,trantp -- 交易类型
            ,crcycd -- 币种
            ,dcmtno -- 凭证号码
            ,dcmttp -- 凭证类型
            ,prcscd -- 原交易处理码
            ,tranam -- 原值变动交易金额
            ,itemcd -- 总账科目编号
            ,psauus -- 授权柜员
            ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
            ,odtrdt -- 原交易日期（被冲正交易日期）
            ,odtrsq -- 原交易流水串（被冲正交流流水）
            ,acsrnm -- 附件张数
            ,remark -- 摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 帐套id
    ,nvl(n.trandt, o.trandt) as trandt -- 交易日期
    ,nvl(n.transq, o.transq) as transq -- 交易流水
    ,nvl(n.tranti, o.tranti) as tranti -- 交易时间
    ,nvl(n.tranbr, o.tranbr) as tranbr -- 交易机构编号
    ,nvl(n.usercd, o.usercd) as usercd -- 用户代码
    ,nvl(n.acctbr, o.acctbr) as acctbr -- 账务机构编号
    ,nvl(n.bsnsdt, o.bsnsdt) as bsnsdt -- 业务日期
    ,nvl(n.bsnssq, o.bsnssq) as bsnssq -- 业务流水
    ,nvl(n.entrsq, o.entrsq) as entrsq -- 入账流水
    ,nvl(n.trantp, o.trantp) as trantp -- 交易类型
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种
    ,nvl(n.dcmtno, o.dcmtno) as dcmtno -- 凭证号码
    ,nvl(n.dcmttp, o.dcmttp) as dcmttp -- 凭证类型
    ,nvl(n.prcscd, o.prcscd) as prcscd -- 原交易处理码
    ,nvl(n.tranam, o.tranam) as tranam -- 原值变动交易金额
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 总账科目编号
    ,nvl(n.psauus, o.psauus) as psauus -- 授权柜员
    ,nvl(n.strkst, o.strkst) as strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,nvl(n.odtrdt, o.odtrdt) as odtrdt -- 原交易日期（被冲正交易日期）
    ,nvl(n.odtrsq, o.odtrsq) as odtrsq -- 原交易流水串（被冲正交流流水）
    ,nvl(n.acsrnm, o.acsrnm) as acsrnm -- 附件张数
    ,nvl(n.remark, o.remark) as remark -- 摘要
    ,case when
            n.stacid is null
            and n.trandt is null
            and n.transq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.trandt is null
            and n.transq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.trandt is null
            and n.transq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_gab_tran_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_gab_tran where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.trandt = n.trandt
            and o.transq = n.transq
where (
        o.stacid is null
        and o.trandt is null
        and o.transq is null
    )
    or (
        n.stacid is null
        and n.trandt is null
        and n.transq is null
    )
    or (
        o.tranti <> n.tranti
        or o.tranbr <> n.tranbr
        or o.usercd <> n.usercd
        or o.acctbr <> n.acctbr
        or o.bsnsdt <> n.bsnsdt
        or o.bsnssq <> n.bsnssq
        or o.entrsq <> n.entrsq
        or o.trantp <> n.trantp
        or o.crcycd <> n.crcycd
        or o.dcmtno <> n.dcmtno
        or o.dcmttp <> n.dcmttp
        or o.prcscd <> n.prcscd
        or o.tranam <> n.tranam
        or o.itemcd <> n.itemcd
        or o.psauus <> n.psauus
        or o.strkst <> n.strkst
        or o.odtrdt <> n.odtrdt
        or o.odtrsq <> n.odtrsq
        or o.acsrnm <> n.acsrnm
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gab_tran_cl(
            stacid -- 帐套id
            ,trandt -- 交易日期
            ,transq -- 交易流水
            ,tranti -- 交易时间
            ,tranbr -- 交易机构编号
            ,usercd -- 用户代码
            ,acctbr -- 账务机构编号
            ,bsnsdt -- 业务日期
            ,bsnssq -- 业务流水
            ,entrsq -- 入账流水
            ,trantp -- 交易类型
            ,crcycd -- 币种
            ,dcmtno -- 凭证号码
            ,dcmttp -- 凭证类型
            ,prcscd -- 原交易处理码
            ,tranam -- 原值变动交易金额
            ,itemcd -- 总账科目编号
            ,psauus -- 授权柜员
            ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
            ,odtrdt -- 原交易日期（被冲正交易日期）
            ,odtrsq -- 原交易流水串（被冲正交流流水）
            ,acsrnm -- 附件张数
            ,remark -- 摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gab_tran_op(
            stacid -- 帐套id
            ,trandt -- 交易日期
            ,transq -- 交易流水
            ,tranti -- 交易时间
            ,tranbr -- 交易机构编号
            ,usercd -- 用户代码
            ,acctbr -- 账务机构编号
            ,bsnsdt -- 业务日期
            ,bsnssq -- 业务流水
            ,entrsq -- 入账流水
            ,trantp -- 交易类型
            ,crcycd -- 币种
            ,dcmtno -- 凭证号码
            ,dcmttp -- 凭证类型
            ,prcscd -- 原交易处理码
            ,tranam -- 原值变动交易金额
            ,itemcd -- 总账科目编号
            ,psauus -- 授权柜员
            ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
            ,odtrdt -- 原交易日期（被冲正交易日期）
            ,odtrsq -- 原交易流水串（被冲正交流流水）
            ,acsrnm -- 附件张数
            ,remark -- 摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 帐套id
    ,o.trandt -- 交易日期
    ,o.transq -- 交易流水
    ,o.tranti -- 交易时间
    ,o.tranbr -- 交易机构编号
    ,o.usercd -- 用户代码
    ,o.acctbr -- 账务机构编号
    ,o.bsnsdt -- 业务日期
    ,o.bsnssq -- 业务流水
    ,o.entrsq -- 入账流水
    ,o.trantp -- 交易类型
    ,o.crcycd -- 币种
    ,o.dcmtno -- 凭证号码
    ,o.dcmttp -- 凭证类型
    ,o.prcscd -- 原交易处理码
    ,o.tranam -- 原值变动交易金额
    ,o.itemcd -- 总账科目编号
    ,o.psauus -- 授权柜员
    ,o.strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,o.odtrdt -- 原交易日期（被冲正交易日期）
    ,o.odtrsq -- 原交易流水串（被冲正交流流水）
    ,o.acsrnm -- 附件张数
    ,o.remark -- 摘要
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
from ${iol_schema}.tgls_gab_tran_bk o
    left join ${iol_schema}.tgls_gab_tran_op n
        on
            o.stacid = n.stacid
            and o.trandt = n.trandt
            and o.transq = n.transq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_gab_tran_cl d
        on
            o.stacid = d.stacid
            and o.trandt = d.trandt
            and o.transq = d.transq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_gab_tran;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_gab_tran') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_gab_tran drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_gab_tran add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_gab_tran exchange partition p_${batch_date} with table ${iol_schema}.tgls_gab_tran_cl;
alter table ${iol_schema}.tgls_gab_tran exchange partition p_20991231 with table ${iol_schema}.tgls_gab_tran_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gab_tran to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gab_tran_op purge;
drop table ${iol_schema}.tgls_gab_tran_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_gab_tran_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gab_tran',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
