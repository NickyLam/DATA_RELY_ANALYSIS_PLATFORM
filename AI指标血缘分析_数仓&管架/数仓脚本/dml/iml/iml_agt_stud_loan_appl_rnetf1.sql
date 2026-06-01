/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_stud_loan_appl_rnetf1
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
drop table ${iml_schema}.agt_stud_loan_appl_rnetf1_tm purge;
drop table ${iml_schema}.agt_stud_loan_appl_rnetf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_stud_loan_appl add partition p_rnetf1 values ('rnetf1')(
        subpartition p_rnetf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_stud_loan_appl modify partition p_rnetf1
    add subpartition p_rnetf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_stud_loan_appl_rnetf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_stud_loan_appl partition for ('rnetf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_stud_loan_appl_rnetf1_tm
compress ${option_switch} for query high
as
select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,cust_id -- 客户编号
    ,stud_loan_corp_id -- 助贷公司编号
    ,stud_loan_corp_name -- 助贷公司名称
    ,curr_cd -- 币种代码
    ,appl_amt -- 申请金额
    ,appl_tenor -- 申请期限
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,apv_status_cd -- 审批状态代码
    ,apv_dt -- 审批日期
    ,apved_amt -- 审批通过金额
    ,e_acct_id -- E账户编号
    ,circl_flg -- 循环标志
    ,enty_c_open_bank_id -- 实体卡开户行编号
    ,bind_card_card_no -- 绑定卡卡号
    ,bind_card_card_name -- 绑定卡卡名称
    ,enty_c_open_bank_name -- 实体卡开户行名称
    ,rgstrat_id -- 登记人编号
    ,revo_flg -- 撤销标志
    ,loan_usage_cd -- 贷款用途代码
    ,mode_pay_cd -- 支付方式代码
    ,appl_flow_num -- 申请流水号
    ,apv_start_tm -- 审批开始时间
    ,refuse_rs -- 拒绝原因
    ,mobile_no -- 手机号码
    ,rest_advise_sucs_flg -- 结果通知成功标志
    ,blip_upload_flg -- 影像上传标志
    ,score_val -- 评分分值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_stud_loan_appl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_stud_loan_appl_rnetf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_stud_loan_appl partition for ('rnetf1') where 0=1;

-- 2.1 insert data to tm table
-- rcrs_net_iqp_loan_appl-
insert into ${iml_schema}.agt_stud_loan_appl_rnetf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,cust_id -- 客户编号
    ,stud_loan_corp_id -- 助贷公司编号
    ,stud_loan_corp_name -- 助贷公司名称
    ,curr_cd -- 币种代码
    ,appl_amt -- 申请金额
    ,appl_tenor -- 申请期限
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,apv_status_cd -- 审批状态代码
    ,apv_dt -- 审批日期
    ,apved_amt -- 审批通过金额
    ,e_acct_id -- E账户编号
    ,circl_flg -- 循环标志
    ,enty_c_open_bank_id -- 实体卡开户行编号
    ,bind_card_card_no -- 绑定卡卡号
    ,bind_card_card_name -- 绑定卡卡名称
    ,enty_c_open_bank_name -- 实体卡开户行名称
    ,rgstrat_id -- 登记人编号
    ,revo_flg -- 撤销标志
    ,loan_usage_cd -- 贷款用途代码
    ,mode_pay_cd -- 支付方式代码
    ,appl_flow_num -- 申请流水号
    ,apv_start_tm -- 审批开始时间
    ,refuse_rs -- 拒绝原因
    ,mobile_no -- 手机号码
    ,rest_advise_sucs_flg -- 结果通知成功标志
    ,blip_upload_flg -- 影像上传标志
    ,score_val -- 评分分值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '205001'||P1.SERNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERNO -- 授信申请编号
    ,P1.CUS_ID -- 客户编号
    ,P1.HELP_COMP_ID -- 助贷公司编号
    ,P1.HELP_COMP_NAME -- 助贷公司名称
    ,NVL(TRIM(P1.CUR_TYPE),'CNY') -- 币种代码
    ,P1.APPLY_AMOUNT -- 申请金额
    ,P1.TERM -- 申请期限
    ,P1.PRD_CODE -- 产品编号
    ,P1.PRD_NAME -- 产品名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.INPUT_DATE) -- 登记日期
    ,P1.INPUT_BR_ID -- 登记机构编号
    ,P1.APPROVE_STATUS -- 审批状态代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.APPR_END_TIME) -- 审批日期
    ,P1.APPROVE_AMT -- 审批通过金额
    ,P1.E_ACCOUNT_NO -- E账户编号
    ,P1.IS_CIRCLE -- 循环标志
    ,P1.BANK_CODE -- 实体卡开户行编号
    ,P1.ACCOUNT -- 绑定卡卡号
    ,P1.ACCOUNT_NAME -- 绑定卡卡名称
    ,P1.BANK_NAME -- 实体卡开户行名称
    ,P1.INPUT_ID -- 登记人编号
    ,P1.IS_CANCEL -- 撤销标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.LOAN_PURPOSE END -- 贷款用途代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PAY_TYPE END -- 支付方式代码
    ,P1.APPLY_CODE -- 申请流水号
    ,P1.APPR_BEGIN_TIME -- 审批开始时间
    ,P1.REFUSE_REASON -- 拒绝原因
    ,P1.MOBILE_PHONE -- 手机号码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.INFORM_FLAG END -- 结果通知成功标志
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.IMAGE_RESULT_FLAG END -- 影像上传标志
    ,P1.AUTO_SCORE -- 评分分值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_net_iqp_loan_appl' -- 源表名称
    ,'rnetf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_net_iqp_loan_appl p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.LOAN_PURPOSE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'RCRS'
        AND R1.SRC_TAB_EN_NAME= 'RCRS_NET_IQP_LOAN_APPL'
        AND R1.SRC_FIELD_EN_NAME= 'LOAN_PURPOSE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_STUD_LOAN_APPL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LOAN_USAGE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PAY_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'RCRS'
        AND R2.SRC_TAB_EN_NAME= 'RCRS_NET_IQP_LOAN_APPL'
        AND R2.SRC_FIELD_EN_NAME= 'PAY_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_STUD_LOAN_APPL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'MODE_PAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.INFORM_FLAG= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'RCRS'
        AND R3.SRC_TAB_EN_NAME= 'RCRS_NET_IQP_LOAN_APPL'
        AND R3.SRC_FIELD_EN_NAME= 'INFORM_FLAG'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_STUD_LOAN_APPL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'REST_ADVISE_SUCS_FLG'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.IMAGE_RESULT_FLAG= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'RCRS'
        AND R4.SRC_TAB_EN_NAME= 'RCRS_NET_IQP_LOAN_APPL'
        AND R4.SRC_FIELD_EN_NAME= 'IMAGE_RESULT_FLAG'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_STUD_LOAN_APPL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'BLIP_UPLOAD_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_stud_loan_appl_rnetf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_stud_loan_appl_rnetf1_ex(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,cust_id -- 客户编号
    ,stud_loan_corp_id -- 助贷公司编号
    ,stud_loan_corp_name -- 助贷公司名称
    ,curr_cd -- 币种代码
    ,appl_amt -- 申请金额
    ,appl_tenor -- 申请期限
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,apv_status_cd -- 审批状态代码
    ,apv_dt -- 审批日期
    ,apved_amt -- 审批通过金额
    ,e_acct_id -- E账户编号
    ,circl_flg -- 循环标志
    ,enty_c_open_bank_id -- 实体卡开户行编号
    ,bind_card_card_no -- 绑定卡卡号
    ,bind_card_card_name -- 绑定卡卡名称
    ,enty_c_open_bank_name -- 实体卡开户行名称
    ,rgstrat_id -- 登记人编号
    ,revo_flg -- 撤销标志
    ,loan_usage_cd -- 贷款用途代码
    ,mode_pay_cd -- 支付方式代码
    ,appl_flow_num -- 申请流水号
    ,apv_start_tm -- 审批开始时间
    ,refuse_rs -- 拒绝原因
    ,mobile_no -- 手机号码
    ,rest_advise_sucs_flg -- 结果通知成功标志
    ,blip_upload_flg -- 影像上传标志
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
    ,nvl(n.crdt_appl_id, o.crdt_appl_id) as crdt_appl_id -- 授信申请编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.stud_loan_corp_id, o.stud_loan_corp_id) as stud_loan_corp_id -- 助贷公司编号
    ,nvl(n.stud_loan_corp_name, o.stud_loan_corp_name) as stud_loan_corp_name -- 助贷公司名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.appl_amt, o.appl_amt) as appl_amt -- 申请金额
    ,nvl(n.appl_tenor, o.appl_tenor) as appl_tenor -- 申请期限
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.apv_dt, o.apv_dt) as apv_dt -- 审批日期
    ,nvl(n.apved_amt, o.apved_amt) as apved_amt -- 审批通过金额
    ,nvl(n.e_acct_id, o.e_acct_id) as e_acct_id -- E账户编号
    ,nvl(n.circl_flg, o.circl_flg) as circl_flg -- 循环标志
    ,nvl(n.enty_c_open_bank_id, o.enty_c_open_bank_id) as enty_c_open_bank_id -- 实体卡开户行编号
    ,nvl(n.bind_card_card_no, o.bind_card_card_no) as bind_card_card_no -- 绑定卡卡号
    ,nvl(n.bind_card_card_name, o.bind_card_card_name) as bind_card_card_name -- 绑定卡卡名称
    ,nvl(n.enty_c_open_bank_name, o.enty_c_open_bank_name) as enty_c_open_bank_name -- 实体卡开户行名称
    ,nvl(n.rgstrat_id, o.rgstrat_id) as rgstrat_id -- 登记人编号
    ,nvl(n.revo_flg, o.revo_flg) as revo_flg -- 撤销标志
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.apv_start_tm, o.apv_start_tm) as apv_start_tm -- 审批开始时间
    ,nvl(n.refuse_rs, o.refuse_rs) as refuse_rs -- 拒绝原因
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.rest_advise_sucs_flg, o.rest_advise_sucs_flg) as rest_advise_sucs_flg -- 结果通知成功标志
    ,nvl(n.blip_upload_flg, o.blip_upload_flg) as blip_upload_flg -- 影像上传标志
    ,nvl(n.score_val, o.score_val) as score_val -- 评分分值
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.appl_id is null
                and o.lp_id is null
            ) or (
                o.crdt_appl_id <> n.crdt_appl_id
                or o.cust_id <> n.cust_id
                or o.stud_loan_corp_id <> n.stud_loan_corp_id
                or o.stud_loan_corp_name <> n.stud_loan_corp_name
                or o.curr_cd <> n.curr_cd
                or o.appl_amt <> n.appl_amt
                or o.appl_tenor <> n.appl_tenor
                or o.prod_id <> n.prod_id
                or o.prod_name <> n.prod_name
                or o.rgst_dt <> n.rgst_dt
                or o.rgst_org_id <> n.rgst_org_id
                or o.apv_status_cd <> n.apv_status_cd
                or o.apv_dt <> n.apv_dt
                or o.apved_amt <> n.apved_amt
                or o.e_acct_id <> n.e_acct_id
                or o.circl_flg <> n.circl_flg
                or o.enty_c_open_bank_id <> n.enty_c_open_bank_id
                or o.bind_card_card_no <> n.bind_card_card_no
                or o.bind_card_card_name <> n.bind_card_card_name
                or o.enty_c_open_bank_name <> n.enty_c_open_bank_name
                or o.rgstrat_id <> n.rgstrat_id
                or o.revo_flg <> n.revo_flg
                or o.loan_usage_cd <> n.loan_usage_cd
                or o.mode_pay_cd <> n.mode_pay_cd
                or o.appl_flow_num <> n.appl_flow_num
                or o.apv_start_tm <> n.apv_start_tm
                or o.refuse_rs <> n.refuse_rs
                or o.mobile_no <> n.mobile_no
                or o.rest_advise_sucs_flg <> n.rest_advise_sucs_flg
                or o.blip_upload_flg <> n.blip_upload_flg
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
from ${iml_schema}.agt_stud_loan_appl_rnetf1_tm n
    full join ${iml_schema}.agt_stud_loan_appl_rnetf1_bk o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_stud_loan_appl truncate partition for ('rnetf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_stud_loan_appl exchange subpartition p_rnetf1_${batch_date} with table ${iml_schema}.agt_stud_loan_appl_rnetf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_stud_loan_appl drop subpartition p_rnetf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_stud_loan_appl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_stud_loan_appl_rnetf1_tm purge;
drop table ${iml_schema}.agt_stud_loan_appl_rnetf1_ex purge;
drop table ${iml_schema}.agt_stud_loan_appl_rnetf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_stud_loan_appl', partname => 'p_rnetf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);