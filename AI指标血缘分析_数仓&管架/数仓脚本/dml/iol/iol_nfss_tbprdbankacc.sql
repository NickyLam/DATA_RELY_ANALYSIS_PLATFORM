/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbprdbankacc
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
create table ${iol_schema}.nfss_tbprdbankacc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbprdbankacc;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprdbankacc_op purge;
drop table ${iol_schema}.nfss_tbprdbankacc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbprdbankacc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprdbankacc where 0=1;

create table ${iol_schema}.nfss_tbprdbankacc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprdbankacc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprdbankacc_cl(
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行编号
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上帐银行帐号
            ,bank_acc_down -- 下帐银行帐号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 基金公司产品代码
            ,square_way -- 结算方式
            ,bank_name -- 托管银行名称
            ,branch_name -- 托管机构名称
            ,prd_name -- 外部产品名称
            ,bank_acc_up_name -- 上帐银行帐号名称
            ,bank_acc_down_name -- 下账银行帐号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 备用1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprdbankacc_op(
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行编号
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上帐银行帐号
            ,bank_acc_down -- 下帐银行帐号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 基金公司产品代码
            ,square_way -- 结算方式
            ,bank_name -- 托管银行名称
            ,branch_name -- 托管机构名称
            ,prd_name -- 外部产品名称
            ,bank_acc_up_name -- 上帐银行帐号名称
            ,bank_acc_down_name -- 下账银行帐号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 备用1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编号
    ,nvl(n.open_bank_ver, o.open_bank_ver) as open_bank_ver -- 验资户开户行
    ,nvl(n.open_bank_up, o.open_bank_up) as open_bank_up -- 注册登记账户开户行
    ,nvl(n.bank_acc_up, o.bank_acc_up) as bank_acc_up -- 上帐银行帐号
    ,nvl(n.bank_acc_down, o.bank_acc_down) as bank_acc_down -- 下帐银行帐号
    ,nvl(n.bank_acc_ver, o.bank_acc_ver) as bank_acc_ver -- 募集验资账户
    ,nvl(n.asso_code, o.asso_code) as asso_code -- 基金公司产品代码
    ,nvl(n.square_way, o.square_way) as square_way -- 结算方式
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 托管银行名称
    ,nvl(n.branch_name, o.branch_name) as branch_name -- 托管机构名称
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 外部产品名称
    ,nvl(n.bank_acc_up_name, o.bank_acc_up_name) as bank_acc_up_name -- 上帐银行帐号名称
    ,nvl(n.bank_acc_down_name, o.bank_acc_down_name) as bank_acc_down_name -- 下账银行帐号名称
    ,nvl(n.bank_acc_ver_name, o.bank_acc_ver_name) as bank_acc_ver_name -- 募集验资户账户名称
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,case when
            n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbprdbankacc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbprdbankacc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
where (
        o.prd_code is null
    )
    or (
        n.prd_code is null
    )
    or (
        o.ta_code <> n.ta_code
        or o.bank_no <> n.bank_no
        or o.open_bank_ver <> n.open_bank_ver
        or o.open_bank_up <> n.open_bank_up
        or o.bank_acc_up <> n.bank_acc_up
        or o.bank_acc_down <> n.bank_acc_down
        or o.bank_acc_ver <> n.bank_acc_ver
        or o.asso_code <> n.asso_code
        or o.square_way <> n.square_way
        or o.bank_name <> n.bank_name
        or o.branch_name <> n.branch_name
        or o.prd_name <> n.prd_name
        or o.bank_acc_up_name <> n.bank_acc_up_name
        or o.bank_acc_down_name <> n.bank_acc_down_name
        or o.bank_acc_ver_name <> n.bank_acc_ver_name
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprdbankacc_cl(
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行编号
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上帐银行帐号
            ,bank_acc_down -- 下帐银行帐号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 基金公司产品代码
            ,square_way -- 结算方式
            ,bank_name -- 托管银行名称
            ,branch_name -- 托管机构名称
            ,prd_name -- 外部产品名称
            ,bank_acc_up_name -- 上帐银行帐号名称
            ,bank_acc_down_name -- 下账银行帐号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 备用1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprdbankacc_op(
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行编号
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上帐银行帐号
            ,bank_acc_down -- 下帐银行帐号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 基金公司产品代码
            ,square_way -- 结算方式
            ,bank_name -- 托管银行名称
            ,branch_name -- 托管机构名称
            ,prd_name -- 外部产品名称
            ,bank_acc_up_name -- 上帐银行帐号名称
            ,bank_acc_down_name -- 下账银行帐号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 备用1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- TA代码
    ,o.prd_code -- 产品代码
    ,o.bank_no -- 银行编号
    ,o.open_bank_ver -- 验资户开户行
    ,o.open_bank_up -- 注册登记账户开户行
    ,o.bank_acc_up -- 上帐银行帐号
    ,o.bank_acc_down -- 下帐银行帐号
    ,o.bank_acc_ver -- 募集验资账户
    ,o.asso_code -- 基金公司产品代码
    ,o.square_way -- 结算方式
    ,o.bank_name -- 托管银行名称
    ,o.branch_name -- 托管机构名称
    ,o.prd_name -- 外部产品名称
    ,o.bank_acc_up_name -- 上帐银行帐号名称
    ,o.bank_acc_down_name -- 下账银行帐号名称
    ,o.bank_acc_ver_name -- 募集验资户账户名称
    ,o.reserve1 -- 备用1
    ,o.reserve2 -- 备用字段2
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbprdbankacc_bk o
    left join ${iol_schema}.nfss_tbprdbankacc_op n
        on
            o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbprdbankacc_cl d
        on
            o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbprdbankacc;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbprdbankacc exchange partition p_19000101 with table ${iol_schema}.nfss_tbprdbankacc_cl;
alter table ${iol_schema}.nfss_tbprdbankacc exchange partition p_20991231 with table ${iol_schema}.nfss_tbprdbankacc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbprdbankacc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprdbankacc_op purge;
drop table ${iol_schema}.nfss_tbprdbankacc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbprdbankacc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbprdbankacc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
