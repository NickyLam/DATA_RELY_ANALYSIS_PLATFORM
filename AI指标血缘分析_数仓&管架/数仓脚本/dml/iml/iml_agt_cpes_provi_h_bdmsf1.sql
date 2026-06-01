/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cpes_provi_h_bdmsf1
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
alter table ${iml_schema}.agt_cpes_provi_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cpes_provi_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cpes_provi_h partition for ('bdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cpes_provi_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_cpes_provi_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_cpes_provi_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cpes_provi_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    provi_mtbl_id -- 计提主表编号
    ,lp_id -- 法人编号
    ,hq_org_id -- 总行机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_id -- 批次编号
    ,agt_id -- 协议编号
    ,dtl_id -- 明细编号
    ,bill_id -- 票据编号
    ,bus_prod_id -- 业务产品编号
    ,interest -- 利息
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,actl_end_provi_dt -- 实际结束计提日期
    ,provi_dt -- 计提日期
    ,int_accr_exp_dt -- 计息到期日期
    ,int_accr_days -- 计息天数
    ,provied_int -- 已计提利息
    ,surp_int -- 剩余利息
    ,daily_provi_amt -- 每日计提金额
    ,provi_bus_type_cd -- 计提业务类型代码
    ,provi_status_cd -- 计提状态代码
    ,provi_excep_cd -- 计提异常代码
    ,acct_instit_id -- 账务机构编号
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_num -- 票据号码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cpes_provi_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_cpes_provi_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cpes_provi_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_cpes_provi_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cpes_provi_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_provision-
insert into ${iml_schema}.agt_cpes_provi_h_bdmsf1_tm(
    provi_mtbl_id -- 计提主表编号
    ,lp_id -- 法人编号
    ,hq_org_id -- 总行机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_id -- 批次编号
    ,agt_id -- 协议编号
    ,dtl_id -- 明细编号
    ,bill_id -- 票据编号
    ,bus_prod_id -- 业务产品编号
    ,interest -- 利息
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,actl_end_provi_dt -- 实际结束计提日期
    ,provi_dt -- 计提日期
    ,int_accr_exp_dt -- 计息到期日期
    ,int_accr_days -- 计息天数
    ,provied_int -- 已计提利息
    ,surp_int -- 剩余利息
    ,daily_provi_amt -- 每日计提金额
    ,provi_bus_type_cd -- 计提业务类型代码
    ,provi_status_cd -- 计提状态代码
    ,provi_excep_cd -- 计提异常代码
    ,acct_instit_id -- 账务机构编号
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_num -- 票据号码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PROV_ID -- 计提主表编号
    ,'9999' -- 法人编号
    ,P1.TOP_BRANCH_NO -- 总行机构编号
    ,P1.BUSI_BRANCH_NO -- 交易机构编号
    ,P1.CONTRACT_ID -- 批次编号
    ,CASE WHEN P1.JITI_TYPE='7' THEN '223104'||P1.DETAIL_ID ELSE '223103'||P1.DETAIL_ID END -- 协议编号
    ,P1.DETAIL_ID -- 明细编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.PRODUCT_NO -- 业务产品编号
    ,P1.INTEREST -- 利息
    ,${iml_schema}.DATEFORMAT_MIN(P1.START_DT_ORA) -- 计提开始日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.END_DT_ORA) -- 计提结束日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.REAL_ENDDT) -- 实际结束计提日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.JITI_DT) -- 计提日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.PAYMENT_DATE) -- 计息到期日期
    ,P1.PAYMENT_DAYS -- 计息天数
    ,P1.PROV_INTEREST -- 已计提利息
    ,P1.REMA_INTEREST -- 剩余利息
    ,P1.EVER_PRO_AMOUNT -- 每日计提金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.JITI_TYPE END -- 计提业务类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 计提状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ERR_FLAG END -- 计提异常代码
    ,P1.ACCT_BRANCH_NO -- 账务机构编号
    ,P1.CD_RANGE -- 票据子区间号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_provision' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_provision p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.JITI_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_PROVISION'
        AND R1.SRC_FIELD_EN_NAME= 'JITI_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CPES_PROVI_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PROVI_BUS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_PROVISION'
        AND R2.SRC_FIELD_EN_NAME= 'STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_CPES_PROVI_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROVI_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ERR_FLAG = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_BMS_PROVISION'
        AND R3.SRC_FIELD_EN_NAME= 'ERR_FLAG'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_CPES_PROVI_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PROVI_EXCEP_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cpes_provi_h_bdmsf1_tm 
  	                                group by 
  	                                        provi_mtbl_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cpes_provi_h_bdmsf1_cl(
            provi_mtbl_id -- 计提主表编号
    ,lp_id -- 法人编号
    ,hq_org_id -- 总行机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_id -- 批次编号
    ,agt_id -- 协议编号
    ,dtl_id -- 明细编号
    ,bill_id -- 票据编号
    ,bus_prod_id -- 业务产品编号
    ,interest -- 利息
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,actl_end_provi_dt -- 实际结束计提日期
    ,provi_dt -- 计提日期
    ,int_accr_exp_dt -- 计息到期日期
    ,int_accr_days -- 计息天数
    ,provied_int -- 已计提利息
    ,surp_int -- 剩余利息
    ,daily_provi_amt -- 每日计提金额
    ,provi_bus_type_cd -- 计提业务类型代码
    ,provi_status_cd -- 计提状态代码
    ,provi_excep_cd -- 计提异常代码
    ,acct_instit_id -- 账务机构编号
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_num -- 票据号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cpes_provi_h_bdmsf1_op(
            provi_mtbl_id -- 计提主表编号
    ,lp_id -- 法人编号
    ,hq_org_id -- 总行机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_id -- 批次编号
    ,agt_id -- 协议编号
    ,dtl_id -- 明细编号
    ,bill_id -- 票据编号
    ,bus_prod_id -- 业务产品编号
    ,interest -- 利息
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,actl_end_provi_dt -- 实际结束计提日期
    ,provi_dt -- 计提日期
    ,int_accr_exp_dt -- 计息到期日期
    ,int_accr_days -- 计息天数
    ,provied_int -- 已计提利息
    ,surp_int -- 剩余利息
    ,daily_provi_amt -- 每日计提金额
    ,provi_bus_type_cd -- 计提业务类型代码
    ,provi_status_cd -- 计提状态代码
    ,provi_excep_cd -- 计提异常代码
    ,acct_instit_id -- 账务机构编号
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_num -- 票据号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.provi_mtbl_id, o.provi_mtbl_id) as provi_mtbl_id -- 计提主表编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.hq_org_id, o.hq_org_id) as hq_org_id -- 总行机构编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.dtl_id, o.dtl_id) as dtl_id -- 明细编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bus_prod_id, o.bus_prod_id) as bus_prod_id -- 业务产品编号
    ,nvl(n.interest, o.interest) as interest -- 利息
    ,nvl(n.provi_start_dt, o.provi_start_dt) as provi_start_dt -- 计提开始日期
    ,nvl(n.provi_end_dt, o.provi_end_dt) as provi_end_dt -- 计提结束日期
    ,nvl(n.actl_end_provi_dt, o.actl_end_provi_dt) as actl_end_provi_dt -- 实际结束计提日期
    ,nvl(n.provi_dt, o.provi_dt) as provi_dt -- 计提日期
    ,nvl(n.int_accr_exp_dt, o.int_accr_exp_dt) as int_accr_exp_dt -- 计息到期日期
    ,nvl(n.int_accr_days, o.int_accr_days) as int_accr_days -- 计息天数
    ,nvl(n.provied_int, o.provied_int) as provied_int -- 已计提利息
    ,nvl(n.surp_int, o.surp_int) as surp_int -- 剩余利息
    ,nvl(n.daily_provi_amt, o.daily_provi_amt) as daily_provi_amt -- 每日计提金额
    ,nvl(n.provi_bus_type_cd, o.provi_bus_type_cd) as provi_bus_type_cd -- 计提业务类型代码
    ,nvl(n.provi_status_cd, o.provi_status_cd) as provi_status_cd -- 计提状态代码
    ,nvl(n.provi_excep_cd, o.provi_excep_cd) as provi_excep_cd -- 计提异常代码
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,case when
            n.provi_mtbl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.provi_mtbl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.provi_mtbl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cpes_provi_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_cpes_provi_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.provi_mtbl_id = n.provi_mtbl_id
            and o.lp_id = n.lp_id
