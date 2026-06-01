/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ym_fund_nv_h_mpcsi1
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
alter table ${iml_schema}.prd_ym_fund_nv_h add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ym_fund_nv_h partition for ('mpcsi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_tm purge;
drop table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_op purge;
drop table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_dt -- 净值日期
    ,fund_cd -- 基金代码
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,daily_incr -- 每日涨幅
    ,ten_thous_prft -- 万份收益
    ,sevn_aual_yld -- 七日年化收益率
    ,status_dt -- 状态日期
    ,fund_status_cd -- 基金状态代码
    ,fund_tran_status_cd -- 基金转换状态代码
    ,aip_status_cd -- 定投状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ym_fund_nv_h partition for ('mpcsi1')
where 0=1
;

create table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ym_fund_nv_h partition for ('mpcsi1') where 0=1;

create table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ym_fund_nv_h partition for ('mpcsi1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a92fundmarket-
insert into ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_dt -- 净值日期
    ,fund_cd -- 基金代码
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,daily_incr -- 每日涨幅
    ,ten_thous_prft -- 万份收益
    ,sevn_aual_yld -- 七日年化收益率
    ,status_dt -- 状态日期
    ,fund_status_cd -- 基金状态代码
    ,fund_tran_status_cd -- 基金转换状态代码
    ,aip_status_cd -- 定投状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223007'||P1.FUNDCODE -- 产品编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_max(P1.NAVDATE) -- 净值日期
    ,P1.FUNDCODE -- 基金代码
    ,P1.PAYSYS -- 服务平台简称
    ,P1.INSTID -- 商户编号
    ,P1.NAV -- 单位净值
    ,P1.ACCUMULATEDNAV -- 累计净值
    ,P1.RETURNDAY -- 每日涨幅
    ,P1.UNITYIELD -- 万份收益
    ,P1.YEARLYROE -- 七日年化收益率
    ,${iml_schema}.dateformat_max(P1.STATUSDATE) -- 状态日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FUNDSTATUS END -- 基金状态代码
    ,nvl(trim(P1.CONVERTSTATUS),'-') -- 基金转换状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.INVESTPLANSTATUS END -- 定投状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a92fundmarket' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a92fundmarket p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.FUNDSTATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A92FUNDMARKET'
        AND R3.SRC_FIELD_EN_NAME= 'FUNDSTATUS'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_YM_FUND_NV_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'FUND_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.INVESTPLANSTATUS = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A92FUNDMARKET'
        AND R4.SRC_FIELD_EN_NAME= 'INVESTPLANSTATUS'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_YM_FUND_NV_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'AIP_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.NAVDATE = '${batch_date}'
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_op(
        prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_dt -- 净值日期
    ,fund_cd -- 基金代码
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,daily_incr -- 每日涨幅
    ,ten_thous_prft -- 万份收益
    ,sevn_aual_yld -- 七日年化收益率
    ,status_dt -- 状态日期
    ,fund_status_cd -- 基金状态代码
    ,fund_tran_status_cd -- 基金转换状态代码
    ,aip_status_cd -- 定投状态代码
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.prod_id -- 产品编号
    ,n.lp_id -- 法人编号
    ,n.nv_dt -- 净值日期
    ,n.fund_cd -- 基金代码
    ,n.serv_plat_abbr -- 服务平台简称
    ,n.mercht_id -- 商户编号
    ,n.corp_nv -- 单位净值
    ,n.acm_nv -- 累计净值
    ,n.daily_incr -- 每日涨幅
    ,n.ten_thous_prft -- 万份收益
    ,n.sevn_aual_yld -- 七日年化收益率
    ,n.status_dt -- 状态日期
    ,n.fund_status_cd -- 基金状态代码
    ,n.fund_tran_status_cd -- 基金转换状态代码
    ,n.aip_status_cd -- 定投状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'mpcsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_tm n
    left join (select * from ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.nv_dt = n.nv_dt
where (
        o.prod_id is null
        and o.lp_id is null
        and o.nv_dt is null
    )
    or (
        o.fund_cd <> n.fund_cd
        or o.serv_plat_abbr <> n.serv_plat_abbr
        or o.mercht_id <> n.mercht_id
        or o.corp_nv <> n.corp_nv
        or o.acm_nv <> n.acm_nv
        or o.daily_incr <> n.daily_incr
        or o.ten_thous_prft <> n.ten_thous_prft
        or o.sevn_aual_yld <> n.sevn_aual_yld
        or o.status_dt <> n.status_dt
        or o.fund_status_cd <> n.fund_status_cd
        or o.fund_tran_status_cd <> n.fund_tran_status_cd
        or o.aip_status_cd <> n.aip_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_dt -- 净值日期
    ,fund_cd -- 基金代码
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,daily_incr -- 每日涨幅
    ,ten_thous_prft -- 万份收益
    ,sevn_aual_yld -- 七日年化收益率
    ,status_dt -- 状态日期
    ,fund_status_cd -- 基金状态代码
    ,fund_tran_status_cd -- 基金转换状态代码
    ,aip_status_cd -- 定投状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_dt -- 净值日期
    ,fund_cd -- 基金代码
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,daily_incr -- 每日涨幅
    ,ten_thous_prft -- 万份收益
    ,sevn_aual_yld -- 七日年化收益率
    ,status_dt -- 状态日期
    ,fund_status_cd -- 基金状态代码
    ,fund_tran_status_cd -- 基金转换状态代码
    ,aip_status_cd -- 定投状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.nv_dt -- 净值日期
    ,o.fund_cd -- 基金代码
    ,o.serv_plat_abbr -- 服务平台简称
    ,o.mercht_id -- 商户编号
    ,o.corp_nv -- 单位净值
    ,o.acm_nv -- 累计净值
    ,o.daily_incr -- 每日涨幅
    ,o.ten_thous_prft -- 万份收益
    ,o.sevn_aual_yld -- 七日年化收益率
    ,o.status_dt -- 状态日期
    ,o.fund_status_cd -- 基金状态代码
    ,o.fund_tran_status_cd -- 基金转换状态代码
    ,o.aip_status_cd -- 定投状态代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_bk o
    left join ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.nv_dt = n.nv_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_ym_fund_nv_h;
alter table ${iml_schema}.prd_ym_fund_nv_h truncate partition for ('mpcsi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_ym_fund_nv_h exchange subpartition p_mpcsi1_19000101 with table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_cl;
alter table ${iml_schema}.prd_ym_fund_nv_h exchange subpartition p_mpcsi1_20991231 with table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ym_fund_nv_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_tm purge;
drop table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_op purge;
drop table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_ym_fund_nv_h_mpcsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ym_fund_nv_h', partname => 'p_mpcsi1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
