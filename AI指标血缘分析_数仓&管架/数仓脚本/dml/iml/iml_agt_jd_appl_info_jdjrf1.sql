/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_jd_appl_info_jdjrf1
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
drop table ${iml_schema}.agt_jd_appl_info_jdjrf1_tm purge;
drop table ${iml_schema}.agt_jd_appl_info_jdjrf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_jd_appl_info add partition p_jdjrf1 values ('jdjrf1')(
        subpartition p_jdjrf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_jd_appl_info modify partition p_jdjrf1
    add subpartition p_jdjrf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_jd_appl_info_jdjrf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_jd_appl_info partition for ('jdjrf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_jd_appl_info_jdjrf1_tm
compress ${option_switch} for query high
as
select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,jd_appl_id -- 京东申请编号
    ,appl_tm -- 申请时间
    ,bus_scene_cd -- 业务场景代码
    ,crdt_mode_cd -- 授信模式代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,user_idf -- 用户标识
    ,id_card_num -- 身份证号
    ,mobile_no -- 手机号码
    ,posta_addr -- 通讯地址
    ,appl_lmt -- 申请额度
    ,day_int_rat -- 日利率
    ,actv_lab -- 激活标签
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,input_dt -- 录入日期
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,login_org_id -- 登录机构编号
    ,apv_status_cd -- 审批状态代码
    ,refuse_rs -- 拒绝原因
    ,rgstrat_id -- 登记人编号
    ,advise_flg -- 通知标志
    ,schd_check_flg -- 调度验证标志
    ,rev_fraud_check_flg -- 反欺诈校验标志
    ,score_card_val -- 评分卡分值
    ,crdtc_flg -- 征信标志
    ,app_id -- 应用编号
    ,prod_type_cd -- 产品类型代码
    ,exec_year_int_rat -- 执行年利率
    ,lpr_int_rat -- LPR利率
    ,float_int_rat_spread_val -- 浮动利率点差值
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_jd_appl_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_jd_appl_info_jdjrf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_jd_appl_info partition for ('jdjrf1') where 0=1;

-- 2.1 insert data to tm table
-- rcrs_jdjr_iqp_loan_app-
insert into ${iml_schema}.agt_jd_appl_info_jdjrf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,jd_appl_id -- 京东申请编号
    ,appl_tm -- 申请时间
    ,bus_scene_cd -- 业务场景代码
    ,crdt_mode_cd -- 授信模式代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,user_idf -- 用户标识
    ,id_card_num -- 身份证号
    ,mobile_no -- 手机号码
    ,posta_addr -- 通讯地址
    ,appl_lmt -- 申请额度
    ,day_int_rat -- 日利率
    ,actv_lab -- 激活标签
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,input_dt -- 录入日期
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,login_org_id -- 登录机构编号
    ,apv_status_cd -- 审批状态代码
    ,refuse_rs -- 拒绝原因
    ,rgstrat_id -- 登记人编号
    ,advise_flg -- 通知标志
    ,schd_check_flg -- 调度验证标志
    ,rev_fraud_check_flg -- 反欺诈校验标志
    ,score_card_val -- 评分卡分值
    ,crdtc_flg -- 征信标志
    ,app_id -- 应用编号
    ,prod_type_cd -- 产品类型代码
    ,exec_year_int_rat -- 执行年利率
    ,lpr_int_rat -- LPR利率
    ,float_int_rat_spread_val -- 浮动利率点差值
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '203003'||P1.SERNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERNO -- 流水号
    ,P1.APPLY_NO -- 京东申请编号
    ,CASE WHEN trim(P1.APPLY_TIME) IS NOT NULL THEN to_timestamp( P1.APPLY_TIME ,'yyyy-mm-dd hh24:mi:ss.ff6') ELSE to_timestamp('0001-01-01','yyyy-mm-dd hh24:mi:ss.ff6') END -- 申请时间
    ,P1.BUSINESS_TYPE -- 业务场景代码
    ,P1.CREDIT_MODE -- 授信模式代码
    ,P1.CUS_ID -- 客户编号
    ,P1.USERNAME -- 客户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CERT_TYPE END -- 证件类型代码
    ,P1.PIN -- 用户标识
    ,P1.CERT_NO -- 身份证号
    ,P1.USER_TEL -- 手机号码
    ,P1.ADDRESS -- 通讯地址
    ,P1.APPLY_AMOUNT -- 申请额度
    ,P1.INTEREST_RATE*100 -- 日利率
    ,P1.ACTIVATE_TAG -- 激活标签
    ,P1.PRD_CODE -- 产品编号
    ,P1.PRD_NAME -- 产品名称
    ,${iml_schema}.dateformat_min(trim(P1.INPUT_DATE)) -- 录入日期
    ,CASE WHEN trim(P1.START_DATE) IS NOT NULL THEN to_timestamp( P1.START_DATE ,'yyyy-mm-dd hh24:mi:ss.ff6') ELSE to_timestamp('0001-01-01','yyyy-mm-dd hh24:mi:ss.ff6') END -- 审批开始时间
    ,CASE WHEN trim(P1.END_DATE) IS NOT NULL THEN to_timestamp(P1.END_DATE,'yyyy-mm-dd hh24:mi:ss.ff6') ELSE to_timestamp('2099-12-31','yyyy-mm-dd hh24:mi:ss.ff6') END -- 审批结束时间
    ,P1.INPUT_BR_ID -- 登录机构编号
    ,P1.APPROVE_STATUS -- 审批状态代码
    ,P1.FAIL_REASON -- 拒绝原因
    ,P1.INPUT_ID -- 登记人编号
    ,P1.INFORM_FLAG -- 通知标志
    ,P1.IS_INTERCEPT -- 调度验证标志
    ,P1.IS_CHECK_FQZ -- 反欺诈校验标志
    ,trim(P1.AUTO_SCORE) -- 评分卡分值
    ,P1.IS_COLLECT_CREDIT -- 征信标志
    ,P1.APPID -- 应用编号
    ,P1.PRD_NO -- 产品类型代码
    ,P1.EXEC_RATE*100 -- 执行年利率
    ,P1.LPR*100 -- LPR利率
    ,P1.FLOAT_RATE_BP/100 -- 浮动利率点差值
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.RATE_FLOAT_MODE END -- 利率浮动方式代码
    ,P1.RATE_TYPE -- 利率类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_jdjr_iqp_loan_app' -- 源表名称
    ,'jdjrf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_jdjr_iqp_loan_app p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CERT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'RCRS'
        AND R1.SRC_TAB_EN_NAME= 'RCRS_JDJR_IQP_LOAN_APP'
        AND R1.SRC_FIELD_EN_NAME= 'CERT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_JD_APPL_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.RATE_FLOAT_MODE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'RCRS'
        AND R2.SRC_TAB_EN_NAME= 'RCRS_JDJR_IQP_LOAN_APP'
        AND R2.SRC_FIELD_EN_NAME= 'RATE_FLOAT_MODE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_JD_APPL_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_FLOAT_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_jd_appl_info_jdjrf1_ex(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,jd_appl_id -- 京东申请编号
    ,appl_tm -- 申请时间
    ,bus_scene_cd -- 业务场景代码
    ,crdt_mode_cd -- 授信模式代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,user_idf -- 用户标识
    ,id_card_num -- 身份证号
    ,mobile_no -- 手机号码
    ,posta_addr -- 通讯地址
    ,appl_lmt -- 申请额度
    ,day_int_rat -- 日利率
    ,actv_lab -- 激活标签
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,input_dt -- 录入日期
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,login_org_id -- 登录机构编号
    ,apv_status_cd -- 审批状态代码
    ,refuse_rs -- 拒绝原因
    ,rgstrat_id -- 登记人编号
    ,advise_flg -- 通知标志
    ,schd_check_flg -- 调度验证标志
    ,rev_fraud_check_flg -- 反欺诈校验标志
    ,score_card_val -- 评分卡分值
    ,crdtc_flg -- 征信标志
    ,app_id -- 应用编号
    ,prod_type_cd -- 产品类型代码
    ,exec_year_int_rat -- 执行年利率
    ,lpr_int_rat -- LPR利率
    ,float_int_rat_spread_val -- 浮动利率点差值
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_type_cd -- 利率类型代码
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
    ,nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.jd_appl_id, o.jd_appl_id) as jd_appl_id -- 京东申请编号
    ,nvl(n.appl_tm, o.appl_tm) as appl_tm -- 申请时间
    ,nvl(n.bus_scene_cd, o.bus_scene_cd) as bus_scene_cd -- 业务场景代码
    ,nvl(n.crdt_mode_cd, o.crdt_mode_cd) as crdt_mode_cd -- 授信模式代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.user_idf, o.user_idf) as user_idf -- 用户标识
    ,nvl(n.id_card_num, o.id_card_num) as id_card_num -- 身份证号
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.posta_addr, o.posta_addr) as posta_addr -- 通讯地址
    ,nvl(n.appl_lmt, o.appl_lmt) as appl_lmt -- 申请额度
    ,nvl(n.day_int_rat, o.day_int_rat) as day_int_rat -- 日利率
    ,nvl(n.actv_lab, o.actv_lab) as actv_lab -- 激活标签
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,nvl(n.apv_start_tm, o.apv_start_tm) as apv_start_tm -- 审批开始时间
    ,nvl(n.apv_end_tm, o.apv_end_tm) as apv_end_tm -- 审批结束时间
    ,nvl(n.login_org_id, o.login_org_id) as login_org_id -- 登录机构编号
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.refuse_rs, o.refuse_rs) as refuse_rs -- 拒绝原因
    ,nvl(n.rgstrat_id, o.rgstrat_id) as rgstrat_id -- 登记人编号
    ,nvl(n.advise_flg, o.advise_flg) as advise_flg -- 通知标志
    ,nvl(n.schd_check_flg, o.schd_check_flg) as schd_check_flg -- 调度验证标志
    ,nvl(n.rev_fraud_check_flg, o.rev_fraud_check_flg) as rev_fraud_check_flg -- 反欺诈校验标志
    ,nvl(n.score_card_val, o.score_card_val) as score_card_val -- 评分卡分值
    ,nvl(n.crdtc_flg, o.crdtc_flg) as crdtc_flg -- 征信标志
    ,nvl(n.app_id, o.app_id) as app_id -- 应用编号
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.exec_year_int_rat, o.exec_year_int_rat) as exec_year_int_rat -- 执行年利率
    ,nvl(n.lpr_int_rat, o.lpr_int_rat) as lpr_int_rat -- LPR利率
    ,nvl(n.float_int_rat_spread_val, o.float_int_rat_spread_val) as float_int_rat_spread_val -- 浮动利率点差值
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.appl_id is null
                and o.lp_id is null
            ) or (
                o.flow_num <> n.flow_num
                or o.jd_appl_id <> n.jd_appl_id
                or o.appl_tm <> n.appl_tm
                or o.bus_scene_cd <> n.bus_scene_cd
                or o.crdt_mode_cd <> n.crdt_mode_cd
                or o.cust_id <> n.cust_id
                or o.cust_name <> n.cust_name
                or o.cert_type_cd <> n.cert_type_cd
                or o.user_idf <> n.user_idf
                or o.id_card_num <> n.id_card_num
                or o.mobile_no <> n.mobile_no
                or o.posta_addr <> n.posta_addr
                or o.appl_lmt <> n.appl_lmt
                or o.day_int_rat <> n.day_int_rat
                or o.actv_lab <> n.actv_lab
                or o.prod_id <> n.prod_id
                or o.prod_name <> n.prod_name
                or o.input_dt <> n.input_dt
                or o.apv_start_tm <> n.apv_start_tm
                or o.apv_end_tm <> n.apv_end_tm
                or o.login_org_id <> n.login_org_id
                or o.apv_status_cd <> n.apv_status_cd
                or o.refuse_rs <> n.refuse_rs
                or o.rgstrat_id <> n.rgstrat_id
                or o.advise_flg <> n.advise_flg
                or o.schd_check_flg <> n.schd_check_flg
                or o.rev_fraud_check_flg <> n.rev_fraud_check_flg
                or o.score_card_val <> n.score_card_val
                or o.crdtc_flg <> n.crdtc_flg
                or o.app_id <> n.app_id
                or o.prod_type_cd <> n.prod_type_cd
                or o.exec_year_int_rat <> n.exec_year_int_rat
                or o.lpr_int_rat <> n.lpr_int_rat
                or o.float_int_rat_spread_val <> n.float_int_rat_spread_val
                or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
                or o.int_rat_type_cd <> n.int_rat_type_cd
            )
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
from ${iml_schema}.agt_jd_appl_info_jdjrf1_tm n
    full join ${iml_schema}.agt_jd_appl_info_jdjrf1_bk o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_jd_appl_info truncate partition for ('jdjrf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_jd_appl_info exchange subpartition p_jdjrf1_${batch_date} with table ${iml_schema}.agt_jd_appl_info_jdjrf1_ex;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_jd_appl_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_jd_appl_info_jdjrf1_tm purge;
drop table ${iml_schema}.agt_jd_appl_info_jdjrf1_ex purge;
drop table ${iml_schema}.agt_jd_appl_info_jdjrf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_jd_appl_info', partname => 'p_jdjrf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);