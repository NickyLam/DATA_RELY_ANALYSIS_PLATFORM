/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_loss_appl_h_bdmsf1
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
alter table ${iml_schema}.agt_bill_loss_appl_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_loss_appl_h partition for ('bdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,loss_rs_descb -- 挂失原因描述
    ,loss_dt -- 挂失日期
    ,loss_applit_name -- 挂失申请人名称
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,unloss_rs_descb -- 解挂原因描述
    ,unloss_dt -- 解挂日期
    ,unloss_teller_id -- 解挂柜员编号
    ,appl_status_cd -- 申请状态代码
    ,modif_teller_id -- 修改柜员编号
    ,final_modif_tm -- 最后修改时间
    ,final_modif_dt -- 最后修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_loss_appl_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_loss_appl_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_loss_appl_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_accept_report_of_loss-
insert into ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,loss_rs_descb -- 挂失原因描述
    ,loss_dt -- 挂失日期
    ,loss_applit_name -- 挂失申请人名称
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,unloss_rs_descb -- 解挂原因描述
    ,unloss_dt -- 解挂日期
    ,unloss_teller_id -- 解挂柜员编号
    ,appl_status_cd -- 申请状态代码
    ,modif_teller_id -- 修改柜员编号
    ,final_modif_tm -- 最后修改时间
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 申请编号
    ,'9999' -- 法人编号
    ,P1.BRANCH_NO -- 机构编号
    ,P1.DRAFT_ID -- 票据编号
    ,'101008'||P1.DRAFT_ID -- 凭证编号
    ,P1.REPORT_OF_LOSS_REASON -- 挂失原因描述
    ,${iml_schema}.DATEFORMAT_MIN(P1.REPORT_OF_LOSS_DATE) -- 挂失日期
    ,P1.REPORT_OF_LOSS_PERSON -- 挂失申请人名称
    ,P1.OPERATOR_NO -- 操作柜员编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TXN_DATE) -- 操作日期
    ,P1.UNLOSS_REASON -- 解挂原因描述
    ,${iml_schema}.DATEFORMAT_MAX2(P1.UNLOSS_DATE) -- 解挂日期
    ,P1.UNLOSS_OPERATOR_NO -- 解挂柜员编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 申请状态代码
    ,P1.LAST_UPD_OPER_NO -- 修改柜员编号
    ,coalesce(SUBSTR(to_char(P1.LAST_UPD_TIME,'yyyymmddhh24miss'),9,2)||':'||SUBSTR(to_char(P1.LAST_UPD_TIME,'yyyymmddhh24miss'),11,2)||':'||SUBSTR(to_char(P1.LAST_UPD_TIME,'yyyymmddhh24miss'),13,2),'') -- 最后修改时间
    ,${iml_schema}.DATEFORMAT_MAX2(to_char(P1.LAST_UPD_TIME,'yyyymmdd')) -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_accept_report_of_loss' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_accept_report_of_loss p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_REPORT_OF_LOSS'
        AND R1.SRC_FIELD_EN_NAME= 'STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_LOSS_APPL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'APPL_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_tm 
  	                                group by 
  	                                        appl_id
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
        into ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,loss_rs_descb -- 挂失原因描述
    ,loss_dt -- 挂失日期
    ,loss_applit_name -- 挂失申请人名称
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,unloss_rs_descb -- 解挂原因描述
    ,unloss_dt -- 解挂日期
    ,unloss_teller_id -- 解挂柜员编号
    ,appl_status_cd -- 申请状态代码
    ,modif_teller_id -- 修改柜员编号
    ,final_modif_tm -- 最后修改时间
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,loss_rs_descb -- 挂失原因描述
    ,loss_dt -- 挂失日期
    ,loss_applit_name -- 挂失申请人名称
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,unloss_rs_descb -- 解挂原因描述
    ,unloss_dt -- 解挂日期
    ,unloss_teller_id -- 解挂柜员编号
    ,appl_status_cd -- 申请状态代码
    ,modif_teller_id -- 修改柜员编号
    ,final_modif_tm -- 最后修改时间
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.loss_rs_descb, o.loss_rs_descb) as loss_rs_descb -- 挂失原因描述
    ,nvl(n.loss_dt, o.loss_dt) as loss_dt -- 挂失日期
    ,nvl(n.loss_applit_name, o.loss_applit_name) as loss_applit_name -- 挂失申请人名称
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 操作日期
    ,nvl(n.unloss_rs_descb, o.unloss_rs_descb) as unloss_rs_descb -- 解挂原因描述
    ,nvl(n.unloss_dt, o.unloss_dt) as unloss_dt -- 解挂日期
    ,nvl(n.unloss_teller_id, o.unloss_teller_id) as unloss_teller_id -- 解挂柜员编号
    ,nvl(n.appl_status_cd, o.appl_status_cd) as appl_status_cd -- 申请状态代码
    ,nvl(n.modif_teller_id, o.modif_teller_id) as modif_teller_id -- 修改柜员编号
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.org_id <> n.org_id
        or o.bill_id <> n.bill_id
        or o.vouch_id <> n.vouch_id
        or o.loss_rs_descb <> n.loss_rs_descb
        or o.loss_dt <> n.loss_dt
        or o.loss_applit_name <> n.loss_applit_name
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_dt <> n.oper_dt
        or o.unloss_rs_descb <> n.unloss_rs_descb
        or o.unloss_dt <> n.unloss_dt
        or o.unloss_teller_id <> n.unloss_teller_id
        or o.appl_status_cd <> n.appl_status_cd
        or o.modif_teller_id <> n.modif_teller_id
        or o.final_modif_tm <> n.final_modif_tm
        or o.final_modif_dt <> n.final_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,loss_rs_descb -- 挂失原因描述
    ,loss_dt -- 挂失日期
    ,loss_applit_name -- 挂失申请人名称
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,unloss_rs_descb -- 解挂原因描述
    ,unloss_dt -- 解挂日期
    ,unloss_teller_id -- 解挂柜员编号
    ,appl_status_cd -- 申请状态代码
    ,modif_teller_id -- 修改柜员编号
    ,final_modif_tm -- 最后修改时间
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,loss_rs_descb -- 挂失原因描述
    ,loss_dt -- 挂失日期
    ,loss_applit_name -- 挂失申请人名称
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,unloss_rs_descb -- 解挂原因描述
    ,unloss_dt -- 解挂日期
    ,unloss_teller_id -- 解挂柜员编号
    ,appl_status_cd -- 申请状态代码
    ,modif_teller_id -- 修改柜员编号
    ,final_modif_tm -- 最后修改时间
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.org_id -- 机构编号
    ,o.bill_id -- 票据编号
    ,o.vouch_id -- 凭证编号
    ,o.loss_rs_descb -- 挂失原因描述
    ,o.loss_dt -- 挂失日期
    ,o.loss_applit_name -- 挂失申请人名称
    ,o.oper_teller_id -- 操作柜员编号
    ,o.oper_dt -- 操作日期
    ,o.unloss_rs_descb -- 解挂原因描述
    ,o.unloss_dt -- 解挂日期
    ,o.unloss_teller_id -- 解挂柜员编号
    ,o.appl_status_cd -- 申请状态代码
    ,o.modif_teller_id -- 修改柜员编号
    ,o.final_modif_tm -- 最后修改时间
    ,o.final_modif_dt -- 最后修改日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_bk o
    left join ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_bill_loss_appl_h;
alter table ${iml_schema}.agt_bill_loss_appl_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_bill_loss_appl_h exchange subpartition p_bdmsf1_19000101 with table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_cl;
alter table ${iml_schema}.agt_bill_loss_appl_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_loss_appl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_bill_loss_appl_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_loss_appl_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
