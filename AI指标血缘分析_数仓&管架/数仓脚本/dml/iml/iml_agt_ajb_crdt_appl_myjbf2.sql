/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ajb_crdt_appl_myjbf2
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ajb_crdt_appl_myjbf2_tm purge;
drop table ${iml_schema}.agt_ajb_crdt_appl_myjbf2_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ajb_crdt_appl add partition p_myjbf2 values ('myjbf2')(
        subpartition p_myjbf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ajb_crdt_appl modify partition p_myjbf2
    add subpartition p_myjbf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ajb_crdt_appl_myjbf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ajb_crdt_appl partition for ('myjbf2')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ajb_crdt_appl_myjbf2_tm
compress ${option_switch} for query high
as
select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_dt -- 申请日期
    ,apv_status_cd -- 审批状态代码
    ,crdt_lmt -- 授信额度
    ,risk_rating -- 风险评级
    ,solv_rating -- 偿债能力评级
    ,cust_id -- 客户编号
    ,apved_dt -- 审批通过日期
    ,ajb_lmt_flg -- 借呗额度标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,apv_rest_flg -- 审批结果标志
    ,netw_vrfction_status_cd -- 联网核查状态代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,prod_name -- 产品名称
    ,check_anti_fraud_flg -- 验证反欺诈标志
    ,cert_type_cd -- 证件类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ajb_crdt_appl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ajb_crdt_appl_myjbf2_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ajb_crdt_appl partition for ('myjbf2') where 0=1;

-- 2.1 insert data to tm table
-- rcrs_myjb_iqp_loan_app-
insert into ${iml_schema}.agt_ajb_crdt_appl_myjbf2_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_dt -- 申请日期
    ,apv_status_cd -- 审批状态代码
    ,crdt_lmt -- 授信额度
    ,risk_rating -- 风险评级
    ,solv_rating -- 偿债能力评级
    ,cust_id -- 客户编号
    ,apved_dt -- 审批通过日期
    ,ajb_lmt_flg -- 借呗额度标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,apv_rest_flg -- 审批结果标志
    ,netw_vrfction_status_cd -- 联网核查状态代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,prod_name -- 产品名称
    ,check_anti_fraud_flg -- 验证反欺诈标志
    ,cert_type_cd -- 证件类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '203002'||P1.SERNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERNO -- 授信申请编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE) -- 申请日期
    ,P1.APPROVE_STATUS -- 审批状态代码
    ,P1.APPLY_AMOUNT -- 授信额度
    ,P1.RISK_RATING -- 风险评级
    ,P1.SOLVENCY_RATINGS -- 偿债能力评级
    ,P1.CUS_ID -- 客户编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.LAST_ADVICE_DATE) -- 审批通过日期
    ,P1.HASJBADMIT -- 借呗额度标志
    ,P1.FAIL_REASON -- 拒绝原因描述
    ,${iml_schema}.DATEFORMAT_MIN(substr(P1.START_DATE,1,10)) -- 审批开始时间
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.END_DATE,1,10)) -- 审批结束时间
    ,P1.PLATFORM_ACCESS -- 审批结果标志
    ,nvl(to_char(P1.IS_CHECK_INSPECT),'-') -- 联网核查状态代码
    ,P1.INFORM_FLAG -- 终审通知成功标志
    ,P1.PRD_NAME -- 产品名称
    ,P1.IS_CHECK_FQZ -- 验证反欺诈标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CERT_TYPE END -- 证件类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_myjb_iqp_loan_app' -- 源表名称
    ,'myjbf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_myjb_iqp_loan_app p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CERT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'RCRS'
        AND R2.SRC_TAB_EN_NAME= 'RCRS_MYJB_IQP_LOAN_APP'
        AND R2.SRC_FIELD_EN_NAME= 'CERT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_AJB_CRDT_APPL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- rcrs_myjb_iqp_loan_app_his-
insert into ${iml_schema}.agt_ajb_crdt_appl_myjbf2_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_dt -- 申请日期
    ,apv_status_cd -- 审批状态代码
    ,crdt_lmt -- 授信额度
    ,risk_rating -- 风险评级
    ,solv_rating -- 偿债能力评级
    ,cust_id -- 客户编号
    ,apved_dt -- 审批通过日期
    ,ajb_lmt_flg -- 借呗额度标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,apv_rest_flg -- 审批结果标志
    ,netw_vrfction_status_cd -- 联网核查状态代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,prod_name -- 产品名称
    ,check_anti_fraud_flg -- 验证反欺诈标志
    ,cert_type_cd -- 证件类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '203002'||P1.SERNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERNO -- 授信申请编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE) -- 申请日期
    ,P1.APPROVE_STATUS -- 审批状态代码
    ,P1.APPLY_AMOUNT -- 授信额度
    ,P1.RISK_RATING -- 风险评级
    ,P1.SOLVENCY_RATINGS -- 偿债能力评级
    ,P1.CUS_ID -- 客户编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.LAST_ADVICE_DATE) -- 审批通过日期
    ,P1.HASJBADMIT -- 借呗额度标志
    ,P1.FAIL_REASON -- 拒绝原因描述
    ,${iml_schema}.DATEFORMAT_MIN(substr(P1.START_DATE,1,10)) -- 审批开始时间
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.END_DATE,1,10)) -- 审批结束时间
    ,P1.PLATFORM_ACCESS -- 审批结果标志
    ,nvl(to_char(P1.IS_CHECK_INSPECT),'-') -- 联网核查状态代码
    ,P1.INFORM_FLAG -- 终审通知成功标志
    ,P1.PRD_NAME -- 产品名称
    ,P1.IS_CHECK_FQZ -- 验证反欺诈标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CERT_TYPE END -- 证件类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_myjb_iqp_loan_app_his' -- 源表名称
    ,'myjbf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_myjb_iqp_loan_app_his p1
    left join ${iol_schema}.rcrs_myjb_iqp_loan_app p2 on P1.SERNO=P2.SERNO
