/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_send_out_coll_batch_bdmsf1
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
alter table ${iml_schema}.agt_send_out_coll_batch add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_send_out_coll_batch partition for ('bdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_op purge;
drop table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    send_out_coll_batch_id -- 发出托收批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_attr_cd -- 票据属性代码
    ,bill_type_cd -- 票据类型代码
    ,coll_dt -- 托收日期
    ,coll_cntpty_bk_no -- 托收对方行行号
    ,ems_id -- EMS编号
    ,oper_status_cd -- 操作状态代码
    ,clear_way_cd -- 清算方式代码
    ,entry_status_cd -- 记账状态代码
    ,check_status_cd -- 审核状态代码
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,final_modif_tm -- 最后修改时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_send_out_coll_batch partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_send_out_coll_batch partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_send_out_coll_batch partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_send_collection_batch-
insert into ${iml_schema}.agt_send_out_coll_batch_bdmsf1_tm(
    send_out_coll_batch_id -- 发出托收批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_attr_cd -- 票据属性代码
    ,bill_type_cd -- 票据类型代码
    ,coll_dt -- 托收日期
    ,coll_cntpty_bk_no -- 托收对方行行号
    ,ems_id -- EMS编号
    ,oper_status_cd -- 操作状态代码
    ,clear_way_cd -- 清算方式代码
    ,entry_status_cd -- 记账状态代码
    ,check_status_cd -- 审核状态代码
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.ID) -- 发出托收批次编号
    ,'9999' -- 法人编号
    ,NVL(P2.brh_no,' ') -- 机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据属性代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.COLLECTION_DATE) -- 托收日期
    ,TO_CHAR(P1.UBANK_ID) -- 托收对方行行号
    ,P1.EMS_NO -- EMS编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 操作状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.STTLM_MK END -- 清算方式代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,NVL(TRIM(P1.AUDIT_STATUS),'-') -- 审核状态代码
    ,CASE WHEN P3.ID IS NOT NULL THEN P3.opr_no 
     WHEN P1.OPERATOR_ID = 0 THEN ' ' 
     ELSE TO_CHAR(P1.OPERATOR_ID)
END  -- 操作柜员编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.TXN_DATE) -- 操作日期
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.LAST_UPD_TIME),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 最后修改时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_send_collection_batch' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_send_collection_batch p1
    left join ${iol_schema}.bdms_branch_info p2 on P1.BRANCH_ID=P2.ID AND  P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DRAFT_ATTR = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_SEND_COLLECTION_BATCH'
        AND R1.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_SEND_OUT_COLL_BATCH'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_ATTR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_SEND_COLLECTION_BATCH'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_SEND_OUT_COLL_BATCH'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.STATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_SEND_COLLECTION_BATCH'
        AND R3.SRC_FIELD_EN_NAME= 'STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_SEND_OUT_COLL_BATCH'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'OPER_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.STTLM_MK = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_SEND_COLLECTION_BATCH'
        AND R4.SRC_FIELD_EN_NAME= 'STTLM_MK'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_SEND_OUT_COLL_BATCH'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.ACCOUNT_STATUS = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_SEND_COLLECTION_BATCH'
        AND R5.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_SEND_OUT_COLL_BATCH'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
    left join ${iol_schema}.bdms_operator p3 on P1.operator_id=P3.ID AND  P3.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P3.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_send_out_coll_batch_bdmsf1_cl(
            send_out_coll_batch_id -- 发出托收批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_attr_cd -- 票据属性代码
    ,bill_type_cd -- 票据类型代码
    ,coll_dt -- 托收日期
    ,coll_cntpty_bk_no -- 托收对方行行号
    ,ems_id -- EMS编号
    ,oper_status_cd -- 操作状态代码
    ,clear_way_cd -- 清算方式代码
    ,entry_status_cd -- 记账状态代码
    ,check_status_cd -- 审核状态代码
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_send_out_coll_batch_bdmsf1_op(
            send_out_coll_batch_id -- 发出托收批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_attr_cd -- 票据属性代码
    ,bill_type_cd -- 票据类型代码
    ,coll_dt -- 托收日期
    ,coll_cntpty_bk_no -- 托收对方行行号
    ,ems_id -- EMS编号
    ,oper_status_cd -- 操作状态代码
    ,clear_way_cd -- 清算方式代码
    ,entry_status_cd -- 记账状态代码
    ,check_status_cd -- 审核状态代码
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.send_out_coll_batch_id, o.send_out_coll_batch_id) as send_out_coll_batch_id -- 发出托收批次编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.bill_attr_cd, o.bill_attr_cd) as bill_attr_cd -- 票据属性代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.coll_dt, o.coll_dt) as coll_dt -- 托收日期
    ,nvl(n.coll_cntpty_bk_no, o.coll_cntpty_bk_no) as coll_cntpty_bk_no -- 托收对方行行号
    ,nvl(n.ems_id, o.ems_id) as ems_id -- EMS编号
    ,nvl(n.oper_status_cd, o.oper_status_cd) as oper_status_cd -- 操作状态代码
    ,nvl(n.clear_way_cd, o.clear_way_cd) as clear_way_cd -- 清算方式代码
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.check_status_cd, o.check_status_cd) as check_status_cd -- 审核状态代码
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 操作日期
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,case when
            n.send_out_coll_batch_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.send_out_coll_batch_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.send_out_coll_batch_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_send_out_coll_batch_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_send_out_coll_batch_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.send_out_coll_batch_id = n.send_out_coll_batch_id
            and o.lp_id = n.lp_id
