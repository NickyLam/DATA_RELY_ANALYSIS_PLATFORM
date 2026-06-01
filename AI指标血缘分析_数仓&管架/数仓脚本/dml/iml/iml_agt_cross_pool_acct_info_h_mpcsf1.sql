/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cross_pool_acct_info_h_mpcsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_cross_pool_acct_info_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cross_pool_acct_info_h partition for ('mpcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,init_agt_id -- 原协议编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,net_flow_in_lmt -- 净流入额度
    ,used_lmt -- 已使用额度
    ,insto_dt -- 入库日期
    ,agt_status_cd -- 协议状态代码
    ,final_modif_tm -- 最后修改时间
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cross_pool_acct_info_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cross_pool_acct_info_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cross_pool_acct_info_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a08tcrossacct-1
insert into ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,init_agt_id -- 原协议编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,net_flow_in_lmt -- 净流入额度
    ,used_lmt -- 已使用额度
    ,insto_dt -- 入库日期
    ,agt_status_cd -- 协议状态代码
    ,final_modif_tm -- 最后修改时间
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130021'||P1.ACCOUNTNUMBER||P1.CONTRACTNUMBER -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTRACTNUMBER -- 原协议编号
    ,P1.ACCOUNTNUMBER -- 账户编号
    ,P1.ACCOUNTNAME -- 账户名称
    ,P1.AMOUNTLIMIT -- 净流入额度
    ,P1.AMOUNT -- 已使用额度
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.SIGNDATE,1,8)) -- 入库日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SIGNFLAG END -- 协议状态代码
    ,${iml_schema}.TIMEFORMAT_MAX(P1.UPDT） -- 最后修改时间
    ,P1.CUSTNO -- 客户编号
    ,P1.SRCSEQNO -- 交易流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a08tcrossacct' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08tcrossacct p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SIGNFLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A08TCROSSACCT'
        AND R1.SRC_FIELD_EN_NAME= 'SIGNFLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CROSS_POOL_ACCT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'AGT_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,init_agt_id -- 原协议编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,net_flow_in_lmt -- 净流入额度
    ,used_lmt -- 已使用额度
    ,insto_dt -- 入库日期
    ,agt_status_cd -- 协议状态代码
    ,final_modif_tm -- 最后修改时间
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,init_agt_id -- 原协议编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,net_flow_in_lmt -- 净流入额度
    ,used_lmt -- 已使用额度
    ,insto_dt -- 入库日期
    ,agt_status_cd -- 协议状态代码
    ,final_modif_tm -- 最后修改时间
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.init_agt_id, o.init_agt_id) as init_agt_id -- 原协议编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.net_flow_in_lmt, o.net_flow_in_lmt) as net_flow_in_lmt -- 净流入额度
    ,nvl(n.used_lmt, o.used_lmt) as used_lmt -- 已使用额度
    ,nvl(n.insto_dt, o.insto_dt) as insto_dt -- 入库日期
    ,nvl(n.agt_status_cd, o.agt_status_cd) as agt_status_cd -- 协议状态代码
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.init_agt_id <> n.init_agt_id
        or o.acct_id <> n.acct_id
        or o.acct_name <> n.acct_name
        or o.net_flow_in_lmt <> n.net_flow_in_lmt
        or o.used_lmt <> n.used_lmt
        or o.insto_dt <> n.insto_dt
        or o.agt_status_cd <> n.agt_status_cd
        or o.final_modif_tm <> n.final_modif_tm
        or o.cust_id <> n.cust_id
        or o.tran_flow_num <> n.tran_flow_num
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,init_agt_id -- 原协议编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,net_flow_in_lmt -- 净流入额度
    ,used_lmt -- 已使用额度
    ,insto_dt -- 入库日期
    ,agt_status_cd -- 协议状态代码
    ,final_modif_tm -- 最后修改时间
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,init_agt_id -- 原协议编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,net_flow_in_lmt -- 净流入额度
    ,used_lmt -- 已使用额度
    ,insto_dt -- 入库日期
    ,agt_status_cd -- 协议状态代码
    ,final_modif_tm -- 最后修改时间
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.init_agt_id -- 原协议编号
    ,o.acct_id -- 账户编号
    ,o.acct_name -- 账户名称
    ,o.net_flow_in_lmt -- 净流入额度
    ,o.used_lmt -- 已使用额度
    ,o.insto_dt -- 入库日期
    ,o.agt_status_cd -- 协议状态代码
    ,o.final_modif_tm -- 最后修改时间
    ,o.cust_id -- 客户编号
    ,o.tran_flow_num -- 交易流水号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_bk o
    left join ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cross_pool_acct_info_h;
alter table ${iml_schema}.agt_cross_pool_acct_info_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_cross_pool_acct_info_h exchange subpartition p_mpcsf1_19000101 with table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_cl;
alter table ${iml_schema}.agt_cross_pool_acct_info_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cross_pool_acct_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cross_pool_acct_info_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cross_pool_acct_info_h', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
