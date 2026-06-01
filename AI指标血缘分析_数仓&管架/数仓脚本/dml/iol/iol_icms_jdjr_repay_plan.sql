/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_jdjr_repay_plan
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.icms_jdjr_repay_plan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_jdjr_repay_plan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_repay_plan_op purge;
drop table ${iol_schema}.icms_jdjr_repay_plan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_repay_plan_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_jdjr_repay_plan where 0=1;

create table ${iol_schema}.icms_jdjr_repay_plan_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_jdjr_repay_plan where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_jdjr_repay_plan_op(
        repaychangetype -- 新增还款变更类型
        ,termno -- 分期单号
        ,prinrepaydt -- 本金到期日
        ,enchashfee -- 取现手续费
        ,lastovdstatus -- 前一天逾期状态
        ,bussdate -- 业务日期
        ,repaytermno -- 还款期数
        ,volfee -- 违约金
        ,lastovddays -- 前一天逾期天数
        ,termtype -- 期数类型
        ,pnltrepaybalance -- 待还罚息
        ,curovddays -- 当前逾期天数
        ,prdno -- 产品编号
        ,loanno -- 贷款编号
        ,realityrate -- 分期单执行费率
        ,ovddays -- 逾期天数
        ,intrepaydt -- 利息到期日
        ,repayterms -- 还款总期数
        ,migtflag -- 
        ,intrepaybalance -- 待还利息
        ,limitno -- 额度编号
        ,enchashfeeenddate -- 取现手续费到期日
        ,prdcode -- 产品编号（行内）
        ,prinrepaybalance -- 待还本金
        ,contno -- 合同号
        ,curovdstatus -- 当前逾期状态
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.repaychangetype -- 新增还款变更类型
    ,n.termno -- 分期单号
    ,n.prinrepaydt -- 本金到期日
    ,n.enchashfee -- 取现手续费
    ,n.lastovdstatus -- 前一天逾期状态
    ,n.bussdate -- 业务日期
    ,n.repaytermno -- 还款期数
    ,n.volfee -- 违约金
    ,n.lastovddays -- 前一天逾期天数
    ,n.termtype -- 期数类型
    ,n.pnltrepaybalance -- 待还罚息
    ,n.curovddays -- 当前逾期天数
    ,n.prdno -- 产品编号
    ,n.loanno -- 贷款编号
    ,n.realityrate -- 分期单执行费率
    ,n.ovddays -- 逾期天数
    ,n.intrepaydt -- 利息到期日
    ,n.repayterms -- 还款总期数
    ,n.migtflag -- 
    ,n.intrepaybalance -- 待还利息
    ,n.limitno -- 额度编号
    ,n.enchashfeeenddate -- 取现手续费到期日
    ,n.prdcode -- 产品编号（行内）
    ,n.prinrepaybalance -- 待还本金
    ,n.contno -- 合同号
    ,n.curovdstatus -- 当前逾期状态
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_jdjr_repay_plan_bk o
    right join (select * from ${itl_schema}.icms_jdjr_repay_plan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.repaychangetype = n.repaychangetype
            and o.termno = n.termno
where (
        o.repaychangetype is null
        and o.termno is null
    )
    or (
        o.prinrepaydt <> n.prinrepaydt
        or o.enchashfee <> n.enchashfee
        or o.lastovdstatus <> n.lastovdstatus
        or o.bussdate <> n.bussdate
        or o.repaytermno <> n.repaytermno
        or o.volfee <> n.volfee
        or o.lastovddays <> n.lastovddays
        or o.termtype <> n.termtype
        or o.pnltrepaybalance <> n.pnltrepaybalance
        or o.curovddays <> n.curovddays
        or o.prdno <> n.prdno
        or o.loanno <> n.loanno
        or o.realityrate <> n.realityrate
        or o.ovddays <> n.ovddays
        or o.intrepaydt <> n.intrepaydt
        or o.repayterms <> n.repayterms
        or o.migtflag <> n.migtflag
        or o.intrepaybalance <> n.intrepaybalance
        or o.limitno <> n.limitno
        or o.enchashfeeenddate <> n.enchashfeeenddate
        or o.prdcode <> n.prdcode
        or o.prinrepaybalance <> n.prinrepaybalance
        or o.contno <> n.contno
        or o.curovdstatus <> n.curovdstatus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_jdjr_repay_plan_cl(
            repaychangetype -- 新增还款变更类型
        ,termno -- 分期单号
        ,prinrepaydt -- 本金到期日
        ,enchashfee -- 取现手续费
        ,lastovdstatus -- 前一天逾期状态
        ,bussdate -- 业务日期
        ,repaytermno -- 还款期数
        ,volfee -- 违约金
        ,lastovddays -- 前一天逾期天数
        ,termtype -- 期数类型
        ,pnltrepaybalance -- 待还罚息
        ,curovddays -- 当前逾期天数
        ,prdno -- 产品编号
        ,loanno -- 贷款编号
        ,realityrate -- 分期单执行费率
        ,ovddays -- 逾期天数
        ,intrepaydt -- 利息到期日
        ,repayterms -- 还款总期数
        ,migtflag -- 
        ,intrepaybalance -- 待还利息
        ,limitno -- 额度编号
        ,enchashfeeenddate -- 取现手续费到期日
        ,prdcode -- 产品编号（行内）
        ,prinrepaybalance -- 待还本金
        ,contno -- 合同号
        ,curovdstatus -- 当前逾期状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_jdjr_repay_plan_op(
            repaychangetype -- 新增还款变更类型
        ,termno -- 分期单号
        ,prinrepaydt -- 本金到期日
        ,enchashfee -- 取现手续费
        ,lastovdstatus -- 前一天逾期状态
        ,bussdate -- 业务日期
        ,repaytermno -- 还款期数
        ,volfee -- 违约金
        ,lastovddays -- 前一天逾期天数
        ,termtype -- 期数类型
        ,pnltrepaybalance -- 待还罚息
        ,curovddays -- 当前逾期天数
        ,prdno -- 产品编号
        ,loanno -- 贷款编号
        ,realityrate -- 分期单执行费率
        ,ovddays -- 逾期天数
        ,intrepaydt -- 利息到期日
        ,repayterms -- 还款总期数
        ,migtflag -- 
        ,intrepaybalance -- 待还利息
        ,limitno -- 额度编号
        ,enchashfeeenddate -- 取现手续费到期日
        ,prdcode -- 产品编号（行内）
        ,prinrepaybalance -- 待还本金
        ,contno -- 合同号
        ,curovdstatus -- 当前逾期状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.repaychangetype -- 新增还款变更类型
    ,o.termno -- 分期单号
    ,o.prinrepaydt -- 本金到期日
    ,o.enchashfee -- 取现手续费
    ,o.lastovdstatus -- 前一天逾期状态
    ,o.bussdate -- 业务日期
    ,o.repaytermno -- 还款期数
    ,o.volfee -- 违约金
    ,o.lastovddays -- 前一天逾期天数
    ,o.termtype -- 期数类型
    ,o.pnltrepaybalance -- 待还罚息
    ,o.curovddays -- 当前逾期天数
    ,o.prdno -- 产品编号
    ,o.loanno -- 贷款编号
    ,o.realityrate -- 分期单执行费率
    ,o.ovddays -- 逾期天数
    ,o.intrepaydt -- 利息到期日
    ,o.repayterms -- 还款总期数
    ,o.migtflag -- 
    ,o.intrepaybalance -- 待还利息
    ,o.limitno -- 额度编号
    ,o.enchashfeeenddate -- 取现手续费到期日
    ,o.prdcode -- 产品编号（行内）
    ,o.prinrepaybalance -- 待还本金
    ,o.contno -- 合同号
    ,o.curovdstatus -- 当前逾期状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_jdjr_repay_plan_bk o
    left join ${iol_schema}.icms_jdjr_repay_plan_op n
        on
            o.repaychangetype = n.repaychangetype
            and o.termno = n.termno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_jdjr_repay_plan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_jdjr_repay_plan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_jdjr_repay_plan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_jdjr_repay_plan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_jdjr_repay_plan exchange partition p_${batch_date} with table ${iol_schema}.icms_jdjr_repay_plan_cl;
alter table ${iol_schema}.icms_jdjr_repay_plan exchange partition p_20991231 with table ${iol_schema}.icms_jdjr_repay_plan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_jdjr_repay_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_repay_plan_op purge;
drop table ${iol_schema}.icms_jdjr_repay_plan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_jdjr_repay_plan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_jdjr_repay_plan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
