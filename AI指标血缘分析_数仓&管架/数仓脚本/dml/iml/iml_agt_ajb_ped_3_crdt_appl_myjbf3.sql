/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ajb_ped_3_crdt_appl_myjbf3
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
drop table ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_tm purge;
drop table ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ajb_ped_3_crdt_appl add partition p_myjbf3 values ('myjbf3')(
        subpartition p_myjbf3_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ajb_ped_3_crdt_appl modify partition p_myjbf3
    add subpartition p_myjbf3_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ajb_ped_3_crdt_appl partition for ('myjbf3')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_tm
compress ${option_switch} for query high
as
select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,appl_dt -- 申请日期
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_id -- 授信申请编号
    ,crdt_appl_type_cd -- 授信申请类型代码
    ,appl_src_cd -- 申请来源代码
    ,cust_id -- 客户编号
    ,appl_exp_tm -- 申请过期时间
    ,crdt_lmt -- 授信额度
    ,open_acct_sucs_flg -- 开户成功标志
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,check_anti_fraud_flg -- 验证反欺诈标志
    ,remark -- 备注
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,apv_status_cd -- 审批状态代码
    ,apv_rest_code -- 审批结果码
    ,apv_rest_descb -- 审批结果描述
    ,apved_flg -- 审批通过标志
    ,crdt_valid_dt -- 授信有效日期
    ,crdtc_acqt_sucs_flg -- 征信采集成功标志
    ,crdtc_check_sucs_flg -- 征信校验成功标志
    ,score_val -- 评分分值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ajb_ped_3_crdt_appl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ajb_ped_3_crdt_appl partition for ('myjbf3') where 0=1;

-- 2.1 insert data to tm table
-- icms_myzy_iqp_loan_app-
insert into ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,appl_dt -- 申请日期
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_id -- 授信申请编号
    ,crdt_appl_type_cd -- 授信申请类型代码
    ,appl_src_cd -- 申请来源代码
    ,cust_id -- 客户编号
    ,appl_exp_tm -- 申请过期时间
    ,crdt_lmt -- 授信额度
    ,open_acct_sucs_flg -- 开户成功标志
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,check_anti_fraud_flg -- 验证反欺诈标志
    ,remark -- 备注
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,apv_status_cd -- 审批状态代码
    ,apv_rest_code -- 审批结果码
    ,apv_rest_descb -- 审批结果描述
    ,apved_flg -- 审批通过标志
    ,crdt_valid_dt -- 授信有效日期
    ,crdtc_acqt_sucs_flg -- 征信采集成功标志
    ,crdtc_check_sucs_flg -- 征信校验成功标志
    ,score_val -- 评分分值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '203007'||P1.SERNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.PRDCODE -- 产品编号
    ,P1.PRDNAME -- 产品名称
    ,${iml_schema}.dateformat_min(P1.APPLYDATE) -- 申请日期
    ,P1.REQUESTID -- 申请流水号
    ,P1.APPLYNO -- 授信申请编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BIZTYPE END -- 授信申请类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.SOURCE END -- 申请来源代码
    ,P1.CUSID -- 客户编号
    ,to_timestamp (nvl(trim(P1.EXPIRED),'20991231'),'yyyy-mm-dd hh24:mi:ss') -- 申请过期时间
    ,P1.APPLYAMOUNT -- 授信额度
    ,P1.ISGETCUSCODE -- 开户成功标志
    ,P1.INFORMFLAG -- 终审通知成功标志
    ,to_timestamp (nvl(trim(P1.STARTDATE),'19000101'),'yyyy-mm-dd hh24:mi:ss') -- 审批开始时间
    ,to_timestamp (nvl(trim(P1.ENDDATE),'20991231'),'yyyy-mm-dd hh24:mi:ss') -- 审批结束时间
    ,P1.ISCHECKRULE -- 验证反欺诈标志
    ,P1.FAILREASON -- 备注
    ,P1.INPUTID -- 登记人编号
    ,P1.INPUTBRID -- 登记机构编号
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.RESULTCODE -- 审批结果码
    ,P1.RESULTMSG -- 审批结果描述
    ,P1.ISAGREE -- 审批通过标志
    ,${iml_schema}.dateformat_max2(P1.EXPIRYDATE) -- 授信有效日期
    ,P1.ISCOLLECTCREDIT -- 征信采集成功标志
    ,P1.ISCREDITADOPTED -- 征信校验成功标志
    ,P1.AUTOSCORE -- 评分分值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_myzy_iqp_loan_app' -- 源表名称
    ,'myjbf3' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_myzy_iqp_loan_app p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BIZTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_MYZY_IQP_LOAN_APP'
        AND R1.SRC_FIELD_EN_NAME= 'BIZTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_AJB_PED_3_CRDT_APPL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CRDT_APPL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.SOURCE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_MYZY_IQP_LOAN_APP'
        AND R2.SRC_FIELD_EN_NAME= 'SOURCE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_AJB_PED_3_CRDT_APPL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'APPL_SRC_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_tm 
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
insert /*+ append */ into ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_ex(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,appl_dt -- 申请日期
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_id -- 授信申请编号
    ,crdt_appl_type_cd -- 授信申请类型代码
    ,appl_src_cd -- 申请来源代码
    ,cust_id -- 客户编号
    ,appl_exp_tm -- 申请过期时间
    ,crdt_lmt -- 授信额度
    ,open_acct_sucs_flg -- 开户成功标志
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,check_anti_fraud_flg -- 验证反欺诈标志
    ,remark -- 备注
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,apv_status_cd -- 审批状态代码
    ,apv_rest_code -- 审批结果码
    ,apv_rest_descb -- 审批结果描述
    ,apved_flg -- 审批通过标志
    ,crdt_valid_dt -- 授信有效日期
    ,crdtc_acqt_sucs_flg -- 征信采集成功标志
    ,crdtc_check_sucs_flg -- 征信校验成功标志
    ,score_val -- 评分分值
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
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.crdt_appl_id, o.crdt_appl_id) as crdt_appl_id -- 授信申请编号
    ,nvl(n.crdt_appl_type_cd, o.crdt_appl_type_cd) as crdt_appl_type_cd -- 授信申请类型代码
    ,nvl(n.appl_src_cd, o.appl_src_cd) as appl_src_cd -- 申请来源代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.appl_exp_tm, o.appl_exp_tm) as appl_exp_tm -- 申请过期时间
    ,nvl(n.crdt_lmt, o.crdt_lmt) as crdt_lmt -- 授信额度
    ,nvl(n.open_acct_sucs_flg, o.open_acct_sucs_flg) as open_acct_sucs_flg -- 开户成功标志
    ,nvl(n.final_jud_advise_sucs_flg, o.final_jud_advise_sucs_flg) as final_jud_advise_sucs_flg -- 终审通知成功标志
    ,nvl(n.apv_start_tm, o.apv_start_tm) as apv_start_tm -- 审批开始时间
    ,nvl(n.apv_end_tm, o.apv_end_tm) as apv_end_tm -- 审批结束时间
    ,nvl(n.check_anti_fraud_flg, o.check_anti_fraud_flg) as check_anti_fraud_flg -- 验证反欺诈标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgstrat_id, o.rgstrat_id) as rgstrat_id -- 登记人编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.apv_rest_code, o.apv_rest_code) as apv_rest_code -- 审批结果码
    ,nvl(n.apv_rest_descb, o.apv_rest_descb) as apv_rest_descb -- 审批结果描述
    ,nvl(n.apved_flg, o.apved_flg) as apved_flg -- 审批通过标志
    ,nvl(n.crdt_valid_dt, o.crdt_valid_dt) as crdt_valid_dt -- 授信有效日期
    ,nvl(n.crdtc_acqt_sucs_flg, o.crdtc_acqt_sucs_flg) as crdtc_acqt_sucs_flg -- 征信采集成功标志
    ,nvl(n.crdtc_check_sucs_flg, o.crdtc_check_sucs_flg) as crdtc_check_sucs_flg -- 征信校验成功标志
    ,nvl(n.score_val, o.score_val) as score_val -- 评分分值
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.appl_id is null
                and o.lp_id is null
            ) or (
                o.prod_id <> n.prod_id
                or o.prod_name <> n.prod_name
                or o.appl_dt <> n.appl_dt
                or o.appl_flow_num <> n.appl_flow_num
                or o.crdt_appl_id <> n.crdt_appl_id
                or o.crdt_appl_type_cd <> n.crdt_appl_type_cd
                or o.appl_src_cd <> n.appl_src_cd
                or o.cust_id <> n.cust_id
                or o.appl_exp_tm <> n.appl_exp_tm
                or o.crdt_lmt <> n.crdt_lmt
                or o.open_acct_sucs_flg <> n.open_acct_sucs_flg
                or o.final_jud_advise_sucs_flg <> n.final_jud_advise_sucs_flg
                or o.apv_start_tm <> n.apv_start_tm
                or o.apv_end_tm <> n.apv_end_tm
                or o.check_anti_fraud_flg <> n.check_anti_fraud_flg
                or o.remark <> n.remark
                or o.rgstrat_id <> n.rgstrat_id
                or o.rgst_org_id <> n.rgst_org_id
                or o.apv_status_cd <> n.apv_status_cd
                or o.apv_rest_code <> n.apv_rest_code
                or o.apv_rest_descb <> n.apv_rest_descb
                or o.apved_flg <> n.apved_flg
                or o.crdt_valid_dt <> n.crdt_valid_dt
                or o.crdtc_acqt_sucs_flg <> n.crdtc_acqt_sucs_flg
                or o.crdtc_check_sucs_flg <> n.crdtc_check_sucs_flg
                or o.score_val <> n.score_val
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
from ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_tm n
    full join ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_bk o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ajb_ped_3_crdt_appl truncate partition for ('myjbf3') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ajb_ped_3_crdt_appl exchange subpartition p_myjbf3_${batch_date} with table ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ajb_ped_3_crdt_appl drop subpartition p_myjbf3_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ajb_ped_3_crdt_appl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_tm purge;
drop table ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_ex purge;
drop table ${iml_schema}.agt_ajb_ped_3_crdt_appl_myjbf3_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ajb_ped_3_crdt_appl', partname => 'p_myjbf3_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);