/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_mcht_mcc_inf
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
create table ${iol_schema}.mrms_tbl_mcht_mcc_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_mcht_mcc_inf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_mcht_mcc_inf_op purge;
drop table ${iol_schema}.mrms_tbl_mcht_mcc_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_mcht_mcc_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_mcht_mcc_inf where 0=1;

create table ${iol_schema}.mrms_tbl_mcht_mcc_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_mcht_mcc_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_mcht_mcc_inf_cl(
            mchnt_tp -- MCC号
            ,mchnt_tp_grp -- 商户组别
            ,descr -- MCC描述
            ,fee_rate -- 费率
            ,remark -- 备注
            ,last_oper_in -- 最后操作状态(新增,修改)
            ,rec_st -- 记录状态
            ,rec_upd_usr_id -- 最后更新柜员ID
            ,rec_upd_ts -- 更新时间
            ,rec_crt_ts -- 创建时间
            ,reserved -- 商户分类
            ,debitfee -- 借记卡费率
            ,creditfee -- 贷记卡费率
            ,credittopamt -- 贷记卡封顶金额
            ,debittopamt -- 借记卡封顶金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_mcht_mcc_inf_op(
            mchnt_tp -- MCC号
            ,mchnt_tp_grp -- 商户组别
            ,descr -- MCC描述
            ,fee_rate -- 费率
            ,remark -- 备注
            ,last_oper_in -- 最后操作状态(新增,修改)
            ,rec_st -- 记录状态
            ,rec_upd_usr_id -- 最后更新柜员ID
            ,rec_upd_ts -- 更新时间
            ,rec_crt_ts -- 创建时间
            ,reserved -- 商户分类
            ,debitfee -- 借记卡费率
            ,creditfee -- 贷记卡费率
            ,credittopamt -- 贷记卡封顶金额
            ,debittopamt -- 借记卡封顶金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mchnt_tp, o.mchnt_tp) as mchnt_tp -- MCC号
    ,nvl(n.mchnt_tp_grp, o.mchnt_tp_grp) as mchnt_tp_grp -- 商户组别
    ,nvl(n.descr, o.descr) as descr -- MCC描述
    ,nvl(n.fee_rate, o.fee_rate) as fee_rate -- 费率
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.last_oper_in, o.last_oper_in) as last_oper_in -- 最后操作状态(新增,修改)
    ,nvl(n.rec_st, o.rec_st) as rec_st -- 记录状态
    ,nvl(n.rec_upd_usr_id, o.rec_upd_usr_id) as rec_upd_usr_id -- 最后更新柜员ID
    ,nvl(n.rec_upd_ts, o.rec_upd_ts) as rec_upd_ts -- 更新时间
    ,nvl(n.rec_crt_ts, o.rec_crt_ts) as rec_crt_ts -- 创建时间
    ,nvl(n.reserved, o.reserved) as reserved -- 商户分类
    ,nvl(n.debitfee, o.debitfee) as debitfee -- 借记卡费率
    ,nvl(n.creditfee, o.creditfee) as creditfee -- 贷记卡费率
    ,nvl(n.credittopamt, o.credittopamt) as credittopamt -- 贷记卡封顶金额
    ,nvl(n.debittopamt, o.debittopamt) as debittopamt -- 借记卡封顶金额
    ,case when
            n.mchnt_tp is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mchnt_tp is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mchnt_tp is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_mcht_mcc_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_mcht_mcc_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mchnt_tp = n.mchnt_tp
where (
        o.mchnt_tp is null
    )
    or (
        n.mchnt_tp is null
    )
    or (
        o.mchnt_tp_grp <> n.mchnt_tp_grp
        or o.descr <> n.descr
        or o.fee_rate <> n.fee_rate
        or o.remark <> n.remark
        or o.last_oper_in <> n.last_oper_in
        or o.rec_st <> n.rec_st
        or o.rec_upd_usr_id <> n.rec_upd_usr_id
        or o.rec_upd_ts <> n.rec_upd_ts
        or o.rec_crt_ts <> n.rec_crt_ts
        or o.reserved <> n.reserved
        or o.debitfee <> n.debitfee
        or o.creditfee <> n.creditfee
        or o.credittopamt <> n.credittopamt
        or o.debittopamt <> n.debittopamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_mcht_mcc_inf_cl(
            mchnt_tp -- MCC号
            ,mchnt_tp_grp -- 商户组别
            ,descr -- MCC描述
            ,fee_rate -- 费率
            ,remark -- 备注
            ,last_oper_in -- 最后操作状态(新增,修改)
            ,rec_st -- 记录状态
            ,rec_upd_usr_id -- 最后更新柜员ID
            ,rec_upd_ts -- 更新时间
            ,rec_crt_ts -- 创建时间
            ,reserved -- 商户分类
            ,debitfee -- 借记卡费率
            ,creditfee -- 贷记卡费率
            ,credittopamt -- 贷记卡封顶金额
            ,debittopamt -- 借记卡封顶金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_mcht_mcc_inf_op(
            mchnt_tp -- MCC号
            ,mchnt_tp_grp -- 商户组别
            ,descr -- MCC描述
            ,fee_rate -- 费率
            ,remark -- 备注
            ,last_oper_in -- 最后操作状态(新增,修改)
            ,rec_st -- 记录状态
            ,rec_upd_usr_id -- 最后更新柜员ID
            ,rec_upd_ts -- 更新时间
            ,rec_crt_ts -- 创建时间
            ,reserved -- 商户分类
            ,debitfee -- 借记卡费率
            ,creditfee -- 贷记卡费率
            ,credittopamt -- 贷记卡封顶金额
            ,debittopamt -- 借记卡封顶金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mchnt_tp -- MCC号
    ,o.mchnt_tp_grp -- 商户组别
    ,o.descr -- MCC描述
    ,o.fee_rate -- 费率
    ,o.remark -- 备注
    ,o.last_oper_in -- 最后操作状态(新增,修改)
    ,o.rec_st -- 记录状态
    ,o.rec_upd_usr_id -- 最后更新柜员ID
    ,o.rec_upd_ts -- 更新时间
    ,o.rec_crt_ts -- 创建时间
    ,o.reserved -- 商户分类
    ,o.debitfee -- 借记卡费率
    ,o.creditfee -- 贷记卡费率
    ,o.credittopamt -- 贷记卡封顶金额
    ,o.debittopamt -- 借记卡封顶金额
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
from ${iol_schema}.mrms_tbl_mcht_mcc_inf_bk o
    left join ${iol_schema}.mrms_tbl_mcht_mcc_inf_op n
        on
            o.mchnt_tp = n.mchnt_tp
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_mcht_mcc_inf_cl d
        on
            o.mchnt_tp = d.mchnt_tp
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_mcht_mcc_inf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_mcht_mcc_inf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_mcht_mcc_inf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_mcht_mcc_inf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_mcht_mcc_inf exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_mcht_mcc_inf_cl;
alter table ${iol_schema}.mrms_tbl_mcht_mcc_inf exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_mcht_mcc_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_mcht_mcc_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_mcht_mcc_inf_op purge;
drop table ${iol_schema}.mrms_tbl_mcht_mcc_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_mcht_mcc_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_mcht_mcc_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