where (
        o.provi_mtbl_id is null
        and o.lp_id is null
    )
    or (
        n.provi_mtbl_id is null
        and n.lp_id is null
    )
    or (
        o.hq_org_id <> n.hq_org_id
        or o.tran_org_id <> n.tran_org_id
        or o.batch_id <> n.batch_id
        or o.agt_id <> n.agt_id
        or o.dtl_id <> n.dtl_id
        or o.bill_id <> n.bill_id
        or o.bus_prod_id <> n.bus_prod_id
        or o.interest <> n.interest
        or o.provi_start_dt <> n.provi_start_dt
        or o.provi_end_dt <> n.provi_end_dt
        or o.actl_end_provi_dt <> n.actl_end_provi_dt
        or o.provi_dt <> n.provi_dt
        or o.int_accr_exp_dt <> n.int_accr_exp_dt
        or o.int_accr_days <> n.int_accr_days
        or o.provied_int <> n.provied_int
        or o.surp_int <> n.surp_int
        or o.daily_provi_amt <> n.daily_provi_amt
        or o.provi_bus_type_cd <> n.provi_bus_type_cd
        or o.provi_status_cd <> n.provi_status_cd
        or o.provi_excep_cd <> n.provi_excep_cd
        or o.acct_instit_id <> n.acct_instit_id
        or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
        or o.bill_num <> n.bill_num
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cpes_provi_h_bdmsf1_cl(
            provi_mtbl_id -- 计提主表编号
    ,lp_id -- 法人编号
    ,hq_org_id -- 总行机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_id -- 批次编号
    ,agt_id -- 协议编号
    ,dtl_id -- 明细编号
    ,bill_id -- 票据编号
    ,bus_prod_id -- 业务产品编号
    ,interest -- 利息
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,actl_end_provi_dt -- 实际结束计提日期
    ,provi_dt -- 计提日期
    ,int_accr_exp_dt -- 计息到期日期
    ,int_accr_days -- 计息天数
    ,provied_int -- 已计提利息
    ,surp_int -- 剩余利息
    ,daily_provi_amt -- 每日计提金额
    ,provi_bus_type_cd -- 计提业务类型代码
    ,provi_status_cd -- 计提状态代码
    ,provi_excep_cd -- 计提异常代码
    ,acct_instit_id -- 账务机构编号
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_num -- 票据号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cpes_provi_h_bdmsf1_op(
            provi_mtbl_id -- 计提主表编号
    ,lp_id -- 法人编号
    ,hq_org_id -- 总行机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_id -- 批次编号
    ,agt_id -- 协议编号
    ,dtl_id -- 明细编号
    ,bill_id -- 票据编号
    ,bus_prod_id -- 业务产品编号
    ,interest -- 利息
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,actl_end_provi_dt -- 实际结束计提日期
    ,provi_dt -- 计提日期
    ,int_accr_exp_dt -- 计息到期日期
    ,int_accr_days -- 计息天数
    ,provied_int -- 已计提利息
    ,surp_int -- 剩余利息
    ,daily_provi_amt -- 每日计提金额
    ,provi_bus_type_cd -- 计提业务类型代码
    ,provi_status_cd -- 计提状态代码
    ,provi_excep_cd -- 计提异常代码
    ,acct_instit_id -- 账务机构编号
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_num -- 票据号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.provi_mtbl_id -- 计提主表编号
    ,o.lp_id -- 法人编号
    ,o.hq_org_id -- 总行机构编号
    ,o.tran_org_id -- 交易机构编号
    ,o.batch_id -- 批次编号
    ,o.agt_id -- 协议编号
    ,o.dtl_id -- 明细编号
    ,o.bill_id -- 票据编号
    ,o.bus_prod_id -- 业务产品编号
    ,o.interest -- 利息
    ,o.provi_start_dt -- 计提开始日期
    ,o.provi_end_dt -- 计提结束日期
    ,o.actl_end_provi_dt -- 实际结束计提日期
    ,o.provi_dt -- 计提日期
    ,o.int_accr_exp_dt -- 计息到期日期
    ,o.int_accr_days -- 计息天数
    ,o.provied_int -- 已计提利息
    ,o.surp_int -- 剩余利息
    ,o.daily_provi_amt -- 每日计提金额
    ,o.provi_bus_type_cd -- 计提业务类型代码
    ,o.provi_status_cd -- 计提状态代码
    ,o.provi_excep_cd -- 计提异常代码
    ,o.acct_instit_id -- 账务机构编号
    ,o.bill_sub_intrv_id -- 票据子区间号
    ,o.bill_num -- 票据号码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cpes_provi_h_bdmsf1_bk o
    left join ${iml_schema}.agt_cpes_provi_h_bdmsf1_op n
        on
            o.provi_mtbl_id = n.provi_mtbl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cpes_provi_h_bdmsf1_cl d
        on
            o.provi_mtbl_id = d.provi_mtbl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cpes_provi_h;
alter table ${iml_schema}.agt_cpes_provi_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_cpes_provi_h exchange subpartition p_bdmsf1_19000101 with table ${iml_schema}.agt_cpes_provi_h_bdmsf1_cl;
alter table ${iml_schema}.agt_cpes_provi_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_cpes_provi_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cpes_provi_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cpes_provi_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_cpes_provi_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_cpes_provi_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cpes_provi_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cpes_provi_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
