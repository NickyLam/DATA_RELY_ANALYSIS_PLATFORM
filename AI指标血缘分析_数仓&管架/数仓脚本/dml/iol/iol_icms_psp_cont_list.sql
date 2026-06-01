/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_psp_cont_list
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
create table ${iol_schema}.icms_psp_cont_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_psp_cont_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_cont_list_op purge;
drop table ${iol_schema}.icms_psp_cont_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_cont_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_cont_list where 0=1;

create table ${iol_schema}.icms_psp_cont_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_cont_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_cont_list_cl(
            serialno -- 主键
            ,prdpk -- 产品主键
            ,mainbrid -- 所属分行
            ,assuremeansmain -- 担保方式
            ,prdname -- 产品名称
            ,contamt -- 合同额度金额
            ,availriskamt -- 敞口余额
            ,biztypesub -- 产品类别
            ,availamt -- 使用余额
            ,contno -- 合同编号
            ,loanenddate -- 额度到期日
            ,biztype -- 贷款品种
            ,contriskamt -- 合同敞口金额
            ,type -- 我行授信情况区别:1、借款人2、保证人
            ,cusid -- 客户号
            ,serno -- 任务编号
            ,currencytype -- 币种
            ,cusname -- 客户名称
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_cont_list_op(
            serialno -- 主键
            ,prdpk -- 产品主键
            ,mainbrid -- 所属分行
            ,assuremeansmain -- 担保方式
            ,prdname -- 产品名称
            ,contamt -- 合同额度金额
            ,availriskamt -- 敞口余额
            ,biztypesub -- 产品类别
            ,availamt -- 使用余额
            ,contno -- 合同编号
            ,loanenddate -- 额度到期日
            ,biztype -- 贷款品种
            ,contriskamt -- 合同敞口金额
            ,type -- 我行授信情况区别:1、借款人2、保证人
            ,cusid -- 客户号
            ,serno -- 任务编号
            ,currencytype -- 币种
            ,cusname -- 客户名称
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 主键
    ,nvl(n.prdpk, o.prdpk) as prdpk -- 产品主键
    ,nvl(n.mainbrid, o.mainbrid) as mainbrid -- 所属分行
    ,nvl(n.assuremeansmain, o.assuremeansmain) as assuremeansmain -- 担保方式
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.contamt, o.contamt) as contamt -- 合同额度金额
    ,nvl(n.availriskamt, o.availriskamt) as availriskamt -- 敞口余额
    ,nvl(n.biztypesub, o.biztypesub) as biztypesub -- 产品类别
    ,nvl(n.availamt, o.availamt) as availamt -- 使用余额
    ,nvl(n.contno, o.contno) as contno -- 合同编号
    ,nvl(n.loanenddate, o.loanenddate) as loanenddate -- 额度到期日
    ,nvl(n.biztype, o.biztype) as biztype -- 贷款品种
    ,nvl(n.contriskamt, o.contriskamt) as contriskamt -- 合同敞口金额
    ,nvl(n.type, o.type) as type -- 我行授信情况区别:1、借款人2、保证人
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.serno, o.serno) as serno -- 任务编号
    ,nvl(n.currencytype, o.currencytype) as currencytype -- 币种
    ,nvl(n.cusname, o.cusname) as cusname -- 客户名称
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
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
from (select * from ${iol_schema}.icms_psp_cont_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_psp_cont_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.prdpk <> n.prdpk
        or o.mainbrid <> n.mainbrid
        or o.assuremeansmain <> n.assuremeansmain
        or o.prdname <> n.prdname
        or o.contamt <> n.contamt
        or o.availriskamt <> n.availriskamt
        or o.biztypesub <> n.biztypesub
        or o.availamt <> n.availamt
        or o.contno <> n.contno
        or o.loanenddate <> n.loanenddate
        or o.biztype <> n.biztype
        or o.contriskamt <> n.contriskamt
        or o.type <> n.type
        or o.cusid <> n.cusid
        or o.serno <> n.serno
        or o.currencytype <> n.currencytype
        or o.cusname <> n.cusname
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_cont_list_cl(
            serialno -- 主键
            ,prdpk -- 产品主键
            ,mainbrid -- 所属分行
            ,assuremeansmain -- 担保方式
            ,prdname -- 产品名称
            ,contamt -- 合同额度金额
            ,availriskamt -- 敞口余额
            ,biztypesub -- 产品类别
            ,availamt -- 使用余额
            ,contno -- 合同编号
            ,loanenddate -- 额度到期日
            ,biztype -- 贷款品种
            ,contriskamt -- 合同敞口金额
            ,type -- 我行授信情况区别:1、借款人2、保证人
            ,cusid -- 客户号
            ,serno -- 任务编号
            ,currencytype -- 币种
            ,cusname -- 客户名称
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_cont_list_op(
            serialno -- 主键
            ,prdpk -- 产品主键
            ,mainbrid -- 所属分行
            ,assuremeansmain -- 担保方式
            ,prdname -- 产品名称
            ,contamt -- 合同额度金额
            ,availriskamt -- 敞口余额
            ,biztypesub -- 产品类别
            ,availamt -- 使用余额
            ,contno -- 合同编号
            ,loanenddate -- 额度到期日
            ,biztype -- 贷款品种
            ,contriskamt -- 合同敞口金额
            ,type -- 我行授信情况区别:1、借款人2、保证人
            ,cusid -- 客户号
            ,serno -- 任务编号
            ,currencytype -- 币种
            ,cusname -- 客户名称
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 主键
    ,o.prdpk -- 产品主键
    ,o.mainbrid -- 所属分行
    ,o.assuremeansmain -- 担保方式
    ,o.prdname -- 产品名称
    ,o.contamt -- 合同额度金额
    ,o.availriskamt -- 敞口余额
    ,o.biztypesub -- 产品类别
    ,o.availamt -- 使用余额
    ,o.contno -- 合同编号
    ,o.loanenddate -- 额度到期日
    ,o.biztype -- 贷款品种
    ,o.contriskamt -- 合同敞口金额
    ,o.type -- 我行授信情况区别:1、借款人2、保证人
    ,o.cusid -- 客户号
    ,o.serno -- 任务编号
    ,o.currencytype -- 币种
    ,o.cusname -- 客户名称
    ,o.migtflag -- 
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
from ${iol_schema}.icms_psp_cont_list_bk o
    left join ${iol_schema}.icms_psp_cont_list_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_psp_cont_list_cl d
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
--truncate table ${iol_schema}.icms_psp_cont_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_psp_cont_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_psp_cont_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_psp_cont_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_psp_cont_list exchange partition p_${batch_date} with table ${iol_schema}.icms_psp_cont_list_cl;
alter table ${iol_schema}.icms_psp_cont_list exchange partition p_20991231 with table ${iol_schema}.icms_psp_cont_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_psp_cont_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_cont_list_op purge;
drop table ${iol_schema}.icms_psp_cont_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_psp_cont_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_psp_cont_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