AND p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CERT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'RCRS'
        AND R2.SRC_TAB_EN_NAME= 'RCRS_MYJB_IQP_LOAN_APP'
        AND R2.SRC_FIELD_EN_NAME= 'CERT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_AJB_CRDT_APPL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
where  1 = 1 
    and P1.etl_dt <=to_date('${batch_date}','yyyy-mm-dd') AND P2.SERNO IS NULL 
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ajb_crdt_appl_myjbf2_tm 
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_ajb_crdt_appl_myjbf2_ex(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_dt -- 申请日期
    ,apv_status_cd -- 审批状态代码
    ,crdt_lmt -- 授信额度
    ,risk_rating -- 风险评级
    ,solv_rating -- 偿债能力评级
    ,cust_id -- 客户编号
    ,apved_dt -- 审批通过日期
    ,ajb_lmt_flg -- 借呗额度标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,apv_rest_flg -- 审批结果标志
    ,netw_vrfction_status_cd -- 联网核查状态代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,prod_name -- 产品名称
    ,check_anti_fraud_flg -- 验证反欺诈标志
    ,cert_type_cd -- 证件类型代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.crdt_appl_id, o.crdt_appl_id) as crdt_appl_id -- 授信申请编号
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.crdt_lmt, o.crdt_lmt) as crdt_lmt -- 授信额度
    ,nvl(n.risk_rating, o.risk_rating) as risk_rating -- 风险评级
    ,nvl(n.solv_rating, o.solv_rating) as solv_rating -- 偿债能力评级
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.apved_dt, o.apved_dt) as apved_dt -- 审批通过日期
    ,nvl(n.ajb_lmt_flg, o.ajb_lmt_flg) as ajb_lmt_flg -- 借呗额度标志
    ,nvl(n.refuse_rs_descb, o.refuse_rs_descb) as refuse_rs_descb -- 拒绝原因描述
    ,nvl(n.apv_start_tm, o.apv_start_tm) as apv_start_tm -- 审批开始时间
    ,nvl(n.apv_end_tm, o.apv_end_tm) as apv_end_tm -- 审批结束时间
    ,nvl(n.apv_rest_flg, o.apv_rest_flg) as apv_rest_flg -- 审批结果标志
    ,nvl(n.netw_vrfction_status_cd, o.netw_vrfction_status_cd) as netw_vrfction_status_cd -- 联网核查状态代码
    ,nvl(n.final_jud_advise_sucs_flg, o.final_jud_advise_sucs_flg) as final_jud_advise_sucs_flg -- 终审通知成功标志
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.check_anti_fraud_flg, o.check_anti_fraud_flg) as check_anti_fraud_flg -- 验证反欺诈标志
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.appl_id is null
                and o.lp_id is null
            ) or (
                o.crdt_appl_id <> n.crdt_appl_id
                or o.appl_dt <> n.appl_dt
                or o.apv_status_cd <> n.apv_status_cd
                or o.crdt_lmt <> n.crdt_lmt
                or o.risk_rating <> n.risk_rating
                or o.solv_rating <> n.solv_rating
                or o.cust_id <> n.cust_id
                or o.apved_dt <> n.apved_dt
                or o.ajb_lmt_flg <> n.ajb_lmt_flg
                or o.refuse_rs_descb <> n.refuse_rs_descb
                or o.apv_start_tm <> n.apv_start_tm
                or o.apv_end_tm <> n.apv_end_tm
                or o.apv_rest_flg <> n.apv_rest_flg
                or o.netw_vrfction_status_cd <> n.netw_vrfction_status_cd
                or o.final_jud_advise_sucs_flg <> n.final_jud_advise_sucs_flg
                or o.prod_name <> n.prod_name
                or o.check_anti_fraud_flg <> n.check_anti_fraud_flg
                or o.cert_type_cd <> n.cert_type_cd
            ) or (
                 case when (
                           n.appl_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.appl_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ajb_crdt_appl_myjbf2_tm n
    full join ${iml_schema}.agt_ajb_crdt_appl_myjbf2_bk o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ajb_crdt_appl truncate partition for ('myjbf2') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ajb_crdt_appl exchange subpartition p_myjbf2_${batch_date} with table ${iml_schema}.agt_ajb_crdt_appl_myjbf2_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ajb_crdt_appl drop subpartition p_myjbf2_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ajb_crdt_appl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ajb_crdt_appl_myjbf2_tm purge;
drop table ${iml_schema}.agt_ajb_crdt_appl_myjbf2_ex purge;
drop table ${iml_schema}.agt_ajb_crdt_appl_myjbf2_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ajb_crdt_appl', partname => 'p_myjbf2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);