where (
        o.send_out_coll_batch_id is null
        and o.lp_id is null
    )
    or (
        n.send_out_coll_batch_id is null
        and n.lp_id is null
    )
    or (
        o.org_id <> n.org_id
        or o.bill_attr_cd <> n.bill_attr_cd
        or o.bill_type_cd <> n.bill_type_cd
        or o.coll_dt <> n.coll_dt
        or o.coll_cntpty_bk_no <> n.coll_cntpty_bk_no
        or o.ems_id <> n.ems_id
        or o.oper_status_cd <> n.oper_status_cd
        or o.clear_way_cd <> n.clear_way_cd
        or o.entry_status_cd <> n.entry_status_cd
        or o.check_status_cd <> n.check_status_cd
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_dt <> n.oper_dt
        or o.final_modif_tm <> n.final_modif_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_send_out_coll_batch_bdmsf1_cl(
            send_out_coll_batch_id -- 发出托收批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_attr_cd -- 票据属性代码
    ,bill_type_cd -- 票据类型代码
    ,coll_dt -- 托收日期
    ,coll_cntpty_bk_no -- 托收对方行行号
    ,ems_id -- EMS编号
    ,oper_status_cd -- 操作状态代码
    ,clear_way_cd -- 清算方式代码
    ,entry_status_cd -- 记账状态代码
    ,check_status_cd -- 审核状态代码
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_send_out_coll_batch_bdmsf1_op(
            send_out_coll_batch_id -- 发出托收批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_attr_cd -- 票据属性代码
    ,bill_type_cd -- 票据类型代码
    ,coll_dt -- 托收日期
    ,coll_cntpty_bk_no -- 托收对方行行号
    ,ems_id -- EMS编号
    ,oper_status_cd -- 操作状态代码
    ,clear_way_cd -- 清算方式代码
    ,entry_status_cd -- 记账状态代码
    ,check_status_cd -- 审核状态代码
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.send_out_coll_batch_id -- 发出托收批次编号
    ,o.lp_id -- 法人编号
    ,o.org_id -- 机构编号
    ,o.bill_attr_cd -- 票据属性代码
    ,o.bill_type_cd -- 票据类型代码
    ,o.coll_dt -- 托收日期
    ,o.coll_cntpty_bk_no -- 托收对方行行号
    ,o.ems_id -- EMS编号
    ,o.oper_status_cd -- 操作状态代码
    ,o.clear_way_cd -- 清算方式代码
    ,o.entry_status_cd -- 记账状态代码
    ,o.check_status_cd -- 审核状态代码
    ,o.oper_teller_id -- 操作柜员编号
    ,o.oper_dt -- 操作日期
    ,o.final_modif_tm -- 最后修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_send_out_coll_batch_bdmsf1_bk o
    left join ${iml_schema}.agt_send_out_coll_batch_bdmsf1_op n
        on
            o.send_out_coll_batch_id = n.send_out_coll_batch_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_send_out_coll_batch_bdmsf1_cl d
        on
            o.send_out_coll_batch_id = d.send_out_coll_batch_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_send_out_coll_batch;
alter table ${iml_schema}.agt_send_out_coll_batch truncate partition for ('bdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_send_out_coll_batch exchange subpartition p_bdmsf1_19000101 with table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_cl;
alter table ${iml_schema}.agt_send_out_coll_batch exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_send_out_coll_batch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_op purge;
drop table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_send_out_coll_batch_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_send_out_coll_batch', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
