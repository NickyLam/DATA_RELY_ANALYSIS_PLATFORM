/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_unused_rtn_bill_rgst_h_bdmsf1
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
alter table ${iml_schema}.agt_unused_rtn_bill_rgst_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unused_rtn_bill_rgst_h partition for ('bdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,org_id -- 机构编号
    ,rtn_rs_descb -- 退回原因描述
    ,rtn_dt -- 退回日期
    ,oper_teller_id -- 操作柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_status_cd -- 登记状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,bill_sub_intrv_id -- 票据子区间编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_unused_rtn_bill_rgst_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unused_rtn_bill_rgst_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unused_rtn_bill_rgst_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_accept_unused_restitution-
insert into ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_tm(
    rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,org_id -- 机构编号
    ,rtn_rs_descb -- 退回原因描述
    ,rtn_dt -- 退回日期
    ,oper_teller_id -- 操作柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_status_cd -- 登记状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,bill_sub_intrv_id -- 票据子区间编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 登记编号
    ,'9999' -- 法人编号
    ,'101008'||P1.DRAFT_ID -- 凭证编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.BRANCH_NO -- 机构编号
    ,P1.WITHDRAW_REASON -- 退回原因描述
    ,${iml_schema}.DATEFORMAT_MAX2(P1.WITHDRAW_DATE) -- 退回日期
    ,P1.OPERATOR_NO -- 操作柜员编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.TXN_DATE) -- 登记日期
    ,nvl(trim(P1.STATUS),'-') -- 登记状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,P1.LAST_OPERATOR_NO -- 最后修改操作员编号
    ,P1.LAST_TXN_DATE -- 最后修改时间
    ,'-' -- 票据子区间编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_accept_unused_restitution' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_accept_unused_restitution p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCOUNT_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_UNUSED_RESTITUTION'
        AND R2.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_UNUSED_RTN_BILL_RGST_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- bdms_cpes_accept_unused_restitution-
insert into ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_tm(
    rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,org_id -- 机构编号
    ,rtn_rs_descb -- 退回原因描述
    ,rtn_dt -- 退回日期
    ,oper_teller_id -- 操作柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_status_cd -- 登记状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,bill_sub_intrv_id -- 票据子区间编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 登记编号
    ,'9999' -- 法人编号
    ,'101008'||P1.DRAFT_ID -- 凭证编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.BRANCH_NO -- 机构编号
    ,P1.WITHDRAW_REASON -- 退回原因描述
    ,${iml_schema}.DATEFORMAT_MAX2(null) -- 退回日期
    ,P1.OPERATOR_NO -- 操作柜员编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.WITHDRAW_DATE） -- 登记日期
    ,nvl(trim(P1.STATUS),'-') -- 登记状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,' ' -- 最后修改操作员编号
    ,${iml_schema}.TIMEFORMAT_MAX(null) -- 最后修改时间
    ,P1.CD_RANGE -- 票据子区间编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_accept_unused_restitution' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_accept_unused_restitution p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCOUNT_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_ACCEPT_UNUSED_RESTITUTION'
        AND R2.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_UNUSED_RTN_BILL_RGST_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_tm 
  	                                group by 
  	                                        rgst_id
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
        into ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_cl(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,org_id -- 机构编号
    ,rtn_rs_descb -- 退回原因描述
    ,rtn_dt -- 退回日期
    ,oper_teller_id -- 操作柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_status_cd -- 登记状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,bill_sub_intrv_id -- 票据子区间编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_op(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,org_id -- 机构编号
    ,rtn_rs_descb -- 退回原因描述
    ,rtn_dt -- 退回日期
    ,oper_teller_id -- 操作柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_status_cd -- 登记状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,bill_sub_intrv_id -- 票据子区间编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rgst_id, o.rgst_id) as rgst_id -- 登记编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.rtn_rs_descb, o.rtn_rs_descb) as rtn_rs_descb -- 退回原因描述
    ,nvl(n.rtn_dt, o.rtn_dt) as rtn_dt -- 退回日期
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_status_cd, o.rgst_status_cd) as rgst_status_cd -- 登记状态代码
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.final_modif_operr_id, o.final_modif_operr_id) as final_modif_operr_id -- 最后修改操作员编号
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间编号
    ,case when
            n.rgst_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rgst_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rgst_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.rgst_id = n.rgst_id
            and o.lp_id = n.lp_id
where (
        o.rgst_id is null
        and o.lp_id is null
    )
    or (
        n.rgst_id is null
        and n.lp_id is null
    )
    or (
        o.vouch_id <> n.vouch_id
        or o.bill_id <> n.bill_id
        or o.org_id <> n.org_id
        or o.rtn_rs_descb <> n.rtn_rs_descb
        or o.rtn_dt <> n.rtn_dt
        or o.oper_teller_id <> n.oper_teller_id
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_status_cd <> n.rgst_status_cd
        or o.entry_status_cd <> n.entry_status_cd
        or o.final_modif_operr_id <> n.final_modif_operr_id
        or o.final_modif_tm <> n.final_modif_tm
        or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_cl(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,org_id -- 机构编号
    ,rtn_rs_descb -- 退回原因描述
    ,rtn_dt -- 退回日期
    ,oper_teller_id -- 操作柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_status_cd -- 登记状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,bill_sub_intrv_id -- 票据子区间编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_op(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,org_id -- 机构编号
    ,rtn_rs_descb -- 退回原因描述
    ,rtn_dt -- 退回日期
    ,oper_teller_id -- 操作柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_status_cd -- 登记状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,bill_sub_intrv_id -- 票据子区间编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rgst_id -- 登记编号
    ,o.lp_id -- 法人编号
    ,o.vouch_id -- 凭证编号
    ,o.bill_id -- 票据编号
    ,o.org_id -- 机构编号
    ,o.rtn_rs_descb -- 退回原因描述
    ,o.rtn_dt -- 退回日期
    ,o.oper_teller_id -- 操作柜员编号
    ,o.rgst_dt -- 登记日期
    ,o.rgst_status_cd -- 登记状态代码
    ,o.entry_status_cd -- 记账状态代码
    ,o.final_modif_operr_id -- 最后修改操作员编号
    ,o.final_modif_tm -- 最后修改时间
    ,o.bill_sub_intrv_id -- 票据子区间编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_bk o
    left join ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_op n
        on
            o.rgst_id = n.rgst_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_cl d
        on
            o.rgst_id = d.rgst_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_unused_rtn_bill_rgst_h;
alter table ${iml_schema}.agt_unused_rtn_bill_rgst_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_unused_rtn_bill_rgst_h exchange subpartition p_bdmsf1_19000101 with table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_cl;
alter table ${iml_schema}.agt_unused_rtn_bill_rgst_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_unused_rtn_bill_rgst_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_unused_rtn_bill_rgst_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_unused_rtn_bill_rgst_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
